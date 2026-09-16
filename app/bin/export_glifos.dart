// Qué letras necesita cada idioma: `dart run bin/export_glifos.dart`.
//
// Escribe `fonts/glifos_<idioma>.txt` con los codepoints únicos que el juego
// puede llegar a dibujar en ese idioma, uno por línea en hexadecimal.
//
// Existe por el japonés y el chino. Las dos fuentes latinas del juego pesan
// 55 y 167 KB porque el alfabeto latino tiene doscientos y pico de signos; una
// Noto CJK entera pesa entre 4 y 9 MB porque tiene decenas de miles de
// ideogramas, y Flutter NO subsetea las fuentes de texto. Meter las dos
// enteras sería multiplicar por dos el tamaño del juego para dibujar los mil y
// pico de caracteres que de verdad usamos.
//
// Así que se recorta la fuente a lo que hace falta. Y para recortarla hay que
// saber qué hace falta, que es este archivo: la lista la genera el programa a
// partir de los textos de verdad, no la escribe nadie a mano.
//
// La salida se COMMITEA, igual que los `.ttf` recortados. Así quien compile el
// juego no necesita ni fonttools ni este script: sólo `flutter build`.
import 'dart:io';

import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/modos/dificultad.dart';
import 'package:guardian_templo/reglas_texto.dart';
import 'package:guardian_templo/temas/temas.dart';

/// Lo que NO sale de ningún texto y aparece igual en pantalla.
///
/// Los números los pone el `Config` en tiempo de ejecución, así que un dígito
/// puede no estar en ninguna cadena y salir igual en «Mazo 20». Lo mismo el
/// signo menos de un daño, la flecha de la hoja de reglas y las comillas que
/// el sistema puede sustituir. Faltando uno de estos el jugador ve un
/// cuadradito, que es el modo de falla que este archivo existe para evitar.
const _siempre =
    '0123456789'
    ' !"#\$%&\'()*+,-./:;<=>?@[]_{|}~'
    '·…—–«»“”‘’≥≤'
    'ÁÉÍÓÚÜÑáéíóúüñ¿¡';

/// Signos que SÍ se dibujan pero que ninguna fuente nuestra tiene, y que
/// dibuja el sistema.
///
/// Por ahora es uno solo: la flecha de la hoja de reglas («peligro → técnica»).
/// Ni Patrick Hand SC ni Atkinson Hyperlegible traen U+2192, y las Noto
/// recortadas tampoco, porque la lista de recorte sale de acá. Flutter cae a la
/// fuente del sistema para el glifo que le falta a la suya, y iOS, Android y
/// macOS tienen los tres una flecha perfectamente decente.
///
/// Está anotado y no escondido: si mañana aparece un segundo signo en esta
/// lista, la pregunta es si no conviene cambiar el texto en vez de sumarlo.
const _delSistema = '→';

/// Lo que no es un glifo.
///
/// El salto de línea de `tutorial.p15` es un carácter de control, no algo que
/// se dibuje. Pedirle a una fuente que lo tenga es pedirle algo que no existe.
bool _seDibuja(int p) => p >= 0x20 && !_delSistema.runes.contains(p);

void main() {
  final con = contenidoPorDefecto();
  for (final idioma in codigosIdioma) {
    final puntos = <int>{};
    void sumar(String s) => puntos.addAll(s.runes);

    sumar(_siempre);

    // 1) La interfaz entera, guion del tutorial incluido: desde E0 el guion
    //    son claves `tutorial.p01`..`p15` de este mismo mapa.
    TextosUi.mapaDe(idioma).values.forEach(sumar);

    // 2) El tema: cartas, viñetas, encargos y reversos.
    final tt = temaTemplo.textosDe(idioma);
    sumar(tt.nombre);
    sumar(tt.bajada);
    sumar(tt.protagonista);
    sumar(tt.recurso);
    tt.nombreFase.values.forEach(sumar);
    for (final c in tt.cartas.values) {
      sumar(c.nombre);
      sumar(c.sabor);
    }
    for (final p in tt.paneles.values) {
      sumar(p.narracion);
      for (final d in p.conversacion) {
        sumar(d.quien);
        sumar(d.texto);
      }
    }
    for (final e in tt.encargos.values) {
      sumar(e.titulo);
      sumar(e.nota);
      sumar(e.recompensa);
    }
    for (final r in tt.reversos.values) {
      sumar(r.nombre);
      sumar(r.queCartasLleva);
      sumar(r.descripcion);
    }

    // 3) Las reglas ya armadas, en TODAS las dificultades.
    //
    //    No alcanza con recorrer las claves `reglas.*`: la prosa sale de
    //    juntarlas con los números del `Config`, y cada camino cambia qué
    //    variantes se eligen. Generarlas de verdad es la única forma de no
    //    depender de que alguien se acuerde.
    for (final d in Dificultad.values) {
      final cfg = aplicarDificultad(Config(), d);
      for (final b in reglasDe(cfg, con, TextosUi.de(idioma))) {
        sumar(b.titulo);
        b.lineas.forEach(sumar);
      }
    }

    final orden = puntos.where(_seDibuja).toList()..sort();
    final f = File('fonts/glifos_$idioma.txt');
    f.writeAsStringSync(
      '${orden.map((p) => p.toRadixString(16).toUpperCase().padLeft(4, '0')).join('\n')}\n',
    );
    stdout.writeln('$idioma: ${orden.length} signos → ${f.path}');
  }
}
