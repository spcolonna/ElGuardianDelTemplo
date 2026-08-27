// Mide cuánto endurece el juego el MODO CANSANCIO.
// `dart run bin/sim_cansancio.dart`
import 'dart:io';

import 'package:guardian_templo/bot.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/models.dart';

// Los peligros por fase van clavados en 7 y no heredados: el default pasó a 10
// con el rebalanceo de los seis caminos, y sin clavarlo esta tabla mediría otro
// juego que el que midió cuando se escribieron sus conclusiones.
void main() {
  final con = contenidoPorDefecto();

  void linea(String etiqueta, Config cfg) {
    final r = simularLote(
      cfg: cfg,
      contenido: con,
      partidas: 2000,
      semilla: 42,
    );
    stdout.writeln(
      '${etiqueta.padRight(38)} '
      '${(r.winRate * 100).toStringAsFixed(1).padLeft(5)}%   '
      'turnos ${r.turnosPromedio.toStringAsFixed(1)}',
    );
  }

  for (final e in [20, 22, 25]) {
    stdout.writeln('\n── Energía inicial $e ──');
    linea(
      'sin Cansancio (juego base)',
      Config(energiaInicial: e, energiaMaxima: e, peligrosPorFase: 7),
    );
    for (final disparo in DisparoCansancio.values) {
      for (final poder in [0, -1, -2]) {
        linea(
          '${disparo.nombre} · poder $poder',
          Config(energiaInicial: e, energiaMaxima: e, peligrosPorFase: 7)
            ..modoCansancio = true
            ..poderCansancio = poder
            ..disparoCansancio = disparo.index,
        );
      }
    }
  }
}
