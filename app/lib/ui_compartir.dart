import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import 'app_state.dart';
import 'engine.dart';
import 'l10n.dart';
import 'modos/dificultad.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart' show logo;
import 'tienda/ids.dart' show urlDescarga;

/// Medidas de la imagen que se comparte: 4:5, la que Instagram y WhatsApp
/// muestran entera sin recortar.
const double kAnchoCompartir = 1080;
const double kAltoCompartir = 1350;

const _arteVictoria = 'assets/movil/comic/40_victoria_campeones.webp';
const _arteDerrota = 'assets/movil/comic/50_derrota_patio.webp';

/// El texto que acompaña la imagen.
String textoParaCompartir(AppState app, Juego j) {
  final t = TextosUi.de(app.idioma);
  final gano = j.estado == EstadoJuego.victoria;
  return fmt(t(gano ? 'compartir.textoGano' : 'compartir.textoPerdio'), {
    'fase': app.textos.fase(j.fase),
    'camino': t('dif.${app.opciones.dificultad.clave}'),
    'link': urlDescarga,
  });
}

/// Abre la vista previa y, si el jugador toca Compartir, el menú del sistema.
Future<void> abrirCompartir(BuildContext context, AppState app, Juego j) =>
    showDialog<void>(
      context: context,
      builder: (_) => _VistaPrevia(app: app, juego: j),
    );

class _VistaPrevia extends StatefulWidget {
  final AppState app;
  final Juego juego;
  const _VistaPrevia({required this.app, required this.juego});

  @override
  State<_VistaPrevia> createState() => _VistaPreviaState();
}

class _VistaPreviaState extends State<_VistaPrevia> {
  final _marco = GlobalKey();
  final _boton = GlobalKey();
  bool _armando = false;

  Future<void> _compartir() async {
    setState(() => _armando = true);
    try {
      final borde =
          _marco.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      // La vista previa mide lo que entra en pantalla; la escala lleva la
      // captura a 1080 de ancho justos.
      final imagen = await borde.toImage(
        pixelRatio: kAnchoCompartir / borde.size.width,
      );
      final datos = await imagen.toByteData(format: ui.ImageByteFormat.png);
      imagen.dispose();
      if (datos == null || !mounted) return;
      // En iPad el menú de compartir es un globito y necesita saber de dónde
      // sale: sin esto, la app se cae.
      final caja = _boton.currentContext?.findRenderObject() as RenderBox?;
      final origen = caja == null
          ? null
          : caja.localToGlobal(Offset.zero) & caja.size;
      await SharePlus.instance.share(
        ShareParams(
          text: textoParaCompartir(widget.app, widget.juego),
          files: [
            XFile.fromData(
              datos.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'guardian.png',
            ),
          ],
          sharePositionOrigin: origen,
        ),
      );
    } catch (_) {
      // Sin menú de compartir no hay nada que hacer: la vista previa sigue.
    } finally {
      if (mounted) setState(() => _armando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosUi.de(widget.app.idioma);
    return Dialog(
      backgroundColor: kPapel,
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: kAnchoCompartir / kAltoCompartir,
                child: RepaintBoundary(
                  key: _marco,
                  child: FittedBox(
                    child: TarjetaCompartir(
                      app: widget.app,
                      juego: widget.juego,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(t('nav.volver')),
                ),
                FilledButton.icon(
                  key: _boton,
                  onPressed: _armando ? null : _compartir,
                  icon: const Icon(Icons.ios_share),
                  label: Text(t('compartir.boton')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// La imagen de la partida, a 1080×1350 lógicos: el arte arriba y el
/// resultado en papel abajo, con la firma y el link al pie.
class TarjetaCompartir extends StatelessWidget {
  final AppState app;
  final Juego juego;
  const TarjetaCompartir({super.key, required this.app, required this.juego});

  @override
  Widget build(BuildContext context) {
    final t = TextosUi.de(app.idioma);
    final gano = juego.estado == EstadoJuego.victoria;
    final camino = t('dif.${app.opciones.dificultad.clave}');
    final link = urlDescarga.replaceFirst(RegExp(r'^https?://'), '');

    TextStyle estilo(double tam, {Color color = kTinta, bool titulo = false}) =>
        TextStyle(
          fontSize: tam,
          color: color,
          height: 1.15,
          fontFamily: titulo ? fuenteTitulo : null,
          fontWeight: titulo ? FontWeight.w700 : FontWeight.w500,
          decoration: TextDecoration.none,
        );

    return SizedBox(
      width: kAnchoCompartir,
      height: kAltoCompartir,
      child: ColoredBox(
        color: kPapelClaro,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 760,
              child: Image.asset(
                gano ? _arteVictoria : _arteDerrota,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(color: kMadera),
              ),
            ),
            Container(height: 10, color: kOroBorde),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(64, 44, 64, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Recortado en redondo: el archivo trae un fondo
                        // claro que sobre el papel se ve como un cuadrado.
                        ClipOval(
                          child: Image.asset(
                            logo,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const SizedBox(width: 160, height: 160),
                          ),
                        ),
                        const SizedBox(width: 28),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.textos.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: estilo(38, color: kTintaSuave),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                gano ? t('juego.ganaste') : t('juego.perdiste'),
                                maxLines: 2,
                                style: estilo(
                                  68,
                                  color: gano ? kVerdeTinta : kTinta,
                                  titulo: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      fmt(t('compartir.camino'), {'camino': camino}),
                      style: estilo(48),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      gano
                          ? t('compartir.gane')
                          : fmt(t('compartir.llegue'), {
                              'fase': app.textos.fase(juego.fase),
                            }),
                      maxLines: 2,
                      style: estilo(48),
                    ),
                    const Spacer(),
                    Container(height: 3, color: kOroBorde),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(t('compartir.firma'), style: estilo(32)),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            link,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: estilo(28, color: kTintaSuave),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
