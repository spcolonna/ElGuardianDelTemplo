'use strict';
/* Reparte una lista plana de bloques en páginas A5 de alto fijo.
 *
 * Por qué paginamos nosotros y no el navegador. La idea obvia es soltar el
 * contenido en un `@page` y dejar que corte solo, y ahí es donde esta clase de
 * herramienta se rompe: `orphans`/`widows` lo respeta casi sólo Chrome,
 * `break-inside: avoid` diverge entre motores en cuanto el bloque es alto, y
 * —lo peor— la cantidad de páginas cambia con el reflow, así que el orden de
 * cuadernillo no se puede calcular hasta después de imprimir.
 *
 * Paginando acá, al navegador sólo le pedimos cortar entre hermanos de alto
 * fijo que llenan la página exacta, que es la única construcción en la que
 * Chrome, Safari y Firefox coinciden.
 *
 * `medir` y `dividir` entran por parámetro para poder probar esto sin DOM.
 */

/** Bloques que se mueven enteros o no se mueven. */
const ATOMICOS = new Set(['tabla', 'ejemplo', 'anatomia', 'figura', 'vineta', 'bifurcacion']);

/** Bloques que nunca pueden quedar últimos en una página. */
const CON_EL_SIGUIENTE = new Set(['titulo', 'capitulo']);

/** Mínimo de líneas o ítems que puede quedar de cada lado de un corte. */
const MINIMO = 2;

function paginar(bloques, { medir, dividir, altoUtil }) {
  const paginas = [];
  const anclas = {};
  let actual = [];
  let usado = 0;

  const cerrar = () => {
    // Un título solo al pie no es una página: baja con lo que encabeza.
    const cola = [];
    while (actual.length && CON_EL_SIGUIENTE.has(actual[actual.length - 1].t)) {
      cola.unshift(actual.pop());
    }
    paginas.push(actual);
    actual = cola;
    usado = cola.reduce((s, b) => s + medir(b), 0);
  };

  const anotar = (b) => {
    if (b.id) anclas[`${b.t}:${b.id}`] = paginas.length + 1;
  };

  for (const b of bloques) {
    if (b.t === 'salto' || (b.t === 'capitulo' && actual.length)) {
      cerrar();
      // Un capítulo que arranca en impar: se cierra otra vez para que caiga a
      // la derecha del pliego, que es donde el ojo espera que empiece algo.
      if (b.t === 'capitulo' && b.empiezaImpar && paginas.length % 2 === 1) cerrar();
      if (b.t === 'salto') continue;
    }

    let pieza = b;
    while (pieza) {
      const alto = medir(pieza);
      const libre = altoUtil - usado;

      if (alto <= libre) {
        anotar(pieza);
        actual.push(pieza);
        usado += alto;
        break;
      }

      // No entra. ¿Se puede partir?
      const partible = !ATOMICOS.has(pieza.t) && !CON_EL_SIGUIENTE.has(pieza.t);
      const trozo = partible && dividir ? dividir(pieza, libre, MINIMO) : null;
      if (trozo) {
        anotar(trozo[0]);
        actual.push(trozo[0]);
        cerrar();
        pieza = trozo[1];
        continue;
      }

      if (!actual.length) {
        // Más alto que una página entera y no se parte: entra igual y se
        // desborda. Falla a la vista en vez de perder contenido.
        anotar(pieza);
        actual.push(pieza);
        usado = altoUtil;
        break;
      }
      cerrar();
    }
  }
  if (actual.length) paginas.push(actual);
  return { paginas, anclas };
}

// Se asigna directo y sin variable intermedia: los cinco archivos de
// `librillo/` se cargan como <script> clásicos y comparten el ámbito
// global, así que cualquier `const` repetido tumba la página entera.
if (typeof window !== 'undefined') window.PAGINADOR = { paginar, ATOMICOS, CON_EL_SIGUIENTE, MINIMO };
