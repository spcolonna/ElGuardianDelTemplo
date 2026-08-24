import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'ui_kit.dart';
import 'ui_texturas.dart';

/// El marco ilustrado del patio: `assets/ui/marco.png`.
///
/// A diferencia de las piezas 9-slice, este marco trae adornos horneados en
/// posiciones concretas —el farol, el cartel colgante, el botón cuadrado, la
/// tabla del pie y el botón dorado—, así que no alcanza con estirarlo: hay que
/// poner cada widget encima de su adorno.
///
/// Las medidas de abajo salieron de decodificar el PNG y buscar dónde cambia
/// el color y el alfa, no de mirarlo a ojo.
abstract final class ZonasMarco {
  static const fuente = Size(1024, 1536);

  /// Alto de las bandas que NO se pueden estirar, porque tienen dibujo.
  static const bandaArriba = 205.0;
  static const bandaAbajo = 184.0; // 1536 - 1352

  /// El cartel colgante donde va el título.
  static const cartel = Rect.fromLTRB(206, 100, 808, 180);

  /// El botón cuadrado de arriba a la derecha.
  static const botonEsquina = Rect.fromLTRB(836, 80, 958, 190);

  /// La tabla del pie: entran dos o tres accesos, no más.
  static const tabla = Rect.fromLTRB(76, 1384, 609, 1473);

  /// El botón dorado: la acción principal.
  static const botonDorado = Rect.fromLTRB(655, 1384, 944, 1468);

  /// Dónde entra el texto del botón dorado: el puño ya está dibujado en el
  /// arte y ocupa el arranque, así que la etiqueta empieza después.
  static const textoBotonDorado = Rect.fromLTRB(742, 1384, 938, 1468);

  /// Lo que queda libre entre las dos bandas, para el contenido.
  static const contenido = Rect.fromLTRB(62, 205, 963, 1352);
}

/// Pinta el marco en tres bandas.
///
/// La banda de arriba y la de abajo se dibujan a su proporción real, para que
/// el farol y los botones no se deformen. La del medio son sólo los dos
/// listones verticales, y estirarlos a lo largo no se nota: por eso el marco
/// se adapta a cualquier alto de pantalla sin repartir el dibujo.
class _PintorMarco extends CustomPainter {
  final ui.Image imagen;
  final double altoArriba;
  final double altoAbajo;

  const _PintorMarco({
    required this.imagen,
    required this.altoArriba,
    required this.altoAbajo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final f = ZonasMarco.fuente;
    final pintura = Paint()..filterQuality = FilterQuality.medium;

    canvas.drawImageRect(
      imagen,
      Rect.fromLTRB(0, 0, f.width, ZonasMarco.bandaArriba),
      Rect.fromLTWH(0, 0, size.width, altoArriba),
      pintura,
    );
    canvas.drawImageRect(
      imagen,
      Rect.fromLTRB(
        0,
        ZonasMarco.bandaArriba,
        f.width,
        f.height - ZonasMarco.bandaAbajo,
      ),
      Rect.fromLTWH(
        0,
        altoArriba,
        size.width,
        size.height - altoArriba - altoAbajo,
      ),
      pintura,
    );
    canvas.drawImageRect(
      imagen,
      Rect.fromLTRB(0, f.height - ZonasMarco.bandaAbajo, f.width, f.height),
      Rect.fromLTWH(0, size.height - altoAbajo, size.width, altoAbajo),
      pintura,
    );
  }

  @override
  bool shouldRepaint(_PintorMarco v) =>
      v.imagen != imagen ||
      v.altoArriba != altoArriba ||
      v.altoAbajo != altoAbajo;
}

/// Pantalla del patio: el marco ilustrado con cada widget sobre su adorno.
class MarcoJuego extends StatefulWidget {
  /// Va sobre el cartel colgante.
  final String titulo;

  /// El botón cuadrado de arriba a la derecha. El ícono ya viene dibujado en
  /// el marco, así que acá sólo se define qué hace al tocarlo.
  final VoidCallback? onEsquina;

  /// Lo que va en el hueco central.
  final Widget contenido;

  /// Los accesos de la tabla del pie. La tabla da para dos o tres.
  final List<AccesoTabla> accesos;

  /// La etiqueta del botón dorado.
  final String textoAccion;
  final VoidCallback? onAccion;

  /// Qué dibujar si el marco todavía no está en el build.
  final WidgetBuilder respaldo;

  const MarcoJuego({
    super.key,
    required this.titulo,
    required this.contenido,
    required this.textoAccion,
    required this.respaldo,
    this.onEsquina,
    this.accesos = const [],
    this.onAccion,
  });

  @override
  State<MarcoJuego> createState() => _MarcoJuegoState();
}

class _MarcoJuegoState extends State<MarcoJuego> {
  ui.Image? _img;
  ImageStream? _flujo;
  ImageStreamListener? _oyente;

  @override
  void initState() {
    super.initState();
    if (hayAsset(marcoPatio)) _cargar();
  }

  void _cargar() {
    _flujo = const AssetImage(marcoPatio).resolve(ImageConfiguration.empty);
    _oyente = ImageStreamListener((info, _) {
      if (mounted) setState(() => _img = info.image);
    }, onError: (_, _) {});
    _flujo!.addListener(_oyente!);
  }

  @override
  void dispose() {
    if (_flujo != null && _oyente != null) _flujo!.removeListener(_oyente!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = _img;
    if (img == null) return widget.respaldo(context);

    return LayoutBuilder(
      builder: (context, cs) {
        final w = cs.maxWidth, h = cs.maxHeight;
        final k = w / ZonasMarco.fuente.width;
        final altoArriba = ZonasMarco.bandaArriba * k;
        final altoAbajo = ZonasMarco.bandaAbajo * k;

        /// Lleva un rectángulo del PNG a la pantalla. Las bandas de arriba y
        /// abajo van a escala; el centro se estira con el alto disponible.
        Rect aPantalla(Rect r) {
          double y(double v) {
            if (v <= ZonasMarco.bandaArriba) return v * k;
            if (v >= ZonasMarco.fuente.height - ZonasMarco.bandaAbajo) {
              return h - (ZonasMarco.fuente.height - v) * k;
            }
            final t =
                (v - ZonasMarco.bandaArriba) /
                (ZonasMarco.fuente.height -
                    ZonasMarco.bandaArriba -
                    ZonasMarco.bandaAbajo);
            return altoArriba + t * (h - altoArriba - altoAbajo);
          }

          return Rect.fromLTRB(r.left * k, y(r.top), r.right * k, y(r.bottom));
        }

        Widget en(Rect zona, Widget hijo) {
          final r = aPantalla(zona);
          return Positioned(
            left: r.left,
            top: r.top,
            width: r.width,
            height: r.height,
            child: hijo,
          );
        }

        final anchoAcceso = widget.accesos.isEmpty
            ? 0.0
            : aPantalla(ZonasMarco.tabla).width / widget.accesos.length;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _PintorMarco(
                  imagen: img,
                  altoArriba: altoArriba,
                  altoAbajo: altoAbajo,
                ),
              ),
            ),

            en(
              ZonasMarco.contenido,
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: widget.contenido,
              ),
            ),

            en(
              ZonasMarco.cartel,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.titulo,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: fuenteTitulo,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kMaderaOscura,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            en(
              ZonasMarco.botonEsquina,
              BotonPulsable(
                onTap: widget.onEsquina,
                escala: .93,
                resalte: BorderRadius.circular(10),
                child: const SizedBox.expand(),
              ),
            ),

            en(
              ZonasMarco.tabla,
              Row(
                children: [
                  for (final (i, a) in widget.accesos.indexed)
                    SizedBox(
                      width: anchoAcceso,
                      child: _Acceso(
                        acceso: a,
                        conSeparador: i < widget.accesos.length - 1,
                      ),
                    ),
                ],
              ),
            ),

            // El área tocable es todo el botón; el texto, sólo la parte libre.
            en(
              ZonasMarco.botonDorado,
              BotonPulsable(
                onTap: widget.onAccion,
                escala: .95,
                resalte: BorderRadius.circular(12),
                child: const SizedBox.expand(),
              ),
            ),
            en(
              ZonasMarco.textoBotonDorado,
              IgnorePointer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.textoAccion,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: fuenteTitulo,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: kTinta,
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              color: kOro.withValues(alpha: .9),
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Un acceso de la tabla del pie.
class AccesoTabla {
  final String texto;
  final IconData icono;
  final VoidCallback onTap;
  final bool destacado;
  const AccesoTabla({
    required this.texto,
    required this.icono,
    required this.onTap,
    this.destacado = false,
  });
}

class _Acceso extends StatelessWidget {
  final AccesoTabla acceso;

  /// Deja una línea tallada a la derecha, salvo en el último.
  final bool conSeparador;

  const _Acceso({required this.acceso, this.conSeparador = true});

  @override
  Widget build(BuildContext context) {
    final color = acceso.destacado ? kOroBorde : kTinta;
    return BotonPulsable(
      onTap: acceso.onTap,
      escala: .92,
      resalte: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: conSeparador
              ? Border(
                  right: BorderSide(
                    color: kMaderaOscura.withValues(alpha: .45),
                    width: 1.5,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(acceso.icono, size: 17, color: color),
            const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  acceso.texto.toUpperCase(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                    color: color,
                    // Un realce claro justo debajo: sobre la madera hace que
                    // la etiqueta se lea tallada en vez de impresa encima.
                    // Al 55% el efecto era decorativo y la letra seguía
                    // costando; acá es lo que la separa de la veta.
                    shadows: [
                      Shadow(
                        color: kPapelClaro.withValues(alpha: .85),
                        offset: const Offset(0, 1),
                        blurRadius: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una pieza ilustrada con un hueco: se dibuja el asset entero y el contenido
/// se posiciona dentro del recuadro útil.
///
/// Sirve para `home.png` (marco de personaje) y `paper.png` (pergamino). Los
/// huecos salieron de decodificar cada PNG y buscar los límites del papel, así
/// que el contenido cae exactamente adentro y no sobre la madera.
class MarcoConHueco extends StatelessWidget {
  final String asset;
  final Size fuente;

  /// El recuadro útil, en píxeles del asset.
  final Rect hueco;

  final Widget child;
  final WidgetBuilder respaldo;

  const MarcoConHueco({
    super.key,
    required this.asset,
    required this.fuente,
    required this.hueco,
    required this.child,
    required this.respaldo,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: fuente.width / fuente.height,
      child: LayoutBuilder(
        builder: (context, cs) {
          final k = cs.maxWidth / fuente.width;
          return Stack(
            children: [
              Positioned.fill(
                child: ImagenUi(
                  asset: asset,
                  fit: BoxFit.fill,
                  respaldo: respaldo,
                ),
              ),
              Positioned(
                left: hueco.left * k,
                top: hueco.top * k,
                width: hueco.width * k,
                height: hueco.height * k,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Medidas de las piezas ilustradas con hueco.
abstract final class Huecos {
  static const marcoPersonajeFuente = Size(670, 1132);
  static const marcoPersonajeHueco = Rect.fromLTRB(122, 176, 552, 1034);

  static const pergaminoFuente = Size(926, 643);
  static const pergaminoHueco = Rect.fromLTRB(214, 162, 701, 480);
}
