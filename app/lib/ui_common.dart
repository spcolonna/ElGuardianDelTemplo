import 'dart:math';

import 'package:flutter/material.dart';

import 'audio.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

import 'models.dart';
import 'temas/temas.dart';

/// Colores de referencia, usados donde no hay un tema a mano (gráficos del
/// simulador, etiquetas de estado). El color real de cada fase lo define el
/// tema activo: ver `colorFaseDe`.
const kAlba = Color(0xFF4F9E63);
const kMediodia = Color(0xFFBE8A22);
const kOcaso = Color(0xFFB2403C);
const kJefe = Color(0xFF7048A8);
const kCombate = Color(0xFF3C7BB0);

Color colorFase(Fase f) => colorFaseDe(temaTemplo, f);

Color colorFaseDe(Tema tema, Fase f) =>
    Color(tema.colorFase[f] ?? kAlba.toARGB32());

/// Versión legible de un color, para usarlo como TEXTO sobre papel.
///
/// Los colores de fase están elegidos para manchas y bordes, donde importa que
/// se distingan entre sí. Como letra sobre `kPapel` varios quedan en 2:1 y
/// desaparecen. Esto los oscurece hasta llegar a 4.5:1, que es el mínimo de
/// WCAG AA para texto chico, y deja intacto al que ya contrastaba.
Color colorTexto(Color c, {Color sobre = kPapel}) {
  double luz(Color x) {
    double canal(double v) =>
        v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * canal(x.r) + 0.7152 * canal(x.g) + 0.0722 * canal(x.b);
  }

  double contraste(Color a, Color b) {
    final (x, y) = (luz(a), luz(b));
    return (max(x, y) + 0.05) / (min(x, y) + 0.05);
  }

  var v = c;
  // Doce pasos del 8% alcanzan para llevar cualquier color de la paleta al
  // umbral; el tope está para no colgarse con un fondo oscuro imposible.
  for (var i = 0; i < 12 && contraste(v, sobre) < 4.5; i++) {
    v = Color.from(alpha: v.a, red: v.r * .92, green: v.g * .92, blue: v.b * .92);
  }
  return v;
}

/// El paisaje de cada fase. Jefes reusa el del ocaso: no tiene arte propio.
/// Cuánto tarda el paisaje en deslizarse de una fase a la siguiente.
///
/// Vive acá y no en `ui_shell.dart` porque hay dos que la necesitan: el que
/// anima el paisaje, y la mesa, que tiene que esperarla antes de mostrar la
/// carta de Cansancio para no encimar dos cosas que se mueven.
const kTransicionPaisaje = Duration(milliseconds: 1600);

const fondoDeFase = <Fase, String>{
  Fase.alba: fondoAlba,
  Fase.mediodia: fondoMediodia,
  Fase.ocaso: fondoOcaso,
  Fase.jefes: fondoOcaso,
};

/// La música de cada fase.
const pistaDeFase = <Fase, Pista>{
  Fase.alba: Pista.alba,
  Fase.mediodia: Pista.mediodia,
  Fase.ocaso: Pista.ocaso,
  Fase.jefes: Pista.jefes,
};

/// Carta de combate dibujada como una carta real (proporción 63x88).
class CartaCombateView extends StatelessWidget {
  final CartaCombate carta;
  final double ancho;
  final bool seleccionada;
  final VoidCallback? onTap;

  const CartaCombateView({
    super.key,
    required this.carta,
    this.ancho = 96,
    this.seleccionada = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final malo = carta.poder < 1 && carta.efecto.vacio;
    final borde = seleccionada
        ? const Color(0xFFC99A2E)
        : (malo ? const Color(0xFF8A7862) : kCombate.withValues(alpha: .75));

    return BotonPulsable(
      onTap: onTap,
      escala: .94,
      child: Container(
        width: ancho,
        height: ancho * 88 / 63,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: malo
                ? [const Color(0xFFEDE4D2), const Color(0xFFE2D7C2)]
                : [const Color(0xFFFDF8EC), const Color(0xFFF3E9D6)],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borde, width: seleccionada ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: carta.poder < 0
                        ? Colors.red.withValues(alpha: .35)
                        : kCombate.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${carta.poder}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              carta.nombre,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (!carta.efecto.vacio)
              Text(
                carta.efecto.texto,
                style: TextStyle(
                  fontSize: 9.5,
                  height: 1.15,
                  color: const Color(0xFF8A5F33),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

class Etiqueta extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final Color? color;
  const Etiqueta(this.texto, {super.key, this.icono, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF4A3728);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: .7), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 15, color: c),
            const SizedBox(width: 6),
          ],
          // `Flexible` y no a secas: la píldora se usa con textos traducibles
          // y dentro de filas que en una ventana angosta de iPad no le dan
          // los 13 pt por letra que pide. Sin esto se desbordaba hasta 115 px.
          // Con `mainAxisSize.min` la píldora sigue midiendo lo justo cuando
          // hay lugar, así que en teléfono no cambia nada.
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
