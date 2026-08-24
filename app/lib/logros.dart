import 'dart:convert';

import 'engine.dart';
import 'models.dart';
import 'progreso.dart';

/// Catálogo de logros.
///
/// Dart puro sin `package:flutter`, igual que `progreso.dart` y los modos, así
/// `bin/check.dart` puede validarlo headless. Los `IconData` se resuelven en
/// `ui_logros.dart`, que sí importa Material.
///
/// Regla que se respetó al armar el catálogo: **ninguna condición inventa
/// datos**. Todas leen campos que el motor ya expone al terminar la partida.

class Logro {
  final String id;

  /// Clave de ícono, resuelta a `IconData` en la capa de interfaz.
  final String icono;

  /// Si se muestra la animación de desbloqueo. `racha7` la tiene apagada
  /// porque esa celebración ya la dispara `semanaCompletadaReciente`, y
  /// mostrarla dos veces sería peor que no mostrarla.
  final bool celebrable;

  final bool Function(Juego? j, Progreso p, LogrosEstado l) condicion;

  const Logro({
    required this.id,
    required this.icono,
    required this.condicion,
    this.celebrable = true,
  });

  String get claveTitulo => 'logro.$id.titulo';
  String get claveDesc => 'logro.$id.desc';
}

/// ¿Ganó esta partida? Los logros de partida se piden todos sobre victoria,
/// salvo los que dicen lo contrario.
bool _gano(Juego? j) => j != null && j.estado == EstadoJuego.victoria;

const catalogoLogros = <Logro>[
  Logro(id: 'primer_dia', icono: 'sol', condicion: _primerDia),
  Logro(id: 'sin_una_derrota', icono: 'escudo', condicion: _sinUnaDerrota),
  Logro(id: 'mente_limpia', icono: 'meditar', condicion: _menteLimpia),
  Logro(id: 'nada_que_soltar', icono: 'mazo', condicion: _nadaQueSoltar),
  Logro(id: 'pulmon', icono: 'rayo', condicion: _pulmon),
  Logro(id: 'por_un_pelo', icono: 'corazon', condicion: _porUnPelo),
  Logro(id: 'sin_pagar_nada', icono: 'moneda', condicion: _sinPagarNada),
  Logro(id: 'relampago', icono: 'reloj', condicion: _relampago),
  Logro(id: 'alba_intacta', icono: 'amanecer', condicion: _albaIntacta),
  Logro(id: 'tres_jefes', icono: 'fuego', condicion: _tresJefes),
  Logro(
    id: 'contra_el_cansancio',
    icono: 'pesa',
    condicion: _contraElCansancio,
  ),
  Logro(id: 'alumno_aplicado', icono: 'nota', condicion: _alumnoAplicado),
  Logro(id: 'maraton', icono: 'camino', condicion: _maraton),
  Logro(id: 'perseverante', icono: 'ancla', condicion: _perseverante),
  Logro(id: 'racha7', icono: 'medalla', celebrable: false, condicion: _racha7),
];

// Las condiciones son funciones sueltas y no closures porque el catálogo es
// `const`, y una lista const no admite lambdas.
bool _primerDia(Juego? j, Progreso p, LogrosEstado l) =>
    l.cuenta('victorias') >= 1;
bool _sinUnaDerrota(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.combatesPerdidos == 0;
bool _menteLimpia(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.cartasEliminadas >= 8;
bool _nadaQueSoltar(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.cartasEliminadas == 0;
bool _pulmon(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.energia >= 12;
bool _porUnPelo(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.energia <= 2;
bool _sinPagarNada(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.energiaGastadaEnRobos == 0;
bool _relampago(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.turnos <= 20;
bool _albaIntacta(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && (j!.perdidosPorFase[Fase.alba] ?? 0) == 0;
bool _tresJefes(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.cfg.cantidadJefes >= 3;
bool _contraElCansancio(Juego? j, Progreso p, LogrosEstado l) =>
    _gano(j) && j!.cfg.modoCansancio && j.cansancioAgregado >= 3;
bool _alumnoAplicado(Juego? j, Progreso p, LogrosEstado l) =>
    l.cuenta('encargosCumplidos') >= 1;
bool _maraton(Juego? j, Progreso p, LogrosEstado l) =>
    l.cuenta('partidas') >= 25;
bool _perseverante(Juego? j, Progreso p, LogrosEstado l) =>
    l.cuenta('derrotas') >= 10;
bool _racha7(Juego? j, Progreso p, LogrosEstado l) => p.logroActivo;

/// Lo desbloqueado y los contadores que el motor no guarda entre partidas.
class LogrosEstado {
  final Set<String> desbloqueados;

  /// Esquema abierto: sumar un contador nuevo no invalida los JSON viejos.
  final Map<String, int> contadores;

  LogrosEstado({Set<String>? desbloqueados, Map<String, int>? contadores})
    : desbloqueados = desbloqueados ?? <String>{},
      contadores = contadores ?? <String, int>{};

  int cuenta(String clave) => contadores[clave] ?? 0;
  void sumar(String clave, [int cuanto = 1]) =>
      contadores[clave] = cuenta(clave) + cuanto;
  void alMenos(String clave, int valor) {
    if (valor > cuenta(clave)) contadores[clave] = valor;
  }

  bool tiene(String id) => desbloqueados.contains(id);
  int get total => catalogoLogros.length;

  String toJson() => jsonEncode({
    'desbloqueados': desbloqueados.toList(),
    'contadores': contadores,
  });

  static LogrosEstado fromJson(String s) {
    try {
      final j = jsonDecode(s) as Map<String, dynamic>;
      return LogrosEstado(
        desbloqueados: ((j['desbloqueados'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet(),
        contadores: ((j['contadores'] as Map?) ?? const {}).map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        ),
      );
    } catch (_) {
      return LogrosEstado();
    }
  }
}

/// Suma los contadores de la partida terminada y devuelve los logros NUEVOS.
///
/// Con [juego] en null no suma nada: sirve para recalcular la galería al
/// abrirla, por si un logro se agregó al catálogo después de que el jugador
/// ya cumplió su condición.
List<Logro> evaluarLogros({
  Juego? juego,
  required Progreso progreso,
  required LogrosEstado estado,
  bool encargoCumplido = false,
}) {
  if (juego != null) {
    final gano = juego.estado == EstadoJuego.victoria;
    estado.sumar('partidas');
    estado.sumar(gano ? 'victorias' : 'derrotas');
    estado.sumar('cartasEliminadasTotal', juego.cartasEliminadas);
    if (gano) {
      estado.sumar('jefesDerrotados', juego.jefes.length);
      estado.alMenos('mejorEnergiaFinal', juego.energia);
      if (juego.cfg.modoCansancio) estado.sumar('victoriasCansancio');
    }
    if (encargoCumplido) estado.sumar('encargosCumplidos');
  }

  final nuevos = <Logro>[];
  for (final l in catalogoLogros) {
    if (estado.tiene(l.id)) continue;
    if (l.condicion(juego, progreso, estado)) {
      estado.desbloqueados.add(l.id);
      nuevos.add(l);
    }
  }
  return nuevos;
}
