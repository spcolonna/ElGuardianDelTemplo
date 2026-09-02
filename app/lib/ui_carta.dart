import 'package:flutter/material.dart';

import 'mecanica.dart';
import 'models.dart';
import 'tutorial_zonas.dart';
import 'ui_common.dart';
import 'ui_kit.dart';

/// Proporción de una carta de mano o de peligro. Los jefes tienen la suya
/// (ver `ratioCarta`), así que para dibujar una carta concreta hay que
/// preguntarle a ella, no usar esta constante.
const kRatioCarta = kRatioPeligro;

/// Muestra la carta ilustrada, y si todavía no existe cae en el dibujo
/// provisorio de [CartaCombateView].
///
/// La carta física está partida al medio: peligro arriba, técnica abajo
/// impresa a 180°. Por eso, cuando la carta actúa como técnica se muestra
/// Si la carta es una técnica de recompensa se dibuja media vuelta, igual
/// que la girás en la mesa real (ver `cartaRotada`).
class CartaView extends StatelessWidget {
  /// Id de la carta o de la técnica que vive en ella.
  final String id;

  /// Qué dibujar si no hay imagen todavía.
  final CartaCombate? respaldo;

  final double ancho;
  final bool seleccionada;
  final VoidCallback? onTap;

  const CartaView({
    super.key,
    required this.id,
    this.respaldo,
    this.ancho = 96,
    this.seleccionada = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final alto = ancho / ratioCarta(id);
    final base = archivoCarta(id);
    // La rotación la decide la carta, no quien la dibuja.
    final rotada = cartaRotada(id);

    // El original vive en `assets/cartas/$base.jpg` y NO se empaqueta: es el
    // que lee `bin/imprimir.py` para armar el print & play a 300 dpi. Lo que
    // viaja en el binario es la copia WebP de `bin/aligerar.py`.
    Widget imagen = Image.asset(
      'assets/movil/cartas/$base.webp',
      fit: BoxFit.contain,
      // Si la carta todavía no tiene arte —o si alguien se olvidó de correr
      // aligerar.py después de agregarla— se dibuja la carta provisoria y la
      // partida sigue.
      errorBuilder: (_, e, s) => _respaldo(),
    );

    if (rotada) {
      imagen = Transform.rotate(angle: 3.14159265, child: imagen);
    }

    return BotonPulsable(
      onTap: onTap,
      escala: .94,
      child: Container(
        width: ancho,
        height: alto,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: seleccionada
              ? Border.all(color: Colors.amberAccent, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .45),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: imagen,
      ),
    );
  }

  Widget _respaldo() {
    final c = respaldo;
    if (c == null) return const ColoredBox(color: Color(0xFF1A1A1F));
    return FittedBox(
      fit: BoxFit.contain,
      child: CartaCombateView(carta: c, ancho: 200),
    );
  }
}

/// Convierte una zona normalizada de la carta al rectángulo que ocupa en
/// pantalla. Vive acá y no en `tutorial_zonas.dart` para que ese archivo siga
/// siendo Dart puro.
Rect zonaEnPantalla(ZonaCarta zona, Rect carta) {
  final z = zonasCarta[zona]!;
  return Rect.fromLTRB(
    carta.left + z.izq * carta.width,
    carta.top + z.arriba * carta.height,
    carta.left + z.der * carta.width,
    carta.top + z.abajo * carta.height,
  );
}

/// Muestra una carta en grande sobre un fondo oscuro, hasta que el jugador
/// toque en cualquier lado.
///
/// En la mesa las cartas se ven chicas por necesidad —la del peligro manda—,
/// pero el jugador tiene que poder leer lo que jugó sin abrir la bitácora.
Future<void> mostrarCarta(
  BuildContext context, {
  required String id,
  CartaCombate? respaldo,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'carta',
    barrierColor: const Color(0xFF2A1F16).withValues(alpha: .78),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, _) {
      final ancho = MediaQuery.of(context).size.width * .82;
      final alto = MediaQuery.of(context).size.height * .78;
      return Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: CartaView(
              id: id,
              respaldo: respaldo,
              // La carta no puede pasarse de alto en pantallas bajas.
              ancho: ancho > alto * ratioCarta(id)
                  ? alto * ratioCarta(id)
                  : ancho,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, _, hijo) {
      final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: .88, end: 1).animate(curva),
          child: hijo,
        ),
      );
    },
  );
}
