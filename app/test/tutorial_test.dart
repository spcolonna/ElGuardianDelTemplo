// El encabezado del tutorial tiene que aguantar un teléfono angosto.
//
// El título es traducible y comparte renglón con el contador de pasos y el
// botón Saltar: sin acotarlo, en 360 px se pasaba 117 px por la derecha.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/tutorial.dart';
import 'package:guardian_templo/tutorial_zonas.dart';
import 'package:guardian_templo/temas/temas.dart';
import 'package:guardian_templo/ui_carta.dart';
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

  // El recuadro ambar tiene que caer sobre lo que el texto nombra.
  //
  // El agujero del velo se calcula en `build`, pero el scroll que el propio
  // tutorial pide lo maneja el `Scrollable` con su estado interno: no dispara
  // ningun `build` del tutorial. Sin el listener de `_scroll`, el recuadro
  // quedaba dibujado donde estaba la carta ANTES de moverse — decenas o
  // cientos de px mas arriba, sobre el fondo.
  //
  // El paso 2 es el unico que lo mostraba: es el primero que pide traer la
  // carta a la vista, y del 3 en adelante cada toque de «Siguiente» vuelve a
  // medir con el scroll ya quieto.
  //
  // Se barren varios tamanos porque el bug depende de que haya scroll: si la
  // mesa es lo bastante alta, la carta entra entera, no se mueve nada y el
  // recuadro cae bien aun estando roto el codigo.
  testWidgets('el recuadro del paso 2 cae sobre el Poder del peligro', (
    t,
  ) async {
    const tamanos = <Size>[
      Size(320, 568),
      Size(360, 640),
      Size(390, 844),
      Size(414, 896),
      Size(834, 1112),
      Size(1366, 1024),
    ];

    var conScroll = 0;
    for (final tam in tamanos) {
      t.view.physicalSize = tam;
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);

      await t.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: AppState()..idiomaElegido = 'es',
            // La `key` por tamaño no es decorativa: sin ella Flutter reusa
            // el `State` entre vueltas del bucle, el tutorial arranca en el
            // paso donde quedó la vuelta anterior, y el test compara contra
            // la zona equivocada.
            child: Scaffold(
              body: TutorialScreen(key: ValueKey(tam), onTerminar: () {}),
            ),
          ),
        ),
      );
      await t.pump();

      // Un toque: del paso 1 (la Energia) al 2 (el Poder del peligro).
      await t.tap(
        find.widgetWithText(
          FilledButton,
          TextosUi.de('es')('tutorial.siguiente'),
        ),
      );

      // Sin `pumpAndSettle`: el resalte late sin parar y nunca hay reposo.
      // Estos frames cubren el pedido de scroll, sus 420 ms de animacion y la
      // remedicion, que llega un frame despues.
      for (var i = 0; i < 6; i++) {
        await t.pump(const Duration(milliseconds: 200));
      }

      final velo = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is VeloRecortado,
      );
      expect(velo, findsOneWidget, reason: 'sin velo en $tam');

      final pintor = t.widget<CustomPaint>(velo).painter as VeloRecortado;
      final hueco = pintor.hueco;
      expect(hueco, isNotNull, reason: 'el velo no recorto nada en $tam');

      // El agujero esta en coordenadas de la pila, que es justo lo que el
      // `CustomPaint` ocupa: se lo pasa a pantalla para poder compararlo.
      final enPantalla = hueco!.shift(t.getRect(velo).topLeft);
      final carta = t.getRect(find.byType(CartaView).first);
      final esperado = zonaEnPantalla(ZonaCarta.poderPeligro, carta);

      expect(
        enPantalla.left,
        closeTo(esperado.left, 1),
        reason: 'el recuadro se corrio en horizontal en $tam',
      );
      expect(
        enPantalla.top,
        closeTo(esperado.top, 1),
        reason:
            'el recuadro se corrio en vertical en $tam — '
            'carta $carta, recuadro $enPantalla',
      );
      expect(
        enPantalla.height,
        closeTo(esperado.height, 1),
        reason: 'el recuadro cambio de alto en $tam',
      );

      final pos = t
          .widget<Scrollable>(find.byType(Scrollable).first)
          .controller!;
      if (pos.offset > 0) conScroll++;
    }

    // Si ningun tamano scrolleo, el test pasa sin probar lo que cree probar.
    expect(
      conScroll,
      greaterThan(0),
      reason: 'ningun tamano necesito scroll: el test no prueba nada',
    );
  });

  // El guión nombra números, y los números salen de la carta.
  //
  // Estuvieron desincronizados: el texto estaba escrito para un peligro de
  // poder 2 y daño 2, pero salía uno de poder 1 y daño 1. El paso 3 decía
  // «en este caso, dos» sobre una carta que mostraba 1, y el paso 9 decía
  // «todavía no alcanza» cuando con la primera carta ya alcanzaba.
  test('el primer peligro del tutorial es el que el guión cuenta', () {
    final j = Juego(
      cfg: configTutorial(),
      contenido: contenidoTutorial(temaTemplo, 'es'),
      rng: Random(1),
      barajar: false,
    );

    expect(j.peligro!.dano, 2, reason: 'el paso 3 dice «en este caso, dos»');

    j.robar();
    expect(
      j.sumaMesa < j.poderPeligroEfectivo,
      isTrue,
      reason: 'el paso 9 dice «todavía no alcanza» tras la primera carta',
    );

    j.robar();
    expect(
      j.sumaMesa >= j.poderPeligroEfectivo,
      isTrue,
      reason: 'el paso 10 dice «llegaste» tras la segunda',
    );
  });
}
