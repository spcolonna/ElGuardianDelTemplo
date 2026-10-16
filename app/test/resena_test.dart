// Cuándo se pide la reseña, y el botón de compartir del resumen.
//
// La regla está en `lib/resena.dart`: solo después de ganar, desde la segunda
// victoria, nunca en la primera sesión, una vez cada 60 días y tres en total.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/resena.dart';
import 'package:guardian_templo/ui_compartir.dart';
import 'package:guardian_templo/ui_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final t = TextosUi.de('es');
  final hoy = DateTime(2026, 10, 16);

  group('la regla', () {
    bool pide({
      int sesiones = 2,
      int pedidas = 0,
      DateTime? ultima,
      int victorias = 2,
    }) => corresponderPedirResena(
      estado: EstadoResena(
        sesiones: sesiones,
        pedidas: pedidas,
        ultima: ultima,
      ),
      victorias: victorias,
      ahora: hoy,
    );

    test('con dos victorias y fuera de la primera sesión, se pide', () {
      expect(pide(), isTrue);
    });

    test('la primera victoria no alcanza', () {
      expect(pide(victorias: 1), isFalse);
      expect(pide(victorias: 0), isFalse);
    });

    test('nunca en la primera sesión', () {
      expect(pide(sesiones: 1, victorias: 5), isFalse);
      expect(pide(sesiones: 0, victorias: 5), isFalse);
    });

    test('una vez cada 60 días', () {
      expect(pide(pedidas: 1, ultima: hoy), isFalse);
      expect(
        pide(pedidas: 1, ultima: hoy.subtract(const Duration(days: 59))),
        isFalse,
      );
      expect(
        pide(pedidas: 1, ultima: hoy.subtract(const Duration(days: 60))),
        isTrue,
      );
    });

    test('tres veces en total, y nunca más', () {
      final hace = hoy.subtract(const Duration(days: 400));
      expect(pide(pedidas: 2, ultima: hace), isTrue);
      expect(pide(pedidas: 3, ultima: hace), isFalse);
      expect(pide(pedidas: 9, ultima: hace), isFalse);
    });
  });

  // Con `testWidgets` y no `test`: `AppState` arma el audio, y fuera del
  // binding de widgets el plugin de audio tira un error asíncrono.
  group('AppState', () {
    testWidgets(
      'pedirResena anota el pedido y muestra el cuadro una sola vez',
      (tester) async {
        var veces = 0;
        final app = AppState()
          ..resena = EstadoResena(sesiones: 2)
          ..mostrarCuadroDeResena = (() async => veces++);
        app.logros.sumar('victorias');
        app.logros.sumar('victorias');

        await app.pedirResena();
        expect(veces, 1);
        expect(app.resena.pedidas, 1);
        expect(app.resena.ultima, isNotNull);

        // Enseguida otra vez: faltan 60 días.
        await app.pedirResena();
        expect(veces, 1);
      },
    );

    testWidgets('si el cuadro falla, no rompe nada', (tester) async {
      final app = AppState()
        ..resena = EstadoResena(sesiones: 2)
        ..mostrarCuadroDeResena = () async => throw Exception('sin tienda');
      app.logros.sumar('victorias');
      app.logros.sumar('victorias');
      await app.pedirResena();
      expect(app.resena.pedidas, 1);
    });
  });

  group('en la pantalla', () {
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

    /// Una app con dos victorias, fuera de la primera sesión. La partida se
    /// monta ya terminada, así que `registrarResultado` no corre: las dos
    /// victorias se cargan a mano, como si la segunda fuera esta.
    AppState lista(EstadoJuego fin, List<int> veces, {int sesiones = 2}) {
      final app = AppState()
        ..idiomaElegido = 'es'
        ..introVista = true
        ..tutorialVisto = true
        ..resena = EstadoResena(sesiones: sesiones)
        ..mostrarCuadroDeResena = (() async => veces.add(1))
        ..juego = terminada(fin);
      app.logros.sumar('victorias', 2);
      return app;
    }

    Future<void> alResumen(WidgetTester tester, AppState app) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: app,
            child: Scaffold(body: GameScreen(onSalir: () {})),
          ),
        ),
      );
      await tester.pump();
      for (var i = 0; i < 3; i++) {
        final saltar = find.text(t('comic.saltar'));
        if (saltar.evaluate().isEmpty) break;
        await tester.tap(saltar.first);
        await tester.pumpAndSettle();
      }
      // Las celebraciones de logros se cierran: la reseña espera a la última.
      for (var i = 0; i < 10; i++) {
        final seguir = find.text(t('comic.seguir'));
        if (seguir.evaluate().isEmpty) break;
        await tester.tap(seguir.first);
        await tester.pumpAndSettle();
      }
    }

    testWidgets(
      'la segunda victoria pide la reseña 1,5 s después del resumen',
      (tester) async {
        telefono(tester);
        final veces = <int>[];
        final app = lista(EstadoJuego.victoria, veces);
        await alResumen(tester, app);
        expect(find.text(t('juego.ganaste')), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 1000));
        expect(veces, isEmpty, reason: 'todavía no pasó el segundo y medio');
        await tester.pump(const Duration(milliseconds: 600));
        expect(veces, hasLength(1));
        expect(app.resena.pedidas, 1);
      },
    );

    testWidgets('perder no pide la reseña', (tester) async {
      telefono(tester);
      final veces = <int>[];
      final app = lista(EstadoJuego.derrota, veces);
      await alResumen(tester, app);
      await tester.pump(const Duration(seconds: 3));
      expect(veces, isEmpty);
    });

    testWidgets('en la primera sesión no se pide aunque gane', (tester) async {
      telefono(tester);
      final veces = <int>[];
      final app = lista(EstadoJuego.victoria, veces, sesiones: 1);
      await alResumen(tester, app);
      await tester.pump(const Duration(seconds: 3));
      expect(veces, isEmpty);
    });

    for (final fin in [EstadoJuego.victoria, EstadoJuego.derrota]) {
      testWidgets('Compartir abre la vista previa (${fin.name})', (
        tester,
      ) async {
        telefono(tester);
        final app = lista(fin, [], sesiones: 1);
        await alResumen(tester, app);

        final boton = find.widgetWithText(OutlinedButton, t('compartir.boton'));
        await tester.ensureVisible(boton);
        await tester.tap(boton);
        await tester.pumpAndSettle();

        expect(find.byType(TarjetaCompartir), findsOneWidget);
        expect(find.text(t('compartir.firma')), findsOneWidget);
        expect(
          find.widgetWithText(FilledButton, t('compartir.boton')),
          findsOneWidget,
        );
      });
    }
  });

  testWidgets('el texto para compartir lleva fase y link', (tester) async {
    final app = AppState()..idiomaElegido = 'es';
    final j = Juego(
      cfg: Config(energiaInicial: 200, energiaMaxima: 200),
      contenido: contenidoPorDefecto(),
    )..estado = EstadoJuego.derrota;
    final texto = textoParaCompartir(app, j);
    expect(texto, contains(app.textos.fase(Fase.alba)));
    expect(texto, contains('apps.apple.com/app/id'));
    expect(texto, isNot(contains('{')));
  });
}
