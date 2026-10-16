/// Cuándo se le pide al jugador que califique el juego.
///
/// Apple deja mostrar el cuadro nativo hasta tres veces por año y por
/// dispositivo, y decide sola si lo muestra o no: no avisa si apareció. Por
/// eso la regla es nuestra y conservadora, para gastar esos tres pedidos en
/// el mejor momento: recién después de ganar, cuando el jugador está contento.
///
/// - Solo después de una VICTORIA, y desde la segunda: la primera puede ser
///   suerte, la segunda ya es alguien que entendió el juego.
/// - Nunca en la primera sesión: quien acaba de instalar todavía no sabe si
///   le gusta.
/// - Como mucho una vez cada [diasEntrePedidos] días y [maximoDePedidos] en
///   total.
///
/// Los logros NO disparan el pedido: algunos se ganan perdiendo, y pedir una
/// reseña después de una derrota es pedirla con bronca.
library;

const int maximoDePedidos = 3;
const int diasEntrePedidos = 60;
const int victoriasMinimas = 2;

/// Lo que hace falta recordar entre sesiones.
class EstadoResena {
  /// Cuántas veces se abrió la app, contando la actual.
  int sesiones;

  /// Cuántas veces se pidió la reseña.
  int pedidas;

  /// Cuándo se pidió la última vez.
  DateTime? ultima;

  EstadoResena({this.sesiones = 0, this.pedidas = 0, this.ultima});
}

/// La regla, sin nada más: se prueba sola.
bool corresponderPedirResena({
  required EstadoResena estado,
  required int victorias,
  required DateTime ahora,
}) {
  if (estado.sesiones <= 1) return false;
  if (victorias < victoriasMinimas) return false;
  if (estado.pedidas >= maximoDePedidos) return false;
  final ultima = estado.ultima;
  if (ultima != null &&
      ahora.difference(ultima) < const Duration(days: diasEntrePedidos)) {
    return false;
  }
  return true;
}
