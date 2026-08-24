import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ui_kit.dart';
import 'ui_texturas.dart';

/// Overlay de semana completada: la insignia entra en escala, un destello
/// radial se expande, y caen pétalos de loto.
///
/// Hecho a mano con un solo `AnimationController`, sin dependencias: es más
/// liviano que traer una librería de confeti y usa la paleta del juego.
class CelebracionLogro extends StatefulWidget {
  final String titulo;
  final String subtitulo;
  final String textoBoton;
  final VoidCallback onCerrar;

  const CelebracionLogro({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.textoBoton,
    required this.onCerrar,
  });

  @override
  State<CelebracionLogro> createState() => _CelebracionLogroState();
}

class _CelebracionLogroState extends State<CelebracionLogro>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..forward();

  late final List<_Petalo> _petalos = List.generate(28, (i) {
    final r = math.Random(i * 7 + 3);
    return _Petalo(
      x: r.nextDouble(),
      demora: r.nextDouble() * .35,
      velocidad: .55 + r.nextDouble() * .5,
      giro: (r.nextDouble() - .5) * 6,
      tamano: 8 + r.nextDouble() * 10,
      deriva: (r.nextDouble() - .5) * .25,
    );
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _tramo(double a, double b) =>
      ((_c.value - a) / (b - a)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final entrada = Curves.easeOutBack.transform(_tramo(0.02, 0.30));
        final destello = Curves.easeOut.transform(_tramo(0.02, 0.35));
        final texto = Curves.easeOut.transform(_tramo(0.22, 0.50));
        final boton = Curves.easeOut.transform(_tramo(0.45, 0.65));

        return Material(
          color: kTinta.withValues(alpha: .55),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _Petalos(t: _c.value, petalos: _petalos),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        painter: _Destello(avance: destello),
                        child: Center(
                          child: Transform.scale(
                            scale: entrada,
                            child: const IconoJuego(
                              asset: insigniaLogro,
                              respaldoIcono: Icons.military_tech,
                              tamano: 92,
                              colorRespaldo: kOroBorde,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: texto,
                      child: Transform.translate(
                        offset: Offset(0, 14 * (1 - texto)),
                        child: Column(
                          children: [
                            CartelMadera(widget.titulo, tamano: 20),
                            const SizedBox(height: 12),
                            PanelPapel(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Text(
                                widget.subtitulo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: kTintaSuave,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Opacity(
                      opacity: boton,
                      child: BotonMadera(
                        texto: widget.textoBoton,
                        principal: true,
                        onTap: boton > .9 ? widget.onCerrar : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Petalo {
  final double x, demora, velocidad, giro, tamano, deriva;
  const _Petalo({
    required this.x,
    required this.demora,
    required this.velocidad,
    required this.giro,
    required this.tamano,
    required this.deriva,
  });
}

class _Petalos extends CustomPainter {
  final double t;
  final List<_Petalo> petalos;
  const _Petalos({required this.t, required this.petalos});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in petalos) {
      final avance = ((t - p.demora) * p.velocidad).clamp(0.0, 2.0);
      if (avance <= 0) continue;
      final y = avance * (size.height + 120) - 60;
      if (y > size.height + 40) continue;

      final x =
          size.width *
          (p.x + p.deriva * math.sin(avance * 5 + p.x * 6)).clamp(-.05, 1.05);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(avance * p.giro);
      final pintura = Paint()
        ..color = (p.tamano > 14 ? kOro : kNaranja).withValues(
          alpha: (1 - avance / 1.6).clamp(0.0, .95),
        );
      // Pétalo: dos curvas que se cierran en punta.
      final path = Path()
        ..moveTo(0, -p.tamano / 2)
        ..quadraticBezierTo(p.tamano / 2, 0, 0, p.tamano / 2)
        ..quadraticBezierTo(-p.tamano / 2, 0, 0, -p.tamano / 2)
        ..close();
      canvas.drawPath(path, pintura);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_Petalos v) => v.t != t;
}

class _Destello extends CustomPainter {
  final double avance;
  const _Destello({required this.avance});

  @override
  void paint(Canvas canvas, Size size) {
    if (avance <= 0 || avance >= 1) return;
    final centro = size.center(Offset.zero);
    final opacidad = (1 - avance) * .75;

    canvas.drawCircle(
      centro,
      size.width * (.25 + .35 * avance),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = kOro.withValues(alpha: opacidad),
    );

    // Rayos cortos, como un sello.
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      final r1 = size.width * (.30 + .22 * avance);
      final r2 = r1 + size.width * .09;
      canvas.drawLine(
        centro + Offset(math.cos(a) * r1, math.sin(a) * r1),
        centro + Offset(math.cos(a) * r2, math.sin(a) * r2),
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = kOroBorde.withValues(alpha: opacidad),
      );
    }
  }

  @override
  bool shouldRepaint(_Destello v) => v.avance != avance;
}
