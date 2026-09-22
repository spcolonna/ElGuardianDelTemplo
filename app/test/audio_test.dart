// Que el sonido se pueda apagar SIN abandonar la partida.
//
// Por qué existe este archivo: los dos interruptores de audio vivían sólo en
// Ajustes, y a Ajustes se llega únicamente desde el patio. Salir de una partida
// en curso pide confirmación, así que quien iba por el ocaso tenía que elegir
// entre la partida y el silencio. El menú de la mesa ahora los lleva, y este
// test es lo que impide que se vuelvan a caer sin que nadie se entere.
//
// Nota: el audio no tiene canal de plataforma en los tests (misma advertencia
// que `coleccion_test.dart`). `sonar` y `ponerPista` se tragan sus excepciones,
// así que los interruptores se pueden tocar; lo que se verifica es el booleano,
// no que suene.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/ui_game.dart';
import 'package:guardian_templo/ui_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el sonido se apaga desde el menú de la partida', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Energía de sobra para que la partida no se termine sola mientras se la
    // empuja hasta el combate.
    final juego = Juego(
      cfg: Config(energiaInicial: 200, energiaMaxima: 200),
      contenido: contenidoPorDefecto(),
    );
    var pasos = 0;
    while (pasos++ < 200 && juego.estado != EstadoJuego.enCombate) {
      if (juego.estado == EstadoJuego.esperandoPeligro) {
        juego.revelarPeligro();
      } else {
        juego.resolver();
        juego.continuar();
      }
    }

    final app = AppState()
      ..idiomaElegido = 'es'
      ..introVista = true
      ..tutorialVisto = true
      ..juego = juego;

    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(
          state: app,
          child: Scaffold(body: GameScreen(onSalir: () {})),
        ),
      ),
    );
    await tester.pump();

    final t = TextosUi.de('es');
    final saltar = find.text(t('comic.saltar'));
    if (saltar.evaluate().isNotEmpty) {
      await tester.tap(saltar);
      await tester.pumpAndSettle();
    }

    expect(app.audio.musicaActiva, isTrue);
    expect(app.audio.efectosActivos, isTrue);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    final musica = find.widgetWithText(FilaInterruptor, t('ajustes.musica'));
    final efectos = find.widgetWithText(FilaInterruptor, t('ajustes.efectos'));
    expect(musica, findsOneWidget, reason: 'sin interruptor de música');
    expect(efectos, findsOneWidget, reason: 'sin interruptor de efectos');

    await tester.tap(musica);
    await tester.pumpAndSettle();
    expect(app.audio.musicaActiva, isFalse);

    // La hoja NO se cierra al tocar un interruptor: el segundo tiene que
    // seguir ahí, porque quien apaga la música casi siempre sigue por los
    // efectos.
    expect(efectos, findsOneWidget, reason: 'la hoja se cerró sola');

    await tester.tap(efectos);
    await tester.pumpAndSettle();
    expect(app.audio.efectosActivos, isFalse);

    // Y la palanca se dibuja apagada, que es lo que el `StatefulBuilder`
    // arregla: sin él el booleano cambia y la pantalla no.
    final pintado = tester.widget<FilaInterruptor>(musica);
    expect(pintado.valor, isFalse, reason: 'la palanca quedó prendida');

    expect(tester.takeException(), isNull);
  });
}
