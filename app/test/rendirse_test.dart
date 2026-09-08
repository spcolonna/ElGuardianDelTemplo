// Rendirse pide confirmación.
//
// El botón de rendirse comparte fila con el de robar, y el pulgar que viene
// apretando «Robar» cae justo ahí. Un toque de más perdía el combate y la
// Energía sin que el jugador lo hubiera decidido, y eso no tiene deshacer.
// Reportado por el dueño del juego jugando de verdad: «a veces lo apreto sin
// querer y pierdo las vidas».
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/ui_intro.dart';
import 'package:guardian_templo/ui_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ui = TextosUi.de('es');

  /// Deja la partida en combate contra el primer peligro, PERDIENDO: así el
  /// botón dice «Rendirse» y no «Resolver».
  Juego enCombatePerdiendo() {
    final j = Juego(
      cfg: Config(energiaInicial: 200, energiaMaxima: 200),
      contenido: contenidoPorDefecto(),
    );
    var pasos = 0;
    while (pasos++ < 200) {
      if (j.estado == EstadoJuego.esperandoPeligro) j.revelarPeligro();
      if (j.estado == EstadoJuego.enCombate &&
          j.sumaMesa < j.poderPeligroEfectivo) {
        return j;
      }
      // Este peligro se gana solo: se resuelve y se busca el siguiente.
      j.resolver();
      j.continuar();
    }
    fail('no se llegó a un combate que se esté perdiendo');
  }

  /// Deja la partida en combate contra el primer jefe, sin cartas en la mesa
  /// —o sea, perdiendo—.
  ///
  /// Se saltea el camino a mano: lo que se prueba es el enfrentamiento final, y
  /// jugar los veinte peligros para llegar sólo agrega maneras de que el test
  /// falle por otra cosa.
  Juego enCombateContraJefe() {
    final j = Juego(
      cfg: Config(energiaInicial: 200, energiaMaxima: 200),
      contenido: contenidoPorDefecto(),
    );
    j.fase = Fase.jefes;
    j.estado = EstadoJuego.esperandoPeligro;
    j.revelarPeligro();
    expect(j.sumaMesa, lessThan(j.poderPeligroEfectivo));
    return j;
  }

  Future<void> aLaMesa(WidgetTester tester, AppState app) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(
          state: app,
          child: Scaffold(body: GameScreen(onSalir: () {})),
        ),
      ),
    );
    await tester.pump();
    // El cómic no siempre está: depende de la fase en la que arranque la
    // partida del test. Lo que importa es llegar a la mesa, no cómo.
    final saltar = find.text(ui('comic.saltar'));
    if (saltar.evaluate().isNotEmpty) {
      await tester.tap(saltar);
    }
    await tester.pumpAndSettle();
    expect(find.byType(ComicView), findsNothing);
  }

  AppState conJuego(Juego j) => AppState()
    ..idiomaElegido = 'es'
    ..introVista = true
    ..tutorialVisto = true
    ..juego = j;

  testWidgets('cancelar deja la partida intacta', (tester) async {
    tester.view.physicalSize = const Size(414, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = conJuego(enCombatePerdiendo());
    final j = app.juego!;
    final energiaAntes = j.energia;
    final enMesa = j.mesa.length;

    await aLaMesa(tester, app);

    await tester.tap(find.text(ui('juego.rendirse')));
    await tester.pumpAndSettle();
    expect(find.text(ui('juego.rendirseConfirmar')), findsOneWidget);

    await tester.tap(find.text(ui('juego.rendirseSeguir')));
    await tester.pumpAndSettle();

    // Lo que importa: el combate sigue exactamente donde estaba.
    expect(j.estado, EstadoJuego.enCombate);
    expect(j.energia, energiaAntes);
    expect(j.mesa.length, enMesa);
  });

  testWidgets('confirmar sí resuelve, y cuesta lo que el cartel dijo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(414, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = conJuego(enCombatePerdiendo());
    final j = app.juego!;
    final energiaAntes = j.energia;
    final dano = j.peligro!.dano;
    final perdidosAntes = j.combatesPerdidos;

    await aLaMesa(tester, app);

    await tester.tap(find.text(ui('juego.rendirse')));
    await tester.pumpAndSettle();
    // El número del cartel es el que se va a pagar: si el detalle miente, el
    // cartel es peor que no tenerlo.
    expect(find.textContaining('$dano'), findsWidgets);

    // El «sí» del diálogo reusa la misma clave que el botón de la mesa, así
    // que hay dos con el mismo texto: se busca dentro del diálogo y no por
    // posición, que depende del orden del árbol y no significa nada.
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(ui('juego.rendirse')),
      ),
    );
    await tester.pumpAndSettle();

    // Se mira el combate perdido y la Energía pagada, y no el estado: al
    // resolver, la mesa avanza sola y para cuando el árbol se asienta ya está
    // en el peligro siguiente. El estado diría «enCombate» otra vez y no
    // significaría nada.
    expect(j.combatesPerdidos, perdidosAntes + 1);
    expect(j.energia, energiaAntes - dano);
  });

  // Contra el jefe no se puede rendir. Reportado jugando en el celular: «pongo
  // rendirme y me saca las vidas y no me la da como ganada». No era un bug del
  // resultado —perder contra un jefe siempre te devolvió al mismo jefe— sino
  // que la pantalla ofrecía, con el mismo botón grande de siempre, la única
  // jugada del juego que no tiene ninguna ventaja.

  test('el motor no deja rendirse contra el jefe', () {
    final j = enCombateContraJefe();
    final energia = j.energia;
    final jefe = j.jefeActual;
    final perdidos = j.combatesPerdidos;

    expect(j.puedeRobar, isTrue);
    expect(j.puedeRendirse, isFalse);

    j.resolver();

    // Nada se movió: ni la Energía, ni el jefe, ni el combate.
    expect(j.estado, EstadoJuego.enCombate);
    expect(j.energia, energia);
    expect(j.jefeActual, jefe);
    expect(j.combatesPerdidos, perdidos);
  });

  testWidgets('contra el jefe el botón no ofrece rendirse', (tester) async {
    tester.view.physicalSize = const Size(414, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = conJuego(enCombateContraJefe());
    final j = app.juego!;
    final energiaAntes = j.energia;

    await aLaMesa(tester, app);

    expect(find.text(ui('juego.rendirse')), findsNothing);
    expect(find.text(ui('juego.jefeNoSeRinde')), findsOneWidget);

    // Y está apagado: tocarlo no cuesta Energía ni cierra el combate.
    await tester.tap(find.text(ui('juego.jefeNoSeRinde')));
    await tester.pumpAndSettle();
    expect(j.estado, EstadoJuego.enCombate);
    expect(j.energia, energiaAntes);
  });

  testWidgets('sin con qué robar, el jefe te vence y el combate cierra', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(414, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = conJuego(enCombateContraJefe());
    final j = app.juego!;
    // Sin robos gratis y sin Energía para pagar uno: no queda ninguna jugada.
    j.gratisRestantes = 0;
    j.energia = 0;
    expect(j.puedeRobar, isFalse);
    expect(j.puedeRendirse, isTrue);

    await aLaMesa(tester, app);

    // El botón existe, está encendido, y no dice «Rendirse»: no te rendiste.
    expect(find.text(ui('juego.rendirse')), findsNothing);
    expect(find.text(ui('juego.jefeTeVence')), findsOneWidget);

    await tester.tap(find.text(ui('juego.jefeTeVence')));
    await tester.pumpAndSettle();

    // Y no pregunta nada: no hay decisión que confirmar.
    expect(j.combatesPerdidos, 1);
    expect(j.estado, EstadoJuego.derrota);
  });
}
