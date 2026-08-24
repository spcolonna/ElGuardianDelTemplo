// Simulador headless: `dart run bin/sim.dart`
import 'package:guardian_templo/bot.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/models.dart';

void main() {
  final con = contenidoPorDefecto();
  print('E   jefes  win%   turnos  elim  muertes');
  for (final e in [18, 20, 22, 25, 28]) {
    for (final jefes in [2, 3]) {
      final cfg = Config(
        energiaInicial: e,
        energiaMaxima: e,
        cantidadJefes: jefes,
      );
      final r = simularLote(
        cfg: cfg,
        contenido: con,
        partidas: 2000,
        semilla: 42,
      );
      print(
        '$e   $jefes      ${(r.winRate * 100).toStringAsFixed(1)}   '
        '${r.turnosPromedio.toStringAsFixed(1)}   '
        '${r.cartasEliminadasProm.toStringAsFixed(1)}   ${r.muertesPorFase}',
      );
    }
  }
}
