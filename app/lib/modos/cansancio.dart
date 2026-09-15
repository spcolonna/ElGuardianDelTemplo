import '../models.dart';

/// MODO CANSANCIO — mazo de fatiga estilo *Friday*.
///
/// Cada vez que se dispara, se baraja en el mazo del jugador una carta de
/// Cansancio sacada al azar de este mazo. Va al mazo y no al descarte: es una
/// carta que te vas a encontrar, no una que ya jugaste. Recién cuando salga y
/// se descarte se la puede purgar meditando, y purgarla cuesta Energía.
///
/// Está apagado por defecto: es un modo aparte, no toca el juego base.
class CartaCansancio {
  final String id;

  /// Cuánto le resta al poder base del modo. 0 = usa el poder base tal cual,
  /// -1 = una peor que el resto. Permite que el mazo no sea uniforme.
  final int ajustePoder;

  const CartaCansancio(this.id, [this.ajustePoder = 0]);
}

/// Cuándo entra una carta de Cansancio.
enum DisparoCansancio {
  /// Al terminar cada fase: 3 cartas por partida. Lectura literal de "oleada".
  finDeFase,

  /// Cada vez que se baraja el descarte para rehacer el mazo. Más frecuente y
  /// autorregulado, como en *Friday*.
  alRebarajar,

  /// Los dos disparos a la vez. Es lo que el reglamento de papel llama «Sin
  /// descanso», y es el techo del modo: las diez cartas entran igual una sola
  /// vez cada una, así que esto acelera el desgaste, no lo multiplica.
  ///
  /// Va último a propósito: `disparoCansancio` se guarda como índice en el
  /// JSON de configuración y agregar al final no repinta partidas viejas.
  ambos,
}

extension DisparoCansancioX on DisparoCansancio {
  /// Etiqueta INTERNA, para Balance y los simuladores. Lo que ve el jugador
  /// son las claves `modos.cans*` que usa `ui_modos.dart`.
  String get nombre => switch (this) {
    DisparoCansancio.finDeFase => 'Al terminar cada fase',
    DisparoCansancio.alRebarajar => 'Cada vez que barajás el descarte',
    DisparoCansancio.ambos => 'Al terminar cada fase y al barajar',
  };
}

/// Las 10 cartas del mazo de Cansancio: el id y cuánto le restan.
///
/// El nombre y el sabor viven en `TextosTema.cartas`, con estos mismos ids,
/// porque son texto y se traducen. Estaban acá y eran las únicas cartas del
/// juego que un jugador inglés veía en castellano.
const mazoCansancio = <CartaCansancio>[
  CartaCansancio('cans_bostezo'),
  CartaCansancio('cans_vista'),
  CartaCansancio('cans_piernas', -1),
  CartaCansancio('cans_hombro'),
  CartaCansancio('cans_ampolla'),
  CartaCansancio('cans_nudillo', -1),
  CartaCansancio('cans_calambre'),
  CartaCansancio('cans_zumbido'),
  CartaCansancio('cans_espalda', -1),
  CartaCansancio('cans_renunciar', -1),
];

/// Convierte una carta de Cansancio en una carta de combate jugable.
/// [poderBase] es el valor configurable en Balance (0, -1 o -2), y [nombre] y
/// [sabor] salen del tema en el idioma que se esté jugando.
CartaCombate cartaDeCansancio(
  CartaCansancio c,
  int poderBase,
  int instancia,
  String nombre,
  String sabor,
) => CartaCombate(
  id: c.id,
  nombre: nombre,
  poder: poderBase + c.ajustePoder,
  sabor: sabor,
  instancia: instancia,
);
