import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Efectos del juego. El nombre coincide con el archivo en `assets/audio/`:
/// para cambiar un sonido alcanza con reemplazar el `.wav`, sin tocar código.
enum Sfx { robar, ganar, perder, meditar, dia, logro, toque }

/// Las pistas de fondo. Cada fase tiene la suya: una sola música durante toda
/// la partida se vuelve insoportable, y además el cambio de pista avisa que
/// cambiaste de fase sin necesidad de un cartel.
enum Pista { home, alba, mediodia, ocaso, jefes }

/// Música y efectos.
///
/// Los sonidos que hay ahora son sintéticos, de relleno, para poder juzgar el
/// ritmo sonoro. Están para reemplazarse.
///
/// En web el audio recién puede sonar **después de la primera interacción del
/// usuario**, así que la música arranca al tocar JUGAR y no en el splash.
class Audio {
  static const _claveMusica = 'guardian_audio_musica_v1';
  static const _claveEfectos = 'guardian_audio_efectos_v1';

  final _musica = AudioPlayer();
  final _efectos = AudioPlayer();

  /// Volumen de crucero de la música. Fondo quiere decir fondo.
  static const _volumenMusica = 0.13;

  /// Cuánto tarda el cambio de pista. Es largo a propósito: el cambio de
  /// pista acompaña la transición de paisaje, que dura 1.6 s.
  static const _fundido = Duration(milliseconds: 900);

  bool musicaActiva = true;
  bool efectosActivos = true;
  Pista? _pista;

  Timer? _fade;

  /// Cada fundido se queda con su número. Si arranca otro mientras éste corre,
  /// el viejo se encuentra con un número que ya no es el suyo y se calla: sin
  /// esto dos cambios encimados se pelean por el volumen y queda a mitad.
  int _generacion = 0;

  SharedPreferences? _prefs;

  Future<void> iniciar(SharedPreferences? prefs) async {
    _prefs = prefs;
    musicaActiva = prefs?.getBool(_claveMusica) ?? true;
    efectosActivos = prefs?.getBool(_claveEfectos) ?? true;
    await _musica.setReleaseMode(ReleaseMode.loop);
    // Bajo a propósito: la música de un solitario se escucha durante veinte
    // minutos seguidos y tiene que poder ignorarse.
    await _musica.setVolume(_volumenMusica);
    await _efectos.setReleaseMode(ReleaseMode.stop);
  }

  /// Arranca la música si corresponde. Llamar desde una interacción del
  /// usuario, no al abrir la app: en web el audio no suena hasta que el
  /// jugador tocó algo.
  Future<void> arrancarMusica() => ponerPista(Pista.home);

  /// Vuelve a la pista del menú, pero SÓLO si ya había música sonando.
  ///
  /// La distinción importa: el patio se dibuja apenas arranca la app, y en web
  /// el audio no puede empezar antes de que el jugador toque algo. Arrancarla
  /// acá haría que el primer intento falle en silencio.
  Future<void> pistaDeMenu() async {
    if (_pista == null || _pista == Pista.home) return;
    await ponerPista(Pista.home);
  }

  /// Cambia la pista de fondo, con fundido. No hace nada si ya suena esa.
  Future<void> ponerPista(Pista p) async {
    if (!musicaActiva || _pista == p) return;
    final habia = _pista != null;
    _pista = p;
    final mia = ++_generacion;
    try {
      // Sin nada sonando no hay qué bajar: entra directo subiendo.
      if (habia) await _rampa(mia, desde: _volumenMusica, hasta: 0);
      if (mia != _generacion) return;
      await _musica.play(AssetSource('audio/musica_${p.name}.wav'), volume: 0);
      await _rampa(mia, desde: 0, hasta: _volumenMusica);
    } catch (_) {
      // Sin audio disponible el juego sigue igual: nunca romper por un sonido.
      _pista = null;
      await _musica.setVolume(_volumenMusica);
    }
  }

  /// Lleva el volumen de un extremo al otro en pasos de un frame.
  ///
  /// `audioplayers` no trae fundido propio, así que se hace a mano. Se corta
  /// solo si otro cambio de pista lo dejó viejo.
  Future<void> _rampa(int mia, {required double desde, required double hasta}) {
    _fade?.cancel();
    const pasos = 18;
    final listo = Completer<void>();
    var i = 0;
    _fade = Timer.periodic(_fundido ~/ pasos, (t) async {
      if (mia != _generacion) {
        t.cancel();
        if (!listo.isCompleted) listo.complete();
        return;
      }
      i++;
      final v = desde + (hasta - desde) * (i / pasos);
      await _musica.setVolume(v.clamp(0, 1));
      if (i >= pasos) {
        t.cancel();
        if (!listo.isCompleted) listo.complete();
      }
    });
    return listo.future;
  }

  Future<void> pararMusica() async {
    _fade?.cancel();
    _generacion++;
    await _musica.stop();
    await _musica.setVolume(_volumenMusica);
    _pista = null;
  }

  Future<void> sonar(Sfx s) async {
    if (!efectosActivos) return;
    try {
      await _efectos.play(AssetSource('audio/${s.name}.wav'), volume: 0.7);
    } catch (_) {
      // Ídem.
    }
  }

  Future<void> cambiarMusica(bool v) async {
    musicaActiva = v;
    await _prefs?.setBool(_claveMusica, v);
    if (v) {
      // Vuelve a la pista de la fase en la que estaba, no siempre a Alba.
      final volver = _pista ?? Pista.home;
      _pista = null;
      await ponerPista(volver);
    } else {
      await pararMusica();
    }
  }

  Future<void> cambiarEfectos(bool v) async {
    efectosActivos = v;
    await _prefs?.setBool(_claveEfectos, v);
  }

  void liberar() {
    _fade?.cancel();
    _musica.dispose();
    _efectos.dispose();
  }
}
