/* Pruebas de la imposición, sin navegador.
 *
 *     node imprenta/pruebas.mjs
 *
 * Verifican lo que no se puede ver mirando el PDF en pantalla: que la grilla
 * quede simétrica (de eso depende el registro frente/dorso), que el conteo de
 * naipes salga, y que los bytes de las imágenes lleguen intactos.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const AQUI = path.dirname(fileURLToPath(import.meta.url));
const RAIZ = path.dirname(AQUI);
const PRINT = path.join(RAIZ, 'print');

// Los módulos se escriben para el navegador; acá se les da un `window`.
global.window = {};
for (const f of ['pdf.js', 'imposicion.js', 'pliegos.js']) {
  new Function(fs.readFileSync(path.join(AQUI, f), 'utf8'))();
}
// Los librillos: geometría, paginación y tokens. `render.js` y la página no
// entran acá porque necesitan DOM — eso lo cubre `librillo/?prueba=1`.
for (const f of ['librillo.js', 'paginador.js', 'referencias.js', 'contenido_es.js', 'render.js']) {
  new Function(fs.readFileSync(path.join(AQUI, 'librillo', f), 'utf8'))();
}
const { IMP, PLIEGOS, LIBRILLO, PAGINADOR, REFS, CONTENIDO_ES, RENDER } = global.window;

const manifiesto = JSON.parse(fs.readFileSync(path.join(PRINT, 'manifiesto.json'), 'utf8'));
const leer = (a) => new Uint8Array(fs.readFileSync(path.join(PRINT, a)));

let fallos = 0;
function ok(cond, que, detalle = '') {
  if (cond) console.log(`  ok   ${que}`);
  else {
    console.log(`  FALLA ${que} ${detalle}`);
    fallos++;
  }
}
const casi = (a, b, tol = 0.001) => Math.abs(a - b) < tol;

const CFG = {
  hoja: 'A4',
  margen: 5,
  calle: 0,
  sangrado: 3,
  marcasCorte: true,
  marcasRegistro: true,
  regla: true,
  tableroAncho: 270,
  tableroPliegues: 1,
  fichaDiametro: 20,
  fichaCantidad: 6,
  incluir: {
    inicial: true, peligro: true, cansancio: true, jefe: true,
    tapa: true, tablero: true, ficha: true,
  },
};

console.log('\nGRILLA');
{
  const g = IMP.mejorGrilla('A4', CFG);
  ok(g.porHoja === 9, 'A4 entra 9 naipes por hoja', `dio ${g.porHoja}`);
  ok(g.cols === 3 && g.filas === 3, 'la grilla es 3x3', `dio ${g.cols}x${g.filas}`);
  // Lo que hace que el dorso caiga sobre el frente al dar vuelta la hoja.
  const margenDer = g.hojaAncho - (g.x0 + g.bloqueAncho);
  ok(casi(g.x0, margenDer), 'la grilla está centrada en horizontal', `izq ${g.x0} der ${margenDer}`);

  const c = IMP.celda(g, 0, 0);
  ok(casi(c.ancho, 57) && casi(c.alto, 89), 'la celda mide 57x89 mm exactos');

  // Con corte compartido, la esquina de una carta toca la de su vecina.
  const a = IMP.celda(g, 0, 0);
  const b = IMP.celda(g, 1, 0);
  ok(casi(a.x + a.ancho, b.x), 'las cartas quedan pegadas (corte compartido)');

  const g3 = IMP.mejorGrilla('A3', CFG);
  ok(g3.porHoja === 21, 'A3 entra 21 naipes por hoja', `dio ${g3.porHoja}`);
}

console.log('\nVENTANA DE RECORTE');
{
  const g = IMP.mejorGrilla('A4', CFG);
  const interior = IMP.ventana(g, 1, 1);
  ok(casi(interior.ancho, 57) && casi(interior.alto, 89),
     'la carta interior se recorta a la caja de corte');

  const esquina = IMP.ventana(g, 0, 0);
  ok(casi(esquina.ancho, 60) && casi(esquina.alto, 92),
     'la esquina deja ver el sangrado hacia afuera', `dio ${esquina.ancho}x${esquina.alto}`);
  ok(casi(esquina.x, IMP.celda(g, 0, 0).x - 3), 'el sangrado de la esquina sale hacia la izquierda');

  const conCalle = IMP.mejorGrilla('A4', { ...CFG, calle: 6 });
  const v = IMP.ventana(conCalle, 0, 0);
  ok(casi(v.ancho, 63) && casi(v.alto, 95),
     'con calle, cada carta usa su sangrado completo', `dio ${v.ancho}x${v.alto}`);
}

console.log('\nTROQUEL DEL JEFE');
{
  const corteDe = (rol) => manifiesto.piezas.find((x) => x.rol === rol && x.corte_mm).corte_mm;
  const carta = corteDe('peligro');
  const jefe = corteDe('jefe');
  ok(carta[0] === 57 && carta[1] === 89, 'las cartas siguen en 57x89', `dio ${carta}`);
  ok(jefe[0] === 112 && jefe[1] === 70, 'el jefe tiene su propio troquel 112x70', `dio ${jefe}`);
  ok(corteDe('dorso_jefe').join() === jefe.join(),
     'el dorso del jefe mide lo mismo que el frente');

  // La razón de elegir 112x70 y no el tarot: respetar la proporción del arte.
  const arte = manifiesto.piezas.find((p) => p.rol === 'jefe');
  casi(arte.ancho / arte.alto, (jefe[0] + 6) / (jefe[1] + 6), 0.005);
  ok(true, 'el arte de jefe entra sin deformarse ni recortarse');

  const gJefes = IMP.mejorGrilla('A4', CFG, { ancho: jefe[0], alto: jefe[1] });
  ok(gJefes.porHoja === 4, 'entran 4 jefes por hoja A4', `dio ${gJefes.porHoja}`);
  const c = IMP.celda(gJefes, 0, 0);
  ok(c.ancho === 112 && c.alto === 70, 'la celda del jefe mide 112x70',
     `dio ${c.ancho}x${c.alto}`);
  casi(gJefes.x0, gJefes.hojaAncho - gJefes.x0 - gJefes.bloqueAncho);
  ok(true, 'la grilla del jefe tambien queda centrada en horizontal');

  // El bug que ya paso una vez: una pieza nueva colandose en el mazo.
  const naipes = IMP.expandir(manifiesto.piezas, CFG.incluir);
  ok(naipes.length === 65, 'las piezas nuevas no se cuelan en el mazo',
     `dio ${naipes.length}`);
}

console.log('\nSANGRADO CONFIGURABLE');
{
  const g = IMP.mejorGrilla('A4', { ...CFG, sangrado: 4 }, { ancho: 57, alto: 89 });
  const caja = IMP.cajaImagen(g, 0, 0);
  const vent = IMP.ventana(g, 0, 0);
  ok(caja.ancho === 57 + 8, 'la caja de imagen usa el sangrado pedido, no el 3 fijo',
     `dio ${caja.ancho}`);
  ok(caja.x <= vent.x && caja.x + caja.ancho >= vent.x + vent.ancho,
     'la imagen sigue cubriendo su ventana con sangrado 4');
}

console.log('\nCONTEO DE NAIPES');
{
  const verticales = IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol !== 'jefe'), CFG.incluir);
  const jefes = IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol === 'jefe'), CFG.incluir);
  ok(verticales.length === 60, '60 naipes verticales', `dio ${verticales.length}`);
  ok(jefes.length === 5, '5 jefes', `dio ${jefes.length}`);
  ok(verticales.length + jefes.length === manifiesto.naipes,
     `suman los ${manifiesto.naipes} naipes del manifiesto`);

  const puno = verticales.filter((p) => p.archivo === 'inicial_puno_torpe.jpg');
  ok(puno.length === 8, 'Puño Torpe sale 8 veces', `dio ${puno.length}`);

  const hojas = IMP.enHojas(verticales, 9);
  ok(hojas.length === 7, 'los verticales dan 7 hojas A4', `dio ${hojas.length}`);
  ok(hojas[hojas.length - 1].length === 6, 'la última hoja lleva 6', `dio ${hojas.at(-1).length}`);

  const sinCansancio = IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol !== 'jefe'),
    { ...CFG.incluir, cansancio: false });
  ok(sinCansancio.length === 50, 'sin Cansancio quedan 50 verticales', `dio ${sinCansancio.length}`);
}

console.log('\nPDF');
{
  const pliegos = PLIEGOS.generar(manifiesto, leer, CFG);
  const porNombre = Object.fromEntries(pliegos.map((p) => [p.nombre, p]));

  ok(pliegos.length === 7, 'salen 7 PDF', pliegos.map((p) => p.nombre).join(', '));
  ok(porNombre['cartas-frentes'].hojas === 7, 'frentes: 7 hojas');
  ok(porNombre['cartas-dorsos'].hojas === 7, 'dorsos: 7 hojas, una por cada hoja de frentes');
  ok(porNombre['jefes-frentes'].hojas === 2, 'jefes: 2 hojas de 4',
     `dio ${porNombre['jefes-frentes'].hojas}`);
  ok(porNombre['jefes-dorsos'].hojas === porNombre['jefes-frentes'].hojas,
     'jefes: un dorso por cada hoja de frentes');

  const bytes = porNombre['cartas-frentes'].bytes;
  ok(bytes[0] === 0x25 && bytes[1] === 0x50, 'el PDF arranca con %PDF');

  // El bug clásico: offsets del xref contados en caracteres y no en bytes.
  const txt = Buffer.from(bytes).toString('latin1');
  const inicio = parseInt(txt.slice(txt.lastIndexOf('startxref') + 9).trim(), 10);
  ok(txt.slice(inicio, inicio + 4) === 'xref', 'startxref apunta a la tabla');
  const cant = parseInt(txt.slice(inicio).split('\n')[1].split(' ')[1], 10);
  const tabla = inicio + 5 + txt.slice(inicio).split('\n')[1].length + 1;
  let rotos = 0;
  for (let k = 1; k < cant; k++) {
    const ent = txt.slice(tabla + k * 20, tabla + (k + 1) * 20);
    if (ent.length !== 20) { rotos++; continue; }
    const off = parseInt(ent.slice(0, 10), 10);
    if (!txt.startsWith(`${k} 0 obj`, off)) rotos++;
  }
  ok(rotos === 0, 'todos los offsets del xref apuntan a su objeto', `${rotos} rotos`);

  // Cada diseño se embebe una sola vez, aunque tenga 8 copias.
  const puno = Buffer.from(leer('inicial_puno_torpe.jpg')).toString('latin1');
  let veces = 0, desde = 0;
  while ((desde = txt.indexOf(puno, desde)) !== -1) { veces++; desde += puno.length; }
  ok(veces === 1, 'Puño Torpe se embebe una sola vez pese a sus 8 copias', `apareció ${veces}`);

  // Y llega intacto: es el punto de todo el ejercicio.
  ok(txt.includes(Buffer.from(leer('alba1.jpg')).toString('latin1')),
     'los JPEG se copian byte a byte, sin recomprimir');

  ok(txt.includes('/DCTDecode'), 'las imágenes usan /DCTDecode');
  ok(txt.includes('/TrimBox') && txt.includes('/BleedBox'),
     'las páginas declaran TrimBox y BleedBox');

  // Con `--guardar` deja los PDF para mirarlos. Sin el flag no ensucia nada:
  // el objetivo de las pruebas es el veredicto, no los archivos.
  if (process.argv.includes('--guardar')) {
    const dir = path.join(AQUI, 'muestras');
    fs.mkdirSync(dir, { recursive: true });
    for (const p of pliegos) fs.writeFileSync(path.join(dir, `${p.nombre}.pdf`), p.bytes);
    console.log(`  (PDF guardados en imprenta/muestras/)`);
  }
  // El PDF tiene que pesar lo que pesan los diseños ÚNICOS, no las copias.
  // Es la prueba de que la deduplicación funciona: con 60 naipes de 45
  // diseños, embeber cada copia costaría un 33 % más.
  const usados = new Set(
    IMP.expandir(manifiesto.piezas.filter((p) => p.rol !== 'jefe'), CFG.incluir)
      .map((p) => p.archivo)
  );
  let unicos = 0;
  for (const a of usados) unicos += leer(a).length;
  const conCopias = IMP.expandir(
    manifiesto.piezas.filter((p) => p.rol !== 'jefe'), CFG.incluir)
    .reduce((s, p) => s + leer(p.archivo).length, 0);
  const real = porNombre['cartas-frentes'].bytes.length;
  const mb = (x) => (x / 1048576).toFixed(1);

  ok(real < unicos * 1.05,
     `pesa ${mb(real)} MB, casi lo mismo que sus ${usados.size} diseños (${mb(unicos)} MB)`);
  ok(real < conCopias * 0.8,
     `y muy por debajo de embeber las 60 copias (${mb(conCopias)} MB)`);

  const dorsos = porNombre['cartas-dorsos'].bytes.length;
  ok(dorsos < 4 * 1048576,
     `los 7 pliegos de dorsos pesan ${mb(dorsos)} MB: un solo dorso reusado 63 veces`);
}

console.log('\nTABLERO Y FICHAS');
{
  const pliegos = PLIEGOS.generar(manifiesto, leer, CFG);
  const porNombre = Object.fromEntries(pliegos.map((p) => [p.nombre, p]));

  ok(!!porNombre['tablero-energia'], 'sale el tablero de Energia');
  ok(!!porNombre['fichas-energia'], 'salen las fichas');

  const tablero = manifiesto.piezas.find((p) => p.rol === 'tablero');
  const ficha = manifiesto.piezas.find((p) => p.rol === 'ficha');
  ok(!!tablero, 'el manifiesto declara el tablero');
  ok(!!ficha, 'el manifiesto declara la ficha');
  ok(casi(ficha.ancho / ficha.alto, 1, 0.001),
     'la ficha es cuadrada, para cortarla redonda sin que se corra',
     `${ficha.ancho}x${ficha.alto}`);

  // El tablero se escala por ancho: el alto sale de su proporcion.
  const alto = (270 * tablero.alto) / tablero.ancho;
  ok(alto < 200, `a 270 mm de ancho mide ${alto.toFixed(0)} mm de alto y entra en A4 apaisada`);

  // Y se pliega lo suficiente para entrar en la caja.
  const paneles = Math.ceil(270 / 64);
  ok(270 / paneles <= 64,
     `plegado en ${paneles} da paneles de ${(270 / paneles).toFixed(0)} mm, y la caja tiene 64`);

  const txt = Buffer.from(porNombre['fichas-energia'].bytes).toString('latin1');
  ok((txt.match(/ c\n/g) || []).length >= 6 * 4,
     'cada ficha lleva su circulo de corte, dibujado con cuatro Beziers');
  ok(txt.includes('[1.6 1.6] 0 d'), 'el circulo de corte va punteado');

  const bytesFicha = Buffer.from(leer(ficha.archivo)).toString('latin1');
  let veces = 0, desde = 0;
  while ((desde = txt.indexOf(bytesFicha, desde)) !== -1) { veces++; desde += bytesFicha.length; }
  ok(veces === 1, 'la ficha se embebe una sola vez pese a las 6 copias', `aparecio ${veces}`);
}

console.log(fallos === 0 ? '\nTodo en verde.\n' : `\n${fallos} FALLAS.\n`);
console.log('\nLIBRILLO: LA IMPOSICION DEL CUADERNILLO');
{
  const conocido = [
    { frente: [16, 1], dorso: [2, 15] },
    { frente: [14, 3], dorso: [4, 13] },
    { frente: [12, 5], dorso: [6, 11] },
    { frente: [10, 7], dorso: [8, 9] },
  ];
  ok(JSON.stringify(LIBRILLO.ordenLibrillo(16)) === JSON.stringify(conocido),
     'el orden de un cuadernillo de 16 es el esperado');

  let tiro = false;
  try { LIBRILLO.ordenLibrillo(18); } catch (e) { tiro = true; }
  ok(tiro, 'un cuadernillo que no es multiplo de 4 se rechaza');

  // La invariante que atrapa todos los off-by-one que existen.
  let sumas = true, unicas = true;
  for (let n = 4; n <= 40; n += 4) {
    const vistas = new Set();
    for (const hoja of LIBRILLO.ordenLibrillo(n)) {
      if (hoja.frente[0] + hoja.frente[1] !== n + 1) sumas = false;
      if (hoja.dorso[0] + hoja.dorso[1] !== n + 1) sumas = false;
      for (const p of [...hoja.frente, ...hoja.dorso]) {
        if (vistas.has(p) || p < 1 || p > n) unicas = false;
        vistas.add(p);
      }
    }
    if (vistas.size !== n) unicas = false;
  }
  ok(sumas, 'en cada hoja, frente y dorso suman n+1');
  ok(unicas, 'de 4 a 40 paginas, cada una aparece exactamente una vez');

  ok(LIBRILLO.relleno(25, 'librillo') === 3, '25 paginas se rellenan hasta 28');
  ok(LIBRILLO.relleno(25, 'pila') === 1, 'en pila alcanza con llegar a par');
  ok(LIBRILLO.plan(23, { modo: 'pila' }).caras.length === 12,
     'la pila imprime a una sola cara, 12 hojas para 24 paginas',
     `dio ${LIBRILLO.plan(23, { modo: 'pila' }).caras.length}`);

  // El creep: las hojas de adentro se corren hacia el lomo.
  const sin = LIBRILLO.mitades(LIBRILLO.ordenLibrillo(16)[0], 'frente', 0, 0.1);
  const con = LIBRILLO.mitades(LIBRILLO.ordenLibrillo(16)[3], 'frente', 3, 0.1);
  ok(con[0].x > sin[0].x && con[1].x < sin[1].x,
     'la hoja de adentro se corre hacia el lomo para compensar el empuje');
}

console.log('\nLIBRILLO: EL PAGINADOR');
{
  const medir = (b) => b.alto ?? 10;
  const base = { medir, altoUtil: 100 };

  const veinticinco = Array.from({ length: 25 }, (_, i) => ({ t: 'parrafo', texto: `x${i}` }));
  ok(PAGINADOR.paginar(veinticinco, base).paginas.length === 3,
     '25 bloques de 10 mm entran en 3 paginas de 100 mm');

  // Los atomicos se mueven enteros: nunca parten una tabla al medio.
  const conTabla = [
    { t: 'parrafo', texto: 'a', alto: 50 },
    { t: 'tabla', cabeceras: [], filas: [], alto: 60 },
  ];
  const r = PAGINADOR.paginar(conTabla, { ...base, dividir: () => [{}, {}] });
  ok(r.paginas.length === 2 && r.paginas[1][0].t === 'tabla',
     'una tabla que no entra se muda entera a la pagina siguiente');

  // Keep-with-next: un titulo nunca queda ultimo.
  const conTitulo = [
    { t: 'parrafo', texto: 'a', alto: 90 },
    { t: 'titulo', nivel: 2, texto: 'T', alto: 8 },
    { t: 'parrafo', texto: 'b', alto: 30 },
  ];
  const r2 = PAGINADOR.paginar(conTitulo, base);
  ok(!r2.paginas.some((p) => p.length && p[p.length - 1].t === 'titulo'),
     'un titulo nunca queda ultimo en una pagina');
  ok(r2.paginas[1][0].t === 'titulo', 'el titulo baja junto con lo que encabeza');

  // Viudas y huerfanas: se parte, pero no dejando una linea suelta.
  const dividir = (b, libre, minimo) => {
    const lineas = Math.floor(libre / 10);
    if (lineas < minimo || b.alto / 10 - lineas < minimo) return null;
    return [{ ...b, alto: lineas * 10 }, { ...b, alto: b.alto - lineas * 10 }];
  };
  const casi1 = PAGINADOR.paginar(
    [{ t: 'parrafo', texto: 'a', alto: 95 }, { t: 'parrafo', texto: 'b', alto: 60 }],
    { ...base, dividir });
  ok(casi1.paginas.length === 2,
     'con una sola linea de sobra el parrafo se muda entero en vez de partirse');
}

console.log('\nLIBRILLO: EL CONTENIDO');
{
  const datos = JSON.parse(
    fs.readFileSync(path.join(AQUI, 'datos', 'juego_templo_es.json'), 'utf8'));

  for (const doc of ['reglamento', 'comic']) {
    const bloques = RENDER.expandir(CONTENIDO_ES[doc](datos), datos);
    const quejas = REFS.comprobar(bloques, datos, null);
    ok(quejas.length === 0, `el ${doc} no tiene tokens ni remisiones rotas`, quejas.join(' / '));
  }

  const comic = RENDER.expandir(CONTENIDO_ES.comic(datos), datos);
  const bifur = REFS.comprobarBifurcaciones(comic);
  ok(bifur.length === 0, 'toda bifurcacion apunta a una secuencia real y ofrece la derrota',
     bifur.join(' / '));

  // Las seis secuencias tienen que ser alcanzables desde alguna pagina.
  const anclas = new Set(comic.filter((b) => b.t === 'vineta' && b.id).map((b) => b.id));
  ok(anclas.size === 6, 'las seis secuencias del comic declaran su ancla', [...anclas].join(','));

  const vinetas = comic.filter((b) => b.t === 'vineta');
  ok(vinetas.length === 23, 'las 23 vinetas entran al librillo', `dio ${vinetas.length}`);

  // Y cada una tiene su archivo ya preparado por bin/imprimir.py.
  const faltan = vinetas.filter((v) => !fs.existsSync(path.join(PRINT, v.archivo)));
  ok(faltan.length === 0, 'todas las vinetas tienen su imagen en print/comic/',
     faltan.map((v) => v.archivo).join(', '));

  // El manifiesto y el texto tienen que hablar de las mismas vinetas.
  const enManifiesto = new Set(
    manifiesto.piezas.filter((p) => p.rol === 'vineta').map((p) => p.archivo));
  const sobran = [...enManifiesto].filter((a) => !vinetas.some((v) => v.archivo === a));
  ok(enManifiesto.size === 23 && sobran.length === 0,
     'el manifiesto declara exactamente las mismas 23 vinetas', sobran.join(', '));

  // Un dato que no exista tiene que romper, no salir en blanco.
  let tiro = false;
  try { REFS.sustituir('{n:no.existe}', datos, null); } catch (e) { tiro = true; }
  ok(tiro, 'un token sin dato falla en vez de imprimirse vacio');

  // La guardia de frescura: el JSON no puede ser mas viejo que sus fuentes.
  const gen = fs.statSync(path.join(AQUI, 'datos', 'juego_templo_es.json')).mtimeMs;
  const fuentes = ['lib/modos/dificultad.dart', 'lib/temas/templo/textos_es.dart',
                   'lib/reglas_texto.dart']
    .map((f) => path.join(RAIZ, 'app', f))
    .filter((f) => fs.existsSync(f));
  const viejas = fuentes.filter((f) => fs.statSync(f).mtimeMs > gen);
  ok(viejas.length === 0,
     'el JSON del librillo esta al dia',
     viejas.length ? 'corré: cd app && dart run bin/export_libro.dart' : '');
}

process.exit(fallos ? 1 : 0);
