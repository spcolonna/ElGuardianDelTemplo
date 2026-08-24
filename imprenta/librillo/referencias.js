'use strict';
/* Tokens y remisiones: los números no se escriben, se resuelven.
 *
 * Dos familias, las dos con la misma sintaxis de llaves:
 *
 *   {n:config.energiaInicial}   un dato del juego, desde imprenta/datos/*.json
 *   {ref:capitulo:preparacion}  el número de página donde está esa ancla
 *
 * La regla de oro del reglamento impreso: en `contenido_es.js` no hay UN SOLO
 * número escrito a mano. Si el motor se rebalancea, el papel cambia solo.
 */

const TOKEN = /\{(n|ref):([^}]+)\}/g;

/** Lee `config.energiaInicial` sobre el JSON exportado. */
function valor(datos, ruta) {
  return ruta.split('.').reduce((o, k) => (o == null ? undefined : o[k]), datos);
}

/** El hueco que ocupa una remisión en la PRIMERA pasada.
 *
 * Se dibuja con ancho reservado para tres dígitos y cifras tabulares. Por eso
 * la segunda pasada, que mete el número de verdad, no puede mover ni un corte
 * de línea: es lo que convierte esto en dos pasadas en vez de en un punto fijo
 * al que hay que iterar sin saber si converge.
 */
const HUECO = '<span class="np">00</span>';

/** Reemplaza los tokens de un texto.
 *
 * Con `anclas === null` está en la primera pasada: los datos ya se resuelven
 * (no cambian nunca) y las remisiones salen como hueco.
 */
function sustituir(texto, datos, anclas) {
  return String(texto).replace(TOKEN, (todo, tipo, arg) => {
    if (tipo === 'n') {
      const v = valor(datos, arg);
      if (v === undefined) throw new Error(`Token sin dato: {n:${arg}}`);
      return String(v);
    }
    if (!anclas) return HUECO;
    const p = anclas[arg];
    if (p === undefined) throw new Error(`Remisión a un ancla que no existe: {ref:${arg}}`);
    return `<span class="np">${p}</span>`;
  });
}

/** Todos los tokens de un árbol de bloques, sin resolver. */
function tokensDe(bloques) {
  const fuera = [];
  const mirar = (v) => {
    if (typeof v === 'string') {
      for (const m of v.matchAll(TOKEN)) fuera.push({ tipo: m[1], arg: m[2] });
    } else if (Array.isArray(v)) v.forEach(mirar);
    else if (v && typeof v === 'object') Object.values(v).forEach(mirar);
  };
  bloques.forEach(mirar);
  return fuera;
}

/** Todo lo que puede estar mal antes de imprimir. Devuelve una lista de quejas. */
function comprobar(bloques, datos, anclas) {
  const quejas = [];
  const declaradas = new Set(
    bloques.filter((b) => b.id).map((b) => `${b.t}:${b.id}`)
  );
  const vistas = new Set();
  for (const b of bloques) {
    if (!b.id) continue;
    const k = `${b.t}:${b.id}`;
    if (vistas.has(k)) quejas.push(`Ancla repetida: ${k}`);
    vistas.add(k);
  }
  for (const { tipo, arg } of tokensDe(bloques)) {
    if (tipo === 'n' && valor(datos, arg) === undefined) {
      quejas.push(`Token sin dato: {n:${arg}}`);
    }
    if (tipo === 'ref' && !declaradas.has(arg)) {
      quejas.push(`Remisión a un ancla que no existe: {ref:${arg}}`);
    }
    if (tipo === 'ref' && anclas && anclas[arg] === undefined) {
      quejas.push(`El ancla ${arg} se declara pero no cayó en ninguna página`);
    }
  }
  return quejas;
}

/** Las bifurcaciones del cómic, que tienen su propia regla.
 *
 * La derrota se dispara desde CUALQUIER fase —hay un solo final de 3 viñetas
 * para todas—, así que toda página de bifurcación tiene que ofrecer esa
 * salida. Es una regla que impone el generador y no algo que el autor tenga
 * que acordarse en cada una.
 */
function comprobarBifurcaciones(bloques) {
  const quejas = [];
  const secuencias = new Set(
    bloques.filter((b) => b.t === 'vineta' && b.id).map((b) => `vineta:${b.id}`)
  );
  for (const b of bloques.filter((x) => x.t === 'bifurcacion')) {
    for (const r of b.ramas || []) {
      if (!secuencias.has(r.a)) quejas.push(`Bifurcación a una secuencia que no existe: ${r.a}`);
    }
    if (!(b.ramas || []).some((r) => r.a === 'vineta:derrota')) {
      quejas.push(`La bifurcación "${b.cierre || b.jugar || '(sin título)'}" no ofrece la salida por derrota`);
    }
  }
  return quejas;
}

// Se asigna directo y sin variable intermedia: los cinco archivos de
// `librillo/` se cargan como <script> clásicos y comparten el ámbito
// global, así que cualquier `const` repetido tumba la página entera.
if (typeof window !== 'undefined') window.REFS = { TOKEN, HUECO, valor, sustituir, tokensDe, comprobar, comprobarBifurcaciones };
