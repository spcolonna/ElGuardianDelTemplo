// El gate de la versión gratis.
//
// La versión gratis deja jugar el camino Aprendiz con los jefes en automático
// y sin los dos modos opcionales. Todo lo demás se abre con una compra única,
// que además saca la publicidad de los cambios de fase.
//
// El caso que de verdad importa es el último: bloquear los controles en
// pantalla no alcanza, porque las opciones quedan guardadas en las
// preferencias y pueden venir de una versión anterior al bloqueo.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/dificultad.dart';
import 'package:guardian_templo/ui_modos.dart';
import 'package:guardian_templo/ui_tienda.dart';

Widget _modos(AppState app) => MaterialApp(
  home: AppScope(state: app, child: const ModosScreen()),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sin comprar, siete de los ocho caminos están con candado', (
    tester,
  ) async {
    // Alta a propósito: el ListView es perezoso y con el alto de un teléfono
    // los últimos caminos ni se construyen, así que un `findsNothing` pasaría
    // por la razón equivocada.
    tester.view.physicalSize = const Size(414, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = AppState()..idiomaElegido = 'es';
    final t = TextosUi.de('es');

    await tester.pumpWidget(_modos(app));
    await tester.pumpAndSettle();

    // Los ocho nombres se ven igual: hay que mostrar lo que se compra.
    for (final d in Dificultad.values) {
      expect(find.text(t('dif.${d.clave}')), findsOneWidget);
    }

    // Aprendiz explica su dificultad; los otros siete explican el candado.
    expect(find.text(t('dif.aprendizSub')), findsOneWidget);
    expect(find.text(t('dif.maestroSub')), findsNothing);
    expect(
      find.text(t('tienda.bloqueado')),
      findsWidgets,
      reason: 'un control bloqueado sin motivo es peor que uno ausente',
    );

    // Y el banner ofrece la salida.
    expect(find.byType(BannerCompra), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('comprado, no queda ni un candado ni el banner', (tester) async {
    // Alta a propósito: el ListView es perezoso y con el alto de un teléfono
    // los últimos caminos ni se construyen, así que un `findsNothing` pasaría
    // por la razón equivocada.
    tester.view.physicalSize = const Size(414, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = AppState()..idiomaElegido = 'es';
    final t = TextosUi.de('es');
    await app.tienda.comprar(); // en kIdsDePrueba se resuelve local

    await tester.pumpWidget(_modos(app));
    await tester.pumpAndSettle();

    expect(app.premium, isTrue);
    expect(find.byType(BannerCompra), findsNothing);
    expect(find.byType(Candado), findsNothing);
    expect(find.text(t('tienda.bloqueado')), findsNothing);
    // Las líneas de sabor vuelven.
    expect(find.text(t('dif.maestroSub')), findsOneWidget);
  });

  test('sin comprar, unas opciones heredadas se aprietan al empezar', () async {
    // La puerta de atrás: `guardian_opciones_v1` guardado por una versión
    // anterior al bloqueo traía Maestro con tres jefes y los dos modos
    // prendidos. Si `guardarOpciones` no las apretara, el juego entero se
    // abriría sin pagar y sin tocar un solo control bloqueado.
    final app = AppState();
    app.opciones
      ..dificultad = Dificultad.maestro
      ..jefes = 3
      ..encargos = true
      ..cansancio = true;

    await app.guardarOpciones();

    expect(app.premium, isFalse);
    expect(app.opciones.dificultad, Dificultad.aprendiz);
    expect(app.opciones.jefes, isNull);
    expect(app.opciones.encargos, isFalse);
    expect(app.opciones.cansancio, isFalse);
  });

  test('comprado, las opciones se respetan tal cual', () async {
    final app = AppState();
    await app.tienda.comprar();
    app.opciones
      ..dificultad = Dificultad.maestro
      ..jefes = 3
      ..cansancio = true;

    await app.guardarOpciones();

    expect(app.opciones.dificultad, Dificultad.maestro);
    expect(app.opciones.jefes, 3);
    expect(app.opciones.cansancio, isTrue);
  });

  test('comprado, el aviso de cambio de fase no aparece ni tarda', () async {
    final app = AppState();
    await app.tienda.comprar();

    // Sin SDK de anuncios en el entorno de test, esto tiene que volver solo y
    // enseguida: una partida que se cuelga esperando un aviso que no existe es
    // mucho peor que un aviso que no se muestra.
    await app.anuncios
        .mostrarEnFase(Fase.jefes)
        .timeout(const Duration(seconds: 2));
  });

  test('el alba no lleva aviso: es el arranque, no una transición', () async {
    final app = AppState();
    await app.anuncios
        .mostrarEnFase(Fase.alba)
        .timeout(const Duration(seconds: 2));
  });
}
