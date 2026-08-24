import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ui_kit.dart';

/// Pantalla de arranque animada: el Loto Torcido.
///
/// El logo se dibuja con `CustomPaint`, no con una imagen: así la pantalla
/// funciona desde el primer día y sirve de referencia exacta para el
/// ilustrador. Si en el futuro hay un PNG, se reemplaza `_LotoTorcido`.
///
/// La animación en 2,2 s:
///   0,0–0,3  el fondo abstracto entra
///   0,3–1,1  el loto aparece con escala y un halo que se expande
///   1,1–1,5  EL PÉTALO SE DOBLA Y CAE — es la firma del juego
///   1,5–2,2  el título aparece desde abajo
class SplashScreen extends StatefulWidget {
  final String titulo;
  final VoidCallback onTerminar;
  const SplashScreen({
    super.key,
    required this.titulo,
    required this.onTerminar,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();

  bool _saliendo = false;

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) _salir();
    });
  }

  void _salir() {
    if (_saliendo) return;
    _saliendo = true;
    widget.onTerminar();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _tramo(double desde, double hasta) =>
      ((_c.value - desde) / (hasta - desde)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _salir,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final fondo = Curves.easeOut.transform(_tramo(0.0, 0.14));
          final loto = Curves.easeOutBack.transform(_tramo(0.14, 0.50));
          final halo = Curves.easeOut.transform(_tramo(0.14, 0.55));
          final petalo = Curves.easeInOut.transform(_tramo(0.50, 0.68));
          final titulo = Curves.easeOut.transform(_tramo(0.68, 1.0));

          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _FondoAbstracto(t: _c.value, entrada: fondo),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        painter: _LotoTorcido(
                          entrada: loto,
                          halo: halo,
                          caida: petalo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Opacity(
                      opacity: titulo,
                      child: Transform.translate(
                        offset: Offset(0, 12 * (1 - titulo)),
                        child: Text(
                          widget.titulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: kTinta,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Gradiente radial cálido con tres manchas desenfocadas que se mueven lento.
class _FondoAbstracto extends CustomPainter {
  final double t;
  final double entrada;
  const _FondoAbstracto({required this.t, required this.entrada});

  @override
  void paint(Canvas canvas, Size size) {
    final r = Offset.zero & size;
    canvas.drawRect(r, Paint()..color = kPapel);

    canvas.saveLayer(
      r,
      Paint()..color = Colors.white.withValues(alpha: entrada),
    );

    canvas.drawRect(
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.15),
          radius: 0.95,
          colors: [kOro.withValues(alpha: .35), kPapel],
        ).createShader(r),
    );

    // Manchas: se mueven en círculos lentos y desfasados.
    const manchas = [
      (kMadera, 0.0, 0.42),
      (kOro, 2.1, 0.34),
      (kVerde, 4.2, 0.28),
    ];
    for (final (color, fase, radio) in manchas) {
      final a = t * 0.9 + fase;
      final c = Offset(
        size.width * (0.5 + 0.26 * math.cos(a)),
        size.height * (0.45 + 0.20 * math.sin(a * 0.8)),
      );
      canvas.drawCircle(
        c,
        size.shortestSide * radio,
        Paint()
          ..color = color.withValues(alpha: .22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FondoAbstracto v) => v.t != t || v.entrada != entrada;
}

/// El logo: loto simétrico de cinco pétalos con uno doblado y caído.
class _LotoTorcido extends CustomPainter {
  final double entrada;
  final double halo;
  final double caida;
  const _LotoTorcido({
    required this.entrada,
    required this.halo,
    required this.caida,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height * 0.62);
    final escala = 0.85 + 0.15 * entrada;

    // Halo que se expande y se desvanece.
    if (halo > 0 && halo < 1) {
      canvas.drawCircle(
        centro,
        size.width * (0.22 + 0.38 * halo),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = kOroBorde.withValues(alpha: .5 * (1 - halo)),
      );
    }

    canvas.save();
    canvas.translate(centro.dx, centro.dy);
    canvas.scale(escala);
    canvas.translate(-centro.dx, -centro.dy);

    final tinta = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = kTinta.withValues(alpha: entrada.clamp(0, 1));

    final relleno = Paint()
      ..style = PaintingStyle.fill
      ..color = kOro.withValues(alpha: .38 * entrada.clamp(0, 1));

    // Cuatro pétalos firmes + el quinto que se cae.
    const angulos = [-1.9, -1.0, -2.24, -0.9];
    for (final a in angulos) {
      _petalo(canvas, centro, a, 1.0, size, tinta, relleno);
    }
    // El pétalo torcido: arranca derecho y se dobla hacia el costado.
    _petalo(
      canvas,
      centro,
      -1.5708 + 1.15 * caida,
      1 - 0.12 * caida,
      size,
      tinta,
      relleno,
    );

    // Base del loto.
    canvas.drawArc(
      Rect.fromCenter(
        center: centro,
        width: size.width * 0.52,
        height: size.width * 0.24,
      ),
      0.15,
      math.pi - 0.3,
      false,
      tinta,
    );
    canvas.restore();
  }

  void _petalo(
    Canvas canvas,
    Offset centro,
    double angulo,
    double largo,
    Size size,
    Paint tinta,
    Paint relleno,
  ) {
    final l = size.width * 0.34 * largo;
    final ancho = size.width * 0.14;
    final punta = centro + Offset(math.cos(angulo) * l, math.sin(angulo) * l);
    final perp = angulo + math.pi / 2;
    final d = Offset(math.cos(perp), math.sin(perp)) * ancho;

    final p = Path()
      ..moveTo(centro.dx, centro.dy)
      ..quadraticBezierTo(
        centro.dx + d.dx + (punta.dx - centro.dx) * .35,
        centro.dy + d.dy + (punta.dy - centro.dy) * .35,
        punta.dx,
        punta.dy,
      )
      ..quadraticBezierTo(
        centro.dx - d.dx + (punta.dx - centro.dx) * .35,
        centro.dy - d.dy + (punta.dy - centro.dy) * .35,
        centro.dx,
        centro.dy,
      )
      ..close();

    canvas.drawPath(p, relleno);
    canvas.drawPath(p, tinta);
  }

  @override
  bool shouldRepaint(_LotoTorcido v) =>
      v.entrada != entrada || v.halo != halo || v.caida != caida;
}
