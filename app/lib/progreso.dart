import 'dart:convert';

/// Los sellos del templo, uno por semana completa y siempre en este orden.
/// El nombre de cada uno es `sello.<id>` en los textos.
const idsSellos = [
  'loto',
  'alba',
  'bambu',
  'campana',
  'montana',
  'rio',
  'llama',
  'luna',
  'viento',
  'ocaso',
  'estrella',
  'shifu',
];

/// Racha de misiones diarias sobre calendario real.
///
/// La regla es simple a propósito: el día se completa GANANDO una partida esa
/// fecha. Perder no penaliza, podés reintentar todas las veces que quieras.
/// El día siguiente no se habilita hasta que cambie la fecha. Si pasa un día
/// entero sin ganar, la cadena se corta y vuelve a cero.
///
/// La racha no se queda en 7: sigue contando, y cada siete días seguidos es
/// una semana completa que da su premio (un sello, y el templo abierto o una
/// bendición). Las semanas seguidas suben el título del jugador.
///
/// Sin dependencias de Flutter: se puede testear headless.
class Progreso {
  static const diasParaLogro = 7;

  /// Sellos que hay para juntar: uno por semana completada.
  static final totalSellos = idsSellos.length;

  /// Lo que dura el templo abierto que gana quien no compró.
  static const duracionTemploAbierto = Duration(hours: 24);

  /// Semanas seguidas que pide cada título, del primero al último. El índice
  /// es el nivel, y su nombre es `titulo.<nivel>` en los textos.
  static const semanasPorTitulo = [0, 1, 2, 3, 4, 6, 8, 12];

  /// Días consecutivos ganados. No tiene techo: el día 8 es el primero de la
  /// segunda semana.
  int racha;

  /// Último día ganado, normalizado a Y-M-D. Null si nunca ganó.
  DateTime? ultimoDiaGanado;

  /// Se consigue al llegar a 7 y se mantiene mientras la cadena siga viva.
  bool logroActivo;

  /// Hasta cuándo está abierto el templo completo sin haberlo comprado.
  DateTime? temploAbiertoHasta;

  /// Día en que quien ya compró completó una semana. La bendición se cobra en
  /// la primera partida de un día posterior, como el beneficio de un encargo.
  DateTime? bendicionDel;

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
    this.temploAbiertoHasta,
    this.bendicionDel,
  });

  static DateTime soloFecha(DateTime d) => DateTime(d.year, d.month, d.day);

  /// ¿Ya se ganó una partida en esta fecha?
  bool hoyCompletado(DateTime hoy) =>
      ultimoDiaGanado != null && ultimoDiaGanado == soloFecha(hoy);

  /// Días marcados de la semana en curso, de 0 a 7. El día que se completa la
  /// semana se ven los siete; al día siguiente arranca la próxima, vacía.
  int diasEnSemana(DateTime hoy) {
    if (racha == 0) return 0;
    final r = racha % diasParaLogro;
    if (r == 0) return hoyCompletado(hoy) ? diasParaLogro : 0;
    return r;
  }

  /// Semanas completas de la cadena viva.
  int get semanasSeguidas => racha ~/ diasParaLogro;

  /// Sellos juntados. No se pierden al cortarse la racha.
  int get sellos => semanasCompletadas.clamp(0, totalSellos);

  /// El título que da una cantidad de semanas seguidas.
  static int nivelDe(int semanas) {
    var nivel = 0;
    for (var i = 0; i < semanasPorTitulo.length; i++) {
      if (semanas >= semanasPorTitulo[i]) nivel = i;
    }
    return nivel;
  }

  int get nivelTitulo => nivelDe(semanasSeguidas);
  int get mejorNivelTitulo => nivelDe(mejorRacha ~/ diasParaLogro);

  /// Semanas que faltan para el próximo título, o null si ya es el último.
  int? get semanasParaSubir {
    final n = nivelTitulo + 1;
    if (n >= semanasPorTitulo.length) return null;
    return semanasPorTitulo[n] - semanasSeguidas;
  }

  bool temploAbierto(DateTime ahora) =>
      temploAbiertoHasta != null && ahora.isBefore(temploAbiertoHasta!);

  /// El premio de la semana que no es el sello: quien no compró recibe el
  /// templo abierto por un día; quien ya compró, una bendición para mañana.
  void premiarSemana(DateTime ahora, {required bool comprado}) {
    if (comprado) {
      bendicionDel = soloFecha(ahora);
    } else {
      temploAbiertoHasta = ahora.add(duracionTemploAbierto);
    }
  }

  bool bendicionLista(DateTime hoy) =>
      bendicionDel != null && soloFecha(hoy).isAfter(bendicionDel!);

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

    racha++;
    ultimoDiaGanado = soloFecha(hoy);
    if (racha > mejorRacha) mejorRacha = racha;

    if (racha % diasParaLogro == 0) {
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
    'temploAbiertoHasta': temploAbiertoHasta?.toIso8601String(),
    'bendicionDel': bendicionDel?.toIso8601String(),
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
        temploAbiertoHasta: j['temploAbiertoHasta'] == null
            ? null
            : DateTime.parse(j['temploAbiertoHasta']),
        bendicionDel: j['bendicionDel'] == null
            ? null
            : DateTime.parse(j['bendicionDel']),
      );
    } catch (_) {
      return Progreso();
    }
  }
}
