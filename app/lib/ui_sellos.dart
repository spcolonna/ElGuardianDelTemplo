import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'progreso.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

const _iconos = <String, IconData>{
  'loto': Icons.spa,
  'alba': Icons.wb_sunny,
  'bambu': Icons.grass,
  'campana': Icons.notifications_none,
  'montana': Icons.landscape,
  'rio': Icons.waves,
  'llama': Icons.local_fire_department,
  'luna': Icons.nightlight_round,
  'viento': Icons.air,
  'ocaso': Icons.wb_twilight,
  'estrella': Icons.auto_awesome,
  'shifu': Icons.self_improvement,
};

/// Bermellón de tinta de sello: más oscuro que `kRojo`, que es el de la
/// interfaz, para que se lea como estampa y no como botón.
const kTintaSello = Color(0xFFB23A2C);

/// Un sello estampado, o el hueco donde va a ir.
///
/// Usa `assets/ui/sello_<id>.png` si existe (ver ASSETS_UI.md). Mientras no
/// esté, se dibuja a mano —círculo de tinta, anillo de papel y el emblema
/// calado—: así ya se ve como un sello y no como un ícono suelto.
class Sello extends StatelessWidget {
  final int indice;
  final bool ganado;
  final double tamano;

  const Sello({
    super.key,
    required this.indice,
    required this.ganado,
    this.tamano = 64,
  });

  @override
  Widget build(BuildContext context) {
    final id = idsSellos[indice % idsSellos.length];
    if (!ganado) {
      return Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kMadera.withValues(alpha: .10),
          border: Border.all(color: kMadera.withValues(alpha: .55), width: 2),
        ),
        child: Icon(
          Icons.lock_outline,
          size: tamano * .34,
          color: kMadera.withValues(alpha: .8),
        ),
      );
    }
    // Cada sello un poco torcido, y siempre igual: una estampa a mano nunca
    // queda derecha.
    final giro = (math.Random(indice * 31 + 7).nextDouble() - .5) * .35;
    return Transform.rotate(
      angle: giro,
      child: SizedBox(
        width: tamano,
        height: tamano,
        child: ImagenUi(
          asset: 'assets/movil/ui/sello_$id.webp',
          respaldo: (_) => _pintado(id),
        ),
      ),
    );
  }

  Widget _pintado(String id) => Container(
    width: tamano,
    height: tamano,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: kTintaSello,
      boxShadow: [
        BoxShadow(
          color: kTintaSello.withValues(alpha: .35),
          blurRadius: tamano * .08,
          offset: Offset(0, tamano * .03),
        ),
      ],
    ),
    padding: EdgeInsets.all(tamano * .07),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kPapelClaro, width: tamano * .035),
      ),
      child: Icon(
        _iconos[id] ?? Icons.spa,
        size: tamano * .48,
        color: kPapelClaro,
      ),
    ),
  );
}

/// La grilla de los doce sellos, ganados y por ganar.
class GrillaSellos extends StatelessWidget {
  final int ganados;
  final String Function(int indice) nombre;

  const GrillaSellos({super.key, required this.ganados, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cs) {
        // Cuatro por fila en teléfono; el sello se achica antes de que la
        // fila se desborde en una ventana angosta de iPad.
        final ancho = (cs.maxWidth - 3 * 10) / 4;
        final tamano = (ancho * .78).clamp(30.0, 74.0);
        return Wrap(
          spacing: 10,
          runSpacing: 12,
          children: [
            for (var i = 0; i < Progreso.totalSellos; i++)
              SizedBox(
                width: ancho,
                child: Column(
                  children: [
                    Sello(indice: i, ganado: i < ganados, tamano: tamano),
                    const SizedBox(height: 5),
                    Text(
                      nombre(i),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.15,
                        fontWeight: i < ganados
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: i < ganados ? kTinta : kTintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
