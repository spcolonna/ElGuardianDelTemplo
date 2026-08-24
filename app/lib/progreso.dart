import 'dart:convert';

/// Racha de misiones diarias sobre calendario real.
///
/// La regla es simple a propósito: el día se completa GANANDO una partida esa
/// fecha. Perder no penaliza, podés reintentar todas las veces que quieras.
/// El día siguiente no se habilita hasta que cambie la fecha. Si pasa un día
/// entero sin ganar, la cadena se corta y hay que rehacer los 7.
///
/// Sin dependencias de Flutter: se puede testear headless.
class Progreso {
  static const diasParaLogro = 7;

  /// Días consecutivos ganados, de 0 a [diasParaLogro].
  int racha;

  /// Último día ganado, normalizado a Y-M-D. Null si nunca ganó.
  DateTime? ultimoDiaGanado;

  /// Se consigue al llegar a 7 y se mantiene mientras la cadena siga viva.
  bool logroActivo;

  /// Mejor racha histórica, no se pierde nunca.
  int mejorRacha;

  /// Cuántas veces se completaron los 7 días.
  int semanasCompletadas;

  /// Si es true, perder una partida también corta la cadena (lectura estricta
  /// de "mientras no pierdas"). Apagado por defecto.
  bool perderRompeLaRacha;

  /// Encargo de Shifu cumplido y todavía sin cobrar, con la fecha en que se
  /// cumplió. El beneficio se aplica recién en la primera partida de un día
  /// posterior.
  String? encargoCumplidoId;
  DateTime? encargoCumplidoEl;

  Progreso({
    this.racha = 0,
    this.ultimoDiaGanado,
    this.logroActivo = false,
    this.mejorRacha = 0,
    this.semanasCompletadas = 0,
    this.perderRompeLaRacha = false,
    this.encargoCumplidoId,
    this.encargoCumplidoEl,
  });

  static DateTime soloFecha(DateTime d) => DateTime(d.year, d.month, d.day);

  /// ¿Ya se ganó una partida en esta fecha?
  bool hoyCompletado(DateTime hoy) =>
      ultimoDiaGanado != null && ultimoDiaGanado == soloFecha(hoy);

  /// Días que faltan para el logro.
  int get faltan => (diasParaLogro - racha).clamp(0, diasParaLogro);

  /// Corta la cadena si pasó un día entero sin ganar. Llamar al arrancar y
  /// antes de mostrar la pantalla de progreso.
  void revisarCadena(DateTime hoy) {
    final u = ultimoDiaGanado;
    if (u == null) return;
    final dias = soloFecha(hoy).difference(u).inDays;
    if (dias > 1) {
      racha = 0;
      logroActivo = false;
    }
  }

  /// Registra una partida ganada. Devuelve true si con esta victoria se
  /// completó la semana.
  bool registrarVictoria(DateTime hoy) {
    revisarCadena(hoy);
    if (hoyCompletado(hoy)) return false; // el día ya estaba hecho

    racha = (racha + 1).clamp(0, diasParaLogro);
    ultimoDiaGanado = soloFecha(hoy);
    if (racha > mejorRacha) mejorRacha = racha;

    if (racha >= diasParaLogro && !logroActivo) {
      logroActivo = true;
      semanasCompletadas++;
      return true;
    }
    return false;
  }

  /// Solo hace algo si [perderRompeLaRacha] está prendido.
  void registrarDerrota() {
    if (!perderRompeLaRacha) return;
    racha = 0;
    logroActivo = false;
  }

  void reiniciar() {
    racha = 0;
    ultimoDiaGanado = null;
    logroActivo = false;
    encargoCumplidoId = null;
    encargoCumplidoEl = null;
  }

  /// ¿Hay un beneficio de encargo listo para cobrar hoy? Solo se cobra en un
  /// día posterior al que se cumplió.
  bool beneficioListo(DateTime hoy) =>
      encargoCumplidoId != null &&
      encargoCumplidoEl != null &&
      soloFecha(hoy).isAfter(encargoCumplidoEl!);

  // ------------------------------------------------------------ persistencia
  String toJson() => jsonEncode({
    'racha': racha,
    'ultimoDiaGanado': ultimoDiaGanado?.toIso8601String(),
    'logroActivo': logroActivo,
    'mejorRacha': mejorRacha,
    'semanasCompletadas': semanasCompletadas,
    'perderRompeLaRacha': perderRompeLaRacha,
    'encargoCumplidoId': encargoCumplidoId,
    'encargoCumplidoEl': encargoCumplidoEl?.toIso8601String(),
  });

  factory Progreso.fromJson(String texto) {
    try {
      final j = jsonDecode(texto) as Map<String, dynamic>;
      return Progreso(
        racha: j['racha'] ?? 0,
        ultimoDiaGanado: j['ultimoDiaGanado'] == null
            ? null
            : DateTime.parse(j['ultimoDiaGanado']),
        logroActivo: j['logroActivo'] ?? false,
        mejorRacha: j['mejorRacha'] ?? 0,
        semanasCompletadas: j['semanasCompletadas'] ?? 0,
        perderRompeLaRacha: j['perderRompeLaRacha'] ?? false,
        encargoCumplidoId: j['encargoCumplidoId'],
        encargoCumplidoEl: j['encargoCumplidoEl'] == null
            ? null
            : DateTime.parse(j['encargoCumplidoEl']),
      );
    } catch (_) {
      return Progreso();
    }
  }
}
