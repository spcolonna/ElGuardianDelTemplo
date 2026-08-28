'use strict';
/* Bloque → HTML, y las dos funciones que el paginador le pide al navegador.
 *
 * Es el único archivo del libro que toca el DOM. La paginación es pura.
 *
 * Nada de lo que sale de acá nombra una carta, un mazo ni un punto de poder:
 * las etiquetas del markdown son andamiaje de producción y mueren en el
 * parser. Acá abajo sólo hay cuento.
 */

const MM = 96 / 25.4; // px CSS por mm

const RAIZ = '../../'; // de cuento/libro/ a la raíz del repo

function url(src) {
  // Las rutas del manifiesto vienen desde la raíz del repo; el HTML vive dos
  // carpetas adentro.
  return RAIZ + src;
}

function esc(s) {
  return String(s == null ? '' : s);
}

/** Un bloque de contenido corriente, de los que se apilan dentro de la caja. */
function html(b) {
  switch (b.t) {
    case 'parrafo':
      return `<p class="parrafo${b.primero ? ' primero' : ''}${b.capitular ? ' capitular' : ''}">${esc(b.texto)}</p>`;

    case 'dialogo': {
      const nota = /^LA NOTA$/i.test(b.quien);
      const acot = b.acot ? `<span class="acot">(${esc(b.acot)})</span> ` : '';
      return `<p class="${nota ? 'nota' : 'dialogo'}"><span class="quien">${esc(b.quien)}</span>${acot}${esc(b.texto)}</p>`;
    }

    case 'aparte':
      return `<p class="aparte">${esc(b.texto)}</p>`;

    case 'separador':
      return '<div class="separador"></div>';

    case 'titulo':
      return `<h2 class="seccion">${esc(b.texto)}</h2>`;

    case 'figura':
      return `<figure class="estampa"><img src="${url(b.src)}" alt=""></figure>`;

    case 'vineta':
      return `<figure class="vineta ${b.lado === 'izq' ? 'izq' : 'der'}">`
        + `<img src="${url(b.src)}" style="width:${b.ancho}mm" alt=""></figure>`;

    // El cierre de cada tomo dentro del volumen unico. Va chico a proposito:
    // el original mide 512 px, asi que a 34 mm imprime a 380 dpi y a ancho de
    // caja imprimiria a 124. Ademas es un sello, no una ilustracion.
    case 'sello':
      return `<figure class="sello"><img src="${url(b.src)}" style="width:${b.ancho || 34}mm" alt=""></figure>`;

    case 'tira':
      return '<div class="tira">' + b.items.map((it) =>
        `<div class="item"><img src="${url(it.src)}" alt="">`
        + (it.nombre ? `<div class="pie">${esc(it.nombre)}</div>` : '')
        + '</div>').join('') + '</div>';

    default:
      return '';
  }
}

/** Una página entera: apertura, imagen a sangre, preliminar. */
function paginaEntera(b, doc) {
  switch (b.t) {
    case 'portadilla':
      return {
        muda: true,
        html: '<div class="preliminar">'
          + `<div class="marca">${esc(b.titulo)}</div>`
          + '<div class="regla"></div>'
          + (b.bajada ? `<div class="bajada">${esc(b.bajada)}</div>` : '')
          + '</div>',
      };

    case 'creditos':
      return {
        muda: true,
        html: '<div class="creditos">'
          + `<p><b>${esc(doc.titulo)}</b>${doc.bajada ? ' · ' + esc(doc.bajada) : ''}</p>`
          + '<p>Texto e ilustraciones del universo de <b>El Guardián del Templo</b>.</p>'
          + '<p>Todas las ilustraciones son originales.</p>'
          + '<p>Primera edición.</p>'
          + '</div>',
      };

    case 'colofon':
      return {
        muda: true,
        html: '<div class="preliminar">'
          + '<div class="regla"></div>'
          + '<div class="bajada">Fin</div>'
          + '</div>',
      };

    // La tapa del volumen, a pagina entera. Se apoya en la banda a sangre pero
    // cubre la hoja de punta a punta en vez de centrarse: una tapa con papel
    // arriba y abajo no es una tapa.
    case 'tapa':
      return {
        muda: true,
        clase: 'sangre tapa-libro',
        html: `<div class="banda-sangre"><img src="${url(b.src)}" alt=""></div>`,
      };

    case 'dia':
      return {
        muda: true,
        html: `<div class="apertura-dia${b.fondo ? '' : ' sin-imagen'}">`
          + (b.fondo ? `<div class="banda"><img src="${url(b.fondo)}" alt=""></div>` : '')
          + '<div class="rotulo">'
          + `<div class="dia">Día ${esc(b.numero).toLowerCase()}</div>`
          + `<h1>${esc(b.titulo)}</h1>`
          + (b.tema ? `<div class="tema">${esc(b.tema)}</div>` : '')
          + '</div></div>',
      };

    case 'fase':
      return {
        muda: true,
        html: `<div class="apertura-fase${b.menor ? ' menor' : ''}${b.fondo ? '' : ' sin-imagen'}">`
          + (b.fondo ? `<div class="banda"><img src="${url(b.fondo)}" alt=""></div>` : '')
          + '<div class="rotulo">'
          + `<h2>${esc(b.nombre)}</h2>`
          + (b.resto ? `<div class="resto">${esc(b.resto)}</div>` : '')
          + '</div></div>',
      };

    case 'figura':
      if (b.modo === 'sangre') {
        return {
          muda: true,
          clase: 'sangre',
          html: `<div class="banda-sangre"><img src="${url(b.src)}" alt=""></div>`,
        };
      }
      // `sobre`: la banda arriba y el panel de texto apoyado sobre su borde.
      // Los párrafos que van en el panel los junta index.html, que es el que
      // sabe qué viene después de la figura.
      return {
        muda: true,
        clase: 'sobre',
        html: `<div class="banda-sangre"><img src="${url(b.src)}" alt=""></div>`,
        panel: true,
      };

    default:
      return { muda: true, html: '' };
  }
}

// ------------------------------------------------------- medir y dividir

function hacerMedidor() {
  const pag = document.createElement('div');
  pag.className = 'pagina medidor';
  pag.innerHTML = '<div class="caja"></div>';
  document.body.appendChild(pag);
  return pag.querySelector('.caja');
}

/** Alto de un bloque en mm.
 *
 * Se mide dos veces, porque el alto depende de si el bloque abre la página o
 * no: un `h2.seccion` primero no lleva su margen de arriba y en medio de la
 * página lleva 9 mm. Medir una sola vez es el origen clásico del desborde de
 * la última línea.
 */
function hacerMedir(caja) {
  const cache = new Map();
  const medirUno = (b, primero) => {
    caja.innerHTML = (primero ? '' : '<div class="vecino"></div>') + html(b);
    return caja.getBoundingClientRect().height / MM;
  };
  return (b, primero) => {
    let par = cache.get(b);
    if (!par) {
      par = [medirUno(b, true), medirUno(b, false)];
      cache.set(b, par);
    }
    return primero ? par[0] : par[1];
  };
}

/** Parte un párrafo para que su primer trozo entre en `libre`.
 *
 * Búsqueda binaria sobre palabras, midiendo de verdad: el corte de línea lo
 * hace el navegador, así que no hay tabla de anchos ni silabación castellana
 * que aproximar. Devuelve `[cabe, resto]`, o null si no vale la pena partir.
 */
function hacerDividir(caja) {
  const altoDe = (b) => {
    caja.innerHTML = html(b);
    return caja.getBoundingClientRect().height / MM;
  };
  return (b, libre, minimo) => {
    if (b.t !== 'parrafo') return null;

    const palabras = b.texto.split(' ');
    if (palabras.length < 14) return null; // no vale partir dos renglones

    const unaLinea = altoDe({ ...b, texto: 'x' });
    if (libre < unaLinea * minimo) return null;

    let mejor = 0, lo = 1, hi = palabras.length - 1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (altoDe({ ...b, texto: palabras.slice(0, mid).join(' ') }) <= libre) {
        mejor = mid; lo = mid + 1;
      } else hi = mid - 1;
    }
    if (!mejor) return null;

    // Que quede al menos `minimo` líneas de cada lado. Una línea suelta
    // arriba o abajo es peor que mover el párrafo entero.
    const arriba = altoDe({ ...b, texto: palabras.slice(0, mejor).join(' ') });
    const abajo = altoDe({ ...b, texto: palabras.slice(mejor).join(' '), primero: true });
    if (arriba < unaLinea * minimo || abajo < unaLinea * minimo) return null;

    return [
      { ...b, texto: palabras.slice(0, mejor).join(' ') },
      { ...b, texto: palabras.slice(mejor).join(' '), primero: true, capitular: false },
    ];
  };
}

window.RENDER = { MM, html, paginaEntera, hacerMedidor, hacerMedir, hacerDividir, url };
