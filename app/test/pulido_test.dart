// Cuatro detalles reportados jugando la versión publicada (1.1.0).
//
// 1. Misiones quedaba pintado de dorado para siempre en el patio: el
//    «destacado» se prendía con el primer logro y no se apagaba nunca.
// 2. Al terminar la partida no había botones: para volver a jugar o al patio
//    había que abrir el menú.
// 3. El resultado del Encargo del Shifu casi no se leía: letra clara y chica
//    sobre un recuadro casi transparente, encima del paisaje.
// 4. El interruptor de la música tardaba en moverse y el de los efectos no:
//    esperaba a que la pista cargara y terminara el fundido antes de
//    redibujarse.
//
// Nota: el audio no tiene canal de plataforma en los tests (ver
// `audio_test.dart`).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/audio.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/encargos.dart';
import 'package:guardian_templo/ui_game.dart';
import 'package:guardian_templo/ui_home.dart';
import 'package:guardian_templo/ui_kit.dart';
import 'package:guardian_templo/ui_texturas.dart';

/// Un audio que tarda en hacer lo que se le pide, como el de verdad: cargar la
/// pista y el fundido de entrada pasan de un segundo en un teléfono.
class _AudioLento extends Audio {
  @override
  Future<void> ponerPista(Pista p) =>
      Future.delayed(const Duration(seconds: 2));
  @override
  Future<void> pararMusica() => Future.delayed(const Duration(seconds: 2));
}

class _AppConAudioLento extends AppState {
  @override
  // ignore: overridden_fields
  final Audio audio = _AudioLento();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final t = TextosUi.de('es');

  void telefono(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Juego terminada(EstadoJuego fin) {
    final j = Juego(
      cfg: Config(energiaInicial: 200, energiaMaxima: 200),
      contenido: contenidoPorDefecto(),
    );
    j.estado = fin;
    return j;
  }

  Future<void> aLaMesa(
    WidgetTester tester,
    AppState app, {
    VoidCallback? onSalir,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(
          state: app,
          child: Scaffold(body: GameScreen(onSalir: onSalir ?? () {})),
        ),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      final saltar = find.text(TextosUi.de(app.idioma)('comic.saltar'));
      if (saltar.evaluate().isEmpty) break;
      await tester.tap(saltar.first);
      await tester.pumpAndSettle();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('1. Misiones se pinta igual que los otros accesos del patio', (
    tester,
  ) async {
    telefono(tester);
    // Sin el manifiesto de assets el patio usa su respaldo, que no es lo que
    // ve el jugador. Y el marco se decodifica de verdad, fuera del reloj
    // falso, ANTES de armar la app: así el audio, que en los tests no tiene
    // plataforma, no llega a correr fuera del reloj falso.
    await tester.runAsync(() async {
      await iniciarTexturas();
      final listo = Completer<void>();
      const AssetImage(marcoPatio)
          .resolve(ImageConfiguration.empty)
          .addListener(ImageStreamListener((_, _) => listo.complete()));
      await listo.future;
    });
    final app = AppState()
      ..idiomaElegido = 'es'
      ..introVista = true
      ..tutorialVisto = true;
    app.logros.desbloqueados.add('primera_victoria');

    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(state: app, child: const PatioScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(
      find.text(t('nav.logros').toUpperCase()),
      findsWidgets,
      reason: 'el patio no llegó a dibujar el marco',
    );

    Color? colorTexto(String clave) {
      final f = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.style?.fontSize == 11 &&
            (w.data ?? '').toUpperCase() == t(clave).toUpperCase(),
      );
      expect(f, findsWidgets, reason: 'no está el acceso ${t(clave)}');
      return tester.widget<Text>(f.first).style?.color;
    }

    // Ídem: el ícono de la tabla mide 17; el del contador, 20 y violeta.
    Color? colorIcono(IconData i) => tester
        .widget<Icon>(
          find.byWidgetPredicate(
            (w) => w is Icon && w.icon == i && w.size == 17,
          ),
        )
        .color;

    expect(colorTexto('nav.logros'), colorTexto('nav.reglas'));
    expect(colorIcono(Icons.military_tech), colorIcono(Icons.menu_book));
    expect(colorTexto('nav.logros'), isNot(kOroBorde));
  });

  group('2. Al terminar la partida', () {
    for (final fin in [EstadoJuego.victoria, EstadoJuego.derrota]) {
      testWidgets(
        'hay botones para jugar otra y para ir al inicio (${fin.name})',
        (tester) async {
          telefono(tester);
          var salio = false;
          final app = AppState()
            ..idiomaElegido = 'es'
            ..introVista = true
            ..tutorialVisto = true
            ..juego = terminada(fin);
          await aLaMesa(tester, app, onSalir: () => salio = true);

          final otra = find.widgetWithText(FilledButton, t('juego.nueva'));
          final inicio = find.widgetWithText(OutlinedButton, t('nav.inicio'));
          expect(otra, findsOneWidget, reason: 'falta «${t('juego.nueva')}»');
          expect(inicio, findsOneWidget, reason: 'falta «${t('nav.inicio')}»');

          await tester.tap(inicio);
          await tester.pump();
          expect(salio, isTrue, reason: 'Inicio no volvió al patio');

          await tester.tap(otra);
          await tester.pump();
          expect(
            app.juego!.terminado,
            isFalse,
            reason: 'no arrancó una partida nueva',
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('con encargo, el resumen entra en un teléfono chico', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final app = AppState()
        ..idiomaElegido =
            'de' // el alemán es el que más ocupa
        ..introVista = true
        ..tutorialVisto = true
        ..juego = terminada(EstadoJuego.victoria)
        ..encargoActivo = encargoDelDia(DateTime(2026, 10, 10));
      await aLaMesa(tester, app);
      expect(tester.takeException(), isNull);
      expect(find.text(TextosUi.de('de')('juego.nueva')), findsOneWidget);
    });
  });

  testWidgets(
    '3. El resultado del encargo se lee: fondo opaco y tinta oscura',
    (tester) async {
      telefono(tester);
      final app = AppState()
        ..idiomaElegido = 'es'
        ..introVista = true
        ..tutorialVisto = true
        ..juego = terminada(EstadoJuego.derrota)
        ..encargoActivo = encargoDelDia(DateTime(2026, 10, 10));
      await aLaMesa(tester, app);

      // Cumplido o no depende del encargo del día: se mira el recuadro entero.
      final titulo = find.textContaining(t('encargo.titulo').split('{').first);
      expect(titulo, findsOneWidget);
      final recuadro = find
          .ancestor(of: titulo, matching: find.byType(Container))
          .first;
      final textos = find.descendant(of: recuadro, matching: find.byType(Text));
      expect(textos, findsNWidgets(2));
      for (final e in textos.evaluate()) {
        final w = e.widget as Text;
        final color = w.style?.color ?? DefaultTextStyle.of(e).style.color;
        expect(color, kTinta, reason: '«${w.data}» no va en tinta oscura');
      }

      final caja = tester.widget<Container>(recuadro);
      final fondo = (caja.decoration as BoxDecoration).color!;
      expect(fondo.a, 1.0, reason: 'el recuadro deja ver el paisaje');
    },
  );

  group('4. Los interruptores de música responden al toque', () {
    for (final desde in [true, false]) {
      testWidgets(desde ? 'al apagar' : 'al prender', (tester) async {
        telefono(tester);
        final juego = Juego(
          cfg: Config(energiaInicial: 200, energiaMaxima: 200),
          contenido: contenidoPorDefecto(),
        );
        final app = _AppConAudioLento()
          ..idiomaElegido = 'es'
          ..introVista = true
          ..tutorialVisto = true
          ..juego = juego;
        app.audio.musicaActiva = desde;
        await aLaMesa(tester, app);

        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        final musica = find.widgetWithText(
          FilaInterruptor,
          t('ajustes.musica'),
        );
        expect(tester.widget<FilaInterruptor>(musica).valor, desde);

        await tester.tap(musica);
        // Un cuadro, no más: el audio tarda dos segundos y la palanca no
        // tiene por qué esperarlo.
        await tester.pump(const Duration(milliseconds: 16));
        expect(
          tester.widget<FilaInterruptor>(musica).valor,
          !desde,
          reason: 'la palanca esperó al audio',
        );

        await tester.pump(const Duration(seconds: 3));
      });
    }
  });
}
