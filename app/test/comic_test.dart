// El cómic tiene que armarse sin desbordes en teléfono angosto.
//
// La secuencia de intro incluye la nota de Shifu, que son cuatro renglones
// largos: es el caso que rompía el bocadillo viejo y el que tiene que aguantar
// el diseño de conversación.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/temas/temas.dart';
import 'package:guardian_templo/ui_intro.dart';

void main() {
  var serie = 0;
  Future<void> montar(WidgetTester tester, Size tam, Secuencia s) async {
    // Clave nueva en cada montaje: sin esto Flutter reusa el State anterior y
    // el reproductor se queda en la viñeta donde lo dejó el montaje previo.
    final clave = ValueKey('comic${serie++}');
    tester.view.physicalSize = tam;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: ComicView(
          key: clave,
          tema: temaTemplo,
          textos: temaTemplo.textosDe('es'),
          ui: TextosUi.de('es'),
          secuencia: s,
          onTerminar: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('la conversación entra en un teléfono angosto', (tester) async {
    await montar(tester, const Size(360, 780), Secuencia.intro);
    expect(tester.takeException(), isNull);

    // Recorre la secuencia entera: cada viñeta arma su propia conversación.
    for (var i = 0; i < 7; i++) {
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'viñeta ${i + 2}');
    }

    // La nota de Shifu, el texto más largo del juego, tiene que estar entera.
    await montar(tester, const Size(360, 780), Secuencia.intro);
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('no quemés el templo'), findsOneWidget);
    expect(find.text('LA NOTA'), findsOneWidget);
  });

  testWidgets('la conversación entera aparece, turno por turno', (
    tester,
  ) async {
    // Una viñeta con cuatro turnos y dos hablantes: es el caso que el diseño
    // viejo, de un diálogo por imagen, no podía representar.
    final textos = temaTemplo.textosDe('es');
    final panel = textos.paneles['11_mei_juzga.png']!;
    expect(panel.conversacion.length, greaterThanOrEqualTo(4));

    await montar(tester, const Size(360, 780), Secuencia.mediodia);
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    for (final d in panel.conversacion) {
      expect(
        find.text(d.texto),
        findsOneWidget,
        reason: 'falta el turno de ${d.quien.isEmpty ? 'nadie' : d.quien}',
      );
    }
    // El nombre del hablante se escribe una sola vez por tanda seguida, como
    // en un chat, así que Mei aparece las veces que toma la palabra.
    final turnosDeMei = panel.conversacion.where((d) => d.quien == 'Mei');
    expect(find.text('MEI'), findsNWidgets(turnosDeMei.length));
    expect(tester.takeException(), isNull);
  });

  testWidgets('el botón Saltar va contra el borde derecho', (tester) async {
    // En pantallas anchas sobra espacio en la fila del encabezado. Con el
    // título en Flexible el botón quedaba pegado al título, flotando en el
    // medio; hace falta que el título se ESTIRE para empujarlo al borde.
    for (final ancho in [360.0, 414.0, 800.0, 1280.0]) {
      await montar(tester, Size(ancho, 800), Secuencia.intro);
      final boton = find.widgetWithText(TextButton, TextosUi.de('es')('comic.saltar'));
      expect(boton, findsOneWidget, reason: 'a $ancho px');
      expect(
        ancho - tester.getRect(boton).right,
        closeTo(12, 0.5),
        reason: 'a $ancho px el botón no está contra el borde',
      );
    }
  });

  testWidgets('todas las secuencias se arman', (tester) async {
    for (final s in Secuencia.values) {
      await montar(tester, const Size(414, 896), s);
      expect(tester.takeException(), isNull, reason: s.name);
    }
  });
}
