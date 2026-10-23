import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
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
/// usuario**, así que ahí la música arranca al tocar JUGAR. En el teléfono no
/// hay esa traba y arranca apenas aparece el patio.
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

  /// La última pista que se pidió, suene o no. Con la música apagada `_pista`
  /// queda en null, y sin esto al prenderla de nuevo siempre volvía la del
  /// patio en vez de la de la fase en curso.
  Pista? _deseada;

  Timer? _fade;

  /// Cada fundido se queda con su número. Si arranca otro mientras éste corre,
  /// el viejo se encuentra con un número que ya no es el suyo y se calla: sin
  /// esto dos cambios encimados se pelean por el volumen y queda a mitad.
  int _generacion = 0;

  SharedPreferences? _prefs;

  /// La app se fue a segundo plano con la música sonando: al volver, sigue.
  bool _pausadaPorSalir = false;

  /// Si el patio ya intentó arrancar la música. Se llama desde un `build`, y
  /// sin esto un teléfono sin audio lo reintentaría en cada repintado.
  bool _patioIntento = false;

  Future<void> iniciar(SharedPreferences? prefs) async {
    _prefs = prefs;
    musicaActiva = prefs?.getBool(_claveMusica) ?? true;
    efectosActivos = prefs?.getBool(_claveEfectos) ?? true;
    await _musica.setReleaseMode(ReleaseMode.loop);
    // Bajo a propósito: la música de un solitario se escucha durante veinte
    // minutos seguidos y tiene que poder ignorarse.
    await _musica.setVolume(_volumenMusica);
    await _efectos.setReleaseMode(ReleaseMode.stop);
    // En Android cada reproductor pide el foco de audio al sonar, y el que lo
    // pierde se pausa: el primer efecto le sacaba el foco a la música y la
    // cortaba hasta el próximo cambio de pista. Los efectos no lo piden.
    try {
      await _efectos.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            usageType: AndroidUsageType.game,
            contentType: AndroidContentType.sonification,
            audioFocus: AndroidAudioFocus.none,
          ),
        ),
      );
    } catch (_) {}
  }

  /// La app pasó a segundo plano: la música se calla. Android, a diferencia
  /// de iOS, la dejaba sonando con el juego minimizado.
  Future<void> alSalir() async {
    if (_pista == null || _pausadaPorSalir) return;
    _pausadaPorSalir = true;
    try {
      await _musica.pause();
    } catch (_) {}
  }

  /// La app volvió: la música sigue donde quedó, si seguía prendida.
  Future<void> alVolver() async {
    if (!_pausadaPorSalir) return;
    _pausadaPorSalir = false;
    if (!musicaActiva || _pista == null) return;
    try {
      await _musica.resume();
    } catch (_) {}
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
    // En el teléfono el patio puede arrancarla: sin esto la primera pista que
    // se oía era la del patio recién al tocar JUGAR, un segundo antes de que
    // la partida la cambiara por la de Alba.
    if (!kIsWeb && !_patioIntento && _pista == null) {
      _patioIntento = true;
      await ponerPista(Pista.home);
      return;
    }
    // Apagada, igual se anota: al prenderla en el patio tiene que sonar la
    // del patio, no la de la partida que se dejó.
    if (!musicaActiva && _deseada != null) _deseada = Pista.home;
    if (_pista == null || _pista == Pista.home) return;
    await ponerPista(Pista.home);
  }

  /// Cambia la pista de fondo, con fundido. No hace nada si ya suena esa.
  Future<void> ponerPista(Pista p) async {
    _deseada = p;
    if (!musicaActiva || _pista == p) return;
    _pausadaPorSalir = false;
    final habia = _pista != null;
    _pista = p;
    final mia = ++_generacion;
    try {
      // Sin nada sonando no hay qué bajar: entra directo subiendo.
      if (habia) await _rampa(mia, desde: _volumenMusica, hasta: 0);
      if (mia != _generacion) return;
      await _musica.play(AssetSource('audio/musica_${p.name}.wav'), volume: 0);
      // Si mientras cargaba la apagaron, que no quede sonando.
      if (mia != _generacion) {
        if (!musicaActiva) await _musica.stop();
        return;
      }
      await _rampa(mia, desde: 0, hasta: _volumenMusica);
    } catch (_) {
      // Sin audio disponible el juego sigue igual: nunca romper por un sonido.
      _pista = null;
      try {
        await _musica.setVolume(_volumenMusica);
      } catch (_) {}
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
    _pista = null;
    try {
      await _musica.stop();
      await _musica.setVolume(_volumenMusica);
    } catch (_) {
      // Ídem.
    }
  }

  Future<void> sonar(Sfx s) async {
    if (!efectosActivos) return;
    try {
      await _efectos.play(AssetSource('audio/${s.name}.wav'), volume: 0.7);
    } catch (_) {
      // Ídem.
    }
  }

  /// Prende o apaga la música.
  ///
  /// El booleano cambia en el acto; cargar la pista y el fundido vienen
  /// después. Quien dibuja la palanca **no espera** este Future: antes lo
  /// esperaba y el interruptor tardaba un segundo en moverse.
  Future<void> cambiarMusica(bool v) async {
    musicaActiva = v;
    unawaited(_prefs?.setBool(_claveMusica, v));
    if (v) {
      // Vuelve a la pista de la fase en la que estaba, no siempre a Alba.
      final volver = _deseada ?? Pista.home;
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
