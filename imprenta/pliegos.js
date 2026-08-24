'use strict';
/* Arma los PDF a partir del manifiesto, la grilla y los bytes de cada imagen.
 *
 * Está separado de la UI para poder probarlo sin navegador: `pruebas.mjs` lo
 * carga tal cual y verifica la geometría contra el PDF resultante.
 */

/** Genera los pliegos pedidos. `leer(archivo)` devuelve Uint8Array.
 *
 * Devuelve `[{nombre, bytes, hojas}]`, un PDF por entregable.
 */
function generar(manifiesto, leer, cfg) {
  const { HOJAS, CORTE, mejorGrilla, celda, ventana, cajaImagen, expandir, enHojas,
          marcasDeCorte, marcasDeRegistro, reglaDeControl } = window.IMP;

  // Dos troqueles, dos grillas. La geometría viaja en el manifiesto por pieza
  // desde que los jefes dejaron de compartir naipe con el resto.
  const corteDe = (rol, respaldo) => {
    const p = manifiesto.piezas.find((x) => x.rol === rol && x.corte_mm);
    return p ? { ancho: p.corte_mm[0], alto: p.corte_mm[1] } : respaldo;
  };
  const gCartas = mejorGrilla(cfg.hoja, cfg, corteDe('peligro', CORTE));
  const gJefes = mejorGrilla(cfg.hoja, cfg, corteDe('jefe', CORTE));
  const salida = [];

  const verticales = expandir(
    manifiesto.piezas.filter((p) => p.rol !== 'jefe'),
    cfg.incluir
  );
  const jefes = cfg.incluir.jefe
    ? expandir(manifiesto.piezas.filter((p) => p.rol === 'jefe'), cfg.incluir)
    : [];
  const dorso = manifiesto.piezas.find((p) => p.rol === 'dorso');
  // El dorso del jefe es una pieza aparte: mismo mandala, girado y a 118x76.
  // Si no existe se cae al dorso normal, que va a quedar deformado — mejor
  // que no salga ningún pliego de dorsos.
  const dorsoJefe = manifiesto.piezas.find((p) => p.rol === 'dorso_jefe') || dorso;
  const tapa = manifiesto.piezas.find((p) => p.rol === 'tapa');

  /** Dibuja una tanda de naipes en su propio PDF de frentes. */
  function pliegoFrentes(lista, girar, rotulo, g) {
    if (!lista.length) return null;
    const pdf = new window.PDF();
    const hojas = enHojas(lista, g.porHoja);
    hojas.forEach((hoja, h) => {
      const pag = pdf.pagina(g.hojaAncho, g.hojaAlto);
      hoja.forEach((pieza, i) => {
        const col = i % g.cols;
        const fila = Math.floor(i / g.cols);
        const img = pdf.imagen(pieza.archivo, leer(pieza.archivo));
        const caja = cajaImagen(g, col, fila);
        const vent = ventana(g, col, fila);
        if (girar) pag.imagenGirada(img, caja, vent);
        else pag.imagen(img, caja, vent);
      });
      adornar(pag, `${rotulo} - hoja ${h + 1} de ${hojas.length}`, g);
    });
    return { nombre: rotulo, bytes: pdf.terminar(), hojas: hojas.length };
  }

  /** El pliego de dorsos: la grilla SIEMPRE completa.
   *
   * No hay espejado y no es un olvido. Con dorso único e idéntico en todas
   * las celdas, invertir el orden de columnas no cambia un solo píxel. Lo que
   * hace que el dorso caiga sobre el frente es que la grilla esté centrada
   * en horizontal, y de eso se ocupa `mejorGrilla`.
   *
   * Ojo si alguna vez hay dorsos distintos por mazo: ahí esta suposición se
   * cae y hay que espejar de verdad.
   *
   * Se rellenan también las celdas que en el frente quedaron vacías: sale
   * papel impreso de un lado que se descarta o sirve de separador, y a cambio
   * todas las hojas son idénticas y no hay que alinear nada a mano.
   */
  function pliegoDorsos(cantidadHojas, girar, rotulo, g, dorso) {
    if (!cantidadHojas || !dorso) return null;
    const pdf = new window.PDF();
    for (let h = 0; h < cantidadHojas; h++) {
      const pag = pdf.pagina(g.hojaAncho, g.hojaAlto);
      for (let i = 0; i < g.porHoja; i++) {
        const col = i % g.cols;
        const fila = Math.floor(i / g.cols);
        const img = pdf.imagen(dorso.archivo, leer(dorso.archivo));
        const caja = cajaImagen(g, col, fila);
        const vent = ventana(g, col, fila);
        if (girar) pag.imagenGirada(img, caja, vent);
        else pag.imagen(img, caja, vent);
      }
      adornar(pag, `${rotulo} - hoja ${h + 1} de ${cantidadHojas}`, g);
    }
    return { nombre: rotulo, bytes: pdf.terminar(), hojas: cantidadHojas };
  }

  function adornar(pag, rotulo, g) {
    if (cfg.marcasCorte) marcasDeCorte(pag, g);
    if (cfg.marcasRegistro) marcasDeRegistro(pag, g);
    if (cfg.regla) reglaDeControl(pag, g, rotulo);
    pag.trim = { x: g.x0, y: g.y0, ancho: g.bloqueAncho, alto: g.bloqueAlto };
    pag.bleed = {
      x: g.x0 - g.sangrado,
      y: g.y0 - g.sangrado,
      ancho: g.bloqueAncho + g.sangrado * 2,
      alto: g.bloqueAlto + g.sangrado * 2,
    };
  }

  const fv = pliegoFrentes(verticales, false, 'cartas-frentes', gCartas);
  if (fv) {
    salida.push(fv);
    const dv = pliegoDorsos(fv.hojas, false, 'cartas-dorsos', gCartas, dorso);
    if (dv) salida.push(dv);
  }

  // Ya no se giran: el troquel del jefe es apaisado igual que su dibujo, así
  // que la celda y la imagen coinciden y `imagenGirada` no entra en juego.
  const fj = pliegoFrentes(jefes, false, 'jefes-frentes', gJefes);
  if (fj) {
    salida.push(fj);
    const dj = pliegoDorsos(fj.hojas, false, 'jefes-dorsos', gJefes, dorsoJefe);
    if (dj) salida.push(dj);
  }

  if (cfg.incluir.tapa && tapa) salida.push(pliegoTapa(tapa, leer, cfg, gCartas));

  const tablero = manifiesto.piezas.find((p) => p.rol === 'tablero');
  if (cfg.incluir.tablero && tablero) salida.push(pliegoTablero(tablero, leer, cfg, gCartas));

  const ficha = manifiesto.piezas.find((p) => p.rol === 'ficha');
  if (cfg.incluir.ficha && ficha) salida.push(pliegoFichas(ficha, leer, cfg, gCartas));

  return salida.filter(Boolean);
}

/** La tapa sola, a tamaño real, con la guía del troquel. */
function pliegoTapa(tapa, leer, cfg, g) {
  const { reglaDeControl } = window.IMP;
  const corte = { ancho: 72, alto: 116 };
  const sangrado = 3;
  const pdf = new window.PDF();
  const pag = pdf.pagina(g.hojaAncho, g.hojaAlto);

  const x = (g.hojaAncho - corte.ancho) / 2;
  const y = (g.hojaAlto - corte.alto) / 2;
  const img = pdf.imagen(tapa.archivo, leer(tapa.archivo));
  pag.imagen(
    img,
    { x: x - sangrado, y: y - sangrado, ancho: corte.ancho + sangrado * 2, alto: corte.alto + sangrado * 2 },
    { x: x - sangrado, y: y - sangrado, ancho: corte.ancho + sangrado * 2, alto: corte.alto + sangrado * 2 }
  );

  // Guía del troquel: dónde termina la tapa y empieza el sangrado.
  const sep = 1;
  const largo = 5;
  for (const px of [x, x + corte.ancho]) {
    pag.linea(px, y - sep, px, y - sep - largo);
    pag.linea(px, y + corte.alto + sep, px, y + corte.alto + sep + largo);
  }
  for (const py of [y, y + corte.alto]) {
    pag.linea(x - sep, py, x - sep - largo, py);
    pag.linea(x + corte.ancho + sep, py, x + corte.ancho + sep + largo, py);
  }
  pag.texto('TAPA DE LA CAJA - corte 72 x 116 mm, sangrado 3 mm', x, y - 10, {
    tam: 7,
    fuente: 'Helvetica',
    color: '#555555',
  });

  const gg = { ...g, x0: x, y0: y, bloqueAncho: corte.ancho, bloqueAlto: corte.alto };
  if (cfg.regla) reglaDeControl(pag, gg, 'tapa de la caja');
  pag.trim = { x, y, ancho: corte.ancho, alto: corte.alto };
  pag.bleed = {
    x: x - sangrado,
    y: y - sangrado,
    ancho: corte.ancho + sangrado * 2,
    alto: corte.alto + sangrado * 2,
  };
  return { nombre: 'tapa-caja', bytes: pdf.terminar(), hojas: 1 };
}

/** El tablero de Energía, a tamaño real, con su guía de plegado.
 *
 * Se escala al ancho pedido respetando su proporción. El ancho por defecto es
 * el máximo que entra en la hoja, porque de él dependen los círculos: cuanto
 * más grande el tablero, más cómoda apoya la ficha.
 */
function pliegoTablero(tablero, leer, cfg, g) {
  const { reglaDeControl, HOJAS } = window.IMP;
  const pdf = new window.PDF();

  // La hoja se gira para la pieza, no para las cartas. El tablero es apaisado
  // y la grilla de naipes eligió vertical: usar la orientación de las cartas
  // lo achicaría de 270 a 200 mm sin ninguna razón.
  const [a, b] = HOJAS[cfg.hoja];
  const proporcion = tablero.ancho / tablero.alto;
  let hojaAncho = a;
  let hojaAlto = b;
  let ancho = 0;
  for (const [w, h] of [[a, b], [b, a]]) {
    const cabe = Math.min(w - cfg.margen * 2, (h - cfg.margen * 2) * proporcion);
    if (cabe > ancho) {
      ancho = cabe;
      hojaAncho = w;
      hojaAlto = h;
    }
  }
  ancho = Math.min(cfg.tableroAncho, ancho);

  const pag = pdf.pagina(hojaAncho, hojaAlto);
  const img = pdf.imagen(tablero.archivo, leer(tablero.archivo));

  const alto = ancho / proporcion;
  const x = (hojaAncho - ancho) / 2;
  const y = (hojaAlto - alto) / 2;

  pag.imagen(img, { x, y, ancho, alto });

  const sep = 1;
  const largo = 4;
  for (const px of [x, x + ancho]) {
    pag.linea(px, y - sep, px, y - sep - largo);
    pag.linea(px, y + alto + sep, px, y + alto + sep + largo);
  }
  for (const py of [y, y + alto]) {
    pag.linea(x - sep, py, x - sep - largo, py);
    pag.linea(x + ancho + sep, py, x + ancho + sep + largo, py);
  }

  // El plegado lo elige el usuario y por defecto no hay ninguno.
  //
  // Automatizarlo era peor: para meter 270 mm en los 64 de la caja hacen
  // falta cinco paneles, o sea un acordeón, y como el tablero tiene once
  // columnas de círculos NINGÚN reparto cae limpio entre casillas. Vale más
  // guardarlo aparte que doblarlo por la mitad de un número.
  const paneles = cfg.tableroPliegues || 1;
  if (paneles > 1) {
    for (let i = 1; i < paneles; i++) {
      const px = x + (ancho / paneles) * i;
      for (let t = 0; t < alto; t += 5) {
        pag.linea(px, y + t, px, y + Math.min(t + 2.5, alto), 0.5, 0.25);
      }
    }
  }

  pag.texto(
    `TABLERO DE ENERGIA - ${ancho.toFixed(0)} x ${alto.toFixed(0)} mm` +
      (paneles > 1
        ? ` - plegado en ${paneles}, paneles de ${(ancho / paneles).toFixed(0)} mm`
        : ''),
    x,
    y - 9,
    { tam: 7, fuente: 'Helvetica', color: '#555555' }
  );

  const gg = { ...g, hojaAncho, hojaAlto, x0: x, y0: y,
               bloqueAncho: ancho, bloqueAlto: alto };
  if (cfg.regla) reglaDeControl(pag, gg, 'tablero de Energia');
  pag.trim = { x, y, ancho, alto };
  return { nombre: 'tablero-energia', bytes: pdf.terminar(), hojas: 1 };
}

/** Las fichas de Energía, con su círculo de corte.
 *
 * Van separadas y no pegadas: se cortan redondas, así que no hay borde
 * compartido que aprovechar y necesitan lugar para la tijera. El círculo
 * punteado marca por dónde cortar; el arte se sale de él, y ese sobrante es
 * el sangrado que perdona el pulso.
 */
function pliegoFichas(ficha, leer, cfg, g) {
  const { reglaDeControl } = window.IMP;
  const pdf = new window.PDF();
  const pag = pdf.pagina(g.hojaAncho, g.hojaAlto);
  const img = pdf.imagen(ficha.archivo, leer(ficha.archivo));

  const d = cfg.fichaDiametro;
  const paso = d + 6;
  // Las columnas que se USAN, no las que entran: con 6 fichas en una fila de
  // 7 lugares, medir el bloque por los 7 lo deja corrido a la izquierda.
  const caben = Math.max(1, Math.floor((g.hojaAncho - cfg.margen * 2 + 6) / paso));
  const cols = Math.min(caben, cfg.fichaCantidad);
  const filas = Math.ceil(cfg.fichaCantidad / cols);
  const bloqueAncho = cols * paso - 6;
  const bloqueAlto = filas * paso - 6;
  const x0 = (g.hojaAncho - bloqueAncho) / 2;
  const y0 = (g.hojaAlto - bloqueAlto) / 2;

  for (let i = 0; i < cfg.fichaCantidad; i++) {
    const c = i % cols;
    const f = Math.floor(i / cols);
    const x = x0 + c * paso;
    const y = y0 + bloqueAlto - (f + 1) * d - f * 6;
    // El arte entero, que es cuadrado y trae crema alrededor del disco.
    pag.imagen(img, { x, y, ancho: d, alto: d });
    pag.circuloPunteado(x + d / 2, y + d / 2, d / 2);
  }

  pag.texto(
    `FICHAS DE ENERGIA - ${cfg.fichaCantidad} de ${d} mm - cortar por el circulo punteado`,
    x0,
    y0 - 9,
    { tam: 7, fuente: 'Helvetica', color: '#555555' }
  );

  const gg = { ...g, x0, y0, bloqueAncho, bloqueAlto };
  if (cfg.regla) reglaDeControl(pag, gg, 'fichas de Energia');
  return { nombre: 'fichas-energia', bytes: pdf.terminar(), hojas: 1 };
}

window.PLIEGOS = { generar };
