import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// De dónde sale la configuración del juego, en orden de prioridad.
///
/// El admin vive sólo en web, pero el juego corre en iOS. Como en web no hay
/// archivo escribible, la configuración viaja en tres capas:
///
/// 1. **`assets/config.json`** — el archivo versionado que la app carga al
///    arrancar. Viaja con el build al teléfono. Es la fuente de verdad.
/// 2. **Override local** — mientras tocás sliders en el admin, los cambios se
///    guardan en `shared_preferences` y pisan al asset, para no recompilar
///    en cada ajuste.
/// 3. **Valores por defecto** — si el asset falta o está roto, `Config()`.
///
/// El puente entre 2 y 1 es el botón de exportar del admin: copiás el JSON y
/// lo pegás en `assets/config.json`.
class ConfigStore {
  // La versión sube cada vez que se mueve `Config()`. v3 fue el paso a seis
  // caminos; v4 bajó el juego base a 23 de Energía. Un override guardado desde
  // /admin con los números viejos se prefiere al asset (`cargar()` más abajo),
  // así que sin subir la clave una máquina de desarrollo se habría quedado
  // midiendo el juego anterior sin que nada avisara.
  static const _clave = 'guardian_config_override_v4';
  static const rutaAsset = 'assets/config.json';

  /// Carga la configuración efectiva. Se llama una vez, antes de jugar.
  static Future<Config> cargar(SharedPreferences? prefs) async {
    final override = prefs?.getString(_clave);
    if (override != null) {
      final c = _desdeJson(override);
      if (c != null) return c;
    }
    return await cargarDelAsset() ?? Config();
  }

  /// Sólo el archivo versionado, sin el override. Lo usa el admin para poder
  /// mostrar de qué valores partió.
  static Future<Config?> cargarDelAsset() async {
    try {
      return _desdeJson(await rootBundle.loadString(rutaAsset));
    } catch (_) {
      return null;
    }
  }

  static Future<void> guardarOverride(
    SharedPreferences? prefs,
    Config c,
  ) async => prefs?.setString(_clave, exportar(c));

  static Future<void> borrarOverride(SharedPreferences? prefs) async =>
      prefs?.remove(_clave);

  static bool hayOverride(SharedPreferences? prefs) =>
      prefs?.getString(_clave) != null;

  /// JSON con sangría, listo para pegar en `assets/config.json`.
  static String exportar(Config c) =>
      const JsonEncoder.withIndent('  ').convert(c.toJson());

  static Config? _desdeJson(String texto) {
    try {
      return Config.fromJson(
        Map<String, dynamic>.from(jsonDecode(texto) as Map),
      );
    } catch (_) {
      return null;
    }
  }
}
