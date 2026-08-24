'use strict';
/* Escritor de PDF mínimo, sin dependencias.
 *
 * Existe por una sola razón: **embeber los JPEG sin recomprimirlos**. Los
 * archivos de `print/` son baseline de 3 componentes, así que sus bytes entran
 * tal cual como stream /DCTDecode y el arte llega a la imprenta con exactamente
 * la calidad que tiene en disco. Cualquier librería que pase por canvas mete
 * una segunda generación de pérdida que nadie pidió.
 *
 * Lo mismo con los PNG: el IDAT de un PNG ES un stream zlib de scanlines
 * filtradas, que es justo lo que /FlateDecode espera con /Predictor 15. Se
 * copia igual de crudo. Por eso no hace falta decodificar ninguna imagen.
 *
 * Sólo hace lo que esta herramienta necesita: páginas, imágenes, líneas,
 * rectángulos y texto con las fuentes base de PDF. Sin transparencia, sin
 * fuentes embebidas, sin anotaciones.
 */

/** Puntos PostScript por milímetro. Todas las medidas públicas van en mm. */
const PT = 72 / 25.4;

/** Redondeo a 4 decimales, que a 300 dpi es una millonésima de píxel. */
function n(v) {
  return Number.isInteger(v) ? String(v) : v.toFixed(4).replace(/0+$/, '').replace(/\.$/, '');
}

class PDF {
  constructor() {
    /** Cada objeto es un array de trozos; se serializa al final. */
    this.objetos = [];
    this.paginas = [];
    /** Imágenes ya embebidas, por clave, para no repetir bytes. */
    this.cache = new Map();
    this.fuentes = new Map();
  }

  /** Reserva un número de objeto y devuelve su índice (1-based). */
  _nuevo(cuerpo) {
    this.objetos.push(cuerpo);
    return this.objetos.length;
  }

  // ------------------------------------------------------------- imágenes

  /** Embebe una imagen y devuelve `{ref, ancho, alto}` en píxeles.
   *
   * `clave` evita duplicar bytes: las ocho copias de Puño Torpe son ocho
   * referencias al mismo objeto, no ocho imágenes. En un pliego lleno eso es
   * la diferencia entre 4 MB y 30.
   */
  imagen(clave, bytes) {
    if (this.cache.has(clave)) return this.cache.get(clave);
    const info = bytes[0] === 0x89 ? this._png(bytes) : this._jpeg(bytes);
    this.cache.set(clave, info);
    return info;
  }

  _jpeg(bytes) {
    const m = leerJPEG(bytes);
    const ref = this._nuevo({
      dic: {
        Type: '/XObject',
        Subtype: '/Image',
        Width: m.ancho,
        Height: m.alto,
        ColorSpace: m.componentes === 1 ? '/DeviceGray' : '/DeviceRGB',
        BitsPerComponent: 8,
        Filter: '/DCTDecode',
      },
      datos: bytes,
    });
    return { ref, ancho: m.ancho, alto: m.alto };
  }

  _png(bytes) {
    const m = leerPNG(bytes);
    // El IDAT viaja intacto: PDF sabe deshacer los filtros de línea de PNG
    // si se le declara el predictor. Cero decodificación, cero pérdida.
    const ref = this._nuevo({
      dic: {
        Type: '/XObject',
        Subtype: '/Image',
        Width: m.ancho,
        Height: m.alto,
        ColorSpace: m.canales === 1 ? '/DeviceGray' : '/DeviceRGB',
        BitsPerComponent: m.bits,
        Filter: '/FlateDecode',
        DecodeParms:
          `<< /Predictor 15 /Colors ${m.canales} ` +
          `/BitsPerComponent ${m.bits} /Columns ${m.ancho} >>`,
      },
      datos: m.idat,
    });
    return { ref, ancho: m.ancho, alto: m.alto };
  }

  fuente(nombre) {
    if (this.fuentes.has(nombre)) return this.fuentes.get(nombre);
    // Las base-14 no se embeben: todo visor de PDF las tiene.
    const ref = this._nuevo({
      dic: { Type: '/Font', Subtype: '/Type1', BaseFont: '/' + nombre, Encoding: '/WinAnsiEncoding' },
    });
    const id = `F${this.fuentes.size + 1}`;
    this.fuentes.set(nombre, { ref, id });
    return this.fuentes.get(nombre);
  }

  // --------------------------------------------------------------- página

  pagina(anchoMm, altoMm) {
    const p = new Pagina(this, anchoMm, altoMm);
    this.paginas.push(p);
    return p;
  }

  // ---------------------------------------------------------- serializar

  /** Devuelve el PDF completo como Uint8Array. */
  terminar() {
    const catalogo = this._nuevo(null); // se rellena abajo
    const arbol = this._nuevo(null);

    const refsPagina = this.paginas.map((p) => p._emitir(arbol));

    this.objetos[catalogo - 1] = {
      dic: { Type: '/Catalog', Pages: `${arbol} 0 R` },
    };
    this.objetos[arbol - 1] = {
      dic: {
        Type: '/Pages',
        Kids: '[' + refsPagina.map((r) => `${r} 0 R`).join(' ') + ']',
        Count: refsPagina.length,
      },
    };

    return this._bytes(catalogo);
  }

  _bytes(catalogo) {
    const trozos = [];
    let largo = 0;
    const meter = (x) => {
      const b = typeof x === 'string' ? ascii(x) : x;
      trozos.push(b);
      largo += b.length;
      return largo;
    };

    // La segunda línea lleva cuatro bytes altos para que ningún transporte
    // de texto se tiente con convertir saltos de línea.
    meter('%PDF-1.7\n');
    meter(new Uint8Array([0x25, 0xe2, 0xe3, 0xcf, 0xd3, 0x0a]));

    // Los offsets del xref son en BYTES. Contar caracteres es el error
    // clásico: un JPEG con bytes >= 0x80 desplaza todo y el archivo no abre.
    const offsets = [];
    for (let i = 0; i < this.objetos.length; i++) {
      offsets.push(largo);
      const o = this.objetos[i];
      let dic = '<< ';
      for (const [k, v] of Object.entries(o.dic)) dic += `/${k} ${v} `;
      if (o.datos) dic += `/Length ${o.datos.length} `;
      dic += '>>';
      meter(`${i + 1} 0 obj\n${dic}\n`);
      if (o.datos) {
        meter('stream\n');
        meter(o.datos);
        meter('\nendstream\n');
      }
      meter('endobj\n');
    }

    const inicioXref = largo;
    meter(`xref\n0 ${this.objetos.length + 1}\n`);
    // Cada entrada mide EXACTAMENTE 20 bytes. Una de 19 y el PDF es ilegible.
    meter('0000000000 65535 f \n');
    for (const off of offsets) {
      meter(String(off).padStart(10, '0') + ' 00000 n \n');
    }

    const id = hexAleatorio();
    meter(
      `trailer\n<< /Size ${this.objetos.length + 1} /Root ${catalogo} 0 R ` +
        `/ID [<${id}> <${id}>] >>\nstartxref\n${inicioXref}\n%%EOF\n`
    );

    const salida = new Uint8Array(largo);
    let p = 0;
    for (const t of trozos) {
      salida.set(t, p);
      p += t.length;
    }
    return salida;
  }
}

/** Una página. Todas las coordenadas públicas son mm desde abajo-izquierda. */
class Pagina {
  constructor(pdf, anchoMm, altoMm) {
    this.pdf = pdf;
    this.ancho = anchoMm;
    this.alto = altoMm;
    this.ops = [];
    this.usadas = new Map(); // ref -> nombre local
    this.trim = null;
    this.bleed = null;
  }

  _nombre(img) {
    if (!this.usadas.has(img.ref)) this.usadas.set(img.ref, `Im${this.usadas.size + 1}`);
    return this.usadas.get(img.ref);
  }

  /** Dibuja `img` ocupando `caja` (mm), mostrando sólo lo que cae en `clip`.
   *
   * Es la operación central de la imposición. La imagen se dibuja SIEMPRE
   * completa —con su sangrado— y la ventana decide cuánto se ve: en el
   * interior de la grilla se recorta a la caja de corte, así las cartas
   * quedan pegadas y una sola línea sirve de corte para las dos vecinas; en
   * el perímetro la ventana se agranda y deja el sangrado a la vista.
   *
   * El `re` va ANTES del `cm` a propósito: se expresa en el espacio de
   * coordenadas vigente, y después del `cm` quedaría en el espacio unitario
   * de la imagen.
   */
  imagen(img, caja, clip) {
    const nm = this._nombre(img);
    const c = clip || caja;
    this.ops.push(
      'q',
      `${n(c.x * PT)} ${n(c.y * PT)} ${n(c.ancho * PT)} ${n(c.alto * PT)} re W n`,
      `${n(caja.ancho * PT)} 0 0 ${n(caja.alto * PT)} ${n(caja.x * PT)} ${n(caja.y * PT)} cm`,
      `/${nm} Do`,
      'Q'
    );
  }

  /** Igual que `imagen`, pero girando el dibujo 90° en sentido antihorario.
   *
   * Para los jefes: el naipe es el mismo de 57x89, pero su ilustración viene
   * apaisada. Escalarla sin rotar la deformaría un 44 %.
   */
  imagenGirada(img, caja, clip) {
    const nm = this._nombre(img);
    const c = clip || caja;
    this.ops.push(
      'q',
      `${n(c.x * PT)} ${n(c.y * PT)} ${n(c.ancho * PT)} ${n(c.alto * PT)} re W n`,
      // 0 H -W 0 (x+W) y : rota 90° y reubica el origen en la esquina correcta.
      `0 ${n(caja.alto * PT)} ${n(-caja.ancho * PT)} 0 ` +
        `${n((caja.x + caja.ancho) * PT)} ${n(caja.y * PT)} cm`,
      `/${nm} Do`,
      'Q'
    );
  }

  linea(x1, y1, x2, y2, grosor = 0.25, gris = 0) {
    this.ops.push(
      'q',
      `${n(gris)} G ${n(grosor)} w`,
      `${n(x1 * PT)} ${n(y1 * PT)} m ${n(x2 * PT)} ${n(y2 * PT)} l S`,
      'Q'
    );
  }

  rect(x, y, ancho, alto, { relleno = null, borde = null, grosor = 0.25 } = {}) {
    const ops = ['q'];
    if (relleno) ops.push(`${rgb(relleno)} rg`);
    if (borde) ops.push(`${rgb(borde)} RG ${n(grosor)} w`);
    ops.push(`${n(x * PT)} ${n(y * PT)} ${n(ancho * PT)} ${n(alto * PT)} re`);
    ops.push(relleno && borde ? 'B' : relleno ? 'f' : 'S');
    ops.push('Q');
    this.ops.push(...ops);
  }

  /** Círculo punteado: por dónde cortar una pieza redonda.
   *
   * Se arma con cuatro curvas de Bézier, que es como PDF dibuja círculos: no
   * tiene primitiva de arco. El 0,5523 es la constante que hace que una
   * Bézier cúbica se pegue a un cuarto de circunferencia.
   */
  circuloPunteado(cx, cy, r, gris = 0.45) {
    const k = 0.5523;
    const [x, y, R, K] = [cx * PT, cy * PT, r * PT, r * PT * k];
    this.ops.push(
      'q',
      `${n(gris)} G 0.4 w [1.6 1.6] 0 d`,
      `${n(x + R)} ${n(y)} m`,
      `${n(x + R)} ${n(y + K)} ${n(x + K)} ${n(y + R)} ${n(x)} ${n(y + R)} c`,
      `${n(x - K)} ${n(y + R)} ${n(x - R)} ${n(y + K)} ${n(x - R)} ${n(y)} c`,
      `${n(x - R)} ${n(y - K)} ${n(x - K)} ${n(y - R)} ${n(x)} ${n(y - R)} c`,
      `${n(x + K)} ${n(y - R)} ${n(x + R)} ${n(y - K)} ${n(x + R)} ${n(y)} c`,
      'S',
      'Q'
    );
  }

  /** Texto. `ancla` es 'izq' | 'centro' | 'der'. Tamaño en puntos. */
  texto(txt, x, y, { tam = 9, fuente = 'Helvetica-Bold', color = '#000', ancla = 'izq' } = {}) {
    const f = this.pdf.fuente(fuente);
    const ancho = anchoTexto(txt, tam, fuente);
    let px = x * PT;
    if (ancla === 'centro') px -= ancho / 2;
    else if (ancla === 'der') px -= ancho;
    this.ops.push(
      'q',
      `${rgb(color)} rg`,
      'BT',
      `/${f.id} ${n(tam)} Tf`,
      `${n(px)} ${n(y * PT)} Td`,
      `(${escapar(txt)}) Tj`,
      'ET',
      'Q'
    );
  }

  _emitir(padre) {
    const contenido = this.pdf._nuevo({ dic: {}, datos: ascii(this.ops.join('\n')) });

    const xobj = [...this.usadas.entries()].map(([ref, nm]) => `/${nm} ${ref} 0 R`).join(' ');
    const fnt = [...this.pdf.fuentes.values()].map((f) => `/${f.id} ${f.ref} 0 R`).join(' ');
    const rec = (c) =>
      `[${n(c.x * PT)} ${n(c.y * PT)} ${n((c.x + c.ancho) * PT)} ${n((c.y + c.alto) * PT)}]`;

    const dic = {
      Type: '/Page',
      Parent: `${padre} 0 R`,
      MediaBox: `[0 0 ${n(this.ancho * PT)} ${n(this.alto * PT)}]`,
      Resources: `<< /XObject << ${xobj} >> /Font << ${fnt} >> >>`,
      Contents: `${contenido} 0 R`,
    };
    // La imprenta lee estas dos cajas para saber dónde cortar sin preguntar.
    if (this.trim) dic.TrimBox = rec(this.trim);
    if (this.bleed) dic.BleedBox = rec(this.bleed);

    return this.pdf._nuevo({ dic });
  }
}

// ------------------------------------------------------------------ lectores

/** Ancho y alto desde el SOF del JPEG, más los guards que hacen falta.
 *
 * Se lee del SOF y nunca de un `<img>`: el `naturalWidth` del navegador ya
 * aplica la orientación EXIF y /DCTDecode no, así que mezclarlos cruza W y H.
 */
function leerJPEG(b) {
  if (b[0] !== 0xff || b[1] !== 0xd8) throw new Error('no es un JPEG');
  let i = 2;
  while (i < b.length - 1) {
    if (b[i] !== 0xff) {
      i++;
      continue;
    }
    const m = b[i + 1];
    if (m === 0xd8 || m === 0x01 || (m >= 0xd0 && m <= 0xd7)) {
      i += 2;
      continue;
    }
    const largo = (b[i + 2] << 8) | b[i + 3];
    // SOF0/1 son baseline. SOF2 es progresivo: Acrobat lo tolera pero hay
    // RIP de imprenta que lo rechazan, así que se corta acá y no en la
    // imprenta.
    if (m === 0xc2 || m === 0xc6 || m === 0xca) {
      throw new Error('JPEG progresivo: volvé a exportarlo baseline');
    }
    if (m === 0xc0 || m === 0xc1 || m === 0xc3) {
      const componentes = b[i + 9];
      if (componentes === 4) throw new Error('JPEG CMYK: convertilo a RGB');
      return { alto: (b[i + 5] << 8) | b[i + 6], ancho: (b[i + 7] << 8) | b[i + 8], componentes };
    }
    i += 2 + largo;
  }
  throw new Error('JPEG sin SOF');
}

/** IHDR + IDAT concatenados. Sólo acepta lo que PDF puede tomar crudo. */
function leerPNG(b) {
  const firma = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  for (let i = 0; i < 8; i++) if (b[i] !== firma[i]) throw new Error('no es un PNG');

  const dv = new DataView(b.buffer, b.byteOffset, b.byteLength);
  let i = 8;
  let meta = null;
  const idat = [];

  while (i < b.length) {
    const largo = dv.getUint32(i);
    const tipo = String.fromCharCode(b[i + 4], b[i + 5], b[i + 6], b[i + 7]);
    const datos = i + 8;
    if (tipo === 'IHDR') {
      const tipoColor = b[datos + 9];
      const canales = { 0: 1, 2: 3, 4: 2, 6: 4 }[tipoColor];
      meta = {
        ancho: dv.getUint32(datos),
        alto: dv.getUint32(datos + 4),
        bits: b[datos + 8],
        tipoColor,
        canales,
        entrelazado: b[datos + 12],
      };
    } else if (tipo === 'IDAT') {
      idat.push(b.subarray(datos, datos + largo));
    } else if (tipo === 'IEND') break;
    i = datos + largo + 4;
  }

  if (!meta) throw new Error('PNG sin IHDR');
  // Con alfa, paleta o entrelazado el IDAT ya no se puede copiar crudo.
  if (meta.entrelazado) throw new Error('PNG entrelazado: guardalo sin Adam7');
  if (meta.tipoColor !== 0 && meta.tipoColor !== 2) {
    throw new Error('PNG con alfa o paleta: guardalo como RGB de 8 bits');
  }

  let total = 0;
  for (const t of idat) total += t.length;
  const junto = new Uint8Array(total);
  let p = 0;
  for (const t of idat) {
    junto.set(t, p);
    p += t.length;
  }
  return { ...meta, idat: junto };
}

// -------------------------------------------------------------- utilidades

function ascii(s) {
  const b = new Uint8Array(s.length);
  for (let i = 0; i < s.length; i++) b[i] = s.charCodeAt(i) & 0xff;
  return b;
}

function escapar(s) {
  return s.replace(/[\\()]/g, (c) => '\\' + c);
}

function rgb(hex) {
  const h = hex.replace('#', '');
  const v = h.length === 3 ? h.split('').map((c) => c + c).join('') : h;
  const p = [0, 2, 4].map((i) => parseInt(v.slice(i, i + 2), 16) / 255);
  return p.map(n).join(' ');
}

function hexAleatorio() {
  let s = '';
  for (let i = 0; i < 16; i++) s += Math.floor(Math.random() * 256).toString(16).padStart(2, '0');
  return s;
}

/** Anchos de Helvetica, en milésimas de em. Alcanza para centrar números.
 *
 * Es una tabla parcial a propósito: los únicos textos de esta herramienta son
 * cifras, milímetros y rótulos cortos en mayúsculas.
 */
const ANCHOS = {
  ' ': 278, '-': 333, '.': 278, '/': 278, ':': 278,
  0: 556, 1: 556, 2: 556, 3: 556, 4: 556, 5: 556, 6: 556, 7: 556, 8: 556, 9: 556,
};
function anchoTexto(txt, tam, fuente) {
  const negrita = fuente.includes('Bold');
  let mils = 0;
  for (const c of txt) {
    if (ANCHOS[c] !== undefined) mils += ANCHOS[c];
    else if (c >= 'A' && c <= 'Z') mils += negrita ? 722 : 667;
    else mils += negrita ? 556 : 500;
  }
  return (mils / 1000) * tam;
}

window.PDF = PDF;
window.PDF_PT = PT;
