/// Regiones de la carta que el tutorial resalta, en coordenadas normalizadas
/// (0 a 1) sobre la imagen de la carta.
///
/// Van normalizadas a propósito: se multiplican por el rectángulo que la carta
/// ocupa en pantalla, así el recorte cae en el lugar correcto tanto en un
/// teléfono de 375 px como en un monitor, sin recalcular nada.
///
/// Medidas sobre `assets/cartas/alba4.jpg` (1024 × 1620).
enum ZonaCarta {
  poderPeligro,
  dano,
  cartasGratis,
  ilustracionPeligro,
  nombrePeligro,
  divisor,
  mitadTecnica,
  nombreTecnica,
  poderTecnica,
  efectoTecnica,
}

/// Rectángulo normalizado. Propio y no `Rect` de Flutter, para que este
/// archivo siga siendo Dart puro y `bin/check.dart` lo pueda importar.
class RectN {
  final double izq;
  final double arriba;
  final double der;
  final double abajo;
  const RectN(this.izq, this.arriba, this.der, this.abajo);
}

/// Rectángulos normalizados: (izquierda, arriba, derecha, abajo).
const zonasCarta = <ZonaCarta, RectN>{
  // Círculo rojo del Poder, esquina superior izquierda.
  ZonaCarta.poderPeligro: RectN(0.045, 0.026, 0.225, 0.132),

  // Corazón roto + número, arriba a la derecha.
  ZonaCarta.dano: RectN(0.705, 0.034, 0.950, 0.116),

  // Ícono de cartas + número, justo debajo del daño.
  ZonaCarta.cartasGratis: RectN(0.705, 0.127, 0.950, 0.200),

  // Toda la escena de la mitad de arriba.
  ZonaCarta.ilustracionPeligro: RectN(0.025, 0.015, 0.980, 0.470),

  // Nombre del peligro y la banda del mazo.
  ZonaCarta.nombrePeligro: RectN(0.280, 0.415, 0.970, 0.487),

  // La barra oscura con el medallón que parte la carta al medio.
  ZonaCarta.divisor: RectN(0.0, 0.483, 1.0, 0.515),

  // Toda la mitad de abajo, la que está impresa al revés.
  ZonaCarta.mitadTecnica: RectN(0.020, 0.505, 0.980, 0.985),

  // Nombre y sabor de la técnica (rotados 180°).
  ZonaCarta.nombreTecnica: RectN(0.170, 0.515, 0.850, 0.585),

  // Círculo azul del Poder de la técnica, abajo a la derecha.
  ZonaCarta.poderTecnica: RectN(0.750, 0.840, 0.950, 0.945),

  // Rayo + número del efecto, abajo a la izquierda.
  ZonaCarta.efectoTecnica: RectN(0.050, 0.895, 0.300, 0.970),
};
