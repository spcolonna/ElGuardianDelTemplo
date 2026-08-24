'use strict';
/* Geometría del librillo: de una lista de páginas A5 a hojas A4 apaisadas.
 *
 * Sin DOM y sin dependencias, para que `pruebas.mjs` lo pueda cargar tal cual.
 * Todo en milímetros.
 */

const A5 = { ancho: 148, alto: 210 };
const A4H = { ancho: 297, alto: 210 }; // A4 apaisada

/** Orden de cuadernillo: qué página va en cada mitad de cada hoja.
 *
 * Para doblar al medio y abrochar sobre el pliegue. La hoja 0 es la de
 * AFUERA: lleva la última página a la izquierda y la primera a la derecha.
 *
 * La invariante que lo verifica todo: en las cuatro mitades de una hoja, las
 * dos de adelante suman n+1 y las dos de atrás también. Si eso se cumple para
 * toda hoja y ninguna página se repite, el orden es correcto.
 */
function ordenLibrillo(n) {
  if (n % 4 !== 0) throw new Error(`Un cuadernillo necesita múltiplo de 4 páginas, no ${n}`);
  const hojas = [];
  for (let s = 0; s < n / 4; s++) {
    hojas.push({
      frente: [n - 2 * s, 2 * s + 1],
      dorso: [2 * s + 2, n - 2 * s - 1],
    });
  }
  return hojas;
}

/** Orden de pila: dos A5 por hoja, en orden de lectura, a UNA sola cara.
 *
 * Existe porque el cuadernillo depende de que la impresora registre bien el
 * dúplex, y muchas no lo hacen. Acá se imprime de un lado, se corta al medio
 * y se apila: no hay doblez, no hay dúplex y no hace falta múltiplo de 4.
 */
function ordenPila(n) {
  const hojas = [];
  for (let i = 0; i < n; i += 2) {
    hojas.push({ frente: [i + 1, Math.min(i + 2, n)], dorso: null });
  }
  return hojas;
}

/** Cuántas páginas en blanco hay que agregar para que el orden cierre. */
function relleno(n, modo) {
  const paso = modo === 'pila' ? 2 : 4;
  return (paso - (n % paso)) % paso;
}

/** Cuánto corregir el empuje del pliegue, en mm, para la hoja [s].
 *
 * Un cuadernillo de 32 páginas de 80 g empuja las hojas de adentro unos 3 mm
 * hacia afuera: si no se corrige, el canto queda escalonado y el margen
 * exterior de las páginas centrales se come el texto. Se compensa corriendo
 * el contenido hacia el LOMO, cada vez más cuanto más adentro está la hoja.
 */
function creep(s, grosor) {
  return s * grosor;
}

/** Dónde va cada media página dentro de la hoja A4 apaisada.
 *
 * Devuelve `[{pagina, x, y}]` en mm, con [x, y] en la esquina inferior
 * izquierda de esa mitad. `pagina` es 1-based; `null` es una mitad vacía.
 */
function mitades(hoja, cara, s, grosor = 0) {
  const par = cara === 'frente' ? hoja.frente : hoja.dorso;
  if (!par) return [];
  const d = creep(s, grosor);
  const sobra = (A4H.ancho - A5.ancho * 2) / 2;
  return [
    // La izquierda tiene el lomo a su derecha: se corre hacia la derecha.
    { pagina: par[0], x: sobra + d, y: 0 },
    // La derecha lo tiene a su izquierda: se corre hacia la izquierda.
    { pagina: par[1], x: sobra + A5.ancho - d, y: 0 },
  ].filter((m) => m.pagina !== null);
}

/** El plan completo de impresión para [n] páginas. */
function plan(n, { modo = 'librillo', grosor = 0 } = {}) {
  const paginas = n + relleno(n, modo);
  const hojas = modo === 'pila' ? ordenPila(paginas) : ordenLibrillo(paginas);
  const caras = [];
  hojas.forEach((hoja, s) => {
    caras.push({ hoja: s, cara: 'frente', mitades: mitades(hoja, 'frente', s, grosor) });
    if (hoja.dorso) {
      caras.push({ hoja: s, cara: 'dorso', mitades: mitades(hoja, 'dorso', s, grosor) });
    }
  });
  return { paginas, relleno: paginas - n, hojas: hojas.length, caras, modo };
}

// Se asigna directo y sin variable intermedia: los cinco archivos de
// `librillo/` se cargan como <script> clásicos y comparten el ámbito
// global, así que cualquier `const` repetido tumba la página entera.
if (typeof window !== 'undefined') window.LIBRILLO = { A5, A4H, ordenLibrillo, ordenPila, relleno, creep, mitades, plan };
