// Los seis caminos.
//
// Los dos altos no son sólo números más duros: traen el mazo de Cansancio
// puesto, y eso es lo que los define. Estos tests cuidan lo que se rompe solo
// al tocar la tabla: que el preset llegue entero a la partida, que el
// interruptor no pueda apagar lo que el camino trae, que ningún camino pida el
// disparo doble, y que los dos caminos retirados no aterricen en uno más fácil.
//
// Los números de la escalera no se cuidan acá sino en `escalera_test.dart`.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/dificultad.dart';

void main() {
  test('los seis caminos existen y sólo los dos altos traen Cansancio', () {
    expect(Dificultad.values.length, 6);
    for (final d in Dificultad.values) {
      final c = aplicarDificultad(Config(), d);
      expect(
        c.modoCansancio,
        d.traeCansancio,
        reason: '${d.name} tendría que ${d.traeCansancio ? '' : 'no '}traerlo',
      );
    }
  });

  test('el techo de la escalera es la mesa que se jugó de verdad', () {
    // Sombra de Shifu es, exactamente, la partida que el autor ganó una vez de
    // tres. Shifu es esa misma mesa con dos de Energía menos. Si alguien mueve
    // estos números, mueve una medición hecha jugando y no una estimación.
    final s = aplicarDificultad(Config(), Dificultad.sombraDeShifu);
    expect(s.energiaInicial, 30);
    expect(s.peligrosPorFase, 10);
    expect(s.cantidadJefes, 5);
    expect(s.costeRoboExtra, 1);
    expect(s.disparoCansancio, DisparoCansancio.alRebarajar.index);

    final f = aplicarDificultad(Config(), Dificultad.shifu);
    expect(f.energiaInicial, 28);
    expect(f.peligrosPorFase, s.peligrosPorFase);
    expect(f.cantidadJefes, s.cantidadJefes);

    // Empezar con el mazo limpio es lo que separa esto de la regla de papel
    // «ya venías cansado», que el motor no implementa.
    final j = Juego(cfg: f, contenido: contenidoPorDefecto());
    expect(j.mazo.any((x) => x.id.startsWith('cans_')), isFalse);
  });

  test('ningún camino usa el disparo doble', () {
    // Medido: meter fatiga al cerrar fase Y al rebarajar es entre 10 y 20
    // veces más duro que cualquiera de los dos solo. Eso no es un escalón,
    // es un acantilado, y por eso ningún camino lo pide. El valor del enum
    // sigue vivo porque el reglamento lo ofrece como variante de mesa.
    for (final d in Dificultad.values) {
      expect(
        aplicarDificultad(Config(), d).disparoCansancio,
        isNot(DisparoCansancio.ambos.index),
        reason: d.name,
      );
    }
  });

  test('los caminos retirados no aterrizan en uno más fácil', () {
    // Al pasar de ocho a seis se fueron Gran Maestro y Anciano del Templo.
    // Sin el mapa de retirados caerían en el `orElse` y el jugador que había
    // llegado arriba se despertaría en Guardián y SIN Cansancio: otro juego,
    // en silencio.
    for (final viejo in ['granMaestro', 'ancianoDelTemplo']) {
      final o = OpcionesPartida.fromJson('{"dificultad":"$viejo"}');
      expect(o.dificultad, Dificultad.sombraDeShifu, reason: viejo);
      expect(o.dificultad.traeCansancio, isTrue);
    }
    // Y la red final sigue existiendo para basura de verdad.
    expect(
      OpcionesPartida.fromJson('{"dificultad":"qwerty"}').dificultad,
      Dificultad.guardian,
    );
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
