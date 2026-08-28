'use strict';
/* Reparte los bloques del cuento en páginas de alto fijo.
 *
 * Copia adaptada de `imprenta/librillo/paginador.js`. Es copia y no import a
 * propósito: el librillo es parte del juego y no quiero que un ajuste en el
 * reglamento mueva un corte de página del libro, ni al revés.
 *
 * Lo que se agregó respecto del original:
 *   - páginas enteras (aperturas de día y de fase, figuras a sangre),
 *   - «el día empieza en impar» generalizado a cualquier bloque,
 *   - las figuras no se parten nunca y arrastran su epígrafe.
 *
 * `medir` y `dividir` entran por parámetro para poder probar esto sin DOM.
 */

/** Se mueven enteros o no se mueven. */
const ATOMICOS = new Set(['figura', 'vineta', 'tira', 'sello', 'dialogo', 'nota']);

/** Nunca pueden quedar últimos en una página. */
const CON_EL_SIGUIENTE = new Set(['titulo']);

/** Ocupan la página completa, ellos solos. */
const PAGINA_ENTERA = new Set(['tapa', 'dia', 'fase', 'portadilla', 'creditos', 'colofon']);

/** Empiezan en página derecha, cueste una blanca. */
const EN_IMPAR = new Set(['tapa', 'dia', 'portadilla']);

/** Mínimo de líneas de cada lado de un corte de párrafo. */
const MINIMO = 2;

function paginar(bloques, { medir, dividir, altoUtil }) {
  const paginas = [];
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
    usado = cola.reduce((s, b, i) => s + medir(b, i === 0), 0);
  };

  for (const b of bloques) {
    const entera = PAGINA_ENTERA.has(b.t) || (b.t === 'figura' && (b.modo === 'sobre' || b.modo === 'sangre'));

    if (entera) {
      if (actual.length) cerrar();
      // paginas.length es el número de la página que se está por abrir menos
      // una; si es par, la próxima es impar y ya estamos donde queremos.
      if (EN_IMPAR.has(b.t) && paginas.length % 2 === 1) paginas.push([]);
      paginas.push([b]);
      actual = [];
      usado = 0;
      continue;
    }

    let pieza = b;
    while (pieza) {
      const alto = medir(pieza, actual.length === 0);
      const libre = altoUtil - usado;

      if (alto <= libre) {
        actual.push(pieza);
        usado += alto;
        break;
      }

      const partible = !ATOMICOS.has(pieza.t) && !CON_EL_SIGUIENTE.has(pieza.t);
      const trozo = partible && dividir ? dividir(pieza, libre, MINIMO) : null;
      if (trozo) {
        actual.push(trozo[0]);
        cerrar();
        pieza = trozo[1];
        continue;
      }

      if (!actual.length) {
        // Más alto que una página entera y no se parte: entra igual y se
        // desborda. Falla a la vista en vez de perder contenido.
        actual.push(pieza);
        usado = altoUtil;
        break;
      }
      cerrar();
    }
  }
  if (actual.length) paginas.push(actual);

  // Un libro se imprime en hojas: el total tiene que ser par o la última
  // página queda sin dorso y la imprenta la rellena como quiera.
  if (paginas.length % 2 === 1) paginas.push([]);

  return { paginas };
}

if (typeof window !== 'undefined') {
  window.PAGINADOR = { paginar, ATOMICOS, CON_EL_SIGUIENTE, PAGINA_ENTERA, EN_IMPAR, MINIMO };
}
