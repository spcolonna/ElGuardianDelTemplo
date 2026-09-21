// El nombre traducido tiene que entrar en su placa, no salirse ni recortarse.
//
// La placa es un parche opaco del tamaño de la banda impresa: lo que se dibuja
// afuera no se ve —el `Stack` de `_placa` recorta— y lo que se dibuja encima de
// la ilustración le tapa al jugador el Poder o el efecto. Las dos cosas fallan
// calladas: el widget construye, el layout mide bien, y el único que se entera
// es el que juega en alemán y ve «FLAMINGO-STAND» comiéndose el medallón.
//
// El test mide el rectángulo PINTADO de cada línea —ya con el encogido del
// `FittedBox` aplicado, porque `getRect` pasa por la transformación— y lo
// compara contra la placa que le tocaba. Corre en los seis idiomas que
// rotulan —el español muestra la carta impresa y no lleva placa, ver
// `rotulaEn`—, que es donde la diferencia entre entrar y no entrar es
// justamente el idioma.
//
// Ojo: en `flutter test` la fuente es Ahem, cuyos glifos son cuadrados llenos,
// así que el texto mide MÁS que con la fuente de verdad. El test es entonces
// más exigente que la app, que es como se lo quiere.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/cartas_rotulo.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/mecanica.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/temas/temas.dart';
import 'package:guardian_templo/ui_carta.dart';

void main() {
  // Un id por carta ilustrada: las técnicas de recompensa comparten carta con
  // su peligro, así que alcanza con el peligro.
  final ids = <String>[
    for (final p in mecPeligros) p.id,
    for (final j in mecJefes) j.id,
    for (final c in mazoCansancio) c.id,
    for (final (id, _) in mecMazoInicial) id,
  ];

  testWidgets('cada línea del rótulo entra en su placa, en los 6 idiomas', (
    t,
  ) async {
    // El audio se inicializa con AppState y en test no hay canal de plataforma.
    FlutterError.onError = (_) {};
    t.view.physicalSize = const Size(1200, 1200);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.resetPhysicalSize);

    final desbordes = <String>[];
    var lineasVistas = 0;
    for (final idioma in codigosIdioma) {
      if (!rotulaEn(idioma)) continue;
      final textos = temaTemplo.textosDe(idioma);
      final app = AppState()..idiomaElegido = idioma;
      for (final id in ids) {
        await t.pumpWidget(
          MaterialApp(
            home: AppScope(
              state: app,
              child: Center(child: CartaView(id: id, ancho: 300)),
            ),
          ),
        );
        await t.pump();

        final carta = t.getRect(find.byType(CartaView));
        final placas = [
          for (final p in rotuloDe(archivoCarta(id), textos))
            () {
              // Girada, la placa ocupa el rectángulo espejado: es lo que hace
              // `_placa` antes de dibujarla.
              final arriba = p.rotada ? 1 - p.abajo : p.arriba;
              return Rect.fromLTRB(
                carta.left + p.izq * carta.width,
                carta.top + arriba * carta.height,
                carta.left + p.der * carta.width,
                carta.top + (arriba + (p.abajo - p.arriba)) * carta.height,
              );
            }(),
        ];
        if (placas.isEmpty) continue;

        // Sin arte cargado la carta cae en el respaldo, que no escribe nada:
        // todos los Text de acá adentro son líneas del rótulo.
        final lineas = find.byType(Text);
        lineasVistas += lineas.evaluate().length;
        for (var i = 0; i < lineas.evaluate().length; i++) {
          final r = t.getRect(lineas.at(i));
          if (r.isEmpty) continue;
          // Medio píxel de tolerancia: el redondeo del layout, no un desborde.
          final entra = placas.any(
            (p) =>
                p.inflate(0.5).contains(r.topLeft) &&
                p.inflate(0.5).contains(r.bottomRight),
          );
          if (!entra) {
            final texto = (lineas.at(i).evaluate().first.widget as Text).data;
            desbordes.add('$idioma/$id "$texto" pintado en $r, placas $placas');
          }
        }
      }
    }
    // Si el árbol dejara de tener textos —otro respaldo, otro layout— el test
    // pasaría sin mirar nada. Son 2 líneas por carta simple y de jefe y 4 por
    // peligro, en siete idiomas: bastante más que cero.
    expect(lineasVistas, greaterThan(ids.length * codigosIdioma.length));
    expect(desbordes, isEmpty, reason: desbordes.join('\n'));
  });

  // El test de arriba sólo sabe decir que el texto NO se sale. Un `_cSabor` de
  // vuelta en 0,0164 lo pasaría feliz, y el lore volvería a ser ilegible sin
  // que se entere nadie. Este mira el otro lado: que el techo siga arriba.
  //
  // Va sobre el dato y no sobre el píxel a propósito. `LineaRotulo.cuerpo` es
  // el cuerpo PEDIDO, que es justamente la decisión que se quiere proteger; el
  // cuerpo pintado depende del encogido, y encoger cuando hace falta es lo
  // correcto, no una regresión.
  test('el lore de los desafíos se pide a un cuerpo legible', () {
    const minimo = 0.0220;
    final chicos = <String>[];
    var vistos = 0;
    for (final idioma in codigosIdioma) {
      if (!rotulaEn(idioma)) continue;
      final textos = temaTemplo.textosDe(idioma);
      for (final p in mecPeligros) {
        final sabor = textos.cartas[p.recompensa]?.sabor ?? '';
        if (sabor.isEmpty) continue;
        // La técnica vive en la placa girada, y su lore es la última línea.
        final placa = rotuloDe(p.id, textos).firstWhere((x) => x.rotada);
        final linea = placa.lineas.last;
        expect(linea.texto, sabor, reason: 'cambió el orden de las líneas');
        vistos++;
        if (linea.cuerpo < minimo) {
          chicos.add('$idioma/${p.id}: ${linea.cuerpo}');
        }
      }
    }
    expect(vistos, greaterThan(100), reason: 'no se miró casi ningún lore');
    expect(chicos, isEmpty, reason: chicos.join('\n'));
  });

  // En español la carta se muestra como salió de imprenta.
  //
  // Los dos tests de arriba saltean el español, así que solos no se enterarían
  // de que volvió a rotularse: pasarían igual. Este mira la pantalla y cuenta
  // los `Text`, que es la única prueba de que arriba de la ilustración no hay
  // nada. En inglés tiene que haber texto: sin esa mitad, el test pasaría
  // también si `CartaView` dejara de dibujar en todos los idiomas.
  testWidgets('en español la carta no lleva ni una placa encima', (t) async {
    FlutterError.onError = (_) {};
    t.view.physicalSize = const Size(1200, 1200);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.resetPhysicalSize);

    Future<int> textosSobre(String id, String idioma) async {
      await t.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: AppState()..idiomaElegido = idioma,
            child: Center(child: CartaView(id: id, ancho: 300)),
          ),
        ),
      );
      await t.pump();
      return find.byType(Text).evaluate().length;
    }

    for (final id in ids) {
      expect(
        await textosSobre(id, 'es'),
        0,
        reason: '$id: en español se dibujó texto encima del arte impreso',
      );
      expect(
        await textosSobre(id, 'en'),
        greaterThan(0),
        reason: '$id: en inglés la carta se quedó sin su rótulo',
      );
    }
  });
}
