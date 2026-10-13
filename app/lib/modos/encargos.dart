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

  /// El número de la condición —«15 de Energía», «3 combates»—, o 0 si no
  /// tiene. Es el MISMO que mira la regla y el que se le muestra al jugador
  /// como `{n}` en la condición del tema: si vivieran por separado, tarde o
  /// temprano el cartel diría una cosa y el juego mediría otra.
  final int n;

  final bool Function(Juego j, int n) _regla;

  /// Se aplica a la configuración del día siguiente.
  final void Function(Config) beneficio;

  const Encargo({
    required this.id,
    this.n = 0,
    required bool Function(Juego j, int n) cumplido,
    required this.beneficio,
  }) : _regla = cumplido;

  /// Se evalúa con la partida ya terminada.
  bool cumplido(Juego j) => _regla(j, n);
}

final encargos = <Encargo>[
  Encargo(
    id: 'sin_meditar',
    cumplido: (j, _) => j.cartasEliminadas == 0,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'terminar_fuerte',
    n: 10,
    cumplido: (j, n) => j.energia >= n,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'alba_impecable',
    cumplido: (j, _) => (j.perdidosPorFase[Fase.alba] ?? 0) == 0,
    beneficio: (c) => c.costeMeditar = 0,
  ),
  Encargo(
    id: 'sin_pagar_robos',
    cumplido: (j, _) => j.energiaGastadaEnRobos == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'purga_profunda',
    n: 5,
    cumplido: (j, n) => j.cartasEliminadas >= n,
    beneficio: (c) => c.cartasPorMeditacion = 2,
  ),
  Encargo(
    id: 'partida_corta',
    // Antes era `turnos <= 22`, y una partida tiene 30 peligros más los
    // jefes: no se podía cumplir nunca. Rápido es dar pocas vueltas al mazo.
    n: 3,
    cumplido: (j, n) => j.vecesBarajado <= n,
    beneficio: (c) => c.energiaInicial += 3,
  ),
  Encargo(
    id: 'pocas_derrotas',
    n: 3,
    cumplido: (j, n) => j.combatesPerdidos <= n,
    beneficio: (c) => c.energiaInicial += 2,
  ),
  Encargo(
    id: 'mediodia_limpio',
    cumplido: (j, _) => (j.perdidosPorFase[Fase.mediodia] ?? 0) == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'jefes_sin_reintento',
    cumplido: (j, _) => (j.perdidosPorFase[Fase.jefes] ?? 0) == 0,
    beneficio: (c) => c.energiaInicial += 3,
  ),
  Encargo(
    id: 'sobrar_energia',
    n: 15,
    cumplido: (j, n) => j.energia >= n,
    beneficio: (c) => c.energiaMaxima += 5,
  ),
  Encargo(
    id: 'sin_curarse',
    cumplido: (j, _) => j.energiaGanadaPorCartas == 0,
    beneficio: (c) => c.cartasGratisExtra += 1,
  ),
  Encargo(
    id: 'victoria_ajustada',
    n: 5,
    cumplido: (j, n) => j.energia <= n,
    beneficio: (c) => c.energiaInicial += 4,
  ),
];

/// Encargo del día, determinístico por fecha.
Encargo encargoDelDia(DateTime dia) {
  final semilla = dia.year * 10000 + dia.month * 100 + dia.day;
  return encargos[semilla % encargos.length];
}
