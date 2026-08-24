// El Cansancio no se puede revelar detrás del cómic.
//
// Con el disparo por defecto (`finDeFase`) la carta entra en el mismo
// `continuar()` que cambia de fase, o sea justo cuando se abre el interludio.
// Antes se revelaba ahí: sus 4,2 s corrían tapados por una pantalla completa y
// el jugador volvía a la mesa con una carta nueva en el mazo que nunca vio.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/ui_carta.dart';
import 'package:guardian_templo/ui_common.dart';
import 'package:guardian_templo/ui_game.dart';
import 'package:guardian_templo/ui_intro.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Deja la partida en el post-combate del ÚLTIMO peligro del Alba: el
  /// siguiente `continuar()` cambia de fase y mete la carta de Cansancio.
  ///
  /// Se pide `puedeMeditar` porque de eso depende que la mesa ofrezca el botón
  /// Continuar en vez de avanzar sola: el test necesita el toque para entrar
  /// por el mismo camino que el jugador.
  Juego alBordeDeFase(Config cfg) {
    final j = Juego(cfg: cfg, contenido: contenidoPorDefecto());
    var pasos = 0;
    while (pasos++ < 500) {
      while (j.estado == EstadoJuego.enCombate &&
          j.sumaMesa < j.poderPeligroEfectivo &&
          j.puedeRobar) {
        j.robar();
      }
      j.resolver();
      if (j.estado == EstadoJuego.postCombate &&
          j.fase == Fase.alba &&
          j.mazosPeligro[Fase.alba]!.isEmpty &&
          j.puedeMeditar) {
        return j;
      }
      j.continuar();
      if (j.terminado || j.fase != Fase.alba) break;
    }
    fail('no se llegó al último post-combate del Alba');
  }

  test('la carta de Cansancio entra al mazo, no al descarte', () {
    // Al descarte iba lo ya jugado, así que meditar la ofrecía para purgar
    // sin que el jugador la hubiera visto nunca en la mesa.
    final cfg = Config(energiaInicial: 200, energiaMaxima: 200)
      ..modoCansancio = true;

    for (var semilla = 0; semilla < 40; semilla++) {
      final j = Juego(
        cfg: cfg,
        contenido: contenidoPorDefecto(),
        rng: Random(semilla),
      );
      var vistos = 0;
      var pasos = 0;
      while (!j.terminado && pasos++ < 500) {
        while (j.estado == EstadoJuego.enCombate &&
            j.sumaMesa < j.poderPeligroEfectivo &&
            j.puedeRobar) {
          j.robar();
        }
        j.resolver();
        j.continuar();

        // El chequeo va pegado al `continuar()` que la trae: más tarde la
        // carta ya pudo salir jugada, y entonces estar en el descarte es
        // legítimo. Lo que nunca puede pasar es que aparezca ahí de entrada.
        if (j.cansancioAgregado > vistos) {
          vistos = j.cansancioAgregado;
          final uid = j.ultimoCansancio!.uid;
          expect(
            j.descarte.any((c) => c.uid == uid),
            isFalse,
            reason: 'semilla $semilla: al descarte sin haberse jugado',
          );
          // O sigue en el mazo, o el peligro que se reveló recién ya la robó.
          expect(
            j.mazo.any((c) => c.uid == uid) ||
                j.mesa.any((c) => c.uid == uid),
            isTrue,
            reason: 'semilla $semilla: no quedó en el mazo',
          );
        }
      }
      expect(vistos, greaterThan(0), reason: 'semilla $semilla: no entró');
    }
  });

  test('ninguna fatiga se repite en la misma partida', () {
    // El mazo de Cansancio son diez cartas distintas, no un sorteo con
    // reposición: que te toque dos veces Ampolla rompe la idea de que el
    // cuerpo se gasta de a pedazos distintos.
    final cfg = Config(energiaInicial: 400, energiaMaxima: 400)
      ..modoCansancio = true
      // El disparo frecuente es el que más chances tiene de repetir.
      ..disparoCansancio = DisparoCansancio.alRebarajar.index;

    for (var semilla = 0; semilla < 60; semilla++) {
      final j = Juego(
        cfg: cfg,
        contenido: contenidoPorDefecto(),
        rng: Random(semilla),
      );
      final salidas = <String>[];
      var vistos = 0;
      var pasos = 0;
      while (!j.terminado && pasos++ < 500) {
        while (j.estado == EstadoJuego.enCombate &&
            j.sumaMesa < j.poderPeligroEfectivo &&
            j.puedeRobar) {
          j.robar();
        }
        j.resolver();
        j.continuar();
        if (j.cansancioAgregado > vistos) {
          vistos = j.cansancioAgregado;
          salidas.add(j.ultimoCansancio!.id);
        }
      }
      expect(
        salidas.toSet().length,
        salidas.length,
        reason: 'semilla $semilla: se repitió una fatiga en $salidas',
      );
      // Y nunca puede repartir más cartas de las que tiene el mazo.
      expect(salidas.length, lessThanOrEqualTo(mazoCansancio.length));
    }
  });

  test('el Cansancio no se cuela siempre en el mismo lugar del mazo', () {
    // Insertarla al azar es lo que hace que el jugador no sepa cuándo sale.
    // Al fondo del mazo sería inofensiva; arriba, siempre la próxima.
    final cfg = Config(energiaInicial: 200, energiaMaxima: 200)
      ..modoCansancio = true;
    final lugares = <int>{};

    for (var semilla = 0; semilla < 40; semilla++) {
      final j = Juego(
        cfg: cfg,
        contenido: contenidoPorDefecto(),
        rng: Random(semilla),
      );
      var pasos = 0;
      while (j.cansancioAgregado == 0 && !j.terminado && pasos++ < 500) {
        while (j.estado == EstadoJuego.enCombate &&
            j.sumaMesa < j.poderPeligroEfectivo &&
            j.puedeRobar) {
          j.robar();
        }
        j.resolver();
        j.continuar();
      }
      final uid = j.ultimoCansancio!.uid;
      lugares.add(j.mazo.indexWhere((c) => c.uid == uid));
    }
    expect(lugares.length, greaterThan(5), reason: 'cae siempre igual');
  });

  testWidgets('la carta de Cansancio espera a que cierre el cómic', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(414, 896);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Energía de sobra: el Alba tiene que terminarse, no perderse.
    final cfg = Config(energiaInicial: 200, energiaMaxima: 200)
      ..modoCansancio = true
      // Con la regla por defecto sólo se medita al perder, y ganando el Alba
      // la mesa avanza sola en vez de ofrecer Continuar. El test necesita el
      // botón para entrar por el mismo camino que el jugador.
      ..meditarSoloAlPerder = false;
    final app = AppState();
    // Sin esto el idioma sale del locale del test, que es inglés.
    app.idiomaElegido = 'es';
    // GameScreen antepone la intro y el tutorial mientras no se hayan visto.
    app.introVista = true;
    app.tutorialVisto = true;
    app.juego = alBordeDeFase(cfg);

    final ui = TextosUi.de('es');
    final entrada = ui('juego.cansancioEntra').toUpperCase();

    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(
          state: app,
          child: Scaffold(body: GameScreen(onSalir: () {})),
        ),
      ),
    );
    await tester.pump();

    // El cómic de apertura abre cada partida: se salta para llegar a la mesa.
    await tester.tap(find.text(ui('comic.saltar')));
    await tester.pumpAndSettle();
    expect(find.byType(ComicView), findsNothing);

    // El toque que cierra el Alba: cambia de fase, entra el Cansancio y se
    // abre el interludio, todo en el mismo frame.
    await tester.tap(find.text(ui('juego.continuarPeligro')));
    await tester.pump();
    expect(app.juego!.fase, Fase.mediodia);
    expect(app.juego!.ultimoCansancio, isNotNull);
    expect(find.byType(ComicView), findsOneWidget);

    // Acá estaba el bug: la carta no puede consumir su ventana detrás del
    // cómic, por más que se deje correr de largo.
    expect(find.text(entrada), findsNothing);
    await tester.pump(const Duration(seconds: 6));
    expect(find.text(entrada), findsNothing);

    // Se cierra el interludio. Saltar y llegar al final son el mismo
    // `onTerminar`, y saltar no depende de cuántas viñetas tenga la secuencia.
    await tester.tap(find.text(ui('comic.saltar')));
    await tester.pump();
    expect(find.byType(ComicView), findsNothing);

    // Tampoco se encima al paisaje, que tarda 1,6 s en deslizarse.
    expect(find.text(entrada), findsNothing, reason: 'se encimó al paisaje');
    await tester.pump(kTransicionPaisaje + const Duration(milliseconds: 50));
    expect(find.text(entrada), findsOneWidget, reason: 'nunca se mostró');
    // Y con la carta a la vista: el punto es que el jugador vea CUÁL entró,
    // no sólo que entró alguna.
    expect(find.text(ui('juego.cansancioSub')), findsOneWidget);
    expect(
      tester
          .widgetList<CartaView>(find.byType(CartaView))
          .map((c) => c.id)
          .contains(app.juego!.ultimoCansancio!.id),
      isTrue,
      reason: 'no es la carta que entró',
    );

    // Y se va sola, sin dejar la mesa tapada.
    await tester.pump(const Duration(seconds: 5));
    expect(find.text(entrada), findsNothing);
  });
}
