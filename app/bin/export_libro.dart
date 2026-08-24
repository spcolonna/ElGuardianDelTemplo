// Vuelca a JSON todo lo que el reglamento y el cómic impresos necesitan saber:
//
//     dart run bin/export_libro.dart            (español)
//     dart run bin/export_libro.dart --idioma=en
//
// Por qué existe. Un reglamento impreso con los números escritos a mano se
// desincroniza del juego en el primer rebalanceo, y nadie se entera hasta que
// alguien juega mal una partida entera. Acá el papel lee del motor.
//
// Lo mismo con el cómic: su texto vive en Dart (`temas/templo/textos_es.dart`)
// y el arte en otro mapa (`temas/templo/arte.dart`). Copiarlo a mano a la web
// sería garantizar que se despeguen. Esto hace la junta por nombre de archivo,
// la misma que hace `ui_intro.dart` en tiempo de ejecución.
import 'dart:convert';
import 'dart:io';

import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/mecanica.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/dificultad.dart';
import 'package:guardian_templo/reglas_texto.dart';
import 'package:guardian_templo/temas/temas.dart';

/// El orden en que se leen las secuencias del cómic, con el momento de la
/// partida que las dispara.
///
/// OJO CON LOS NOMBRES: cada interludio narra la fase que se ACABA de
/// terminar, no la que empieza. La clave `mediodia` contiene las viñetas del
/// fin del Alba. Escribir las bifurcaciones contra la clave en vez de contra
/// el disparo manda al lector a la escena equivocada.
const secuencias = <(String, String)>[
  ('intro', 'Antes de empezar la partida.'),
  ('mediodia', 'Cuando se acaba el mazo del Alba.'),
  ('ocaso', 'Cuando se acaba el mazo del Mediodía.'),
  ('jefes', 'Cuando se acaba el mazo del Ocaso.'),
  ('victoria', 'Cuando derrotás al último jefe.'),
  ('derrota', 'Cuando tu Energía baja de 0, en CUALQUIER fase.'),
];

Map<String, dynamic> efectoJson(Efecto e) => {
  'roba': e.roba,
  'energiaAlJugar': e.energiaAlJugar,
  'energiaSiGanas': e.energiaSiGanas,
  'reducePeligro': e.reducePeligro,
  'texto': e.texto,
};

void main(List<String> args) {
  final idioma = args
      .firstWhere((a) => a.startsWith('--idioma='), orElse: () => '--idioma=es')
      .split('=')[1];

  final tema = temaTemplo;
  final t = tema.textosDe(idioma);
  final ui = TextosUi.de(idioma);
  final contenido = contenidoDe(tema, idioma);
  final base = Config();

  // Las cuatro dificultades salen del motor, no de una tabla escrita a mano.
  // Las que el reglamento agrega encima —las que no existen en la app— van en
  // el contenido de la web y llevan su propio cartel de "sin simular".
  final dificultades = Dificultad.values.map((d) {
    final c = aplicarDificultad(base, d);
    return {
      'clave': d.clave,
      'nombre': ui('dif.${d.clave}'),
      'bajada': ui('dif.${d.clave}Sub'),
      'energiaInicial': c.energiaInicial,
      'energiaMaxima': c.energiaMaxima,
      'peligrosPorFase': c.peligrosPorFase,
      'cantidadJefes': c.cantidadJefes,
      'costeRoboExtra': c.costeRoboExtra,
      'costeMeditar': c.costeMeditar,
      'cartasPorMeditacion': c.cartasPorMeditacion,
      'meditarSoloAlPerder': c.meditarSoloAlPerder,
      'cartasGratisExtra': c.cartasGratisExtra,
    };
  }).toList();

  Map<String, dynamic> peligro(CartaPeligro p) => {
    'id': p.id,
    'archivo': '${p.id}.jpg',
    'nombre': p.nombre,
    'poder': p.poder,
    'dano': p.dano,
    'cartasGratis': p.cartasGratis,
    'recompensa': {
      'nombre': p.recompensa.nombre,
      'poder': p.recompensa.poder,
      'efecto': efectoJson(p.recompensa.efecto),
      'sabor': p.recompensa.sabor,
    },
  };

  final comic = secuencias.map((s) {
    final arte = tema.paneles[s.$1] ?? const <PanelArte>[];
    return {
      'clave': s.$1,
      'disparo': s.$2,
      'paneles': arte.map((a) {
        final texto = t.paneles[a.archivo];
        if (texto == null) {
          stderr.writeln('FALTA TEXTO para la viñeta ${a.archivo} en $idioma');
          exitCode = 1;
        }
        return {
          'archivo': a.archivo,
          'narracion': texto?.narracion ?? '',
          'dichos': (texto?.conversacion ?? const <Dicho>[])
              .map(
                (d) => {
                  'quien': d.quien,
                  'texto': d.texto,
                  // La convención de `tema.dart`: sin autor, o entre
                  // paréntesis, es acotación y va sin globo ni atribución.
                  'acotacion':
                      d.quien.isEmpty ||
                      (d.texto.startsWith('(') && d.texto.endsWith(')')),
                },
              )
              .toList(),
        };
      }).toList(),
    };
  }).toList();

  final salida = {
    'tema': tema.id,
    'idioma': idioma,
    'generado': DateTime.now().toIso8601String(),
    'juego': {'nombre': t.nombre, 'bajada': t.bajada, 'recurso': t.recurso},
    'config': base.toJson(),
    'reglas': reglasDe(base, contenido).map((b) => b.toJson()).toList(),
    'dificultades': dificultades,
    'cansancio': {
      // Lo que el motor sabe hacer hoy. Los modos 4 y 5 del reglamento no
      // están acá porque no existen: el papel los declara como propios.
      'disparos': DisparoCansancio.values.map((d) => d.name).toList(),
      'poderes': const [0, -1, -2],
      'cartas': mazoCansancio
          .map(
            (c) => {
              'id': c.id,
              'nombre': t.cartas[c.id]?.nombre ?? c.id,
              'ajustePoder': c.ajustePoder,
            },
          )
          .toList(),
    },
    // Los rangos del Modo Libre se exportan en vez de escribirse, así el
    // tablero de Energía impreso y el máximo que dice el reglamento no pueden
    // separarse.
    'libre': {
      'energiaInicial': {'min': 1, 'max': 30},
      'peligrosPorFase': {'min': 1, 'max': 10},
      'jefes': {'min': 1, 'max': mecJefes.length},
      'modosCansancio': {'min': 1, 'max': 5},
    },
    'mazoInicial': contenido.mazoInicial
        .map(
          (e) => {
            'id': e.$1.id,
            'archivo': 'inicial_${e.$1.id}.jpg',
            'nombre': e.$1.nombre,
            'poder': e.$1.poder,
            'efecto': efectoJson(e.$1.efecto),
            'sabor': e.$1.sabor,
            'copias': e.$2,
          },
        )
        .toList(),
    'peligros': {
      'alba': contenido.alba.map(peligro).toList(),
      'mediodia': contenido.mediodia.map(peligro).toList(),
      'ocaso': contenido.ocaso.map(peligro).toList(),
    },
    'jefes': contenido.jefes
        .map(
          (j) => {
            'id': j.id,
            'archivo': '${j.id}.jpg',
            'nombre': j.nombre,
            'poder': j.poder,
            'dano': j.dano,
            'cartasGratis': j.cartasGratis,
            'lore': j.lore,
          },
        )
        .toList(),
    'comic': comic,
  };

  final destino = File('../imprenta/datos/juego_${tema.id}_$idioma.json');
  destino.parent.createSync(recursive: true);
  destino.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(salida),
  );

  final vinetas = comic.fold<int>(
    0,
    (a, s) => a + (s['paneles'] as List).length,
  );
  stdout.writeln(destino.path);
  stdout.writeln(
    '  ${salida['reglas'] is List ? (salida['reglas'] as List).length : 0} bloques de reglas · '
    '${dificultades.length} dificultades · $vinetas viñetas en ${comic.length} secuencias',
  );
}
