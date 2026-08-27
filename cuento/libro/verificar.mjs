// Chequeos automáticos del libro.
//
//   node cuento/libro/verificar.mjs            # todos los documentos
//   node cuento/libro/verificar.mjs tomo1
//
// Lo que se puede medir se mide. Lo que no —si el libro es bueno— lo mirás vos.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const AQUI = path.dirname(fileURLToPath(import.meta.url));
const RAIZ = path.resolve(AQUI, '..', '..');
const DATOS = path.join(AQUI, 'datos');

// Geometría de la maqueta, en mm. Tiene que coincidir con libro.css.
//
// Las bandas a sangre conservan la proporción del arte —ancho completo, alto
// libre—, así que el ancho es lo único que decide la resolución. Si alguna vez
// se vuelve a recortar a página entera con `object-fit: cover`, este número
// deja de ser el correcto y hay que medir contra el alto.
const CAJA_MM = 104.7;
const SANGRE_MM = 139.7 + 3.175 * 2;

/** Palabras del juego que no pueden aparecer en la página impresa.
 *
 * `mazo` va con contexto porque en el cuento hay un mazo de madera con el que
 * se toca la campana, y ése es un mazo de verdad. */
const JERGA = [
  /\bmazo de (cartas|peligro|cansancio)\b/i,
  /\bcartas?\s+(de\s+)?(peligro|técnica|jefe|inicial|campeón)/i,
  /\bpuntos? de (poder|daño|energía)\b/i,
  /\bpoder\s+\d+/i,
  /\bdaño\s+\d+/i,
  /\btexto de sabor\b/i,
  /\brobás?\s+(una|dos|tres|\d+)\s+cartas?\b/i,
  /\bmazo inicial\b/i,
];

// ------------------------------------------------------ tamaño de imagen

/** Ancho y alto de un JPEG o un PNG leyendo la cabecera. Sin dependencias. */
function medida(archivo) {
  const b = fs.readFileSync(archivo);

  if (b[0] === 0x89 && b[1] === 0x50) {           // PNG: IHDR es siempre el primero
    return { w: b.readUInt32BE(16), h: b.readUInt32BE(20) };
  }
  if (b[0] === 0xff && b[1] === 0xd8) {           // JPEG: buscar el marcador SOFn
    let i = 2;
    while (i < b.length) {
      if (b[i] !== 0xff) { i++; continue; }
      const marca = b[i + 1];
      // C0..CF son SOF salvo C4 (Huffman), C8 (JPG) y CC (DAC).
      if (marca >= 0xc0 && marca <= 0xcf && marca !== 0xc4 && marca !== 0xc8 && marca !== 0xcc) {
        return { h: b.readUInt16BE(i + 5), w: b.readUInt16BE(i + 7) };
      }
      i += 2 + b.readUInt16BE(i + 2);
    }
  }
  return null;
}

const dpi = (px, mm) => Math.round(px / (mm / 25.4));

// ----------------------------------------------------------- chequeos

function revisar(nombre) {
  const doc = JSON.parse(fs.readFileSync(path.join(DATOS, `${nombre}.json`), 'utf8'));
  const fallos = [];
  const avisos = [];

  // 1 · las imágenes existen, 2 · ninguna se repite, 3 · resolución suficiente
  const vistas = new Map();
  const colocaciones = [];

  const anotar = (src, mm, donde) => {
    if (!src) return;
    colocaciones.push({ src, mm, donde });
    if (vistas.has(src)) fallos.push(`imagen repetida: ${src} (${vistas.get(src)} y ${donde})`);
    else vistas.set(src, donde);
  };

  for (const b of doc.bloques) {
    if (b.t === 'fase' || b.t === 'dia') anotar(b.fondo, SANGRE_MM, `apertura ${b.nombre || b.titulo}`);
    else if (b.t === 'figura') {
      anotar(b.src, b.modo === 'estampa' ? CAJA_MM : SANGRE_MM, `figura ${b.modo}`);
    } else if (b.t === 'vineta') anotar(b.src, b.ancho, 'viñeta');
    else if (b.t === 'tira') {
      // Cinco viñetas repartidas en el ancho de caja, menos las separaciones.
      const anchoUno = (CAJA_MM - 2.2 * (b.items.length - 1)) / b.items.length;
      for (const it of b.items) anotar(it.src, anchoUno, 'tira');
    }
  }

  for (const c of colocaciones) {
    const archivo = path.join(RAIZ, c.src);
    if (!fs.existsSync(archivo)) { fallos.push(`no existe: ${c.src}`); continue; }
    const m = medida(archivo);
    if (!m) { avisos.push(`no pude medir ${c.src}`); continue; }
    c.dpi = dpi(m.w, c.mm);
    c.px = m.w;
    if (c.dpi < 180) fallos.push(`${c.src} a ${Math.round(c.mm)} mm queda en ${c.dpi} dpi (${m.w} px) — ${c.donde}`);
    else if (c.dpi < 300) avisos.push(`${c.src} a ${Math.round(c.mm)} mm queda en ${c.dpi} dpi — ${c.donde}`);
  }

  // 4 · nada de jerga de juego en la página
  const texto = doc.bloques
    .map((b) => [b.texto, b.tema, b.titulo, b.nombre, ...(b.items || []).map((i) => i.nombre)].filter(Boolean).join(' '))
    .join('\n')
    .replace(/<[^>]+>/g, '');
  for (const re of JERGA) {
    const m = texto.match(re);
    if (m) fallos.push(`jerga de juego en la página: «${m[0]}»`);
  }

  return { doc, fallos, avisos, colocaciones, arte: vistas.size };
}

// ------------------------------------------------------------------ salida

const pedido = process.argv[2];
const docs = fs.readdirSync(DATOS).filter((f) => f.endsWith('.json')).map((f) => f.slice(0, -5));
let total = 0;

for (const nombre of docs) {
  if (pedido && pedido !== nombre) continue;
  const r = revisar(nombre);
  const bajos = r.colocaciones.filter((c) => c.dpi && c.dpi < 300).length;

  console.log(`\n── ${nombre} · ${r.arte} ilustraciones · ${r.colocaciones.length} colocaciones`);
  console.log(`   resolución: ${r.colocaciones.length - bajos} a 300 dpi o más, ${bajos} por debajo`);

  for (const f of r.fallos) console.log(`   ✗ ${f}`);
  for (const a of r.avisos) console.log(`   · ${a}`);
  if (!r.fallos.length) console.log('   ✓ sin fallos');
  total += r.fallos.length;
}

console.log(total ? `\n${total} fallo(s).` : '\nTodo en orden.');
process.exit(total ? 1 : 0);
