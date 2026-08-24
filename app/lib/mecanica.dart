import 'models.dart';
import 'modos/cansancio.dart';

/// Los números del juego. NO contiene un solo texto temático:
/// nombres y sabores viven en `temas/`. Esta es la fuente única
/// de balance y lo que consume el simulador.

class MecCombate {
  final String id;
  final int poder;
  final Efecto efecto;
  const MecCombate(this.id, this.poder, [this.efecto = const Efecto()]);
}

class MecPeligro {
  final String id;
  final Fase fase;
  final int poder;
  final int dano;
  final int cartasGratis;

  /// id de la técnica que se gana al vencerlo.
  final String recompensa;
  const MecPeligro(
    this.id,
    this.fase,
    this.poder,
    this.dano,
    this.cartasGratis,
    this.recompensa,
  );
}

class MecJefe {
  final String id;
  final int poder;
  final int dano;
  final int cartasGratis;
  const MecJefe(this.id, this.poder, this.dano, this.cartasGratis);
}

/// Mazo inicial: (id de la técnica, copias en el mazo).
const mecMazoInicial = <(String, int)>[
  ('puno_torpe', 8),
  ('postura_flamenco', 4),
  ('patada_descuidada', 3),
  ('respiracion_agitada', 3),
  ('duda_existencial', 2),
];

/// Todas las técnicas: las 5 iniciales y las 30 de recompensa.
const mecCombates = <MecCombate>[
  MecCombate('puno_torpe', 1),
  MecCombate('postura_flamenco', 0, Efecto(roba: 1)),
  MecCombate('patada_descuidada', 2, Efecto(energiaSiGanas: -1)),
  MecCombate('respiracion_agitada', 0),
  MecCombate('duda_existencial', -1),
  MecCombate('garra_inicial', 2),
  MecCombate('puno_bambu', 2, Efecto(energiaSiGanas: 1)),
  MecCombate('equilibrio', 1, Efecto(roba: 1)),
  MecCombate('despertar_brusco', 3, Efecto(energiaAlJugar: -1)),
  MecCombate('rascada_felina', 2),
  MecCombate('mirada_fija', 1, Efecto(roba: 2)),
  MecCombate('paso_firme', 2),
  MecCombate('salto_novato', 3),
  MecCombate('reflejo', 1, Efecto(energiaAlJugar: 1)),
  MecCombate('resistencia', 2),
  MecCombate('puno_tigre', 4, Efecto(energiaAlJugar: -1)),
  MecCombate('ala_grulla', 2, Efecto(energiaSiGanas: 1)),
  MecCombate('fe_renovada', 3),
  MecCombate('colmillo_serpiente', 3, Efecto(reducePeligro: 1)),
  MecCombate('zancada_leopardo', 3, Efecto(roba: 1)),
  MecCombate('disciplina', 2, Efecto(energiaAlJugar: 2)),
  MecCombate('escama_dragon', 3, Efecto(roba: 1, energiaAlJugar: 1)),
  MecCombate('vuelo_bambu', 4, Efecto(energiaAlJugar: -1)),
  MecCombate('lealtad', 3),
  MecCombate('resistencia_desierto', 4),
  MecCombate('rugido_tigre', 5, Efecto(energiaAlJugar: -2)),
  MecCombate('vuelo_grulla', 4, Efecto(energiaSiGanas: 2)),
  MecCombate('humildad', 4),
  MecCombate('determinacion', 5, Efecto(energiaAlJugar: -1)),
  MecCombate('puno_dragon', 5, Efecto(roba: 1, energiaAlJugar: 2)),
  MecCombate('patada_tigre', 6, Efecto(energiaAlJugar: -2)),
  MecCombate('serenidad', 4, Efecto(energiaAlJugar: 3)),
  MecCombate('agua_sagrada', 5, Efecto(energiaAlJugar: 2)),
  MecCombate('perdon', 4),
  MecCombate('iluminacion', 5, Efecto(roba: 2, energiaAlJugar: 1)),
];

const mecPeligros = <MecPeligro>[
  MecPeligro('alba1', Fase.alba, 1, 1, 2, 'garra_inicial'),
  MecPeligro('alba2', Fase.alba, 2, 1, 3, 'puno_bambu'),
  MecPeligro('alba3', Fase.alba, 1, 1, 2, 'equilibrio'),
  MecPeligro('alba4', Fase.alba, 2, 2, 3, 'despertar_brusco'),
  MecPeligro('alba5', Fase.alba, 1, 1, 2, 'rascada_felina'),
  MecPeligro('alba6', Fase.alba, 2, 1, 3, 'mirada_fija'),
  MecPeligro('alba7', Fase.alba, 1, 1, 2, 'paso_firme'),
  MecPeligro('alba8', Fase.alba, 2, 2, 3, 'salto_novato'),
  MecPeligro('alba9', Fase.alba, 1, 1, 2, 'reflejo'),
  MecPeligro('alba10', Fase.alba, 2, 1, 3, 'resistencia'),
  MecPeligro('med1', Fase.mediodia, 4, 2, 3, 'puno_tigre'),
  MecPeligro('med2', Fase.mediodia, 3, 2, 2, 'ala_grulla'),
  MecPeligro('med3', Fase.mediodia, 3, 2, 2, 'fe_renovada'),
  MecPeligro('med4', Fase.mediodia, 4, 3, 3, 'colmillo_serpiente'),
  MecPeligro('med5', Fase.mediodia, 5, 2, 4, 'zancada_leopardo'),
  MecPeligro('med6', Fase.mediodia, 3, 2, 2, 'disciplina'),
  MecPeligro('med7', Fase.mediodia, 4, 2, 3, 'escama_dragon'),
  MecPeligro('med8', Fase.mediodia, 3, 3, 2, 'vuelo_bambu'),
  MecPeligro('med9', Fase.mediodia, 4, 2, 3, 'lealtad'),
  MecPeligro('med10', Fase.mediodia, 5, 3, 4, 'resistencia_desierto'),
  MecPeligro('oca1', Fase.ocaso, 6, 3, 3, 'rugido_tigre'),
  MecPeligro('oca2', Fase.ocaso, 7, 3, 4, 'vuelo_grulla'),
  MecPeligro('oca3', Fase.ocaso, 6, 3, 3, 'humildad'),
  MecPeligro('oca4', Fase.ocaso, 5, 4, 3, 'determinacion'),
  MecPeligro('oca5', Fase.ocaso, 8, 3, 4, 'puno_dragon'),
  MecPeligro('oca6', Fase.ocaso, 9, 4, 5, 'patada_tigre'),
  MecPeligro('oca7', Fase.ocaso, 7, 4, 4, 'serenidad'),
  MecPeligro('oca8', Fase.ocaso, 6, 4, 3, 'agua_sagrada'),
  MecPeligro('oca9', Fase.ocaso, 7, 3, 4, 'perdon'),
  MecPeligro('oca10', Fase.ocaso, 8, 3, 4, 'iluminacion'),
];

const mecJefes = <MecJefe>[
  MecJefe('jefe1', 20, 5, 7),
  MecJefe('jefe2', 22, 4, 8),
  MecJefe('jefe3', 18, 5, 7),
  MecJefe('jefe4', 24, 4, 9),
  MecJefe('jefe5', 16, 6, 6),
];

/// Proporción (ancho/alto) de la carta ilustrada de este id.
///
/// Los jefes son APAISADOS: 1620x1024, al revés que el resto. Es a propósito
/// —el enfrentamiento final se ve distinto a cualquier otro turno— pero
/// obliga a que la proporción sea un dato de la carta y no una constante.
double ratioCarta(String id) =>
    mecJefes.any((j) => j.id == id) ? kRatioJefe : kRatioPeligro;

/// 1024 x 1620: peligros, técnicas y cartas iniciales.
const kRatioPeligro = 1024 / 1620;

/// 1620 x 1024: los cinco jefes.
const kRatioJefe = 1620 / 1024;

/// ¿La imagen de esta carta hay que darla vuelta para mostrarla?
///
/// Una técnica de recompensa NO tiene carta propia: se dibuja con la imagen
/// del peligro que la otorgó, donde la técnica está impresa al revés en la
/// mitad de abajo. Las cartas del mazo inicial sí tienen carta propia, impresa
/// derecha, y girarlas era el bug.
///
/// Vive acá y no en la interfaz porque es una propiedad de la carta, no una
/// decisión de quien la dibuja.
bool cartaRotada(String id) => mecPeligros.any((p) => p.recompensa == id);

/// Nombre base del archivo de imagen donde vive esta carta.
///
/// La carta física es una sola: peligro arriba, técnica abajo. Por eso una
/// técnica ganada NO tiene imagen propia — se muestra la carta del peligro
/// que la otorgó, rotada 180°.
String archivoCarta(String id) {
  for (final p in mecPeligros) {
    if (p.id == id) return id;
    if (p.recompensa == id) return p.id;
  }
  for (final j in mecJefes) {
    if (j.id == id) return id;
  }
  // Las de Cansancio se llaman `can1`..`can10` y el número sale del ORDEN en
  // `mazoCansancio`, no de una tabla aparte: así no se pueden desalinear si
  // algún día se agrega o se reordena una carta de fatiga.
  final fatiga = mazoCansancio.indexWhere((c) => c.id == id);
  if (fatiga >= 0) return 'can${fatiga + 1}';
  // Las técnicas iniciales sí tienen carta propia: nunca fueron un peligro.
  return 'inicial_$id';
}
