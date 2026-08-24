'use strict';
/* Imposición: de una lista de naipes a pliegos listos para guillotina.
 *
 * Todo en milímetros. El origen de coordenadas es abajo-izquierda, como PDF.
 */

const HOJAS = {
  A4: [210, 297],
  A3: [297, 420],
  Carta: [215.9, 279.4],
  Tabloide: [279.4, 431.8],
};

/** Corte y sangrado del naipe. Sale del manifiesto, esto es sólo el respaldo.
 *
 * NO son la geometría de la tirada: desde que los jefes tienen su propio
 * troquel de 112x70, cada pliego trae la suya en `g.corte` y `g.sangrado`.
 * Todo lo que lea estas constantes en vez del `g` que recibe es un bug.
 */
const CORTE = { ancho: 57, alto: 89 };
const SANGRADO = 3;

/** Elige la grilla que más naipes mete por hoja.
 *
 * Prueba las dos orientaciones de la HOJA, nunca las de la pieza. Rotar la
 * pieza daría la misma cuenta con la grilla transpuesta y sólo serviría para
 * confundir el registro del dorso, que depende de que frente y dorso usen
 * exactamente la misma grilla.
 */
function mejorGrilla(nombreHoja, { margen, calle, sangrado }, corte = CORTE) {
  const [w, h] = HOJAS[nombreHoja];
  let mejor = null;

  for (const [ph, pv] of [[w, h], [h, w]]) {
    const utilAncho = ph - margen * 2;
    const utilAlto = pv - margen * 2;
    // El sangrado exterior se descuenta una vez por lado, no por carta.
    const cols = Math.floor((utilAncho - sangrado * 2 + calle) / (corte.ancho + calle));
    const filas = Math.floor((utilAlto - sangrado * 2 + calle) / (corte.alto + calle));
    if (cols < 1 || filas < 1) continue;

    const n = cols * filas;
    if (mejor && n <= mejor.porHoja) continue;

    const bloqueAncho = cols * corte.ancho + (cols - 1) * calle;
    const bloqueAlto = filas * corte.alto + (filas - 1) * calle;
    mejor = {
      porHoja: n,
      cols,
      filas,
      hojaAncho: ph,
      hojaAlto: pv,
      apaisada: ph > pv,
      bloqueAncho,
      bloqueAlto,
      // Centrado EXACTO en horizontal. De esto depende que el dorso caiga
      // sobre el frente al dar vuelta la hoja: si los márgenes izquierdo y
      // derecho no son iguales, no hay marca de registro que lo salve.
      x0: (ph - bloqueAncho) / 2,
      y0: (pv - bloqueAlto) / 2,
      calle,
      sangrado,
      corte,
    };
  }
  if (!mejor) throw new Error(`No entra ni una pieza de ${corte.ancho}x${corte.alto} en ${nombreHoja} con esos márgenes`);
  return mejor;
}

/** Esquina inferior izquierda de la celda (col, fila). Fila 0 es la de arriba. */
function celda(g, col, fila) {
  return {
    x: g.x0 + col * (g.corte.ancho + g.calle),
    y: g.y0 + g.bloqueAlto - (fila + 1) * g.corte.alto - fila * g.calle,
    ancho: g.corte.ancho,
    alto: g.corte.alto,
  };
}

/** La ventana visible de una celda.
 *
 * En el interior es la caja de corte pelada, así las cartas quedan pegadas y
 * una sola línea sirve de corte para las dos vecinas. En el perímetro se
 * agranda hacia afuera para dejar ver el sangrado, que es el margen que se
 * come la guillotina cuando se desvía.
 *
 * Con calle > 0 cada carta tiene su propio sangrado por los cuatro lados y no
 * hay borde compartido: el error de corte deja crema propio en vez de una
 * tira del dibujo de la vecina.
 */
function ventana(g, col, fila) {
  const c = celda(g, col, fila);
  if (g.calle > 0) {
    const s = Math.min(g.sangrado, g.calle / 2);
    return { x: c.x - s, y: c.y - s, ancho: c.ancho + s * 2, alto: c.alto + s * 2 };
  }
  const izq = col === 0 ? g.sangrado : 0;
  const der = col === g.cols - 1 ? g.sangrado : 0;
  const abajo = fila === g.filas - 1 ? g.sangrado : 0;
  const arriba = fila === 0 ? g.sangrado : 0;
  return {
    x: c.x - izq,
    y: c.y - abajo,
    ancho: c.ancho + izq + der,
    alto: c.alto + abajo + arriba,
  };
}

/** La caja donde se dibuja la imagen: siempre completa, con su sangrado. */
function cajaImagen(g, col, fila) {
  const c = celda(g, col, fila);
  // Leía el SANGRADO del módulo mientras `ventana` leía el de `g`: con
  // cualquier valor distinto de 3 la imagen y su recorte no coincidían.
  return {
    x: c.x - g.sangrado,
    y: c.y - g.sangrado,
    ancho: g.corte.ancho + g.sangrado * 2,
    alto: g.corte.alto + g.sangrado * 2,
  };
}

/** A décimas de micrón, para que dos bordes que coinciden den la misma clave. */
function redondear(v) {
  return Math.round(v * 1000) / 1000;
}

/** Los roles que son naipes de 57x89. El resto son piezas con su propia
 * geometría —dorso, tapa, tablero, ficha— y no entran en la grilla de cartas.
 *
 * Es lista blanca a propósito: con lista negra, cada pieza nueva que se
 * agregue al manifiesto se cuela en el mazo hasta que alguien se acuerde de
 * excluirla, y el síntoma es un conteo de naipes silenciosamente equivocado.
 */
const NAIPES = new Set(['inicial', 'peligro', 'cansancio', 'jefe']);

/** Expande el manifiesto a la lista de naipes físicos, con sus copias. */
function expandir(piezas, incluir) {
  const fuera = [];
  for (const p of piezas) {
    if (!NAIPES.has(p.rol)) continue;
    if (!incluir[p.rol]) continue;
    for (let i = 0; i < Math.max(1, p.copias); i++) fuera.push(p);
  }
  return fuera;
}

/** Reparte los naipes en hojas de `porHoja`. */
function enHojas(lista, porHoja) {
  const hojas = [];
  for (let i = 0; i < lista.length; i += porHoja) hojas.push(lista.slice(i, i + porHoja));
  return hojas;
}

// ------------------------------------------------------------------- marcas

/** Marcas de corte para TODAS las líneas de la grilla, no sólo el perímetro.
 *
 * Con corte compartido cada línea interior es un corte real: sin su tick en
 * los cuatro márgenes no hay contra qué alinear la guillotina. Los ticks van
 * cortos y pegados al bloque porque hay impresoras con 12,7 mm no imprimible
 * y las marcas estándar de 3+5 mm se caen de la hoja.
 */
function marcasDeCorte(pag, g) {
  const sep = 1;
  const largo = 4;

  // Sin calle los bordes se comparten: cols+1 líneas. Con calle cada carta
  // tiene el suyo propio: 2*cols líneas. Un Set las junta sin duplicar.
  const xs = new Set();
  for (let c = 0; c < g.cols; c++) {
    const izq = g.x0 + c * (g.corte.ancho + g.calle);
    xs.add(redondear(izq));
    xs.add(redondear(izq + g.corte.ancho));
  }
  const ys = new Set();
  for (let f = 0; f < g.filas; f++) {
    const arriba = g.y0 + g.bloqueAlto - f * (g.corte.alto + g.calle);
    ys.add(redondear(arriba));
    ys.add(redondear(arriba - g.corte.alto));
  }

  const arriba = g.y0 + g.bloqueAlto;
  const abajo = g.y0;
  for (const x of xs) {
    pag.linea(x, arriba + sep, x, arriba + sep + largo);
    pag.linea(x, abajo - sep, x, abajo - sep - largo);
  }
  const izq = g.x0;
  const der = g.x0 + g.bloqueAncho;
  for (const y of ys) {
    pag.linea(izq - sep, y, izq - sep - largo, y);
    pag.linea(der + sep, y, der + sep + largo, y);
  }
}

/** Cruces de registro en las cuatro esquinas, simétricas respecto del eje. */
function marcasDeRegistro(pag, g) {
  const d = 5;
  const fuera = 6;
  const puntos = [
    [g.x0 - fuera, g.y0 - fuera],
    [g.x0 + g.bloqueAncho + fuera, g.y0 - fuera],
    [g.x0 - fuera, g.y0 + g.bloqueAlto + fuera],
    [g.x0 + g.bloqueAncho + fuera, g.y0 + g.bloqueAlto + fuera],
  ];
  for (const [x, y] of puntos) {
    if (x < 2 || y < 2 || x > g.hojaAncho - 2 || y > g.hojaAlto - 2) continue;
    pag.linea(x - d / 2, y, x + d / 2, y, 0.25);
    pag.linea(x, y - d / 2, x, y + d / 2, 0.25);
  }
}

/** Regla de 100 mm con marcas cada 10.
 *
 * Es la única defensa contra el error más caro de todos: el diálogo de
 * impresión con "ajustar a página" puesto, que escala al 96 % sin avisar y
 * no se nota a ojo. Si medís 100 mm con una regla de verdad, salió al 100 %.
 */
function reglaDeControl(pag, g, rotulo) {
  const y = Math.max(3, g.y0 - 14);
  const x = g.x0;
  if (y < 2 || x + 100 > g.hojaAncho) return;
  pag.linea(x, y, x + 100, y, 0.4);
  for (let i = 0; i <= 10; i++) {
    const alto = i % 5 === 0 ? 2.5 : 1.5;
    pag.linea(x + i * 10, y, x + i * 10, y + alto, 0.4);
  }
  pag.texto('100 mm exactos - si no mide 100, imprimiste con escala', x + 103, y - 0.6, {
    tam: 6,
    fuente: 'Helvetica',
    color: '#555555',
  });
  if (rotulo) {
    pag.texto(rotulo, x, y - 5, { tam: 7, fuente: 'Helvetica', color: '#555555' });
  }
}

window.IMP = {
  HOJAS,
  NAIPES,
  CORTE,
  SANGRADO,
  mejorGrilla,
  celda,
  ventana,
  cajaImagen,
  expandir,
  enHojas,
  marcasDeCorte,
  marcasDeRegistro,
  reglaDeControl,
};
