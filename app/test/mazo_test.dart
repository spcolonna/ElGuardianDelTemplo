// El mazo es un mazo, no un sorteo.
//
// Este archivo existe por una sospecha del jugador: que la carta que le hace
// perder Energía «sale muchas veces». Es una sospecha razonable —Patada
// Descuidada viene por triplicado— y la única forma honesta de contestarla es
// medirla, no explicarla. Si algún día alguien cambia `_sacarDelMazo()` por un
// `rng.nextInt(mazo.length)`, o mete el descarte de vuelta antes de tiempo,
// estos tests se ponen rojos.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/models.dart';

void main() {
  final contenido = contenidoPorDefecto();

  Juego nuevo(int semilla) =>
      Juego(cfg: Config(), contenido: contenido, rng: Random(semilla));

  test('ninguna carta se repite antes de barajar de nuevo', () {
    // La propiedad de fondo: se reparte de arriba y lo repartido no vuelve.
    // Cada copia lleva su `instancia` propia, así que dos Puños Torpes son
    // distinguibles y ver el MISMO dos veces sería el error.
    for (var s = 0; s < 50; s++) {
      final j = nuevo(s);
      final vistas = <int>{};
      final total = j.mazo.length;
      for (var i = 0; i < total; i++) {
        final c = j.mazo[i];
        expect(
          vistas.add(c.instancia),
          isTrue,
          reason: 'la instancia ${c.instancia} está dos veces en el mazo',
        );
      }
      expect(total, 20);
    }
  });

  test('el mazo inicial es el que está impreso, sin copias de más', () {
    // Si esto cambia, cambió una carta física. No es un test de balance: es la
    // frontera con la imprenta.
    final j = nuevo(1);
    final cuenta = <String, int>{};
    for (final c in j.mazo) {
      cuenta[c.id] = (cuenta[c.id] ?? 0) + 1;
    }
    expect(cuenta, {
      'puno_torpe': 8,
      'postura_flamenco': 4,
      'patada_descuidada': 3,
      'respiracion_agitada': 3,
      'duda_existencial': 2,
    });
  });

  test('cada copia sale con la misma frecuencia en la primera carta', () {
    // Lo que contesta la sospecha. Se mira SÓLO la carta de arriba de mazos
    // recién barajados: ahí no hay descarte, ni Cansancio, ni decisiones del
    // jugador, así que cualquier desvío sería del barajado y de nada más.
    //
    // 20 000 barajadas, 20 cartas: lo esperado es 1000 por copia. La tolerancia
    // es ±15 %, unas cinco desviaciones estándar (σ ≈ 31): pasa siempre si el
    // barajado es uniforme y falla enseguida si está sesgado.
    const barajadas = 20000;
    final porInstancia = <int, int>{};
    for (var s = 0; s < barajadas; s++) {
      final c = nuevo(s).mazo.first;
      porInstancia[c.instancia] = (porInstancia[c.instancia] ?? 0) + 1;
    }
    expect(porInstancia.length, 20);
    const esperado = barajadas / 20;
    for (final e in porInstancia.entries) {
      expect(
        e.value,
        inInclusiveRange(esperado * .85, esperado * 1.15),
        reason: 'la instancia ${e.key} salió ${e.value} veces de $barajadas',
      );
    }
  });

  test('la carta que cuesta Energía sale lo que dicen sus copias, ni más', () {
    // Patada Descuidada tiene 3 de 20 copias, así que tiene que salir el 15 %
    // de las veces: se siente más porque sólo cobra cuando GANÁS el combate,
    // o sea que aparece en el recuerdo de las peleas que salieron bien.
    const barajadas = 20000;
    var patadas = 0;
    for (var s = 0; s < barajadas; s++) {
      if (nuevo(s).mazo.first.id == 'patada_descuidada') patadas++;
    }
    expect(patadas / barajadas, inInclusiveRange(.13, .17));
  });
}
