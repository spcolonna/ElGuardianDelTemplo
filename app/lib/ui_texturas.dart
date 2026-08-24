import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// Sistema de texturas 9-slice ("nine-patch") del juego.
///
/// El arte de interfaz —marco de pantalla, cartel colgante, botones, placas—
/// son PNG dibujados a mano que tienen que estirarse a cualquier tamaño de
/// pantalla sin deformar el detalle. La solución es `centerSlice`, que es
/// nine-patch nativo del engine: las cuatro esquinas nunca se escalan, los
/// bordes se estiran en un solo eje y el centro en los dos.
///
/// Por qué `centerSlice` y no piezas separadas teseladas: teselar preserva
/// mejor la escala de la veta, pero exige bordes *seamless*, y el arte
/// generado con IA no lo es. Ocho archivos a alinear al píxel es además la
/// fuente de bugs más cara de todo el rediseño.
///
/// IMPORTANTE: los cortes se expresan en píxeles de la imagen YA resuelta, así
/// que estos assets NO pueden tener variantes `2.0x/3.0x` — si el engine
/// eligiera la de 3x, el rectángulo quedaría corrido por un factor de 3 en
/// silencio. Un archivo por pieza, dimensionado generoso, y `FilterQuality`.

/// Descriptor de una pieza: qué asset, de qué tamaño, y dónde están los cortes.
class NueveCortes {
  /// Ruta del asset.
  final String asset;

  /// Medida del PNG en píxeles. Sirve para validar (ver chequeo 14 de
  /// `bin/check.dart`) y para calcular el tamaño mínimo dibujable.
  final Size fuente;

  /// El rectángulo que SÍ se estira, en píxeles del PNG. Todo lo de afuera
  /// (las esquinas) se dibuja a escala fija.
  final Rect centro;

  /// Cuánto padding lógico necesita el hijo para no pisar el borde dibujado.
  final EdgeInsets contenido;

  /// Píxeles del asset por píxel lógico.
  ///
  /// Importa más de lo que parece: con `centerSlice`, las esquinas se dibujan
  /// a su tamaño de origen dividido por esta escala, y NO se estiran. Un botón
  /// de 600 px con esquinas de 90 px dibujado a escala 1 tendría 90 px lógicos
  /// de esquina por lado, o sea 180: más ancho que el botón entero. Subiendo
  /// la escala las esquinas se achican y la pieza entra.
  final double escala;

  const NueveCortes({
    required this.asset,
    required this.fuente,
    required this.centro,
    this.contenido = EdgeInsets.zero,
    this.escala = 3,
  });

  /// Tamaño mínimo lógico por debajo del cual las esquinas no entran y hay
  /// que caer al respaldo pintado.
  Size get minimo => Size(
    (fuente.width - centro.width) / escala,
    (fuente.height - centro.height) / escala,
  );
}

// --------------------------------------------------------------- descriptores
// Las medidas son contrato con ASSETS_UI.md. Si el arte llega con otra medida,
// el chequeo 14 de bin/check.dart lo detecta antes de que se vea raro.

const marcoPantalla = NueveCortes(
  asset: 'assets/ui/marco_pantalla.png',
  fuente: Size(1200, 1800),
  centro: Rect.fromLTRB(300, 300, 900, 1500),
  contenido: EdgeInsets.all(38),
);

const cartelColgante = NueveCortes(
  asset: 'assets/ui/cartel_colgante.png',
  fuente: Size(1024, 384),
  centro: Rect.fromLTRB(300, 150, 724, 250),
  contenido: EdgeInsets.fromLTRB(28, 20, 28, 16),
  escala: 6,
);

const panelPapelTex = NueveCortes(
  asset: 'assets/ui/panel_papel.png',
  fuente: Size(600, 600),
  centro: Rect.fromLTRB(120, 120, 480, 480),
  contenido: EdgeInsets.all(14),
  escala: 5,
);

// Los cortes salieron de decodificar el PNG y buscar dónde el borde superior
// se vuelve recto: ahí termina el remate tallado y empieza la tabla lisa.
const botonMaderaTex = NueveCortes(
  asset: 'assets/ui/boton_madera.png',
  fuente: Size(600, 240),
  centro: Rect.fromLTRB(84, 76, 516, 164),
  // Panel liso medido en el PNG: x 79..507, y 43..173 de 600x240.
  contenido: EdgeInsets.fromLTRB(23, 9, 26, 14),
  escala: 4.4,
);

const botonDoradoTex = NueveCortes(
  asset: 'assets/ui/boton_dorado.png',
  fuente: Size(600, 234),
  centro: Rect.fromLTRB(84, 74, 516, 160),
  // Panel liso medido en el PNG: x 127..516, y 42..172 de 600x234.
  contenido: EdgeInsets.fromLTRB(34, 9, 25, 14),
  escala: 4.4,
);

const placaNombreTex = NueveCortes(
  asset: 'assets/ui/placa_nombre.png',
  fuente: Size(512, 160),
  centro: Rect.fromLTRB(110, 60, 402, 100),
  contenido: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
  escala: 5,
);

const marcoRetratoTex = NueveCortes(
  asset: 'assets/ui/marco_retrato.png',
  fuente: Size(768, 900),
  centro: Rect.fromLTRB(150, 150, 618, 750),
  contenido: EdgeInsets.all(16),
);

const barraInferiorTex = NueveCortes(
  asset: 'assets/ui/barra_inferior.png',
  fuente: Size(1200, 300),
  centro: Rect.fromLTRB(300, 120, 900, 200),
  contenido: EdgeInsets.fromLTRB(10, 8, 10, 6),
  escala: 4.5,
);

/// Piezas sueltas (sin cortes) que también viven en `assets/ui/`.
/// El marco ilustrado del patio, con sus adornos horneados. No es 9-slice:
/// lo dibuja `ui_marco.dart` en tres bandas.
const marcoPatio = 'assets/ui/marco.png';

/// El fondo cambia con la fase: el mismo templo al amanecer, a pleno día y al
/// atardecer. Es lo que hace que avanzar de fase se sienta, sin un cartel que
/// lo anuncie.
const fondoAlba = 'assets/ui/fondo_alba.jpg';
const fondoMediodia = 'assets/ui/fondo_mediodia.jpg';
const fondoOcaso = 'assets/ui/fondo_ocaso.jpg';

/// El patio tiene su propio paisaje, más ancho: el mismo asset se reusa en
/// tablet, así que no se recorta.
const fondoPatio = 'assets/ui/background_home.jpg';

/// El marco vertical con papel donde va el personaje.
const marcoPersonaje = 'assets/ui/home.png';

/// El Novato de cuerpo entero, con fondo transparente.
const personaje = 'assets/ui/character.png';

/// El pergamino horizontal donde entran racha y logros.
const pergamino = 'assets/ui/paper.png';

/// El logo del juego: el poste de entrenamiento con el cinturón atado.
const logo = 'assets/ui/logo.jpeg';

/// Iconografía propia, en la estética del juego. Mientras no existan, la
/// interfaz cae en íconos de Material.
const iconoVictoria = 'assets/ui/victoria.png';
const iconoDerrota = 'assets/ui/derrota.png';
const fondoPapelTextura = 'assets/ui/fondo_papel.jpg';
const retratoNovato = 'assets/ui/retrato_novato.png';
const iconoVolver = 'assets/ui/boton_volver.png';
const insigniaLogro = 'assets/ui/insignia_logro.png';
const insigniaBloqueada = 'assets/ui/insignia_bloqueada.png';

/// Todas las texturas 9-slice, para precargar y para validar en check.dart.
const todasLasPiezas = <NueveCortes>[
  marcoPantalla,
  cartelColgante,
  panelPapelTex,
  botonMaderaTex,
  botonDoradoTex,
  placaNombreTex,
  marcoRetratoTex,
  barraInferiorTex,
];

// ------------------------------------------------------- qué arte ya existe

/// Rutas de asset que el build realmente incluye.
///
/// `errorBuilder` alcanza para que la app no se rompa, pero cada intento
/// fallido igual escupe una excepción por consola, y con 14 piezas ausentes
/// eso son 14 excepciones por pantalla. Consultando el manifiesto ni siquiera
/// se intenta cargar lo que no está.
Set<String>? _disponibles;

/// Lee el manifiesto de assets una sola vez. Se llama desde `AppState.cargar()`
/// para que ya esté listo antes de que se dibuje la primera pantalla.
Future<void> iniciarTexturas() async {
  try {
    final m = await AssetManifest.loadFromAssetBundle(rootBundle);
    _disponibles = m.listAssets().toSet();
  } catch (_) {
    // Sin manifiesto se asume que no hay arte: todo usa su respaldo pintado.
    _disponibles = const <String>{};
  }
}

/// Mientras el manifiesto no esté leído se responde que no: es preferible un
/// respaldo de más que una excepción.
bool hayAsset(String ruta) => _disponibles?.contains(ruta) ?? false;

// ------------------------------------------------------------------- widget

/// Carga una imagen de asset y la entrega ya decodificada.
///
/// Hace falta porque las piezas se dibujan con `CustomPaint`, y un painter
/// necesita una `ui.Image` de verdad, no un `ImageProvider`.
class _ConImagen extends StatefulWidget {
  final String asset;
  final Widget Function(BuildContext, ui.Image) construir;
  final WidgetBuilder mientrasNo;

  const _ConImagen({
    required this.asset,
    required this.construir,
    required this.mientrasNo,
  });

  @override
  State<_ConImagen> createState() => _ConImagenState();
}

class _ConImagenState extends State<_ConImagen> {
  ui.Image? _img;
  ImageStream? _flujo;
  ImageStreamListener? _oyente;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(_ConImagen viejo) {
    super.didUpdateWidget(viejo);
    if (viejo.asset != widget.asset) {
      _soltar();
      _img = null;
      _cargar();
    }
  }

  void _cargar() {
    if (!hayAsset(widget.asset)) return;
    _flujo = AssetImage(widget.asset).resolve(ImageConfiguration.empty);
    _oyente = ImageStreamListener((info, _) {
      if (mounted) setState(() => _img = info.image);
    }, onError: (_, _) {});
    _flujo!.addListener(_oyente!);
  }

  void _soltar() {
    if (_flujo != null && _oyente != null) _flujo!.removeListener(_oyente!);
    _flujo = null;
    _oyente = null;
  }

  @override
  void dispose() {
    _soltar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = _img;
    return img == null
        ? widget.mientrasNo(context)
        : widget.construir(context, img);
  }
}

/// Dibuja las nueve regiones a mano.
///
/// Reemplaza a `centerSlice`, que se usó tres veces y falló tres veces. El
/// motivo está en `paintImage` del SDK:
///
///     sliceBorder = inputSize / scale - centerSlice.size;
///
/// `inputSize / scale` está en píxeles LÓGICOS y `centerSlice` en píxeles de
/// la IMAGEN. Con una escala distinta de 1 las unidades no cierran y el borde
/// no estirable sale negativo, así que el arte se dibuja de cualquier tamaño
/// menos el correcto. Acá las unidades son nuestras y se convierten una sola
/// vez, en `_regiones`.
class _PintorNueveCortes extends CustomPainter {
  final ui.Image imagen;
  final NueveCortes pieza;

  const _PintorNueveCortes({required this.imagen, required this.pieza});

  @override
  void paint(Canvas canvas, Size size) {
    final f = pieza.fuente;
    final c = pieza.centro;
    final e = pieza.escala;

    // Los bordes en píxeles lógicos: lo que NO se estira.
    final izq = c.left / e;
    final der = (f.width - c.right) / e;
    final arr = c.top / e;
    final aba = (f.height - c.bottom) / e;

    // Si la caja no da para las esquinas, se achican en proporción en vez de
    // dibujar basura. Degradar suave es mejor que romper.
    final factor = math.min(
      1.0,
      math.min(
        izq + der > 0 ? size.width / (izq + der) : 1.0,
        arr + aba > 0 ? size.height / (arr + aba) : 1.0,
      ),
    );
    final li = izq * factor, ld = der * factor;
    final la = arr * factor, lb = aba * factor;

    final pintura = Paint()..filterQuality = FilterQuality.medium;

    // Columnas y filas, en la imagen y en la pantalla.
    final sx = [0.0, c.left, c.right, f.width];
    final sy = [0.0, c.top, c.bottom, f.height];
    final dx = [0.0, li, size.width - ld, size.width];
    final dy = [0.0, la, size.height - lb, size.height];

    for (var fila = 0; fila < 3; fila++) {
      for (var col = 0; col < 3; col++) {
        final origen = Rect.fromLTRB(
          sx[col],
          sy[fila],
          sx[col + 1],
          sy[fila + 1],
        );
        final destino = Rect.fromLTRB(
          dx[col],
          dy[fila],
          dx[col + 1],
          dy[fila + 1],
        );
        if (destino.width <= 0 || destino.height <= 0) continue;
        canvas.drawImageRect(imagen, origen, destino, pintura);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorNueveCortes v) =>
      v.imagen != imagen || v.pieza != pieza;
}

/// Una pieza ilustrada que se estira sin deformar su detalle.
///
/// Si el asset no está, dibuja [respaldo].
class PiezaNueveCortes extends StatelessWidget {
  final NueveCortes pieza;
  final Widget? child;
  final WidgetBuilder respaldo;

  /// Si el hijo debe recibir el padding declarado en el descriptor.
  final bool aplicarPadding;

  const PiezaNueveCortes({
    super.key,
    required this.pieza,
    required this.respaldo,
    this.child,
    this.aplicarPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final hijo = child == null
        ? null
        : (aplicarPadding
              ? Padding(padding: pieza.contenido, child: child)
              : child!);

    Widget conFondo(Widget fondo) => Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(child: fondo),
        ?hijo,
      ],
    );

    return _ConImagen(
      asset: pieza.asset,
      mientrasNo: (context) => conFondo(respaldo(context)),
      construir: (context, img) => conFondo(
        CustomPaint(
          painter: _PintorNueveCortes(imagen: img, pieza: pieza),
        ),
      ),
    );
  }
}

/// Imagen suelta con respaldo, para las piezas sin cortes.
class ImagenUi extends StatelessWidget {
  final String asset;
  final BoxFit fit;
  final WidgetBuilder respaldo;
  const ImagenUi({
    super.key,
    required this.asset,
    required this.respaldo,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (!hayAsset(asset)) return respaldo(context);
    return Image.asset(
      asset,
      fit: fit,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, _, _) => respaldo(context),
    );
  }
}

/// Mete las texturas en caché antes de mostrarlas, para que la primera
/// pantalla no aparezca a medio pintar. Se llama desde el splash, que ya
/// tiene una ventana de espera natural.
///
/// Los errores se tragan a propósito: si un asset falta, la pieza va a usar
/// su respaldo pintado y el juego sigue.
Future<void> precargarTexturas(BuildContext context) async {
  final rutas = <String>[
    marcoPatio,
    marcoPersonaje,
    personaje,
    pergamino,
    logo,
    fondoAlba,
    fondoOcaso,
    ...todasLasPiezas.map((p) => p.asset),
    fondoPatio,
    fondoPapelTextura,
    retratoNovato,
  ];
  for (final r in rutas) {
    if (!hayAsset(r)) continue;
    try {
      if (!context.mounted) return;
      await precacheImage(AssetImage(r), context);
    } catch (_) {
      // El asset está declarado pero no se pudo decodificar: respaldo.
    }
  }
}
