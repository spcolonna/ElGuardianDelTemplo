import 'package:shared_preferences/shared_preferences.dart';

import 'logros.dart';
import 'models.dart';
import 'modos/dificultad.dart';
import 'progreso.dart';

/// Todo lo que persiste entre sesiones, en un solo lugar.
///
/// No hace falta login ni servidor: el estado completo del juego son dos
/// objetos chicos. `shared_preferences` ya es un archivo de configuración
/// (NSUserDefaults en iOS, un XML en Android, localStorage en web).
///
/// Contrapartida asumida: desinstalar la app borra el progreso, y la racha
/// diaria usa el reloj del dispositivo.
class Preferencias {
  static const _kProgreso = 'guardian_progreso_v1';
  static const _kConfig = 'guardian_config_v1';
  static const _kIdioma = 'guardian_idioma_v1';
  static const _kTema = 'guardian_tema_v1';
  static const _kTutorial = 'guardian_tutorial_visto_v1';
  static const _kIntro = 'guardian_intro_vista_v1';
  static const _kLogros = 'guardian_logros_v1';
  static const _kOpciones = 'guardian_opciones_v1';

  SharedPreferences? _p;

  /// Para los módulos que guardan lo suyo (config, audio).
  SharedPreferences? get crudo => _p;

  Future<void> iniciar() async => _p = await SharedPreferences.getInstance();

  // ------------------------------------------------------------- progreso
  Progreso cargarProgreso() {
    final t = _p?.getString(_kProgreso);
    return t == null ? Progreso() : Progreso.fromJson(t);
  }

  Future<void> guardarProgreso(Progreso p) async =>
      _p?.setString(_kProgreso, p.toJson());

  // --------------------------------------------------------------- logros
  LogrosEstado cargarLogros() {
    final t = _p?.getString(_kLogros);
    return t == null ? LogrosEstado() : LogrosEstado.fromJson(t);
  }

  Future<void> guardarLogros(LogrosEstado l) async =>
      _p?.setString(_kLogros, l.toJson());

  // ------------------------------------------------------------- opciones
  /// Lo que el jugador elige en la pantalla de modos. Va aparte del override
  /// de `ConfigStore`, que es del admin: son dos cosas distintas.
  OpcionesPartida cargarOpciones() {
    final t = _p?.getString(_kOpciones);
    return t == null ? OpcionesPartida() : OpcionesPartida.fromJson(t);
  }

  Future<void> guardarOpciones(OpcionesPartida o) async =>
      _p?.setString(_kOpciones, o.toJson());

  // --------------------------------------------------------------- config
  Config cargarConfig() {
    final t = _p?.getString(_kConfig);
    if (t == null) return Config();
    try {
      return Config.fromJson(Map<String, dynamic>.from(_decode(t)));
    } catch (_) {
      return Config();
    }
  }

  Future<void> guardarConfig(Config c) async =>
      _p?.setString(_kConfig, _encode(c.toJson()));

  // --------------------------------------------------------------- idioma
  /// `null` = seguir el idioma del sistema.
  String? cargarIdioma() => _p?.getString(_kIdioma);

  Future<void> guardarIdioma(String? id) async => id == null
      ? await _p?.remove(_kIdioma)
      : await _p?.setString(_kIdioma, id);

  // ----------------------------------------------------------------- tema
  String cargarTema() => _p?.getString(_kTema) ?? 'templo';

  Future<void> guardarTema(String id) async => _p?.setString(_kTema, id);

  // ------------------------------------------------------------- banderas
  bool get tutorialVisto => _p?.getBool(_kTutorial) ?? false;
  Future<void> marcarTutorialVisto(bool v) async => _p?.setBool(_kTutorial, v);

  bool get introVista => _p?.getBool(_kIntro) ?? false;
  Future<void> marcarIntroVista(bool v) async => _p?.setBool(_kIntro, v);

  // ------------------------------------------------------------- internos
  String _encode(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key}=${e.value}').join(';');

  Map<String, dynamic> _decode(String s) {
    final m = <String, dynamic>{};
    for (final par in s.split(';')) {
      final i = par.indexOf('=');
      if (i < 0) continue;
      final k = par.substring(0, i);
      final v = par.substring(i + 1);
      m[k] = v == 'true' ? true : (v == 'false' ? false : int.tryParse(v) ?? v);
    }
    return m;
  }
}
