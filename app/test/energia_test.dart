// La Energía se cobra UNA sola vez.
//
// Esta prueba existe por una sospecha concreta del jugador: que el efecto de
// una carta se aplica al robarla y otra vez al resolver el combate. No pasa —
// `resolver()` sólo suma `poder` de la mesa — pero hasta ahora ningún chequeo
// lo garantizaba, así que un refactor podía romperlo en silencio.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/models.dart';

void main() {
  test('resolver() no vuelve a aplicar los efectos de las cartas de la mesa', () {
    // Energía alta para que nada tope y la partida llegue lejos.
    final j = Juego(
      cfg: Config(energiaInicial: 400, energiaMaxima: 400),
      contenido: contenidoPorDefecto(),
      rng: Random(11),
    );

    var combates = 0;
    var vueltas = 0;
    while (!j.terminado && vueltas++ < 4000) {
      if (j.estado == EstadoJuego.enCombate) {
        // Robar hasta poder ganar, o hasta que ya no se pueda robar más.
        if (j.faltante > 0 && (j.gratisRestantes > 0 || j.energia > 20)) {
          j.robar();
          continue;
        }

        // Lo único que `resolver()` tiene derecho a mover.
        final antes = j.energia;
        final esperado = j.sumaMesa >= j.poderPeligroEfectivo
            ? j.energiaSiGanaAcumulada
            : -j.peligro!.dano;

        j.resolver();
        combates++;

        expect(
          j.energia - antes,
          esperado,
          reason:
              'El combate $combates movió ${j.energia - antes} de Energía en '
              'vez de $esperado: alguien está recobrando los efectos de la '
              'mesa al resolver.',
        );
      }
      j.continuar();
    }

    // Si no jugó nada, la prueba no probó nada.
    expect(combates, greaterThan(10));
  });

  test('ninguna carta sale dos veces antes de rebarajar', () {
    // La promesa del mazo: una carta jugada no vuelve hasta que se rebaraja.
    // No es evidente desde afuera porque el mazo inicial tiene ocho copias del
    // mismo dibujo, así que parece repetirse todo el tiempo; esto separa la
    // carta (instancia) del dibujo (id) y verifica la de verdad.
    for (var s = 0; s < 60; s++) {
      final j = Juego(
        cfg: Config(),
        contenido: contenidoPorDefecto(),
        rng: Random(s),
      );
      var barajadas = 0;
      var vistas = <String>{};
      var vueltas = 0;
      while (!j.terminado && vueltas++ < 3000) {
        if (j.estado == EstadoJuego.enCombate) {
          final antes = j.mesa.length;
          if (j.faltante > 0 && (j.gratisRestantes > 0 || j.energia > 8)) {
            j.robar();
            if (j.vecesBarajado != barajadas) {
              barajadas = j.vecesBarajado;
              vistas = {};
            }
            for (var k = antes; k < j.mesa.length; k++) {
              expect(
                vistas.add(j.mesa[k].uid),
                isTrue,
                reason: '${j.mesa[k].nombre} salió dos veces sin rebarajar '
                    '(semilla $s)',
              );
            }
            continue;
          }
          j.resolver();
        }
        j.continuar();
      }
    }
  });

  test('la bitácora dice qué cartas causaron el ajuste de victoria', () {
    final j = Juego(
      cfg: Config(energiaInicial: 400, energiaMaxima: 400),
      contenido: contenidoPorDefecto(),
      rng: Random(5),
    );

    var revisados = 0;
    var vueltas = 0;
    while (!j.terminado && vueltas++ < 4000 && revisados < 5) {
      if (j.estado == EstadoJuego.enCombate) {
        if (j.faltante > 0 && (j.gratisRestantes > 0 || j.energia > 20)) {
          j.robar();
          continue;
        }
        final gana = j.sumaMesa >= j.poderPeligroEfectivo;
        final causas = [...j.causasSiGana];
        final desde = j.log.length;
        j.resolver();

        if (gana && causas.isNotEmpty) {
          final linea = j.log
              .skip(desde)
              .map((e) => e.texto)
              .firstWhere((t) => t.startsWith('Efectos de victoria'));
          // El total anunciado tiene que ser la suma de lo que se detalla: si
          // el desglose no cierra, el jugador tiene razón en desconfiar.
          final suma = causas.fold(0, (a, c) => a + c.$2);
          expect(linea, contains('${suma > 0 ? '+' : ''}$suma Energía'));
          for (final c in causas) {
            expect(linea, contains(c.$1));
          }
          revisados++;
        }
      }
      j.continuar();
    }

    expect(revisados, greaterThan(0));
  });

  test('energiaAlJugar se aplica al robar y el tope queda anotado', () {
    final j = Juego(
      cfg: Config(energiaInicial: 400, energiaMaxima: 400),
      contenido: contenidoPorDefecto(),
      rng: Random(3),
    );

    var conEfecto = 0;
    var vueltas = 0;
    while (!j.terminado && vueltas++ < 4000) {
      if (j.estado == EstadoJuego.enCombate) {
        final antes = j.energia;
        final cuantas = j.mesa.length;
        final gratis = j.gratisRestantes > 0;
        j.robar();

        // Un robo puede encadenar varias cartas (efecto `roba`), así que el
        // total esperado se suma sobre todas las que entraron.
        var nominal = 0;
        for (var i = cuantas; i < j.mesa.length; i++) {
          nominal += j.mesa[i].efecto.energiaAlJugar;
        }
        final coste = gratis ? 0 : j.cfg.costeRoboExtra;
        expect(j.energia - antes, nominal - coste);

        if (nominal != 0) {
          conEfecto++;
          // `ultimoDeltaEnergia` es lo que movió la ÚLTIMA carta que tocó la
          // Energía, no el total del robo: un robo encadenado puede meter
          // varias. Sólo se puede comparar contra `mesa.last` cuando es esa
          // carta la que trae el efecto, que es justo la condición con la que
          // la interfaz decide dibujar la chispa.
          if (j.mesa.last.efecto.energiaAlJugar != 0) {
            expect(j.ultimoDeltaEnergia, j.mesa.last.efecto.energiaAlJugar);
          }
        }
        if (j.faltante > 0 && j.energia > 20) continue;
        j.resolver();
      }
      j.continuar();
    }

    expect(conEfecto, greaterThan(3));
  });
}
