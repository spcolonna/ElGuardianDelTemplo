// La colección muestra las 50 cartas y deja girar las que tienen dos caras.
//
// Lo que estos tests cuidan es una regla del juego disfrazada de interfaz:
// girar sólo tiene sentido en los 30 desafíos, porque son los únicos con la
// técnica impresa cabeza abajo en la mitad de abajo. Ofrecer el botón en un
// jefe o en una carta de cansancio le estaría prometiendo al jugador algo que
// la carta no tiene.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/mecanica.dart';
import 'package:guardian_templo/ui_carta.dart';
import 'package:guardian_templo/ui_coleccion.dart';
import 'package:guardian_templo/ui_kit.dart';

/// El `AppScope` va POR ENCIMA del `MaterialApp`, como en `main.dart`.
///
/// No es un detalle de armado: el visor se abre con `showGeneralDialog`, o sea
/// dentro del Navigator, y si el scope quedara del lado de adentro el diálogo
/// no lo vería y la carta abierta no sabría en qué idioma está.
Widget _app(AppState app) => AppScope(
  state: app,
  child: const MaterialApp(home: Scaffold(body: ColeccionScreen())),
);

Finder _carta(String id) =>
    find.byWidgetPredicate((w) => w is CartaView && w.id == id);

/// La grilla es perezosa: una carta que nunca estuvo cerca de la pantalla no
/// existe en el árbol. Para tocarla hay que ir hasta ella, como el jugador.
Future<void> _hasta(WidgetTester t, String id) async {
  await t.scrollUntilVisible(
    _carta(id),
    400,
    scrollable: find.byType(Scrollable).first,
  );
  // `scrollUntilVisible` para en cuanto la carta ASOMA, y una carta que asoma
  // por el borde tiene el centro fuera de pantalla: el tap le erra. Esto la
  // termina de traer.
  await t.ensureVisible(_carta(id));
  await t.pumpAndSettle();
}

void main() {
  // El audio se inicializa con AppState y en test no hay canal de plataforma.
  setUp(() => FlutterError.onError = (_) {});

  test('la colección son 50 cartas y ningún archivo repetido', () {
    expect(cartasDeColeccion, hasLength(50));
    expect(cartasDeColeccion.toSet(), hasLength(50));
    // Cada carta de la colección es un arte distinto: si dos compartieran
    // archivo, una de las dos estaría de más en la grilla.
    expect(cartasDeColeccion.map(archivoCarta).toSet(), hasLength(50));
    // Las 30 técnicas de recompensa NO están: viven dadas vuelta en su
    // peligro. Si alguna se colara, la grilla mostraría la misma imagen dos
    // veces seguidas.
    for (final p in mecPeligros) {
      expect(cartasDeColeccion, contains(p.id));
      expect(cartasDeColeccion, isNot(contains(p.recompensa)));
    }
  });

  test('girable es exactamente el conjunto de los desafíos', () {
    final girables = cartasDeColeccion.where(cartaGirable).toList();
    expect(girables, hasLength(30));
    expect(girables.toSet(), mecPeligros.map((p) => p.id).toSet());
  });

  testWidgets('se llega scrolleando desde la primera hasta la última', (
    t,
  ) async {
    await t.pumpWidget(_app(AppState()));
    await t.pump();

    expect(_carta(cartasDeColeccion.first), findsOneWidget);
    await _hasta(t, cartasDeColeccion.last);
    expect(_carta(cartasDeColeccion.last), findsOneWidget);
  });

  testWidgets('un desafío se abre, gira media vuelta y vuelve', (t) async {
    await t.pumpWidget(_app(AppState()));
    await t.pump();

    await _hasta(t, 'alba1');
    await t.tap(_carta('alba1'));
    await t.pumpAndSettle();
    expect(find.byKey(kGiroCarta), findsOneWidget);
    expect(find.byType(BotonMadera), findsOneWidget);

    // storage[0] de la matriz es el coseno del giro: 1 derecha, -1 al revés.
    double angulo() =>
        t.widget<Transform>(find.byKey(kGiroCarta)).transform.storage[0];
    expect(angulo(), closeTo(1, .001));

    await t.tap(find.byType(BotonMadera));
    await t.pumpAndSettle();
    expect(angulo(), closeTo(-1, .001));

    // Y vuelve, que es lo que espera quien ya leyó la técnica.
    await t.tap(find.byType(BotonMadera));
    await t.pumpAndSettle();
    expect(angulo(), closeTo(1, .001));
  });

  // El zoom es para mirar una carta, no un estado que el jugador tenga que
  // deshacer. Se prueban las dos salidas: girar y cerrar.
  testWidgets('el zoom no sobrevive ni al giro ni a cerrar la carta', (
    t,
  ) async {
    await t.pumpWidget(_app(AppState()));
    await t.pump();

    Future<void> abrir() async {
      await _hasta(t, 'alba1');
      await t.tap(_carta('alba1'));
      await t.pumpAndSettle();
    }

    // El controlador del `InteractiveViewer` es lo que guarda el zoom; se lo
    // empuja a mano porque un pellizco de dos dedos no se simula desde acá.
    TransformationController control() => t
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    double escala() => control().value.getMaxScaleOnAxis();

    await abrir();
    expect(escala(), closeTo(1, .001), reason: 'abrió ya agrandada');

    control().value = Matrix4.identity()..scaleByDouble(2.5, 2.5, 1, 1);
    expect(escala(), closeTo(2.5, .001));

    await t.tap(find.byType(BotonMadera));
    await t.pumpAndSettle();
    expect(escala(), closeTo(1, .001), reason: 'giró con el zoom puesto');

    control().value = Matrix4.identity()..scaleByDouble(2.5, 2.5, 1, 1);
    await t.tapAt(const Offset(10, 10)); // el velo, que cierra
    await t.pumpAndSettle();
    await abrir();
    expect(escala(), closeTo(1, .001), reason: 'se reabrió agrandada');
  });

  testWidgets('un jefe se abre sin botón de girar', (t) async {
    await t.pumpWidget(_app(AppState()));
    await t.pump();

    await _hasta(t, 'jefe1');
    await t.tap(_carta('jefe1'));
    await t.pumpAndSettle();
    // Se abrió —hay una carta encima de la grilla— pero sin nada que girar.
    expect(find.byKey(kGiroCarta), findsOneWidget);
    expect(find.byType(BotonMadera), findsNothing);
  });
}
