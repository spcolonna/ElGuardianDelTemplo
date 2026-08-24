'use strict';
/* La UI: cargar la carpeta, elegir el pliego, generar los PDF.
 *
 * Todo el dato de imagen entra por objetos `File`, nunca por una ruta
 * relativa. No es una preferencia: en `file://` una imagen cargada por ruta
 * es cross-origin opaca para el navegador, y además `fetch` está bloqueado.
 */

const ROLES = [
  ['inicial', 'Mazo inicial'],
  ['peligro', 'Peligros'],
  ['cansancio', 'Cansancio'],
  ['jefe', 'Jefes'],
  ['tapa', 'Tapa de la caja'],
  ['tablero', 'Tablero de Energía'],
  ['ficha', 'Fichas de Energía'],
];

const $ = (id) => document.getElementById(id);

/** El troquel de un rol, tal como lo declaró `bin/imprimir.py`. */
const cortePorRol = (rol) => {
  const p = manifiesto && manifiesto.piezas.find((x) => x.rol === rol && x.corte_mm);
  return p ? p.corte_mm : null;
};
const bytesPorArchivo = new Map();
let manifiesto = null;

// ------------------------------------------------------------------ carga

const zona = $('zona');
zona.addEventListener('click', () => $('entrada').click());
$('entrada').addEventListener('change', (e) => cargar([...e.target.files]));

for (const ev of ['dragenter', 'dragover']) {
  zona.addEventListener(ev, (e) => {
    e.preventDefault();
    zona.classList.add('encima');
  });
}
for (const ev of ['dragleave', 'drop']) {
  zona.addEventListener(ev, (e) => {
    e.preventDefault();
    zona.classList.remove('encima');
  });
}
zona.addEventListener('drop', async (e) => {
  const items = [...e.dataTransfer.items]
    .map((i) => i.webkitGetAsEntry && i.webkitGetAsEntry())
    .filter(Boolean);
  const files = [];
  for (const it of items) await recorrer(it, files);
  cargar(files.length ? files : [...e.dataTransfer.files]);
});

/** Recorre una entrada del drop. `readEntries` devuelve como mucho 100 por
 * llamada y hay que insistir hasta que devuelva vacío: si no, con carpetas
 * grandes se pierden archivos en silencio. */
async function recorrer(entrada, fuera) {
  if (entrada.isFile) {
    fuera.push(await new Promise((r) => entrada.file(r)));
    return;
  }
  const lector = entrada.createReader();
  for (;;) {
    const tanda = await new Promise((r) => lector.readEntries(r, () => r([])));
    if (!tanda.length) break;
    for (const e of tanda) await recorrer(e, fuera);
  }
}

/** Servida por HTTP, la herramienta se carga sola desde `print/`.
 *
 * Con doble clic sobre el HTML esto no puede funcionar —`fetch` está
 * bloqueado en `file://`— y ahí queda el arrastre de carpeta, que es el único
 * camino posible. Servida, arrastrar sería pedirle al usuario que busque a
 * mano una carpeta que está a dos directorios de distancia.
 */
async function autocargar() {
  if (!location.protocol.startsWith('http')) return false;
  const estado = $('estadoCarga');
  try {
    estado.innerHTML = aviso('ojo', 'Buscando el arte en <code>print/</code>…');
    const man = await fetch('../print/manifiesto.json', { cache: 'no-store' });
    if (!man.ok) throw new Error('sin manifiesto');
    const datos = await man.json();

    const files = [
      new File([JSON.stringify(datos)], 'manifiesto.json', { type: 'application/json' }),
    ];
    let hechas = 0;
    for (const p of datos.piezas) {
      const r = await fetch('../print/' + encodeURIComponent(p.archivo));
      if (!r.ok) throw new Error('falta ' + p.archivo);
      files.push(new File([await r.blob()], p.archivo));
      hechas++;
      estado.innerHTML = aviso(
        'ojo',
        `Cargando el arte… ${hechas} de ${datos.piezas.length}`
      );
    }
    await cargar(files);
    return true;
  } catch (err) {
    estado.innerHTML = '';
    zona.querySelector('span').innerHTML =
      'o hacé clic para elegirla. No pude cargarla solo: ' + err.message;
    return false;
  }
}

async function cargar(files) {
  const estado = $('estadoCarga');
  bytesPorArchivo.clear();
  manifiesto = null;

  const man = files.find((f) => f.name === 'manifiesto.json');
  if (!man) {
    estado.innerHTML = aviso(
      'mal',
      'En esa carpeta no hay <code>manifiesto.json</code>. Corré ' +
        '<code>python3 bin/imprimir.py</code> y arrastrá la carpeta ' +
        '<code>print/</code> que genera.'
    );
    return;
  }

  try {
    manifiesto = JSON.parse(await man.text());
  } catch (err) {
    estado.innerHTML = aviso('mal', 'El manifiesto no se pudo leer: ' + err.message);
    return;
  }

  const faltan = [];
  for (const p of manifiesto.piezas) {
    const f = files.find((x) => x.name === p.archivo);
    if (!f) {
      faltan.push(p.archivo);
      continue;
    }
    bytesPorArchivo.set(p.archivo, new Uint8Array(await f.arrayBuffer()));
  }

  if (faltan.length) {
    estado.innerHTML = aviso(
      'mal',
      `Faltan ${faltan.length} archivos que el manifiesto declara: ` +
        `<code>${faltan.slice(0, 5).join(', ')}</code>` +
        (faltan.length > 5 ? ' y más.' : '.') +
        ' Volvé a correr <code>bin/imprimir.py</code>.'
    );
    return;
  }

  // El insumo tiene que venir con el sangrado ya horneado. El arte de la app
  // mide 1024x1620 y no lo tiene: pegado tal cual, la guillotina se come la
  // cenefa. Mejor detectarlo acá que después de imprimir ocho hojas.
  //
  // Se mide contra el corte DE CADA PIEZA y no contra uno global: los jefes
  // tienen su propio troquel de 112x70, así que un único número esperado los
  // rechazaría a todos.
  const aPx = (mm) => Math.round(mm * (manifiesto.dpi / 25.4));
  // Sólo los naipes tienen que medir exactamente la caja sangrada. La tapa,
  // el tablero y la ficha se escalan al vuelo, así que su tamaño en píxeles
  // no dice nada.
  const naipe = new Set(['inicial', 'peligro', 'cansancio', 'jefe', 'dorso', 'dorso_jefe']);
  let rara = null;
  for (const p of manifiesto.piezas) {
    if (!naipe.has(p.rol)) continue;
    const corte = p.corte_mm || manifiesto.corte_mm;
    const sangrado = p.sangrado_mm ?? manifiesto.sangrado_mm;
    const corto = aPx(Math.min(corte[0], corte[1]) + sangrado * 2);
    const largo = aPx(Math.max(corte[0], corte[1]) + sangrado * 2);
    if (Math.min(p.ancho, p.alto) !== corto || Math.max(p.ancho, p.alto) !== largo) {
      rara = { p, corto, largo };
      break;
    }
  }
  if (rara) {
    estado.innerHTML = aviso(
      'mal',
      `<code>${rara.p.archivo}</code> mide ${rara.p.ancho}×${rara.p.alto} px y se ` +
        `esperaban ${rara.corto}×${rara.largo} px. Ese arte no tiene sangrado.`
    );
    return;
  }

  estado.innerHTML = aviso(
    'bien',
    `Cargadas ${bytesPorArchivo.size} piezas · ${manifiesto.naipes} naipes · ` +
      `cartas de ${manifiesto.corte_mm.join('×')} mm y jefes de ` +
      `${(cortePorRol('jefe') || manifiesto.corte_mm).join('×')} mm, ` +
      `con ${manifiesto.sangrado_mm} mm de sangrado.`
  );
  $('panelConfig').classList.remove('oculto');
  $('panelGenerar').classList.remove('oculto');
  pintarGrupos();
  refrescar();
}

// ------------------------------------------------------------- controles

const p_sinConteo = new Set(['tapa', 'tablero', 'ficha']);

function pintarGrupos() {
  const cont = $('grupos');
  cont.innerHTML = '';
  for (const [rol, etiqueta] of ROLES) {
    const hay = manifiesto.piezas.some((p) => p.rol === rol);
    if (!hay) continue;
    const n = manifiesto.piezas
      .filter((p) => p.rol === rol)
      .reduce((s, p) => s + Math.max(1, p.copias), 0);
    const lbl = document.createElement('label');
    lbl.className = 'chip on';
    lbl.innerHTML =
      `<input type="checkbox" data-rol="${rol}" checked> ${etiqueta}` +
      (p_sinConteo.has(rol) ? '' : ` <span class="meta">(${n})</span>`);
    lbl.querySelector('input').addEventListener('change', (e) => {
      lbl.classList.toggle('on', e.target.checked);
      refrescar();
    });
    cont.appendChild(lbl);
  }
}

for (const id of ['hoja', 'margen', 'sangrado', 'calle', 'mCorte', 'mRegistro',
                  'mRegla', 'tableroAncho', 'tableroPliegues', 'fichaDiametro',
                  'fichaCantidad']) {
  document.addEventListener('change', (e) => {
    if (e.target.id === id) refrescar();
  });
}
document.addEventListener('change', (e) => {
  const c = e.target.closest('.chip');
  if (c && e.target.type === 'checkbox') c.classList.toggle('on', e.target.checked);
});

function config() {
  const incluir = {};
  for (const [rol] of ROLES) {
    const cb = document.querySelector(`input[data-rol="${rol}"]`);
    incluir[rol] = cb ? cb.checked : false;
  }
  return {
    hoja: $('hoja').value,
    margen: parseFloat($('margen').value) || 0,
    sangrado: parseFloat($('sangrado').value) || 0,
    calle: parseFloat($('calle').value) || 0,
    tableroAncho: parseFloat($('tableroAncho').value) || 270,
    tableroPliegues: parseInt($('tableroPliegues').value, 10) || 1,
    fichaDiametro: parseFloat($('fichaDiametro').value) || 20,
    fichaCantidad: parseInt($('fichaCantidad').value, 10) || 6,
    marcasCorte: $('mCorte').checked,
    marcasRegistro: $('mRegistro').checked,
    regla: $('mRegla').checked,
    incluir,
  };
}

function refrescar() {
  if (!manifiesto) return;
  const cfg = config();

  $('avisoCalle').innerHTML =
    cfg.calle > 0
      ? 'Con calle cada carta lleva su sangrado completo: si el corte se ' +
        'desvía, te deja crema propio. Entran menos por hoja y hay que ' +
        'cortar dos veces por lado.'
      : 'Con corte compartido entran más cartas y cada línea se corta una ' +
        'sola vez. A cambio, un desvío de la guillotina no te deja tu ' +
        'sangrado: te deja una tira del dibujo de la carta vecina.';

  // El tablero elige la orientación de hoja que más lo deje crecer, así que
  // el tope es el lado largo de la hoja, no el que usan las cartas.
  const [a, b] = window.IMP.HOJAS[cfg.hoja];
  const tope = Math.max(a, b) - cfg.margen * 2;
  const real = Math.min(cfg.tableroAncho, tope);
  const panel = real / cfg.tableroPliegues;
  $('avisoTablero').innerHTML =
    (cfg.tableroAncho > tope
      ? `<b>${cfg.tableroAncho} mm no entra en ${cfg.hoja}</b>: sale a ${tope.toFixed(0)} mm. ` +
        'Para más grande, probá A3. '
      : '') +
    `Tablero de ${real.toFixed(0)} mm` +
    (cfg.tableroPliegues > 1 ? ` en ${cfg.tableroPliegues} paneles de ${panel.toFixed(0)} mm` : '') +
    '. ' +
    (panel <= 64
      ? 'Entra en la caja (64 mm de interior).'
      : `<b>No entra en la caja</b>, que tiene 64 mm. Guardalo aparte, o plegalo en ` +
        `${Math.ceil(real / 64)} — aunque con once columnas de círculos ningún pliegue ` +
        'cae justo entre casillas.');

  let g, gj;
  try {
    const c = (rol) => {
      const m = cortePorRol(rol);
      return m ? { ancho: m[0], alto: m[1] } : undefined;
    };
    g = window.IMP.mejorGrilla(cfg.hoja, cfg, c('peligro'));
    gj = window.IMP.mejorGrilla(cfg.hoja, cfg, c('jefe'));
  } catch (err) {
    $('resumen').innerHTML = aviso('mal', err.message);
    return;
  }

  const verticales = window.IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol !== 'jefe'), cfg.incluir);
  const jefes = window.IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol === 'jefe'), cfg.incluir);

  const hv = Math.ceil(verticales.length / g.porHoja);
  const hj = Math.ceil(jefes.length / gj.porHoja);
  const sueltas =
    (cfg.incluir.tapa ? 1 : 0) + (cfg.incluir.tablero ? 1 : 0) + (cfg.incluir.ficha ? 1 : 0);
  const total = (hv + hj) * 2 + sueltas;

  const ultima = verticales.length % g.porHoja;
  $('resumen').innerHTML =
    `<table><tr><th>Pliego</th><th class="num">Naipes</th><th class="num">Hojas</th></tr>` +
    fila('Cartas (frentes)', verticales.length, hv) +
    fila('Cartas (dorsos)', hv * g.porHoja, hv) +
    fila('Jefes (frentes)', jefes.length, hj) +
    fila('Jefes (dorsos)', hj * gj.porHoja, hj) +
    (cfg.incluir.tapa ? fila('Tapa de la caja', 1, 1) : '') +
    (cfg.incluir.tablero ? fila('Tablero de Energía', 1, 1) : '') +
    (cfg.incluir.ficha ? fila('Fichas de Energía', cfg.fichaCantidad, 1) : '') +
    `<tr><th>Total</th><th class="num">${verticales.length + jefes.length}</th>` +
    `<th class="num">${total}</th></tr></table>` +
    aviso(
      'ojo',
      `Cartas: <b>${g.cols}×${g.filas}</b> = ${g.porHoja} por hoja ` +
        `${cfg.hoja}${g.apaisada ? ' apaisada' : ''}, de ` +
        `${g.corte.ancho}×${g.corte.alto} mm. ` +
        `Jefes: <b>${gj.cols}×${gj.filas}</b> = ${gj.porHoja} por hoja` +
        `${gj.apaisada === g.apaisada ? '' : gj.apaisada ? ' apaisada' : ' vertical'}, de ` +
        `${gj.corte.ancho}×${gj.corte.alto} mm — su propio troquel. ` +
        (ultima
          ? `La última hoja de cartas lleva ${ultima}; su dorso sale completo igual, ` +
            'así todas las hojas son idénticas y no hay que alinear nada a mano.'
          : 'Todas las hojas salen llenas.')
    );
}

const fila = (n, naipes, hojas) =>
  hojas ? `<tr><td>${n}</td><td class="num">${naipes}</td><td class="num">${hojas}</td></tr>` : '';

const aviso = (tipo, html) => `<div class="aviso ${tipo}">${html}</div>`;

// ------------------------------------------------------------- generación

$('generar').addEventListener('click', () => {
  const salida = $('salida');
  salida.innerHTML = '<p>Armando…</p>';
  setTimeout(() => {
    try {
      const pliegos = window.PLIEGOS.generar(
        manifiesto,
        (a) => bytesPorArchivo.get(a),
        config()
      );
      salida.innerHTML = '';
      for (const p of pliegos) {
        const url = URL.createObjectURL(new Blob([p.bytes], { type: 'application/pdf' }));
        const a = document.createElement('a');
        a.href = url;
        a.download = `${p.nombre}.pdf`;
        a.innerHTML =
          `<span><b>${p.nombre}.pdf</b></span>` +
          `<span class="meta">${p.hojas} hoja${p.hojas > 1 ? 's' : ''} · ` +
          `${(p.bytes.length / 1048576).toFixed(1)} MB</span>`;
        salida.appendChild(a);
      }
      salida.insertAdjacentHTML(
        'beforeend',
        aviso('bien', 'Hacé clic en cada uno para guardarlo. Imprimilos al 100 %.')
      );
    } catch (err) {
      salida.innerHTML = aviso('mal', 'No se pudo generar: ' + err.message);
      console.error(err);
    }
  }, 30);
});

autocargar();

$('revisar').addEventListener('click', () => {
  const caja = $('tablaPiezas');
  caja.classList.toggle('oculto');
  if (caja.classList.contains('oculto')) return;
  caja.innerHTML =
    '<table><tr><th>Archivo</th><th>Rol</th><th class="num">Copias</th>' +
    '<th class="num">Píxeles</th></tr>' +
    manifiesto.piezas
      .map(
        (p) =>
          `<tr><td>${p.archivo}</td><td>${p.rol}</td>` +
          `<td class="num">${p.copias || '—'}</td>` +
          `<td class="num">${p.ancho}×${p.alto}</td></tr>`
      )
      .join('') +
    '</table>';
});
