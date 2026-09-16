/// Textos de la interfaz (botones, títulos, etiquetas), por idioma.
///
/// No usa ARB/gen_l10n a propósito: el juego YA tiene una capa de textos por
/// idioma (`TextosTema`) para el contenido. Meter un segundo sistema con
/// codegen duplicaría el mecanismo sin ganar nada, y además esta versión se
/// puede testear headless — `bin/check.dart` verifica que no falte ninguna
/// clave en ningún idioma, que no sobre ninguna, y que los `{placeholders}`
/// sean los mismos en todos.
///
/// Los mapas viven en `lib/l10n/ui_<idioma>.dart`, uno por archivo. Acá no hay
/// datos, sólo la clase.
///
/// Las pantallas **Balance** y **Simulador** quedan sólo en español a
/// propósito: son herramientas internas de playtesting, no las ve el jugador.
library;

import 'idiomas.dart';
import 'l10n/ui_de.dart';
import 'l10n/ui_en.dart';
import 'l10n/ui_es.dart';
import 'l10n/ui_it.dart';
import 'l10n/ui_ja.dart';
import 'l10n/ui_pt_br.dart';
import 'l10n/ui_zh_hans.dart';

class TextosUi {
  final Map<String, String> _m;
  const TextosUi(this._m);

  String call(String clave) => _m[clave] ?? clave;

  /// Como [call] pero rellenando los `{placeholders}`:
  /// `t.con('juego.mazo', {'n': 20})`.
  String con(String clave, Map<String, Object?> valores) =>
      fmt(call(clave), valores);

  /// Cada idioma soportado con su mapa. Es la lista de [idiomasSoportados];
  /// si alguien agrega uno allá y se olvida acá, `bin/check.dart` lo canta.
  static const _mapas = <String, Map<String, String>>{
    'es': uiEs,
    'en': uiEn,
    'pt-BR': uiPtBr,
    'it': uiIt,
    'de': uiDe,
    'ja': uiJa,
    'zh-Hans': uiZhHans,
  };

  static Iterable<String> get idiomas => _mapas.keys;

  /// El español, para los pocos lugares que necesitan un mapa en tiempo de
  /// compilación: el respaldo del motor y las herramientas de línea de
  /// comandos. La app siempre pasa el idioma que se está jugando.
  static const es = TextosUi(uiEs);

  static TextosUi de(String idioma) => TextosUi(mapaDe(idioma));

  /// Las claves que tiene que definir todo idioma.
  static Iterable<String> get claves => uiEs.keys;

  static Map<String, String> mapaDe(String idioma) => _mapas[idioma] ?? uiEs;
}

/// Reemplaza `{clave}` por su valor. `t('juego.mazo', {'n': 20})`.
String fmt(String plantilla, [Map<String, Object?> vals = const {}]) {
  var s = plantilla;
  vals.forEach((k, v) => s = s.replaceAll('{$k}', '$v'));
  return s;
}
