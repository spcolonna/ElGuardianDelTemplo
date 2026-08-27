// La escalera de dificultad es un invariante, no una intención.
//
// Este archivo existe porque ya pasó lo contrario: la tabla llegó a tener
// cuatro caminos seguidos que medían todos 0,1 % de victorias —cuatro maneras
// distintas de perder, no cuatro escalones— y no había nada que avisara. Se
// descubrió midiendo a mano, meses después.
//
// Corre pocas partidas a propósito: no busca el número exacto, que para eso
// está `bin/sim_dificultad.dart`, sino que el ORDEN no se dé vuelta.
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/bot.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/dificultad.dart';

void main() {
  final contenido = contenidoPorDefecto();

  /// El mismo camino que recorre `AppState.nuevaPartida()`.
  ///
  /// Tiene que ser `OpcionesPartida.aplicar()` y no `aplicarDificultad()` a
  /// secas: el preset prende `modoCansancio` pero deja `poderCansancio` en 0,
  /// y el -1 —que es el que está impreso en las cartas— lo pone recién
  /// `aplicar()`. Midiendo por el atajo, los dos caminos altos salen con
  /// fatigas más blandas que las que el jugador tiene en la mano.
  double ganar(Dificultad d, Politica pol) => simularLote(
    cfg: OpcionesPartida(dificultad: d).aplicar(Config()),
    contenido: contenido,
    partidas: 400,
    semilla: 42,
    politica: pol,
  ).winRate;

  test('cada camino se gana menos que el anterior', () {
    // Con las dos políticas. El bot de siempre casi no medita, así que mide
    // mal justo los caminos que se tratan de administrar un mazo que se
    // ensucia; si el orden aguanta también con uno que medita, el orden es
    // del juego y no del bot.
    for (final (nombre, pol) in [
      ('codicioso', const Politica()),
      ('meditador', const Politica(umbralMeditar: 4, valorBasura: 3)),
    ]) {
      var anterior = 1.0;
      for (final d in Dificultad.values) {
        final w = ganar(d, pol);
        expect(
          w,
          lessThan(anterior),
          reason:
              '$nombre: ${d.name} gana ${(w * 100).toStringAsFixed(1)} %, '
              'que no es menos que el camino anterior',
        );
        anterior = w;
      }
    }
  });

  test('Guardián, que es el juego base, cae en la zona sana', () {
    // 25-45 % es lo que declara `lib/ui_sim.dart` para un solitario de este
    // tipo, y Guardián es la identidad sobre `Config()`: si se va de la banda,
    // el juego que se reparte por defecto está mal calibrado.
    final w = ganar(Dificultad.guardian, const Politica());
    expect(w, greaterThan(.25));
    expect(w, lessThan(.45));
  });

  test('ningún camino se gana casi nunca', () {
    // Un camino bajo 10 % no es difícil: es un tapón. Shifu es el más duro y
    // tiene que seguir siendo ganable.
    for (final d in Dificultad.values) {
      expect(
        ganar(d, const Politica()),
        greaterThan(.10),
        reason: '${d.name} está en zona de «demasiado difícil»',
      );
    }
  });

  test('el disparo doble sigue siendo un acantilado, y por eso no se usa', () {
    // Deja constancia del número que justifica la decisión: si algún día
    // alguien lo suaviza en el motor, este test se vuelve rojo y hay que
    // volver a discutir si algún camino puede usarlo.
    Config cans(int disparo) => Config()
      ..modoCansancio = true
      ..poderCansancio = -1
      ..disparoCansancio = disparo;

    double w(int disparo) => simularLote(
      cfg: cans(disparo),
      contenido: contenido,
      partidas: 400,
      semilla: 42,
    ).winRate;

    final solo = w(DisparoCansancio.alRebarajar.index);
    final doble = w(DisparoCansancio.ambos.index);
    expect(doble, lessThan(solo / 3));
  });
}
