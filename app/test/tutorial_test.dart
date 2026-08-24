// El encabezado del tutorial tiene que aguantar un teléfono angosto.
//
// El título es traducible y comparte renglón con el contador de pasos y el
// botón Saltar: sin acotarlo, en 360 px se pasaba 117 px por la derecha.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/ui_tutorial.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el tutorial se arma sin desbordes', (tester) async {
    for (final idioma in ['es', 'en']) {
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
}
