import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ui_common.dart';

/// El golpe visual de resolver un combate: la carta se enciende y salen
/// partículas.
///
/// Se dispara por CAMBIO DE KEY, no por una bandera de estado: el padre le
/// pasa una key derivada de cuántos combates se resolvieron, así que cada
/// combate construye un widget nuevo y la animación corre una sola vez, sin
/// que nadie tenga que acordarse de apagarla.
class Fogonazo extends StatefulWidget {
  final bool gano;

  const Fogonazo({super.key, required this.gano});

  @override
  State<Fogonazo> createState() => _FogonazoState();
}

class _FogonazoState extends State<Fogonazo>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final List<_Chispa> _chispas = List.generate(widget.gano ? 26 : 14, (i) {
    final r = math.Random(i * 31 + (widget.gano ? 1 : 2));
    return _Chispa(
      angulo: r.nextDouble() * math.pi * 2,
      // Al perder las partículas caen; al ganar salen disparadas.
      distancia: widget.gano
          ? .45 + r.nextDouble() * .55
          : .18 + r.nextDouble() * .3,
      tamano: 3 + r.nextDouble() * (widget.gano ? 6 : 4),
      demora: r.nextDouble() * .18,
      giro: (r.nextDouble() - .5) * 5,
    );
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.gano ? kAlba : kOcaso;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          // El destello sube rápido y baja lento: se lee como un golpe.
          final brillo = t < .12 ? t / .12 : math.max(0.0, 1 - (t - .12) / .55);
          return CustomPaint(
            painter: _PintorFogonazo(
              avance: t,
              brillo: brillo,
              color: color,
              gano: widget.gano,
              chispas: _chispas,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _Chispa {
  final double angulo, distancia, tamano, demora, giro;
  const _Chispa({
    required this.angulo,
    required this.distancia,
    required this.tamano,
    required this.demora,
    required this.giro,
  });
}

class _PintorFogonazo extends CustomPainter {
  final double avance;
  final double brillo;
  final Color color;
  final bool gano;
  final List<_Chispa> chispas;

  const _PintorFogonazo({
    required this.avance,
    required this.brillo,
    required this.color,
    required this.gano,
    required this.chispas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = size.center(Offset.zero);
    final radio = size.shortestSide;

    // 1) El resplandor que envuelve la carta.
    if (brillo > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: .55 * brillo),
              color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: centro, radius: radio * .85)),
      );
    }

    // 2) El anillo que se expande, sólo al ganar: es el premio.
    if (gano && avance < .75) {
      final a = avance / .75;
      canvas.drawCircle(
        centro,
        radio * (.2 + .5 * a),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5 * (1 - a)
          ..color = color.withValues(alpha: .8 * (1 - a)),
      );
    }

    // 3) Las chispas.
    for (final ch in chispas) {
      final a = ((avance - ch.demora) / (1 - ch.demora)).clamp(0.0, 1.0);
      if (a <= 0) continue;
      final suave = 1 - math.pow(1 - a, 3).toDouble();
      final d = radio * ch.distancia * suave;
      // Al perder, las chispas se hunden en vez de expandirse.
      final caida = gano ? 0.0 : radio * .35 * a * a;
      final p =
          centro +
          Offset(math.cos(ch.angulo) * d, math.sin(ch.angulo) * d + caida);

      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(ch.giro * a);
      final pintura = Paint()..color = color.withValues(alpha: (1 - a) * .95);
      if (gano) {
        // Pétalos, como en la celebración de logro.
        final path = Path()
          ..moveTo(0, -ch.tamano)
          ..quadraticBezierTo(ch.tamano, 0, 0, ch.tamano)
          ..quadraticBezierTo(-ch.tamano, 0, 0, -ch.tamano)
          ..close();
        canvas.drawPath(path, pintura);
      } else {
        canvas.drawCircle(Offset.zero, ch.tamano * .6, pintura);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_PintorFogonazo v) => v.avance != avance;
}

/// Borde encendido alrededor de la carta mientras dura el post-combate.
///
/// El fogonazo dura un segundo; esto se queda hasta que el jugador continúa,
/// así que el resultado sigue estando a la vista mientras decide si medita.
class HaloCarta extends StatelessWidget {
  final bool gano;
  final double radio;
  const HaloCarta({super.key, required this.gano, this.radio = 10});

  @override
  Widget build(BuildContext context) {
    final color = gano ? kAlba : kOcaso;
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radio),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: .55), blurRadius: 18),
          ],
        ),
      ),
    );
  }
}
