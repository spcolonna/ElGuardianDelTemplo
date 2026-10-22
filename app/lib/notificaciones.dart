import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'l10n.dart';
import 'recordatorios.dart';

/// Las notificaciones locales que invitan a volver. Todo sale del teléfono:
/// no hay servidor, ni token, ni nada que viaje.
///
/// Igual que la publicidad, **el juego nunca depende de esto**: sin plugin
/// (tests, web), sin permiso o con un error del sistema, cada método vuelve
/// sin hacer nada y la partida sigue.
class Notificaciones {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _iniciado = false;

  static const _canal = 'recordatorios';

  Future<bool> _iniciar() async {
    if (_iniciado) return true;
    if (kIsWeb) return false;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_notificacion'),
          // El permiso NO se pide al iniciar: se pide cuando el jugador dice
          // que sí, después de su primera victoria (ver `pedirPermiso`).
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      _iniciado = true;
    } catch (_) {
      // Sin plugin: no hay avisos y listo.
    }
    return _iniciado;
  }

  /// Pide el permiso del sistema. Devuelve si quedó concedido.
  Future<bool> pedirPermiso() async {
    if (!await _iniciar()) return false;
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await ios?.requestPermissions(alert: true, sound: true) ?? false;
      }
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Borra lo programado y deja sólo [avisos], con los textos de [t].
  Future<void> reprogramar(List<Recordatorio> avisos, TextosUi t) async {
    if (!await _iniciar()) return;
    try {
      await _plugin.cancelAll();
      final detalles = NotificationDetails(
        android: AndroidNotificationDetails(
          _canal,
          t('aviso.canal'),
          channelDescription: t('aviso.canalSub'),
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      for (final a in avisos) {
        await _plugin.zonedSchedule(
          id: a.id,
          title: t.con(a.claveTitulo, a.valores),
          body: t.con(a.claveCuerpo, a.valores),
          // En UTC y no en la zona del teléfono: cada aviso es un instante
          // que ya se calculó en hora local, y así no hace falta cargar la
          // base de zonas horarias. Si el jugador viaja, el próximo cálculo
          // lo corrige.
          scheduledDate: tz.TZDateTime.from(a.cuando, tz.UTC),
          notificationDetails: detalles,
          // Inexacta a propósito: un aviso de racha no necesita el minuto
          // justo, y la alarma exacta pide un permiso que Play audita.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (_) {
      // Un aviso que no se programa no rompe nada.
    }
  }

  Future<void> cancelarTodo() async {
    if (!await _iniciar()) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}
