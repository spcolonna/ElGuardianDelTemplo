// El modo Encargos tiene que ser legible de punta a punta.
//
// La mecánica ya andaba, pero se explicaba sola en ningún lado: la nota del
// día no se veía antes de empezar, la franja de la partida mostraba el título
// sin el premio, y el beneficio de la partida anterior se aplicaba en
// silencio. Un modo que no se puede ver no se puede entender.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/modos/encargos.dart';
import 'package:guardian_templo/temas/temas.dart';
import 'package:guardian_templo/ui_modos.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('todos los encargos tienen título, nota y recompensa en cada idioma', () {
    // Sin recompensa escrita, la franja de la partida promete un premio en
    // blanco: el jugador cumple la condición sin saber qué gana.
    for (final idioma in temaTemplo.idiomas) {
      final textos = temaTemplo.textosDe(idioma);
      for (final e in encargos) {
        final t = textos.encargos[e.id];
        expect(t, isNotNull, reason: '$idioma: falta el encargo ${e.id}');
        expect(t!.titulo.trim(), isNotEmpty, reason: '${e.id} sin título');
        expect(t.nota.trim(), isNotEmpty, reason: '${e.id} sin nota');
        expect(
          t.recompensa.trim(),
          isNotEmpty,
          reason: '${e.id} sin recompensa: el premio quedaría en blanco',
        );
      }
    }
  });

  test('el encargo del día es el mismo todo el día y cambia al siguiente', () {
    // Se puede mostrar antes de empezar justamente porque ya está decidido.
    final manana = DateTime(2026, 8, 21, 9);
    final noche = DateTime(2026, 8, 21, 23);
    expect(encargoDelDia(manana).id, encargoDelDia(noche).id);
    expect(
      encargoDelDia(manana).id,
      isNot(encargoDelDia(DateTime(2026, 8, 22)).id),
    );
  });

  testWidgets('prendido, la pantalla de modos muestra la nota de hoy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(414, 896);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = AppState()..idiomaElegido = 'es';
    final t = TextosUi.de('es');
    final hoy = app.textos.encargos[encargoDelDia(DateTime.now()).id]!;

    // Encargos es un modo del juego completo. Sin comprar, el interruptor
    // está bloqueado y tocarlo abre la tienda: no es esto lo que se prueba
    // acá, así que se abre el juego primero. En `kIdsDePrueba` la compra se
    // resuelve local y sin red.
    await app.tienda.comprar();

    await tester.pumpWidget(
      MaterialApp(home: AppScope(state: app, child: const ModosScreen())),
    );
    await tester.pumpAndSettle();

    // Las reglas opcionales viven abajo de todo, después de los caminos.
    final interruptor = find.text(t('modos.encargosT'));
    await tester.scrollUntilVisible(interruptor, 120);
    await tester.pumpAndSettle();

    // Apagado no muestra nada: el detalle es la recompensa de prenderlo.
    expect(find.text(hoy.nota), findsNothing);

    await tester.tap(interruptor);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text(hoy.nota), 120);
    await tester.pumpAndSettle();

    // Prendido, la nota entera: qué pide y qué se gana.
    expect(find.text(hoy.titulo), findsOneWidget);
    expect(find.text(hoy.nota), findsOneWidget);
    expect(
      find.text(fmt(t('modos.encargoPremio'), {'r': hoy.recompensa})),
      findsOneWidget,
      reason: 'no dice qué se gana',
    );
    expect(tester.takeException(), isNull);
  });
}
