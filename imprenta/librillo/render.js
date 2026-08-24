'use strict';
/* Bloque → HTML, y las dos funciones que el paginador necesita del navegador.
 *
 * Es el único archivo de `librillo/` que toca el DOM. El resto —geometría,
 * paginación, tokens— es puro y se prueba sin navegador.
 */

const MM = 96 / 25.4; // px CSS por mm

/** Expande los bloques generados desde el JSON del juego.
 *
 * `contenido_es.js` escribe marcas como `{t:'reglas'}` en vez de repetir el
 * texto: acá se convierten en bloques normales. Así la prosa queda separada
 * del dato y ninguna de las dos sabe de la otra.
 */
function expandir(bloques, d) {
  const fuera = [];
  for (const b of bloques) {
    if (b.t === 'reglas') {
      for (const r of d.reglas) {
        fuera.push({ t: 'titulo', nivel: 2, texto: r.titulo });
        fuera.push({ t: 'lista', orden: 'punto', items: r.lineas });
      }
    } else if (b.t === 'tabla-dificultades') {
      // La columna de Cansancio dice la ACCIÓN, no un número de modo. Decía
      // «1 · ninguno», que no significa nada si no tenés la otra tabla
      // delante. Y la del coste de robo decía «Robo extra», que se lee como
      // «cuántas cartas robás» cuando en realidad es lo que cuesta cada una.
      const SIN_CANSANCIO = 'No se usa: queda en la caja';
      const filas = d.dificultades.map((x) => [
        `<b>${x.nombre}</b>`, x.energiaInicial, x.peligrosPorFase, x.cantidadJefes,
        x.costeRoboExtra, SIN_CANSANCIO,
      ]);
      for (const n of window.CONTENIDO_ES.NIVELES_DE_PAPEL) {
        filas.push([`<b>${n.nombre}</b>`, n.energia, n.peligros, n.jefes, n.robo, n.cansancio]);
      }
      fuera.push({
        t: 'tabla',
        cabeceras: ['Nivel', 'Energía<br>inicial', 'Peligros<br>por fase', 'Jefes',
                    'Cada carta extra<br>cuesta (Energía)', 'Mazo de Cansancio'],
        filas,
      });
      // Las reglas propias de cada nivel que la tabla no puede mostrar sin
      // volverse ilegible: sólo se listan las que se apartan de lo normal.
      const especiales = (x) => {
        const e = [];
        if (x.cartasGratisExtra > 0) {
          e.push(`robás ${x.cartasGratisExtra} carta gratis de más en cada peligro`);
        }
        if (!x.meditarSoloAlPerder) e.push('podés meditar también después de ganar');
        return e.length ? ` <i>Además: ${e.join('; ')}.</i>` : '';
      };
      fuera.push({
        t: 'lista', orden: 'punto',
        items: d.dificultades.map((x) => `<b>${x.nombre}</b> — ${x.bajada}${especiales(x)}`)
          .concat(window.CONTENIDO_ES.NIVELES_DE_PAPEL.map((n) => `<b>${n.nombre}</b> — ${n.bajada}`)),
      });
    } else if (b.t === 'referencia-cartas') {
      fuera.push({ t: 'titulo', nivel: 2, texto: 'Mazo inicial' });
      fuera.push({
        t: 'tabla',
        cabeceras: ['Carta', 'Poder', 'Efecto', 'Copias'],
        filas: d.mazoInicial.map((c) => [c.nombre, c.poder, c.efecto.texto || '—', c.copias]),
      });
      for (const [clave, titulo] of [['alba', 'Alba'], ['mediodia', 'Mediodía'], ['ocaso', 'Ocaso']]) {
        fuera.push({ t: 'titulo', nivel: 2, texto: `Mazo del ${titulo}` });
        fuera.push({
          t: 'tabla',
          cabeceras: ['Peligro', 'Pod', 'Dañ', 'Gratis', 'Técnica que ganás'],
          filas: d.peligros[clave].map((x) => [
            x.nombre, x.poder, x.dano, x.cartasGratis,
            `${x.recompensa.nombre} (${x.recompensa.poder})` +
              (x.recompensa.efecto.texto ? ` · ${x.recompensa.efecto.texto}` : ''),
          ]),
        });
      }
      fuera.push({ t: 'titulo', nivel: 2, texto: 'Campeones del Torneo' });
      fuera.push({
        t: 'tabla',
        cabeceras: ['Jefe', 'Poder', 'Daño', 'Cartas gratis'],
        filas: d.jefes.map((x) => [x.nombre, x.poder, x.dano, x.cartasGratis]),
      });
    } else {
      fuera.push(b);
    }
  }
  return fuera;
}

// ------------------------------------------------------------------- dibujo
const esc = (s) => String(s);

function html(b, d, anclas) {
  const S = (x) => window.REFS.sustituir(x, d, anclas);
  switch (b.t) {
    case 'portada':
      return `<div class="portada"><h1>${esc(b.titulo)}</h1>` +
        `<p class="bajada">${esc(b.bajada)}</p><p class="pie">${esc(b.linea)}</p></div>`;
    case 'capitulo':
      return `<h1 class="capitulo">${esc(b.titulo)}</h1>`;
    case 'titulo':
      return `<h${b.nivel + 1}>${S(b.texto)}</h${b.nivel + 1}>`;
    case 'parrafo':
      return `<p>${S(b.texto)}</p>`;
    case 'lista': {
      const tag = b.orden === 'numero' ? 'ol' : 'ul';
      return `<${tag}>${b.items.map((i) => `<li>${S(i)}</li>`).join('')}</${tag}>`;
    }
    case 'tabla':
      return `<table><thead><tr>${b.cabeceras.map((c) => `<th>${S(c)}</th>`).join('')}` +
        `</tr></thead><tbody>${b.filas.map((f) =>
          `<tr>${f.map((c) => `<td>${S(c)}</td>`).join('')}</tr>`).join('')}</tbody></table>` +
        (b.pie ? `<p class="pie-tabla">${S(b.pie)}</p>` : '');
    case 'aparte':
      return `<div class="aparte ${b.tono}">${S(b.texto)}</div>`;
    case 'anatomia':
      return `<div class="anatomia"><p>${S(b.texto)}</p>` +
        `<img src="../../print/${b.carta}" alt="">` +
        `<ol class="llamadas">${b.llamadas.map((c) => `<li>${S(c)}</li>`).join('')}</ol></div>`;
    case 'ejemplo':
      return `<div class="ejemplo"><h3>${S(b.titulo)}</h3>` +
        `<img src="../../print/${b.carta}" alt="">` +
        `<ol>${b.pasos.map((c) => `<li>${S(c)}</li>`).join('')}</ol></div>`;
    case 'vineta':
      return `<div class="vineta">` +
        (b.entrada ? `<p class="entrada"><span>Momento de la partida</span>${S(b.entrada)}</p>` : '') +
        `<img src="../../print/${b.archivo}" alt="">` +
        (b.narracion ? `<p class="narracion">${S(b.narracion)}</p>` : '') +
        `<div class="dichos">${(b.dichos || []).map((di) =>
          di.acotacion
            ? `<p class="acotacion">${esc(di.texto)}</p>`
            : `<p class="dicho"><span class="quien">${esc(di.quien)}</span>${esc(di.texto)}</p>`
        ).join('')}</div></div>`;
    case 'bifurcacion':
      // La página de «pará y jugá». Es la única del cómic que no es una
      // viñeta, así que se compone como una señal, no como texto: si se lee
      // igual que el resto, el lector la pasa de largo y sigue leyendo el
      // final antes de haber jugado.
      return `<div class="bifurcacion">` +
        `<p class="alto">Alto</p>` +
        (b.cierre ? `<p class="cierre">${S(b.cierre)}</p>` : '') +
        `<p class="jugar">Cerrá el librillo y jugá ${S(b.jugar)}.</p>` +
        `<p class="volve">Cuando la partida llegue a su fin, volvé acá:</p>` +
        `<ul class="ramas">${b.ramas.map((r) =>
          `<li><span class="cond">${S(r.condicion)}</span>` +
          `<span class="dest">seguí en la página ${S(`{ref:${r.a}}`)}</span></li>`).join('')}</ul></div>`;
    default:
      return `<p class="error">bloque desconocido: ${esc(b.t)}</p>`;
  }
}

/** Medidor: un contenedor oculto del ancho EXACTO de la columna A5. */
function hacerMedidor(anchoMm) {
  const el = document.createElement('div');
  el.className = 'pagina medidor';
  el.style.width = `${anchoMm}mm`;
  document.body.appendChild(el);
  return el;
}

function hacerMedir(medidor, d) {
  const cache = new Map();
  return (b) => {
    if (cache.has(b)) return cache.get(b);
    medidor.innerHTML = html(b, d, null);
    const alto = medidor.getBoundingClientRect().height / MM;
    cache.set(b, alto);
    return alto;
  };
}

/** Parte un párrafo o una lista para que su primer trozo entre en [libre].
 *
 * Búsqueda binaria sobre palabras (o ítems) midiendo de verdad: el corte de
 * línea lo hace el navegador, así que no hay tabla de anchos ni silabación
 * que aproximar. Devuelve `[cabe, resto]`, o null si no vale la pena partir.
 */
function hacerDividir(medir, medidor, d) {
  const altoDe = (b) => {
    medidor.innerHTML = html(b, d, null);
    return medidor.getBoundingClientRect().height / MM;
  };
  return (b, libre, minimo) => {
    if (b.t === 'lista') {
      if (b.items.length < minimo * 2) return null;
      for (let n = b.items.length - minimo; n >= minimo; n--) {
        const cabe = { ...b, items: b.items.slice(0, n) };
        if (altoDe(cabe) <= libre) {
          return [cabe, { ...b, items: b.items.slice(n) }];
        }
      }
      return null;
    }
    if (b.t !== 'parrafo') return null;

    const palabras = b.texto.split(' ');
    if (palabras.length < 12) return null; // no vale partir dos renglones

    // Una línea suelta arriba o abajo es peor que mover el párrafo entero.
    const unaLinea = altoDe({ ...b, texto: 'x' });
    let mejor = 0, lo = 1, hi = palabras.length - 1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      const alto = altoDe({ ...b, texto: palabras.slice(0, mid).join(' ') });
      if (alto <= libre) { mejor = mid; lo = mid + 1; } else hi = mid - 1;
    }
    if (!mejor) return null;

    const cabe = { ...b, texto: palabras.slice(0, mejor).join(' ') };
    const resto = { ...b, texto: palabras.slice(mejor).join(' ') };
    if (altoDe(cabe) < unaLinea * minimo) return null;
    if (altoDe(resto) < unaLinea * minimo) return null;
    return [cabe, resto];
  };
}

// Se asigna directo y sin variable intermedia: los cinco archivos de
// `librillo/` se cargan como <script> clásicos y comparten el ámbito
// global, así que cualquier `const` repetido tumba la página entera.
if (typeof window !== 'undefined') window.RENDER = { MM, expandir, html, hacerMedidor, hacerMedir, hacerDividir };
