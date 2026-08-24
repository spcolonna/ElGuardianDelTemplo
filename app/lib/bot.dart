import 'dart:math';

import 'engine.dart';
import 'models.dart';

/// Política del bot para simulaciones automáticas.
class Politica {
  /// Energía que el bot intenta no gastar, por fase.
  final Map<Fase, int> reserva;

  /// Medita si tiene energía por encima de este umbral y hay basura en descarte.
  final int umbralMeditar;

  /// Valor máximo (heurística) de una carta para considerarla "basura".
  final int valorBasura;

  const Politica({
    this.reserva = const {
      Fase.alba: 5,
      Fase.mediodia: 7,
      Fase.ocaso: 8,
      Fase.jefes: 0,
    },
    this.umbralMeditar = 8,
    this.valorBasura = 2,
  });
}

class ResultadoSim {
  final bool victoria;
  final Fase faseFinal;
  final int energiaFinal;
  final int turnos;
  final int combatesGanados;
  final int combatesPerdidos;
  final int cartasEliminadas;
  final int jefesDerrotados;

  ResultadoSim({
    required this.victoria,
    required this.faseFinal,
    required this.energiaFinal,
    required this.turnos,
    required this.combatesGanados,
    required this.combatesPerdidos,
    required this.cartasEliminadas,
    required this.jefesDerrotados,
  });
}

ResultadoSim simularPartida({
  required Config cfg,
  required Contenido contenido,
  required Random rng,
  Politica politica = const Politica(),
}) {
  final j = Juego(cfg: cfg, contenido: contenido, rng: rng);
  var guarda = 0;

  while (!j.terminado && guarda++ < 5000) {
    switch (j.estado) {
      case EstadoJuego.esperandoPeligro:
        j.revelarPeligro();
      case EstadoJuego.enCombate:
        _jugarCombate(j, politica);
      case EstadoJuego.postCombate:
        _meditarSiConviene(j, politica);
        j.continuar();
      default:
        break;
    }
  }

  return ResultadoSim(
    victoria: j.estado == EstadoJuego.victoria,
    faseFinal: j.fase,
    energiaFinal: j.energia,
    turnos: j.turnos,
    combatesGanados: j.combatesGanados,
    combatesPerdidos: j.combatesPerdidos,
    cartasEliminadas: j.cartasEliminadas,
    jefesDerrotados: j.jefeActual,
  );
}

void _jugarCombate(Juego j, Politica p) {
  var guarda = 0;
  while (j.estado == EstadoJuego.enCombate && guarda++ < 200) {
    if (j.sumaMesa >= j.poderPeligroEfectivo) break;
    if (!j.hayCartasParaRobar) break;

    if (j.puedeRobarGratis) {
      j.robar();
      continue;
    }

    // Robo pagado: ¿vale la pena?
    final falta = j.faltante;
    final promedio = _poderPromedioMazo(j);
    final estimadas = promedio <= 0 ? 99 : (falta / promedio).ceil();
    final costo = estimadas * j.cfg.costeRoboExtra;
    final dano = j.peligro!.dano;
    final reserva = j.fase == Fase.jefes ? 0 : p.reserva[j.fase] ?? 5;

    final vale = costo < dano && j.energia - costo > reserva;
    // Contra jefes hay que ganar sí o sí: paga mientras le quede aire.
    final obligado = j.fase == Fase.jefes && j.energia >= j.cfg.costeRoboExtra;

    if ((vale || obligado) && j.puedeRobar) {
      j.robar();
    } else {
      break;
    }
  }
  j.resolver();
}

double _poderPromedioMazo(Juego j) {
  final todas = [...j.mazo, ...j.descarte];
  if (todas.isEmpty) return 0;
  final suma = todas.fold<int>(0, (a, c) => a + c.poder + c.efecto.roba);
  return suma / todas.length;
}

void _meditarSiConviene(Juego j, Politica p) {
  var guarda = 0;
  while (j.puedeMeditar && guarda++ < 5) {
    final reserva = j.fase == Fase.jefes ? 99 : p.umbralMeditar;
    if (j.energia <= reserva) break;
    final basura = j.descarte
        .where((c) => Juego.valorCarta(c) <= p.valorBasura)
        .toList();
    if (basura.isEmpty) break;
    basura.sort((a, b) => Juego.valorCarta(a).compareTo(Juego.valorCarta(b)));
    j.meditar(basura.first);
  }
}

class ResumenSim {
  final int partidas;
  final int victorias;
  final double energiaPromedioFinal;
  final double turnosPromedio;
  final double cartasEliminadasProm;
  final Map<String, int> muertesPorFase;
  final double jefesPromedio;

  ResumenSim({
    required this.partidas,
    required this.victorias,
    required this.energiaPromedioFinal,
    required this.turnosPromedio,
    required this.cartasEliminadasProm,
    required this.muertesPorFase,
    required this.jefesPromedio,
  });

  double get winRate => partidas == 0 ? 0 : victorias / partidas;
}

ResumenSim simularLote({
  required Config cfg,
  required Contenido contenido,
  required int partidas,
  int? semilla,
  Politica politica = const Politica(),
}) {
  final rng = Random(semilla ?? DateTime.now().millisecondsSinceEpoch);
  var victorias = 0;
  var energia = 0;
  var turnos = 0;
  var elim = 0;
  var jefes = 0;
  final muertes = <String, int>{};

  for (var i = 0; i < partidas; i++) {
    final r = simularPartida(
      cfg: cfg,
      contenido: contenido,
      rng: rng,
      politica: politica,
    );
    if (r.victoria) victorias++;
    energia += r.energiaFinal;
    turnos += r.turnos;
    elim += r.cartasEliminadas;
    jefes += r.jefesDerrotados;
    if (!r.victoria) {
      muertes[r.faseFinal.nombre] = (muertes[r.faseFinal.nombre] ?? 0) + 1;
    }
  }

  return ResumenSim(
    partidas: partidas,
    victorias: victorias,
    energiaPromedioFinal: partidas == 0 ? 0 : energia / partidas,
    turnosPromedio: partidas == 0 ? 0 : turnos / partidas,
    cartasEliminadasProm: partidas == 0 ? 0 : elim / partidas,
    muertesPorFase: muertes,
    jefesPromedio: partidas == 0 ? 0 : jefes / partidas,
  );
}
