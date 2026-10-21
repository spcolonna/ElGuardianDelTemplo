import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fondo de la pantalla de carga nativa: el oscuro de Oraki Games, el mismo
/// en todos los juegos del estudio.
const kFondoMarca = Color(0xFF231E1A);

const _logoOraki = 'assets/movil/marca/oraki_logo_light_on_dark.webp';

/// Ancho con que la pantalla nativa muestra el logo: lienzo de 768 px a 192 pt
/// con el logo de 520 px centrado. Así la animación arranca exactamente donde
/// termina la pantalla de carga y no se nota el cambio.
const _anchoLogo = 130.0;

/// Presentación del estudio al abrir el juego, igual que en Hexiege: el logo
/// que dejó la pantalla de carga brilla un momento, aparece «GAMES» y se
/// apaga. Tocar la salta.
class PresentacionOraki extends StatefulWidget {
  final VoidCallback onTerminar;
  const PresentacionOraki({super.key, required this.onTerminar});

  @override
  State<PresentacionOraki> createState() => _PresentacionOrakiState();
}

class _PresentacionOrakiState extends State<PresentacionOraki>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..forward().whenComplete(_salir);
  bool _saliendo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(_logoOraki), context);
  }

  void _salir() {
    if (_saliendo || !mounted) return;
    _saliendo = true;
    widget.onTerminar();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _salir,
      child: ColoredBox(
        color: kFondoMarca,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = _c.value;
            // Quieto al principio (igual a la pantalla nativa), después el
            // brillo y «GAMES», y al final se apaga.
            final brillo = Curves.easeOut.transform(
              ((t - 0.12) / 0.4).clamp(0.0, 1.0),
            );
            final games = Curves.easeOutCubic.transform(
              ((t - 0.25) / 0.3).clamp(0.0, 1.0),
            );
            final fin = Curves.easeIn.transform(
              ((t - 0.8) / 0.2).clamp(0.0, 1.0),
            );
            final escala = 1 + 0.035 * brillo - 0.02 * fin;
            return Opacity(
              opacity: 1 - fin * 0.35,
              child: Center(
                child: Transform.scale(
                  scale: escala,
                  child: SizedBox(
                    width: _anchoLogo,
                    // «GAMES» va fuera del flujo para no mover el logo, que
                    // queda centrado como en la pantalla nativa.
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _Brillo(brillo, t)),
                        ),
                        Image.asset(
                          _logoOraki,
                          width: _anchoLogo,
                          filterQuality: FilterQuality.high,
                        ),
                        Positioned(
                          left: -60,
                          right: -60,
                          bottom: -26 - 6 * (1 - games),
                          child: Opacity(
                            opacity: games,
                            // La marca no se traduce.
                            child: const Text(
                              'GAMES',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ZenKakuGothic',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                letterSpacing: 9,
                                decoration: TextDecoration.none,
                                color: Color(0xFFD9A84E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Halo cálido detrás del logo y destello de la estrella dorada.
class _Brillo extends CustomPainter {
  final double brillo, t;
  _Brillo(this.brillo, this.t);

  // Centro de la estrella dentro del logo (medido sobre la imagen).
  static const _estrella = Offset(0.712, 0.119);

  @override
  void paint(Canvas canvas, Size size) {
    if (brillo <= 0) return;
    final c = Offset(size.width / 2, size.height * 0.38);
    canvas.drawCircle(
      c,
      size.width * 0.9,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE07A3A).withValues(alpha: 0.16 * brillo),
            const Color(0x00E07A3A),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: size.width * 0.9)),
    );
    // La estrella titila una vez: cruz de luz que crece y se apaga.
    final s = Offset(_estrella.dx * size.width, _estrella.dy * size.height);
    final k = math.sin(((t - 0.18) / 0.45).clamp(0.0, 1.0) * math.pi);
    if (k <= 0) return;
    final p = Paint()
      ..color = const Color(0xFFFFE3A0).withValues(alpha: 0.85 * k)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    final largo = size.width * 0.22 * k;
    canvas.drawRect(
      Rect.fromCenter(center: s, width: largo * 2, height: 1.6),
      p,
    );
    canvas.drawRect(
      Rect.fromCenter(center: s, width: 1.6, height: largo * 2),
      p,
    );
    canvas.drawCircle(
      s,
      6 * k,
      Paint()
        ..color = const Color(0xFFFFE3A0).withValues(alpha: 0.5 * k)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(_Brillo v) => v.brillo != brillo || v.t != t;
}
