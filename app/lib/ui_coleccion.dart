// Las 50 cartas del juego, para mirarlas fuera de la partida.
//
// En la mesa una carta de desafío se lee en dos tiempos: el peligro arriba y,
// cuando lo ganás, la técnica que está impresa cabeza abajo en la mitad de
// abajo. Girás la carta y ahí la leés. Esta pantalla hace lo mismo, con el
// giro animado, porque es el gesto del juego y no un adorno.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'mecanica.dart';
import 'ui_carta.dart';
import 'ui_kit.dart';
import 'ui_shell.dart';

/// ¿Esta carta tiene una segunda lectura del otro lado?
///
/// Sólo los 30 desafíos. Las iniciales, las de cansancio y los jefes están
/// impresos derechos de arriba abajo: girarlos no muestra nada nuevo, muestra
/// la misma carta al revés.
bool cartaGirable(String id) => mecPeligros.any((p) => p.id == id);

/// El `Transform` que gira la carta abierta. La usa `test/coleccion_test.dart`.
const kGiroCarta = ValueKey('coleccion.giro');

/// La colección. Devuelve el cuerpo pelado: el marco lo pone `rutas.dart`.
class ColeccionScreen extends StatelessWidget {
  const ColeccionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);

    String titulo(SeccionColeccion s) => switch (s) {
      // Alba, Mediodía, Ocaso y Jefes ya tienen nombre en el tema: son los
      // mazos del juego y el jugador los conoce por ese nombre.
      _ when s.fase != null => app.textos.fase(s.fase!),
      SeccionColeccion.cansancio => t('modos.cansancioT'),
      _ => t('coleccion.iniciales'),
    };

    return CustomScrollView(
      slivers: [
        for (final (seccion, ids) in coleccionPorSeccion) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
              child: PlacaTitulo(titulo(seccion)),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // Los cinco jefes son apaisados —1620x1024, al revés que el
              // resto— y la app está fijada en vertical. A tres por fila
              // quedaban del tamaño de una estampilla, así que van de a uno
              // por fila y con su propia proporción.
              crossAxisCount: seccion == SeccionColeccion.jefes ? 1 : 3,
              childAspectRatio: seccion == SeccionColeccion.jefes
                  ? kRatioJefe
                  : kRatioPeligro,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final id = ids[i];
              return LayoutBuilder(
                builder: (context, cons) => CartaView(
                  id: id,
                  ancho: cons.maxWidth,
                  onTap: () {
                    tocarUi(context);
                    mostrarCartaGirable(context, id: id);
                  },
                ),
              );
            }, childCount: ids.length),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

/// Abre la carta en grande, con el botón de girarla si la carta lo merece.
///
/// Hermano de `mostrarCarta` (`ui_carta.dart`), que es el que usa la partida.
/// No se reusó aquél porque su contenido es la carta y nada más: acá abajo va
/// el botón, y meterlo allá le agregaría a la partida un botón que no quiere.
Future<void> mostrarCartaGirable(BuildContext context, {required String id}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'carta',
    barrierColor: const Color(0xFF2A1F16).withValues(alpha: .84),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, _) => _VisorCarta(id: id),
    transitionBuilder: (context, anim, _, hijo) {
      final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: .9, end: 1).animate(curva),
          child: hijo,
        ),
      );
    },
  );
}

class _VisorCarta extends StatefulWidget {
  final String id;
  const _VisorCarta({required this.id});

  @override
  State<_VisorCarta> createState() => _VisorCartaState();
}

class _VisorCartaState extends State<_VisorCarta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _giro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  /// El zoom lo maneja `CartaConZoom`, pero el controlador vive acá porque el
  /// giro necesita poder resetearlo.
  final _zoom = TransformationController();

  @override
  void dispose() {
    _giro.dispose();
    _zoom.dispose();
    super.dispose();
  }

  void _girar() {
    tocarUi(context);
    // Se vuelve a 1x antes de girar: media vuelta con la carta ampliada deja
    // al jugador mirando un pedazo de pergamino, sin saber de qué carta es.
    _zoom.value = Matrix4.identity();
    if (_giro.status == AnimationStatus.completed) {
      _giro.reverse();
    } else {
      _giro.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TextosUi.de(AppScope.of(context).idioma);
    final girable = cartaGirable(widget.id);
    final pantalla = MediaQuery.of(context).size;
    final ratio = ratioCarta(widget.id);
    // Se le deja aire abajo al botón, y la carta nunca se pasa de alto.
    final alto = pantalla.height * (girable ? .70 : .78);
    final ancho = math.min<double>(pantalla.width * .86, alto * ratio);

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // El tap de adentro no cierra: girar no es salir.
              GestureDetector(
                onTap: girable ? _girar : null,
                // El zoom va POR FUERA del giro. Adentro, con la carta a 180°,
                // el arrastre saldría invertido: movés el dedo a la derecha y
                // la carta se va a la izquierda.
                child: CartaConZoom(
                  control: _zoom,
                  dobleToqueReencuadra: !girable,
                  child: AnimatedBuilder(
                    animation: _giro,
                    builder: (context, hijo) {
                      final v = Curves.easeInOutCubic.transform(_giro.value);
                      // El giro es sobre el PLANO de la carta, no un volteo.
                      // La carta tiene una sola cara: la técnica está impresa
                      // cabeza abajo en la misma cara, así que lo que la
                      // endereza es girarla sobre la mesa. Un `rotateY` la
                      // dejaría espejada, con el texto al revés.
                      //
                      // La escala baja en el medio del giro y vuelve: es la
                      // carta que se levanta y se apoya. Sin eso el giro se ve
                      // plano, como un ícono rotando.
                      final e = 1 - .08 * math.sin(v * math.pi);
                      return Transform(
                        // La llave es para el test: es la única forma de leer
                        // el ángulo al que quedó la carta sin espiar el estado.
                        key: kGiroCarta,
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0012)
                          ..rotateZ(v * math.pi)
                          ..scaleByDouble(e, e, 1, 1),
                        child: hijo,
                      );
                    },
                    child: RepaintBoundary(
                      child: CartaView(id: widget.id, ancho: ancho),
                    ),
                  ),
                ),
              ),
              if (girable) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: math.min<double>(ancho, 260),
                  child: BotonMadera(
                    texto: t('coleccion.girar'),
                    icono: Icons.rotate_right,
                    principal: true,
                    onTap: _girar,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
