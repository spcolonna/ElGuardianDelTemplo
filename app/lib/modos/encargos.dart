import '../engine.dart';
import '../models.dart';

/// MODO ENCARGOS DE SHIFU.
///
/// Cada día real trae una nota extra de Shifu con una condición. Si la
/// cumplís, arrancás el día siguiente con un beneficio. El encargo se elige
/// determinísticamente por fecha: recargar la página no lo cambia.
///
/// Está apagado por defecto: es un modo aparte, no toca el juego base.
/// Sólo la LÓGICA del encargo. El título, la nota y la descripción de la
/// recompensa son texto del tema y viven en `temas/<tema>/textos_<idioma>`.
class Encargo {
  final String id;

  /// Se evalúa con la partida ya terminada.
  final bool Function(Juego) cumplido;

  /// Se aplica a la configuración del día siguiente.
  final void Function(Config) beneficio;

  const Encargo({
    required this.id,
    required this.cumplido,
    required this.beneficio,
  });
}

final encargos = <Encargo>[
  Encargo(
    id: 'sin_meditar',
    cumplido: (j) => j.cartasEliminadas == 0,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'terminar_fuerte',
    cumplido: (j) => j.energia >= 10,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'alba_impecable',
    cumplido: (j) => (j.perdidosPorFase[Fase.alba] ?? 0) == 0,
    beneficio: (c) => c.costeMeditar = 0,
  ),
  Encargo(
    id: 'sin_pagar_robos',
    cumplido: (j) => j.energiaGastadaEnRobos == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'purga_profunda',
    cumplido: (j) => j.cartasEliminadas >= 5,
    beneficio: (c) => c.cartasPorMeditacion = 2,
  ),
  Encargo(
    id: 'partida_corta',
    cumplido: (j) => j.turnos <= 22,
    beneficio: (c) => c.energiaInicial += 3,
  ),
  Encargo(
    id: 'pocas_derrotas',
    cumplido: (j) => j.combatesPerdidos <= 3,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'mediodia_limpio',
    cumplido: (j) => (j.perdidosPorFase[Fase.mediodia] ?? 0) == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'jefes_sin_reintento',
    cumplido: (j) => (j.perdidosPorFase[Fase.jefes] ?? 0) == 0,
    beneficio: (c) => c.energiaInicial += 3,
  ),
  Encargo(
    id: 'sobrar_energia',
    cumplido: (j) => j.energia >= 15,
    beneficio: (c) => c.energiaMaxima += 5,
  ),
  Encargo(
    id: 'sin_curarse',
    cumplido: (j) => j.energiaGanadaPorCartas == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'victoria_ajustada',
    cumplido: (j) => j.energia <= 5,
    beneficio: (c) => c.energiaInicial += 4,
  ),
];

/// Encargo del día, determinístico por fecha.
Encargo encargoDelDia(DateTime dia) {
  final semilla = dia.year * 10000 + dia.month * 100 + dia.day;
  return encargos[semilla % encargos.length];
}
