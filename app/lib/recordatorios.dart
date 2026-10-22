import 'progreso.dart';

/// Una notificación local programada: cuándo sale y con qué textos.
///
/// Los textos van como claves de `l10n` y se resuelven al programar, en el
/// idioma del jugador: así esta parte queda en Dart puro y se prueba sin
/// teléfono.
class Recordatorio {
  final int id;
  final DateTime cuando;
  final String clave;
  final Map<String, Object?> valores;

  const Recordatorio(
    this.id,
    this.cuando,
    this.clave, [
    this.valores = const {},
  ]);

  String get claveTitulo => 'aviso.$clave.titulo';
  String get claveCuerpo => 'aviso.$clave.cuerpo';

  @override
  String toString() => '$id $clave $cuando $valores';
}

/// Hora a la que salen los avisos de la racha: después del trabajo y de la
/// escuela, con tiempo de jugar una partida antes de que termine el día.
const horaDelAviso = 19;

/// Días sin abrir el juego después de los cuales se lo extraña, uno por aviso.
/// Cada vez que se abre se vuelven a contar desde cero.
const diasDeVuelta = [2, 5, 12];

/// Los avisos que tienen que quedar programados, mirando el progreso de
/// ahora. Se recalculan enteros cada vez que el jugador abre, gana o deja el
/// juego: nada se acumula, el último cálculo pisa al anterior.
///
/// Son pocos a propósito. Un juego que avisa todos los días termina con las
/// notificaciones apagadas, y entonces no puede avisar ni lo que importa.
List<Recordatorio> planificarRecordatorios({
  required Progreso progreso,
  required DateTime ahora,
  required bool comprado,
}) {
  final avisos = <Recordatorio>[];
  final hoy = Progreso.soloFecha(ahora);
  // Por calendario y no sumando 24 horas: el día que cambia la hora de
  // verano dura 23 o 25, y medianoche más 24 h puede caer en el mismo día.
  DateTime alas(int enDias, int hora, [int minuto = 0]) =>
      DateTime(hoy.year, hoy.month, hoy.day + enDias, hora, minuto);

  // 1) La racha está viva y se corta si no gana el día que toca.
  progreso.revisarCadena(ahora);
  if (progreso.racha > 0) {
    final hecho = progreso.hoyCompletado(ahora);
    final cuando = alas(hecho ? 1 : 0, horaDelAviso);
    if (cuando.isAfter(ahora)) {
      // Si la victoria de ese día cierra la semana, el aviso dice el premio.
      final cierra =
          progreso.racha % Progreso.diasParaLogro == Progreso.diasParaLogro - 1;
      avisos.add(
        Recordatorio(1, cuando, cierra ? 'semana' : 'racha', {
          'n': progreso.racha,
        }),
      );
    }
  }

  // 2) Hace días que no viene. Salen media hora antes que el de la racha, y
  // nunca el mismo día: el primero ya cae cuando la racha se cortó.
  for (var i = 0; i < diasDeVuelta.length; i++) {
    final cuando = alas(diasDeVuelta[i], 18, 30);
    avisos.add(Recordatorio(10 + i, cuando, 'vuelta${i + 1}'));
  }

  // 3) El templo abierto se termina: unas horas antes, si cae de día.
  final hasta = progreso.temploAbiertoHasta;
  if (hasta != null && !comprado) {
    final cuando = hasta.subtract(const Duration(hours: 3));
    if (cuando.isAfter(ahora) && cuando.hour >= 10 && cuando.hour < 22) {
      avisos.add(Recordatorio(20, cuando, 'templo'));
    }
  }

  return avisos;
}
