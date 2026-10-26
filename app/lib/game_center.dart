import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'logros.dart';

/// Game Center: los logros del juego y la tabla de la mejor racha.
///
/// Habla con `ios/Runner/GameCenter.swift` por un canal propio, sin paquete.
/// Solo existe en iOS; en Android, web y tests cada método vuelve sin hacer
/// nada. Igual que la publicidad y los avisos, **el juego nunca depende de
/// esto**: si el jugador no entra a Game Center, todo sigue igual.
class GameCenter {
  static const _canal = MethodChannel('guardian/game_center');

  /// Los ids dados de alta en App Store Connect. Una vez publicados no se
  /// pueden borrar ni renombrar: cambiar estos prefijos rompe los logros de
  /// todos los que ya los tienen.
  static String idLogro(String id) => 'logro.$id';
  static const idTablaRacha = 'racha.mejor';

  bool _autenticado = false;
  bool get autenticado => _autenticado;

  bool get _disponible =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Pide entrar a Game Center. Si el teléfono ya tiene sesión, entra solo;
  /// si no, iOS muestra su propia hoja una vez.
  Future<bool> autenticar() async {
    if (!_disponible) return false;
    try {
      _autenticado = await _canal.invokeMethod<bool>('autenticar') ?? false;
    } catch (_) {
      _autenticado = false;
    }
    return _autenticado;
  }

  /// Manda todo lo que el jugador tiene: los logros desbloqueados y su mejor
  /// racha. Reenviar un logro que ya está completo no hace nada, y la tabla se
  /// queda con el valor más alto, así que se puede llamar siempre.
  Future<void> sincronizar(LogrosEstado logros, int mejorRacha) async {
    if (!_autenticado) return;
    try {
      final ids = [
        for (final l in catalogoLogros)
          if (logros.tiene(l.id)) idLogro(l.id),
      ];
      if (ids.isNotEmpty) await _canal.invokeMethod('logros', ids);
      if (mejorRacha > 0) {
        await _canal.invokeMethod('puntaje', {
          'tabla': idTablaRacha,
          'valor': mejorRacha,
        });
      }
    } catch (_) {}
  }

  /// Abre la pantalla de Game Center en los logros.
  Future<void> mostrar() async {
    if (!_autenticado) return;
    try {
      await _canal.invokeMethod('mostrar');
    } catch (_) {}
  }
}
