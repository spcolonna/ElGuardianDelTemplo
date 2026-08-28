// Markdown de los tomos -> bloques tipados para la maqueta.
//
//   node cuento/libro/parser.mjs            # todos los documentos
//   node cuento/libro/parser.mjs tomo1      # uno solo
//
// Escribe en cuento/libro/datos/. No toca los .md: la prosa sigue siendo la
// fuente unica y se la puede seguir corrigiendo sin pensar en la maqueta.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const AQUI = path.dirname(fileURLToPath(import.meta.url));
const RAIZ = path.resolve(AQUI, '..', '..');
const CUENTO = path.join(RAIZ, 'cuento');
const DATOS = path.join(AQUI, 'datos');

// Los tomos terminados a mano. `final/` le gana a `datos/`: si un documento
// existe ahi, este script NO lo escribe. El Tomo I esta acomodado imagen por
// imagen y no hay ninguna razon para que un `node parser.mjs` distraido lo
// pise, que es exactamente lo que pasaba antes de que existiera esta carpeta.
const FINAL = path.join(AQUI, 'final');

function congelado(nombre) {
  return fs.existsSync(path.join(FINAL, `${nombre}.json`));
}

const TOMOS = [
  { archivo: '01_el_dragon_de_papel.md', dia: 'UNO', bajada: 'Libro Uno — El Dragón de Papel' },
  { archivo: '02_el_senor_de_los_mercenarios.md', dia: 'DOS', bajada: 'Libro Dos — El Señor de los Mercenarios' },
  { archivo: '03_el_monje_caido.md', dia: 'TRES', bajada: 'Libro Tres — El Monje Caído' },
  { archivo: '04_tu_propio_reflejo.md', dia: 'CUATRO', bajada: 'Libro Cuatro — Tu Propio Reflejo' },
  { archivo: '05_el_loto_negro.md', dia: 'CINCO', bajada: 'Libro Cinco — El Loto Negro' },
];

// Etiquetas de produccion. Marcan de donde sale cada ilustracion y NUNCA se
// imprimen: en la pagina la imagen entra sola, como en cualquier libro.
const ETIQUETAS = /^\*\*(Peligro|Técnica|Escenario|Campeón|Cansancio|Fatiga|Personajes|Ilustraciones|Arte)\*\*/;

const FASES = new Set(['ALBA', 'MEDIODÍA', 'OCASO', 'NOCHE']);

// ------------------------------------------------------------------ inline

function inline(s) {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
    .replace(/\*([^*]+)\*/g, '<em>$1</em>')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/---/g, '—')
    .replace(/ -- /g, ' — ');
}

// ------------------------------------------------------- lectura del tomo

/** Junta las lineas fisicas en unidades logicas: parrafos, citas y metadatos. */
function agrupar(texto) {
  const crudas = texto.split('\n');
  const unidades = [];
  let buffer = null;

  const cerrar = () => { if (buffer) unidades.push(buffer); buffer = null; };

  for (const cruda of crudas) {
    const linea = cruda.replace(/\s+$/, '');

    if (!linea.trim()) { cerrar(); continue; }

    if (linea.startsWith('#') || linea.trim() === '---') {
      cerrar();
      unidades.push({ clase: linea.trim() === '---' ? 'regla' : 'titulo', texto: linea.trim() });
      continue;
    }

    if (ETIQUETAS.test(linea)) {
      cerrar();
      buffer = { clase: 'meta', texto: linea };
      continue;
    }

    if (linea.startsWith('> ')) {
      const cuerpo = linea.slice(2);
      // Cada `> **NOMBRE** —` abre una intervencion nueva; el resto continua
      // la anterior, que es como estan escritos los dialogos largos.
      if (/^\*\*[^*]+\*\*\s*—/.test(cuerpo) || buffer?.clase !== 'cita') {
        cerrar();
        buffer = { clase: 'cita', texto: cuerpo };
      } else {
        buffer.texto += ' ' + cuerpo;
      }
      continue;
    }

    if (buffer && buffer.clase !== 'parrafo') {
      // Continuacion de una linea de metadatos partida por el ancho de columna.
      buffer.texto += ' ' + linea.trim();
      continue;
    }

    if (buffer) buffer.texto += ' ' + linea.trim();
    else buffer = { clase: 'parrafo', texto: linea.trim() };
  }
  cerrar();
  return unidades;
}

/** `**Etiqueta** \`ruta\` — Nombre` / `\`ruta\` (Nombre) · \`ruta\` (Nombre)` */
function imagenesDe(linea) {
  const salida = [];
  const re = /`(Assets\/[^`]+)`\s*(?:—\s*([^·`]+)|\(([^)]*)\))?/g;
  let m;
  while ((m = re.exec(linea))) {
    salida.push({
      src: m[1].trim(),
      nombre: (m[2] || m[3] || '').trim().replace(/\s+/g, ' ') || null,
    });
  }
  return salida;
}

function dialogo(cuerpo) {
  const m = cuerpo.match(/^\*\*([^*]+)\*\*\s*—\s*([\s\S]*)$/);
  if (!m) return { t: 'aparte', texto: inline(cuerpo) };
  let texto = m[2].trim();
  let acot = null;
  const a = texto.match(/^\*\(([^)]*)\)\*\s*/);
  if (a) { acot = a[1]; texto = texto.slice(a[0].length); }
  return { t: 'dialogo', quien: m[1].trim(), acot, texto: inline(texto) };
}

function leerTomo(spec) {
  const texto = fs.readFileSync(path.join(CUENTO, spec.archivo), 'utf8');
  const unidades = agrupar(texto);
  const bloques = [];
  let tituloTomo = null;
  let tema = null;
  let pendientes = [];   // imagenes declaradas por la ultima seccion

  const volcar = () => {
    for (const img of pendientes) bloques.push({ t: 'figura', ...img });
    pendientes = [];
  };

  for (const u of unidades) {
    if (u.clase === 'regla') { bloques.push({ t: 'separador' }); continue; }

    if (u.clase === 'titulo') {
      const nivel = u.texto.match(/^#+/)[0].length;
      const texto = u.texto.replace(/^#+\s*/, '').trim();

      if (nivel === 1) { tituloTomo = texto.replace(/^Tomo\s+[IVX]+\s*—\s*/, ''); continue; }

      if (nivel === 2) {
        volcar();
        const raiz = texto.split('·')[0].trim().toUpperCase();
        if (FASES.has(raiz)) {
          bloques.push({ t: 'fase', nombre: raiz, resto: texto.includes('·') ? inline(texto.split('·').slice(1).join('·').trim()) : null });
        } else {
          bloques.push({ t: 'fase', nombre: texto.toUpperCase(), resto: null, menor: true });
        }
        continue;
      }

      volcar();
      bloques.push({ t: 'titulo', texto: inline(texto) });
      continue;
    }

    if (u.clase === 'meta') {
      const linea = u.texto;
      // La bajada del tomo viaja como cita al principio; los metadatos, no.
      pendientes.push(...imagenesDe(linea));
      continue;
    }

    if (u.clase === 'cita') {
      // La bajada del tomo: «**Día uno de cinco.** *El tema del dia.*»
      if (!tema && /^\*\*Día \w+ de cinco/.test(u.texto)) {
        const m = u.texto.match(/\*([^*]+)\*\s*$/);
        tema = m ? m[1].trim() : '';
        continue;
      }
      bloques.push(dialogo(u.texto));
      continue;
    }

    bloques.push({ t: 'parrafo', texto: inline(u.texto) });
  }
  volcar();

  return { dia: spec.dia, titulo: tituloTomo, tema, bajada: spec.bajada, bloques };
}

// -------------------------------------------- colocacion de ilustraciones

/**
 * Reparte las figuras dentro de la seccion a la que pertenecen.
 *
 * `vistas` se comparte entre los cinco tomos cuando se arma el volumen unico,
 * para que una ilustracion no reaparezca en el dia tres habiendo salido en el
 * uno. En los tomos sueltos cada uno arranca con el conjunto vacio.
 *
 * En el markdown las imagenes se declaran juntas arriba de cada escena, que es
 * comodo para escribir y espantoso para leer: quedarian tres ilustraciones
 * apiladas y despues dos paginas de texto seco. Aca se separan y se intercalan
 * segun `posiciones` (0 = pegada al titulo, 1 = al final de la seccion).
 */
function colocar(bloques, maqueta, vistas, dia) {

  const secciones = [];
  let actual = { encabezado: null, cuerpo: [], figuras: [] };
  for (const b of bloques) {
    if (b.t === 'fase' || b.t === 'titulo') {
      secciones.push(actual);
      actual = { encabezado: b, cuerpo: [], figuras: [] };
    } else if (b.t === 'figura') {
      if (vistas.has(b.src)) continue;
      vistas.add(b.src);
      actual.figuras.push(b);
    } else {
      actual.cuerpo.push(b);
    }
  }
  secciones.push(actual);

  const salida = [];
  for (const s of secciones) {
    const clave = s.encabezado ? textoPlano(s.encabezado.texto || s.encabezado.nombre) : '@apertura';
    // «ALBA» existe en los cinco tomos. La clave con dia adelante —«1/ALBA»—
    // gana sobre la general, para poder darle a cada dia su propia apertura.
    const regla = maqueta[`${dia}/${clave}`] || maqueta[clave] || {};

    if (s.encabezado) {
      const cab = { ...s.encabezado };
      if (regla.fondo) cab.fondo = regla.fondo;
      else if (regla.fondo === null) delete cab.fondo;
      else if (s.figuras.length && s.encabezado.t === 'fase') {
        cab.fondo = s.figuras.shift().src;
      }
      if (cab.fondo) vistas.add(cab.fondo);
      salida.push(cab);
    }

    // `figuras` en el manifiesto reemplaza lo que declaro el markdown: sirve
    // para mudar una ilustracion a la seccion donde queda mejor.
    let figuras = s.figuras;
    if (regla.figuras) {
      figuras = regla.figuras.map((f) => (typeof f === 'string' ? { src: f, nombre: null } : f));
      // Tambien las del manifiesto pasan por el filtro de repetidas: sin esto
      // una clave vieja que quedo dando vueltas vuelve a poner una imagen que
      // ya salio, y el libro se ve reciclado. Las que la propia seccion habia
      // declarado en el markdown no cuentan como repetidas: ya estan en
      // `vistas` justamente porque son de aca, y el manifiesto lo unico que
      // hace con ellas es reordenarlas.
      const propias = new Set(s.figuras.map((f) => f.src));
      figuras = figuras.filter((f) => propias.has(f.src) || !vistas.has(f.src));
      for (const f of figuras) vistas.add(f.src);
    }
    if (regla.quitar) figuras = figuras.filter((f) => !regla.quitar.includes(f.src));

    // `anclas` es la forma buena de ubicar: { "src": ..., "tras": "texto" }.
    // `posiciones` sigue andando para lo que no necesita precision.
    const porSrc = Object.fromEntries((regla.anclas || []).map((a) => [a.src, a.tras]));

    const piezas = figuras.map((f, i) => ({
      bloque: { ...f, t: 'figura', modo: (regla.modos || {})[f.src] || regla.modo || 'estampa' },
      tras: f.tras || porSrc[f.src] || null,
      pos: (regla.posiciones || repartir(figuras.length))[i],
    }));

    if (regla.tira) {
      for (const src of regla.tira) vistas.add(src);
      piezas.push({
        bloque: { t: 'tira', items: regla.tira.map((x) => (typeof x === 'string' ? { src: x } : x)) },
        tras: regla.trasTira || null,
        pos: regla.posTira ?? 0.16,
      });
    }

    for (const v of regla.vinetas || []) {
      vistas.add(v.src);
      piezas.push({
        bloque: { t: 'vineta', src: v.src, ancho: v.ancho || 38, lado: v.lado || 'der', nombre: v.nombre || null },
        tras: v.tras || porSrc[v.src] || null,
        pos: v.pos ?? 0.5,
      });
    }

    if (!piezas.length) { salida.push(...s.cuerpo); continue; }

    // Cada pieza se resuelve a un indice del cuerpo. Se ordena por ese indice
    // y no por `pos`, porque una pieza anclada por texto puede caer antes que
    // otra que pidio una fraccion mas chica.
    const puestas = piezas
      .map((p) => ({ bloque: p.bloque, en: ubicar(p, s.cuerpo, clave) }))
      .sort((a, b) => a.en - b.en);

    let f = 0;
    for (let i = 0; i <= s.cuerpo.length; i++) {
      while (f < puestas.length && puestas[f].en === i) { salida.push(puestas[f].bloque); f++; }
      if (i < s.cuerpo.length) salida.push(s.cuerpo[i]);
    }
  }
  return salida;
}

// Se acumulan y las revisa `verificar.mjs`: un ancla rota mueve una imagen a
// cualquier lado sin avisar, que es peor que no tenerla.
const ROTAS = [];

/**
 * Donde entra una pieza dentro del cuerpo de la seccion.
 *
 * Con `tras` se busca el parrafo que contiene ese texto y la imagen entra
 * justo despues. Es la forma buena: la imagen aparece cuando el texto acaba de
 * nombrar lo que muestra. La fraccion `pos` sigue existiendo para los casos
 * donde no importa tanto, pero no sabe leer: en el 12 % de una seccion puede
 * haber perfectamente el medio de una conversacion.
 *
 * Y despues, con cualquiera de los dos, se corrige el lugar:
 *
 *   - una `figura` ocupa el ancho de la caja y parte la lectura, asi que nunca
 *     queda entre dos `dialogo`: se corre hasta el final de la tanda hablada;
 *   - una `vineta` va flotada al margen y el texto la rodea, asi que puede
 *     quedarse adentro de un dialogo — es como quedaron las de Tao y la de Mei
 *     en el Tomo I;
 *   - ninguna imagen queda pegada arriba de nada que no sea texto.
 */
function ubicar(pieza, cuerpo, clave) {
  const n = cuerpo.length;
  let i;

  if (pieza.tras) {
    const buscado = normalizar(pieza.tras);
    i = cuerpo.findIndex((b) => normalizar(textoPlano(b.texto)).includes(buscado));
    if (i === -1) {
      ROTAS.push({ clave, src: pieza.bloque.src || pieza.bloque.t, tras: pieza.tras });
      i = Math.round((pieza.pos ?? 0.4) * n); // no se pierde la imagen; se avisa
    } else {
      i += 1; // «tras» quiere decir despues de ese parrafo
    }
  } else {
    i = Math.round((pieza.pos ?? 0.5) * n);
  }

  i = Math.max(0, Math.min(n, i));

  if (pieza.bloque.t !== 'vineta') {
    while (i > 0 && i < n && cuerpo[i - 1].t === 'dialogo' && cuerpo[i].t === 'dialogo') i++;
  }
  return i;
}

/** Para comparar anclas sin que un acento o un guion largo las rompa. */
function normalizar(s) {
  return String(s || '')
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9]+/g, ' ')
    .trim()
    .toLowerCase();
}

/** Reparte n figuras a lo largo de la seccion sin amontonarlas ni al principio ni al final. */
function repartir(n) {
  if (n === 1) return [0.28];
  return Array.from({ length: n }, (_, i) => 0.12 + (0.76 * i) / (n - 1));
}

function textoPlano(s) {
  return String(s || '').replace(/<[^>]+>/g, '').trim();
}

// ------------------------------------------------------------ documentos

function preliminares(doc) {
  return [
    { t: 'portadilla', titulo: 'El Guardián del Templo', bajada: doc.bajada },
    { t: 'creditos' },
  ];
}

function armar(tomos, meta, maqueta) {
  const bloques = [];
  const vistas = new Set();
  for (const tomo of tomos) {
    const reglaDia = maqueta[`${tomo.dia}/@dia`] || {};
    if (reglaDia.fondo) vistas.add(reglaDia.fondo);
    bloques.push({
      t: 'dia', numero: tomo.dia, titulo: tomo.titulo, tema: tomo.tema,
      fondo: reglaDia.fondo || null,
    });
    bloques.push(...colocar(tomo.bloques, maqueta, vistas, tomo.dia));
  }
  return {
    titulo: 'El Guardián del Templo',
    bajada: meta.bajada,
    bloques: [...preliminares(meta), ...bloques, { t: 'colofon' }],
  };
}

// -------------------------------------------------------- volumen unico

// Los tomos que ya estan terminados. El volumen se arma con estos y nada mas:
// meter un tomo sin revisar mentiria sobre el largo del libro y sobre lo que
// se esta vendiendo. El II y el III pasaron la revision del autor y entraron;
// los dos quedaron congelados en `final/` el mismo dia, asi que el volumen los
// hereda acomodados y no vuelve a colocarles las imagenes.
const EN_EL_VOLUMEN = ['tomo1', 'tomo2', 'tomo3'];

// El recortado, no el original: `fuerza.jpg` trae su propio papel gris.
// Lo produce preparar_arte.py::recortar_sello().
const SELLO = 'cuento/libro/img/sello_fuerza.png';

// La misma tapa que arma el forro de imprenta en tapa.html. Va sola adentro del
// volumen: los tomos sueltos se venden con su forro y no la llevan en el cuerpo.
// La produce preparar_arte.py::ampliar_tapa(), ya recortada a la proporcion del
// destino, asi que entra a pagina entera sin deformarse.
const TAPA = 'cuento/libro/img/tapa.jpeg';

/**
 * El volumen unico: los tomos terminados, uno atras del otro, cada uno cerrado
 * con el sello 加油.
 *
 * Lee de `final/`, asi que hereda el acomodo a mano de cada tomo en vez de
 * volver a colocar las imagenes por su cuenta. Le saca a cada tomo sus propios
 * preliminares —portadilla, creditos— y su «Fin», porque adentro del volumen
 * esas paginas van una sola vez, al principio y al final de todo.
 */
function volumen(docs) {
  const PROPIOS = new Set(['portadilla', 'creditos', 'colofon']);
  const bloques = [];

  for (const nombre of EN_EL_VOLUMEN) {
    const ruta = path.join(FINAL, `${nombre}.json`);
    const doc = fs.existsSync(ruta)
      ? JSON.parse(fs.readFileSync(ruta, 'utf8'))
      : docs[nombre];
    if (!doc) continue;

    bloques.push(...doc.bloques.filter((b) => !PROPIOS.has(b.t)));
    bloques.push({ t: 'sello', src: SELLO, ancho: 34 });
  }

  return {
    titulo: 'El Guardián del Templo',
    bajada: 'Espíritu de sacrificio',
    bloques: [
      { t: 'tapa', src: TAPA },
      { t: 'portadilla', titulo: 'El Guardián del Templo', bajada: 'Espíritu de sacrificio' },
      { t: 'creditos' },
      ...bloques,
      { t: 'colofon' },
    ],
  };
}

// ----------------------------------------------------------------- salida

function main() {
  const pedido = process.argv[2];
  fs.mkdirSync(DATOS, { recursive: true });

  const rutaMaqueta = path.join(AQUI, 'maqueta.json');
  const maqueta = fs.existsSync(rutaMaqueta)
    ? JSON.parse(fs.readFileSync(rutaMaqueta, 'utf8'))
    : {};

  const leidos = TOMOS.map(leerTomo);

  const docs = {};
  leidos.forEach((tomo, i) => {
    docs[`tomo${i + 1}`] = armar([tomo], { bajada: tomo.bajada }, maqueta);
  });
  docs.completo = volumen(docs);

  for (const [nombre, doc] of Object.entries(docs)) {
    if (pedido && pedido !== nombre) continue;

    if (congelado(nombre)) {
      console.log(`${nombre.padEnd(9)} CONGELADO · se lee de final/${nombre}.json y no se toca`);
      continue;
    }

    const destino = path.join(DATOS, `${nombre}.json`);
    fs.writeFileSync(destino, JSON.stringify(doc, null, 1));
    const figuras = doc.bloques.filter((b) => b.t === 'figura').length;
    const palabras = doc.bloques
      .filter((b) => b.t === 'parrafo' || b.t === 'dialogo')
      .reduce((n, b) => n + textoPlano(b.texto).split(/\s+/).length, 0);
    console.log(`${nombre.padEnd(9)} ${String(doc.bloques.length).padStart(5)} bloques · ${String(figuras).padStart(3)} ilustraciones · ${String(palabras).padStart(6)} palabras`);
  }

  if (ROTAS.length) {
    console.log('\n  ANCLAS ROTAS — el texto cambió y la imagen quedó a la deriva:');
    for (const r of ROTAS) console.log(`   · ${r.clave} → ${r.src}\n     buscaba: «${r.tras}»`);
    process.exitCode = 1;
  }
}

main();
