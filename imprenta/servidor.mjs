/* Un solo proceso que sirve todo el proyecto en el navegador.
 *
 *     node imprenta/servidor.mjs          desde la raíz del proyecto
 *     node imprenta/servidor.mjs 9000     en otro puerto
 *
 * Levanta tres cosas en el mismo servidor:
 *
 *     /            un índice con las dos herramientas
 *     /imprenta/   los pliegos de impresión, con el arte ya cargado
 *     /juego/      el juego compilado (necesita `flutter build web`)
 *
 * La imprenta también funciona con doble clic en `index.html`, sin nada de
 * esto; servida por HTTP se ahorra el paso de arrastrar la carpeta.
 */
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const RAIZ = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const JUEGO = path.join(RAIZ, 'app', 'build', 'web');
// El puerto puede venir por argumento o por PORT; 8123 es el último recurso.
const PUERTO = Number(process.argv[2] || process.env.PORT || 8123);

const TIPOS = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.wasm': 'application/wasm',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.wav': 'audio/wav',
  '.mp3': 'audio/mpeg',
  '.pdf': 'application/pdf',
  '.md': 'text/plain; charset=utf-8',
};

const hayJuego = () => fs.existsSync(path.join(JUEGO, 'index.html'));

/** El índice: dos puertas, y el estado real de cada una. */
function portada() {
  const juegoListo = hayJuego();
  return `<!doctype html><html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>El Guardián del Templo</title>
<style>
  body { margin:0; padding:40px 24px; background:#F7F1E1; color:#4A3728;
    font:16px/1.55 "Avenir Next","Segoe UI",system-ui,sans-serif; }
  .marco { max-width:660px; margin:0 auto; }
  h1 { font-size:30px; margin:0 0 4px; }
  .bajada { color:#8A7862; margin:0 0 30px; font-size:15px; }
  a.puerta { display:block; text-decoration:none; color:inherit;
    background:#FDF8EC; border:1.5px solid #C99A2E; border-radius:12px;
    padding:20px 22px; margin-bottom:14px; }
  a.puerta:hover { background:#FBF6E8; }
  a.puerta.apagada { opacity:.6; border-style:dashed; }
  .puerta b { font-size:19px; display:block; margin-bottom:3px; }
  .puerta span { color:#8A7862; font-size:14px; }
  code { background:#F0E7D2; padding:2px 6px; border-radius:4px; font-size:13px; }
  .pie { margin-top:26px; color:#8A7862; font-size:13.5px; }
</style></head><body><div class="marco">
<h1>El Guardián del Templo</h1>
<p class="bajada">Todo en un solo proceso. Abrí cada cosa en su pestaña.</p>

<a class="puerta" href="/imprenta/" target="_blank">
  <b>La Imprenta</b>
  <span>Los pliegos de cartas, la tapa, el tablero y las fichas. El arte se carga solo.</span>
</a>

<a class="puerta" href="/imprenta/librillo/?doc=reglamento" target="_blank">
  <b>El reglamento</b>
  <span>Librillo A5 para doblar y abrochar. El PDF lo hace tu navegador.</span>
</a>

<a class="puerta" href="/imprenta/librillo/?doc=comic" target="_blank">
  <b>El cómic</b>
  <span>Las 23 viñetas, con las páginas que te dicen cuándo seguir leyendo.</span>
</a>

${juegoListo
  ? `<a class="puerta" href="/juego/" target="_blank">
  <b>El juego</b>
  <span>La partida corriendo en el navegador.</span>
</a>`
  : `<a class="puerta apagada" href="#" onclick="return false">
  <b>El juego</b>
  <span>Todavía no está compilado. Corré <code>cd app &amp;&amp; flutter build web</code>
  y recargá esta página.</span>
</a>`}

<p class="pie">Un solo proceso. Se corta con <code>Ctrl+C</code> en la terminal.</p>
</div></body></html>`;
}

http
  .createServer((req, res) => {
    let rel = decodeURIComponent(req.url.split('?')[0]);

    if (rel === '/' || rel === '/index.html') {
      res.writeHead(200, { 'Content-Type': TIPOS['.html'] });
      res.end(portada());
      return;
    }

    // `/juego/` es el build de Flutter, que vive fuera de la raíz servida.
    let abs;
    if (rel === '/juego' || rel.startsWith('/juego/')) {
      if (!hayJuego()) {
        res.writeHead(503, { 'Content-Type': TIPOS['.html'] });
        res.end('<p>El juego no está compilado. Corré <code>cd app && flutter build web</code>.</p>');
        return;
      }
      const dentro = rel.slice('/juego'.length) || '/';
      abs = path.join(JUEGO, dentro.endsWith('/') ? dentro + 'index.html' : dentro);
      if (!abs.startsWith(JUEGO)) {
        res.writeHead(403).end('fuera del build');
        return;
      }
    } else {
      if (rel.endsWith('/')) rel += 'index.html';
      abs = path.join(RAIZ, rel);
      // Sin esto, un `..` en la URL sirve cualquier archivo del disco.
      if (!abs.startsWith(RAIZ)) {
        res.writeHead(403).end('fuera del proyecto');
        return;
      }
    }

    fs.readFile(abs, (err, datos) => {
      if (err) {
        res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('no está: ' + rel);
        return;
      }
      // Flutter compila su index.html con `<base href="/">`, así que pediría
      // `flutter_bootstrap.js` desde la raíz del servidor y no desde /juego/.
      // Reescribirlo acá evita tener que recompilar con --base-href.
      if (abs === path.join(JUEGO, 'index.html')) {
        datos = Buffer.from(
          datos.toString('utf8').replace(/<base href="[^"]*">/, '<base href="/juego/">'),
          'utf8'
        );
      }
      res.writeHead(200, {
        'Content-Type': TIPOS[path.extname(abs).toLowerCase()] || 'application/octet-stream',
      });
      res.end(datos);
    });
  })
  .on('error', (e) => {
    if (e.code === 'EADDRINUSE') {
      console.error(
        `\nEl puerto ${PUERTO} está ocupado.\n` +
          `Probá con otro:  node imprenta/servidor.mjs ${PUERTO + 1}\n`
      );
      process.exit(1);
    }
    throw e;
  })
  .listen(PUERTO, '127.0.0.1', () => {
    console.log(`\n  El Guardián del Templo\n`);
    console.log(`  http://127.0.0.1:${PUERTO}/            índice`);
    console.log(`  http://127.0.0.1:${PUERTO}/imprenta/   los pliegos`);
    console.log(
      `  http://127.0.0.1:${PUERTO}/juego/      ${hayJuego() ? 'el juego' : '(falta flutter build web)'}`
    );
    console.log(`\n  Ctrl+C para cortar.\n`);
  });
