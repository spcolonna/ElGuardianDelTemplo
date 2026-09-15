// La app tiene que aguantar CUALQUIER ancho, no sólo los de un teléfono.
//
// Por qué existe este archivo: `TARGETED_DEVICE_FAMILY` declara iPhone y iPad,
// y desde iPadOS 26 ya no se puede pedir la pantalla entera —`UIRequiresFullScreen`
// está deprecada y el sistema la ignora, ver TN3192—. O sea que el iPad le da a
// la app la ventana que se le antoja: un tercio de pantalla en Slide Over, la
// mitad, o 1366 px de punta a punta. Un desborde ahí es un rechazo de review, y
// no se ve nunca corriendo el juego en un simulador de teléfono.
//
// Los anchos no son inventados: 320 es Slide Over, 507 es un tercio de un iPad
// de 11", 639 la mitad, 834 el vertical entero, y 1366 el apaisado del de 12,9".
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/ui_game.dart';
import 'package:guardian_templo/ui_ajustes.dart';
import 'package:guardian_templo/ui_home.dart';
import 'package:guardian_templo/ui_modos.dart';
import 'package:guardian_templo/ui_progreso.dart';
import 'package:guardian_templo/ui_shell.dart';

const _anchos = <double>[320, 507, 639, 834, 1024, 1366];

/// Cuántos textos recorta cada pantalla EN ESPAÑOL, que es la vara.
///
/// Se llena en la primera vuelta del bucle porque `codigosIdioma` arranca en
/// español; si algún día deja de arrancar ahí, este test empieza a comparar
/// contra cero y se va a quejar enseguida, que es lo que uno quiere.
final _enEspanol = <String, int>{};

/// Si ese párrafo, al ancho que le tocó, no entra en las líneas que tiene.
///
/// Se mide de nuevo con un painter propio en vez de leerle
/// `didExceedMaxLines` al render: ese flag lo pisan los pases de medición
/// intrínseca —`Wrap` e `IntrinsicWidth` relayoutean el texto a ancho cero— y
/// queda en true para cosas que en pantalla entran de sobra, como la palabra
/// «Ajustes». Falsos positivos en un test de desborde son peores que no
/// tenerlo: se aprende a ignorarlo.
bool _seComeTexto(RenderParagraph r) {
  if (!r.hasSize || r.size.width <= 0) return false;
  // El ancho es el que le DIERON, no el que terminó midiendo. Cuando el texto
  // entra, el render encoge la caja hasta la línea, y volver a medir a ese
  // ancho exacto empuja la última palabra al renglón siguiente por medio
  // píxel: todo texto que entra justo se reportaría como recortado.
  final c = r.constraints;
  final ancho = c.maxWidth.isFinite && c.maxWidth > 0
      ? c.maxWidth
      : r.size.width;
  final painter = TextPainter(
    text: r.text,
    textDirection: r.textDirection,
    textAlign: r.textAlign,
    maxLines: r.maxLines,
    textScaler: r.textScaler,
    locale: r.locale,
    strutStyle: r.strutStyle,
    textWidthBasis: r.textWidthBasis,
    ellipsis: r.overflow == TextOverflow.ellipsis ? '\u2026' : null,
  )..layout(maxWidth: ancho);
  final cortado = painter.didExceedMaxLines;
  painter.dispose();
  return cortado;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> probar(
    WidgetTester tester,
    String nombre,
    Widget Function() construir,
  ) async {
    for (final idioma in codigosIdioma) {
      for (final ancho in _anchos) {
        // El alto se cruza a propósito: en Slide Over la ventana es angosta y
        // alta, y en apaisado es ancha y baja. Probar sólo el caso cómodo
        // esconde justo los desbordes verticales.
        final alto = ancho < 700 ? 1180.0 : 768.0;
        tester.view.physicalSize = Size(ancho, alto);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final app = AppState()..idiomaElegido = idioma;
        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(state: app, child: construir()),
          ),
        );
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: '$nombre · $idioma · ${ancho.toInt()}x${alto.toInt()}',
        );

        // Y además: que la traducción no recorte MÁS que el original.
        //
        // `takeException` agarra los desbordes de CAJA — el RenderFlex que se
        // pasa— pero un `Text` con `maxLines` y `ellipsis` no tira nada: se
        // come la palabra y sigue de largo. Ese es exactamente el modo de
        // falla de una traducción más larga que el original, y el que importa
        // cuando el juego habla siete idiomas.
        //
        // La cuenta se compara contra el español y no contra cero porque hoy
        // ya hay títulos que elipsan a 320 px, que es Slide Over y es angosto
        // de verdad. Cero sería el listón correcto y es otra tarea; lo que
        // este test tiene que impedir es que el alemán, que es un 30% más
        // largo, empeore una pantalla que en español entraba.
        final recortados = tester.allRenderObjects
            .whereType<RenderParagraph>()
            .where(_seComeTexto)
            .map((r) => r.text.toPlainText())
            .toSet();
        final caso = '$nombre · ${ancho.toInt()}';
        if (idioma == 'es') {
          _enEspanol[caso] = recortados.length;
        } else {
          expect(
            recortados.length,
            lessThanOrEqualTo(_enEspanol[caso] ?? 0),
            reason:
                '$nombre · $idioma · ${ancho.toInt()}x${alto.toInt()}: '
                'recorta más que el español. Recortado: $recortados',
          );
        }
      }
    }
  }

  testWidgets('el patio entra en cualquier ventana de iPad', (tester) async {
    await probar(tester, 'patio', () => const PatioScreen());
  });

  testWidgets('el selector de modos entra en cualquier ventana', (
    tester,
  ) async {
    await probar(tester, 'modos', () => const ModosScreen());
  });

  testWidgets('ajustes entra en cualquier ventana', (tester) async {
    await probar(tester, 'ajustes', () => const AjustesScreen());
  });

  testWidgets('progreso entra en cualquier ventana', (tester) async {
    // Envuelta en el mismo shell que le pone `rutas.dart`: `ProgresoScreen`
    // devuelve su cuerpo scrolleable pelado y necesita una altura acotada.
    await probar(
      tester,
      'progreso',
      () => const PantallaTemplo(
        titulo: 'Progreso',
        conVolver: true,
        cuerpo: ProgresoScreen(),
      ),
    );
  });

  // La mesa es la pantalla que más cosas apila —peligro, mano, mesa, energía,
  // botones— y la que más se mira. Va aparte porque necesita una partida en
  // curso, no alcanza con construir el widget.
  testWidgets('la mesa entra en cualquier ventana de iPad', (tester) async {
    for (final ancho in _anchos) {
      final alto = ancho < 700 ? 1180.0 : 768.0;
      tester.view.physicalSize = Size(ancho, alto);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

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
      // El cómic del interludio puede estar o no según en qué momento quedó
      // la partida; si está, se saltea para llegar a la mesa.
      final saltar = find.text(TextosUi.de('es')('comic.saltar'));
      if (saltar.evaluate().isNotEmpty) {
        await tester.tap(saltar);
        await tester.pumpAndSettle();
      }

      expect(
        tester.takeException(),
        isNull,
        reason: 'mesa · ${ancho.toInt()}x${alto.toInt()}',
      );
    }
  });
}
