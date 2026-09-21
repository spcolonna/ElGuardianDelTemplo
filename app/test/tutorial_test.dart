// El encabezado del tutorial tiene que aguantar un teléfono angosto.
//
// El título es traducible y comparte renglón con el contador de pasos y el
// botón Saltar: sin acotarlo, en 360 px se pasaba 117 px por la derecha.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/ui_tutorial.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el tutorial se arma sin desbordes', (tester) async {
    for (final idioma in codigosIdioma) {
      for (final ancho in [320.0, 360.0, 414.0]) {
        tester.view.physicalSize = Size(ancho, 780);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final app = AppState()..idiomaElegido = idioma;
        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              state: app,
              child: Scaffold(body: TutorialScreen(onTerminar: () {})),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$idioma a $ancho px');

        // Y pegado a la derecha, contra el padding del header, como el del
        // cómic. Con flex de por medio le quedaba aire al costado y se leía
        // como un botón suelto en el medio del renglón.
        final t = TextosUi.de(idioma);
        final boton = find.widgetWithText(TextButton, t('tutorial.saltar'));
        expect(
          ancho - tester.getRect(boton).right,
          closeTo(12, 0.5),
          reason: '$idioma a $ancho px: el botón no está contra el borde',
        );
      }
    }
  });

  // El paso que pide tocar algo tiene que traer ese algo a la vista.
  //
  // En un teléfono bajo los botones de la mesa nacen debajo del pliegue, y el
  // globo de texto del tutorial —que es fijo y está abajo— tapa todavía más.
  // Sin el scroll automático el tutorial dice «robá una carta» señalando un
  // botón que no se ve, y el jugador tiene que descubrir solo que hay que
  // arrastrar.
  //
  // OJO: acá no se puede usar `pumpAndSettle`. El resalte late sin parar, así
  // que nunca hay un frame en reposo y el test se cuelga para siempre.
  testWidgets('el paso trae su objetivo a la vista', (t) async {
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final textos = TextosUi.de('es');
    await t.pumpWidget(
      MaterialApp(
        home: AppScope(
          state: AppState()..idiomaElegido = 'es',
          child: Scaffold(body: TutorialScreen(onTerminar: () {})),
        ),
      ),
    );
    await t.pump();

    final siguiente = find.widgetWithText(
      FilledButton,
      textos('tutorial.siguiente'),
    );
    final robar = find.widgetWithText(
      FilledButton,
      textos('juego.robarGratis'),
    );

    // Los seis primeros pasos son de leer: se avanza hasta `p07`, que es el
    // primero que señala los botones.
    for (var i = 0; i < 6; i++) {
      await t.tap(siguiente);
      await t.pump(const Duration(milliseconds: 600));
    }

    // El scroll se pide en el `addPostFrameCallback` del frame que acaba de
    // dibujarse, así que la animación arranca DESPUÉS: sin este frame de más,
    // el test mira la pantalla justo antes de que se mueva.
    await t.pump();
    await t.pump(const Duration(milliseconds: 600));

    expect(robar, findsOneWidget, reason: 'no se llegó al paso de robar');

    final pantalla = Offset.zero & const Size(360, 640);
    final r = t.getRect(robar);
    expect(
      pantalla.contains(r.topLeft) && pantalla.contains(r.bottomRight),
      isTrue,
      reason: 'el botón a tocar quedó fuera de pantalla: $r',
    );

    // Y que haya hecho falta scrollear: si el objetivo ya se veía solo, el
    // test de arriba pasaría sin probar nada.
    final pos = t.widget<Scrollable>(find.byType(Scrollable).first).controller;
    expect(
      pos!.offset,
      greaterThan(0),
      reason: 'no scrolleó: el test no está probando lo que cree',
    );
  });
}
