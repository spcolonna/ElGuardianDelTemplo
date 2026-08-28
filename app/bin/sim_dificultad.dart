// Mide la ESCALERA: cuánto se gana en cada camino.
// `dart run bin/sim_dificultad.dart`
//
// Es el único script que mide los presets de verdad: aplica
// `OpcionesPartida.aplicar()`, que es el mismo camino que recorre
// `AppState.nuevaPartida()`, y no una copia de los números a mano. Si acá dice
// una cosa y el teléfono hace otra, el bug está en el motor y no en la tabla.
//
// CORRE CON DOS BOTS, y eso es el punto del script. El bot por defecto casi
// nunca medita —le hace falta perder el combate, tener más de 8 de Energía y
// una carta basura en el descarte a la vez—, así que mide mal justamente los
// caminos altos, que tratan de administrar un mazo que se ensucia. El segundo
// bot medita al doble de seguido. Si la escalera baja monótona con los dos,
// la escalera es del juego; si sólo baja con uno, era del bot.
//
// El bot es codicioso de un paso y juega peor que una persona: estos números
// son un PISO, no la experiencia real. La referencia de la casa está en
// `lib/ui_sim.dart`: zona sana 25-45 %, y por debajo de 10 % «demasiado
// difícil».
import 'dart:io';

import 'package:guardian_templo/bot.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/dificultad.dart';

const _partidas = 2000;
const _semilla = 42;

/// El bot de siempre, el que produjo todos los números publicados.
const _codicioso = Politica();

/// Medita al doble de seguido y con la vara de basura más alta. No es un
/// jugador humano —sigue sin planificar—, pero sí ejerce la palanca que los
/// caminos altos ponen en juego.
const _meditador = Politica(umbralMeditar: 4, valorBasura: 3);

void main(List<String> args) {
  final con = contenidoPorDefecto();

  // `--config` mide una configuración suelta en vez de los presets. Sirve para
  // probar una partida de mesa antes de convertirla en un camino.
  if (args.contains('--config')) {
    _sueltas(con);
    return;
  }

  if (args.contains('--grilla')) {
    stdout.writeln('E  p  j   codicioso  meditador');
    for (final e in [22, 23, 24, 25, 26, 27]) {
      for (final p in [7, 8, 9, 10]) {
        for (final j in [2, 3]) {
          final cfg = Config(
            energiaInicial: e,
            energiaMaxima: e,
            cantidadJefes: j,
            peligrosPorFase: p,
          );
          final a = simularLote(
            cfg: cfg,
            contenido: con,
            partidas: 2000,
            semilla: _semilla,
            politica: _codicioso,
          );
          final b = simularLote(
            cfg: cfg,
            contenido: con,
            partidas: 2000,
            semilla: _semilla,
            politica: _meditador,
          );
          stdout.writeln(
            '$e  $p  $j   '
            '${(a.winRate * 100).toStringAsFixed(1).padLeft(5)}      '
            '${(b.winRate * 100).toStringAsFixed(1).padLeft(5)}',
          );
        }
      }
    }
    return;
  }

  for (final (nombre, pol) in [
    ('bot codicioso (el de siempre)', _codicioso),
    ('bot meditador', _meditador),
  ]) {
    stdout.writeln('\n── $nombre ──');
    stdout.writeln(
      '${'camino'.padRight(17)}  win%   salto   turnos  elim  jefes  muertes',
    );
    double? anterior;
    for (final d in Dificultad.values) {
      final cfg = OpcionesPartida(dificultad: d).aplicar(Config());
      final r = simularLote(
        cfg: cfg,
        contenido: con,
        partidas: _partidas,
        semilla: _semilla,
        politica: pol,
      );
      final win = r.winRate * 100;
      // El salto contra la fila de arriba: es lo que se mira para saber si
      // esto es una escalera o dos mesetas con un precipicio en el medio.
      final salto = anterior == null
          ? '   —'
          : (win - anterior).toStringAsFixed(1).padLeft(6);
      anterior = win;
      stdout.writeln(
        '${d.name.padRight(17)} '
        '${win.toStringAsFixed(1).padLeft(5)}  $salto   '
        '${r.turnosPromedio.toStringAsFixed(1).padLeft(5)} '
        '${r.cartasEliminadasProm.toStringAsFixed(1).padLeft(5)} '
        '${r.jefesPromedio.toStringAsFixed(1).padLeft(5)}  '
        '${_muertes(r)}',
      );
    }
  }
}

/// Las configuraciones sueltas que hay que tener medidas mientras se calibra.
void _sueltas(Contenido con) {
  Config base({
    required int e,
    required int peligros,
    required int jefes,
    int robo = 1,
    int? disparo,
  }) {
    final c = Config(
      energiaInicial: e,
      energiaMaxima: e,
      cantidadJefes: jefes,
      peligrosPorFase: peligros,
      costeRoboExtra: robo,
    );
    if (disparo != null) {
      c
        ..modoCansancio = true
        ..poderCansancio = -1
        ..disparoCansancio = disparo;
    }
    return c;
  }

  // Los vecinos del techo de la escalera. Sirven para dos cosas: ver cuánto
  // vale cada palanca cerca del extremo duro, y no volver a proponer como
  // «escalón» algo que en realidad es un acantilado.
  final casos = <String, Config>{
    // La partida que el autor ganó una vez de tres. Es `sombraDeShifu`.
    'Sombra: E30 p10 j5 robo1 rebarajar': base(
      e: 30,
      peligros: 10,
      jefes: 5,
      disparo: DisparoCansancio.alRebarajar.index,
    ),
    'Shifu: idem con E28': base(
      e: 28,
      peligros: 10,
      jefes: 5,
      disparo: DisparoCansancio.alRebarajar.index,
    ),
    'idem sin Cansancio': base(e: 30, peligros: 10, jefes: 5),
    'idem al cerrar fase': base(
      e: 30,
      peligros: 10,
      jefes: 5,
      disparo: DisparoCansancio.finDeFase.index,
    ),
    // Descartados como escalón, y por qué. El robo a 2 saca 17 puntos de una:
    // no es un escalón. Que el peligro perdido vuelva sale al revés de lo que
    // parece —afloja— porque da más chances de llevarse la técnica.
    'descartado · robo 2': base(
      e: 30,
      peligros: 10,
      jefes: 5,
      robo: 2,
      disparo: DisparoCansancio.alRebarajar.index,
    ),
    'descartado · el peligro perdido vuelve': base(
      e: 30,
      peligros: 10,
      jefes: 5,
      disparo: DisparoCansancio.alRebarajar.index,
    )..peligroPerdidoSaleDelJuego = false,
  };

  for (final (nombre, pol) in [
    ('bot codicioso', _codicioso),
    ('bot meditador', _meditador),
  ]) {
    stdout.writeln('\n── $nombre ──');
    for (final e in casos.entries) {
      final r = simularLote(
        cfg: e.value,
        contenido: con,
        partidas: _partidas,
        semilla: _semilla,
        politica: pol,
      );
      stdout.writeln(
        '${e.key.padRight(34)} '
        '${(r.winRate * 100).toStringAsFixed(1).padLeft(5)}%  '
        'turnos ${r.turnosPromedio.toStringAsFixed(1)}  '
        '${_muertes(r)}',
      );
    }
  }
}

/// Dónde muere el bot, ordenado. Un camino donde se muere siempre en el mismo
/// lado no es difícil, es un tapón.
String _muertes(ResumenSim r) {
  final e = r.muertesPorFase.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return e.map((x) => '${x.key} ${x.value}').join(' · ');
}
