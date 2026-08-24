import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/ui_texturas.dart';

/// El borde NO estirable de una pieza 9-slice se dibuja a tamaño fijo: si es
/// más grande que la caja donde se la usa, el arte se ve mal sin que nada
/// falle. Este test es lo que faltaba cuando los botones se dibujaron de
/// cualquier tamaño menos el correcto, tres veces seguidas.
void main() {
  // El tamaño más chico en el que cada pieza aparece de verdad en pantalla.
  const usos = <String, Size>{
    'boton_madera.png': Size(120, 46),
    'boton_dorado.png': Size(120, 46),
    'panel_papel.png': Size(110, 60),
    'placa_nombre.png': Size(120, 30),
    'cartel_colgante.png': Size(240, 52),
    'marco_retrato.png': Size(120, 140),
    'barra_inferior.png': Size(300, 56),
    'marco_pantalla.png': Size(320, 480),
  };

  for (final p in todasLasPiezas) {
    final nombre = p.asset.split('/').last;
    final uso = usos[nombre];
    if (uso == null) continue;

    test('$nombre entra en su uso más chico', () {
      final bordeH = (p.fuente.width - p.centro.width) / p.escala;
      final bordeV = (p.fuente.height - p.centro.height) / p.escala;
      expect(
        bordeH,
        lessThanOrEqualTo(uso.width),
        reason:
            'El borde horizontal de $nombre mide ${bordeH.toStringAsFixed(1)} '
            'y la pieza se usa a ${uso.width} de ancho. Subí `escala` o '
            'agrandá el centro.',
      );
      expect(
        bordeV,
        lessThanOrEqualTo(uso.height),
        reason:
            'El borde vertical de $nombre mide ${bordeV.toStringAsFixed(1)} '
            'y la pieza se usa a ${uso.height} de alto.',
      );
    });
  }

  test('el centro está dentro de la fuente', () {
    for (final p in todasLasPiezas) {
      expect(p.centro.right, lessThanOrEqualTo(p.fuente.width));
      expect(p.centro.bottom, lessThanOrEqualTo(p.fuente.height));
      expect(p.centro.left, greaterThanOrEqualTo(0));
      expect(p.centro.top, greaterThanOrEqualTo(0));
    }
  });
}
