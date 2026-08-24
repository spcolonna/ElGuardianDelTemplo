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
  final String nombre;
  final String sabor;

  /// Cuánto le resta al poder base del modo. 0 = usa el poder base tal cual,
  /// -1 = una peor que el resto. Permite que el mazo no sea uniforme.
  final int ajustePoder;

  const CartaCansancio(
    this.id,
    this.nombre,
    this.sabor, [
    this.ajustePoder = 0,
  ]);
}

/// Cuándo entra una carta de Cansancio.
enum DisparoCansancio {
  /// Al terminar cada fase: 3 cartas por partida. Lectura literal de "oleada".
  finDeFase,

  /// Cada vez que se baraja el descarte para rehacer el mazo. Más frecuente y
  /// autorregulado, como en *Friday*.
  alRebarajar,
}

extension DisparoCansancioX on DisparoCansancio {
  String get nombre => switch (this) {
    DisparoCansancio.finDeFase => 'Al terminar cada fase',
    DisparoCansancio.alRebarajar => 'Cada vez que barajás el descarte',
  };
}

/// Las 10 cartas del mazo de Cansancio.
const mazoCansancio = <CartaCansancio>[
  CartaCansancio(
    'cans_bostezo',
    'Bostezo',
    'Se contagia. Hasta el bandido bostezó.',
  ),
  CartaCansancio(
    'cans_vista',
    'Vista Nublada',
    'Son dos bandidos. O uno. Difícil.',
  ),
  CartaCansancio(
    'cans_piernas',
    'Piernas de Trapo',
    'Están ahí abajo, pero no contestan.',
    -1,
  ),
  CartaCansancio(
    'cans_hombro',
    'Hombro Dormido',
    'Se despertó antes que vos y volvió a dormirse.',
  ),
  CartaCansancio('cans_ampolla', 'Ampolla', 'Chiquita. Insoportable.'),
  CartaCansancio(
    'cans_nudillo',
    'Nudillo Partido',
    'Shifu diría que es carácter. Shifu no está.',
    -1,
  ),
  CartaCansancio('cans_calambre', 'Calambre', 'Justo ahora. Justo ahí.'),
  CartaCansancio(
    'cans_zumbido',
    'Zumbido en el Oído',
    'El mosquito del Alba tuvo la última palabra.',
  ),
  CartaCansancio(
    'cans_espalda',
    'Espalda Vieja',
    'Tenés dieciséis años y la espalda de Shifu.',
    -1,
  ),
  CartaCansancio(
    'cans_renunciar',
    'Ganas de Renunciar',
    'El puesto de fideos del pueblo también necesita gente.',
    -1,
  ),
];

/// Convierte una carta de Cansancio en una carta de combate jugable.
/// [poderBase] es el valor configurable en Balance (0, -1 o -2).
CartaCombate cartaDeCansancio(CartaCansancio c, int poderBase, int instancia) =>
    CartaCombate(
      id: c.id,
      nombre: c.nombre,
      poder: poderBase + c.ajustePoder,
      sabor: c.sabor,
      instancia: instancia,
    );
