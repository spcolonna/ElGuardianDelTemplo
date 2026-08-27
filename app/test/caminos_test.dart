// Los ocho caminos.
//
// Los cuatro altos no son sólo números más duros: traen el mazo de Cansancio
// puesto, y eso es lo que los define. Estos tests cuidan las tres cosas que se
// rompen solas al tocar la tabla: que el preset llegue entero a la partida,
// que el interruptor no pueda apagar lo que el camino trae, y que el disparo
// `ambos` dispare de verdad por las dos puertas.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/dificultad.dart';

void main() {
  test('los ocho caminos existen y sólo los cuatro altos traen Cansancio', () {
    expect(Dificultad.values.length, 8);
    for (final d in Dificultad.values) {
      final c = aplicarDificultad(Config(), d);
      expect(
        c.modoCansancio,
        d.traeCansancio,
        reason: '${d.name} tendría que ${d.traeCansancio ? '' : 'no '}traerlo',
      );
    }
  });

  test('Shifu no baraja las diez de entrada: usa los dos disparos', () {
    final c = aplicarDificultad(Config(), Dificultad.shifu);
    expect(c.disparoCansancio, DisparoCansancio.ambos.index);
    expect(c.cantidadJefes, 5);
    expect(c.energiaInicial, 30);
    // Empezar con el mazo limpio es justamente lo que lo diferencia de la
    // regla de papel que no se pudo implementar.
    final j = Juego(cfg: c, contenido: contenidoPorDefecto());
    expect(j.mazo.any((x) => x.id.startsWith('cans_')), isFalse);
  });

  test('el interruptor puede sumar Cansancio pero no sacarlo', () {
    // Guardián no lo trae: manda el interruptor, en los dos sentidos.
    final base = Config();
    expect(
      OpcionesPartida(
        dificultad: Dificultad.guardian,
      ).aplicar(base).modoCansancio,
      isFalse,
    );
    expect(
      OpcionesPartida(
        dificultad: Dificultad.guardian,
        cansancio: true,
      ).aplicar(base).modoCansancio,
      isTrue,
    );
    // Sombra de Shifu lo trae: apagarlo no lo apaga.
    final c = OpcionesPartida(
      dificultad: Dificultad.sombraDeShifu,
    ).aplicar(base);
    expect(c.modoCansancio, isTrue);
    expect(c.poderCansancio, -1, reason: 'el poder se completa igual');
  });

  test('`ambos` mete fatiga al cerrar fase Y al rebarajar', () {
    // Sin barajar el mazo es determinístico, así que las cuentas cierran.
    int fatigasEn(int disparo) {
      final cfg = Config()
        ..modoCansancio = true
        ..poderCansancio = -1
        ..disparoCansancio = disparo;
      final j = Juego(
        cfg: cfg,
        contenido: contenidoPorDefecto(),
        rng: Random(7),
        barajar: false,
      );
      var pasos = 0;
      while (!j.terminado && pasos++ < 4000) {
        if (j.estado == EstadoJuego.esperandoPeligro) {
          j.revelarPeligro();
        } else if (j.estado == EstadoJuego.enCombate) {
          if (j.puedeRobar && j.sumaMesa < j.poderPeligroEfectivo) {
            j.robar();
          } else {
            j.resolver();
          }
        } else {
          j.continuar();
        }
      }
      return j.cansancioAgregado;
    }

    final fase = fatigasEn(DisparoCansancio.finDeFase.index);
    final barajar = fatigasEn(DisparoCansancio.alRebarajar.index);
    final ambos = fatigasEn(DisparoCansancio.ambos.index);

    expect(fase, greaterThan(0));
    expect(barajar, greaterThan(0));
    // No es la suma exacta —la partida cambia de forma al ensuciarse el mazo—
    // pero tiene que superar a cada disparo por separado.
    expect(ambos, greaterThan(fase));
    expect(ambos, greaterThan(barajar));
    // El mazo de Cansancio tiene diez cartas y se reparte sin reposición.
    expect(ambos, lessThanOrEqualTo(mazoCansancio.length));
  });
}
