import 'dart:convert';

import '../models.dart';
import 'cansancio.dart';

/// Presets de dificultad y opciones de partida.
///
/// Dart puro a propósito: `bin/check.dart` y los simuladores lo importan sin
/// arrastrar Flutter.
///
/// DÓNDE ENCAJA ESTO. Las capas de configuración, de afuera hacia adentro:
///
///   assets/config.json  →  override del admin  →  PRESET  →  jefes  →  modos
///   └──────────── el `cfg` de AppState ────────┘  └─── OpcionesPartida ───┘
///
/// Las tres primeras capas dan el `cfg` que el admin edita y exporta, y no se
/// tocan acá. Las tres últimas se aplican recién al clonar en `nuevaPartida()`.
/// Por eso los presets NO viven en `assets/config.json`: el chequeo 12 de
/// `bin/check.dart` exige que ese archivo sea idéntico a `Config()`, y
/// `bin/sim.dart` —la referencia de balance— construye sus `Config` a mano.
/// Los ocho caminos, del más suave al más brutal, en el mismo orden y con los
/// mismos números que la tabla del reglamento de papel.
///
/// Los cuatro primeros aprietan **sacándote recursos**: menos Energía, menos
/// peligros por fase —o sea un mazo más pobre—, más jefes. De `granMaestro`
/// para arriba la dificultad cambia de forma: te devuelve recursos y te pone a
/// pelear contra tu propio mazo, que se ensucia de Cansancio mientras jugás.
/// Por eso `maestro` es el nivel más magro de la tabla y no el más difícil.
enum Dificultad {
  aprendiz,
  novato,
  guardian,
  maestro,
  granMaestro,
  ancianoDelTemplo,
  sombraDeShifu,
  shifu,
}

extension DificultadX on Dificultad {
  /// Clave de traducción del nombre y de la línea de sabor.
  String get clave => switch (this) {
    Dificultad.aprendiz => 'aprendiz',
    Dificultad.novato => 'novato',
    Dificultad.guardian => 'guardian',
    Dificultad.maestro => 'maestro',
    Dificultad.granMaestro => 'granMaestro',
    Dificultad.ancianoDelTemplo => 'ancianoDelTemplo',
    Dificultad.sombraDeShifu => 'sombraDeShifu',
    Dificultad.shifu => 'shifu',
  };

  /// Los cuatro niveles altos traen el mazo de Cansancio puesto: no es un
  /// extra que se prende aparte, es lo que los define.
  bool get traeCansancio => index >= Dificultad.granMaestro.index;
}

/// Devuelve un CLONE con el preset aplicado. Nunca muta [base].
///
/// `Dificultad.guardian` es la IDENTIDAD: devuelve exactamente [base] sin
/// tocar nada. Eso hace que el preset por defecto reproduzca bit a bit el
/// juego que `bin/sim.dart` mide en 14.0%, y da un aserto trivial de escribir
/// (chequeo 13).
Config aplicarDificultad(Config base, Dificultad d) {
  final c = base.clone();
  switch (d) {
    case Dificultad.aprendiz:
      c.energiaInicial = 26;
      c.energiaMaxima = 26;
      c.cantidadJefes = 1;
      c.meditarSoloAlPerder = false;
      c.cartasGratisExtra = 1;
      // Enfrenta el mazo entero: más peligros son más técnicas ganadas, o sea
      // un mazo más fuerte para el jefe.
      c.peligrosPorFase = 10;
    case Dificultad.novato:
      c.energiaInicial = 22;
      c.energiaMaxima = 22;
      c.cantidadJefes = 2;
      c.peligrosPorFase = 9;
    case Dificultad.guardian:
      break; // La identidad: el juego tal como está balanceado.
    case Dificultad.maestro:
      c.energiaInicial = 18;
      c.energiaMaxima = 18;
      c.cantidadJefes = 3;
      c.costeRoboExtra = 2;
      c.peligrosPorFase = 6;

    // De acá para arriba el Cansancio es parte del nivel. `poderCansancio` no
    // se fija acá: lo pone `OpcionesPartida.aplicar()` en -1, que es el valor
    // con el que `bin/sim_cansancio.dart` midió el modo.
    case Dificultad.granMaestro:
      c.energiaInicial = 20;
      c.energiaMaxima = 20;
      c.cantidadJefes = 3;
      c.costeRoboExtra = 2;
      c.peligrosPorFase = 8;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.finDeFase.index;
    case Dificultad.ancianoDelTemplo:
      c.energiaInicial = 22;
      c.energiaMaxima = 22;
      c.cantidadJefes = 3;
      c.costeRoboExtra = 2;
      c.peligrosPorFase = 8;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.alRebarajar.index;
    case Dificultad.sombraDeShifu:
      c.energiaInicial = 26;
      c.energiaMaxima = 26;
      c.cantidadJefes = 4;
      c.costeRoboExtra = 2;
      c.peligrosPorFase = 9;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.ambos.index;
    // El papel pedía para Shifu las diez fatigas barajadas en el mazo inicial.
    // El motor reparte el Cansancio por disparos y no por mazo de arranque, y
    // forzarlo pedía tocar la preparación de la partida para un solo nivel.
    // Se juega con los dos disparos a la vez: llega a las mismas diez cartas,
    // repartidas a lo largo del día en vez de todas encima desde el principio.
    case Dificultad.shifu:
      c.energiaInicial = 30;
      c.energiaMaxima = 30;
      c.cantidadJefes = 5;
      c.costeRoboExtra = 2;
      c.peligrosPorFase = 10;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.ambos.index;
  }
  return c;
}

/// Lo que el jugador elige antes de empezar. Se persiste entre sesiones.
class OpcionesPartida {
  Dificultad dificultad;

  /// Cantidad de jefes elegida a mano. `null` = la que diga el preset.
  int? jefes;

  bool cansancio;
  bool encargos;

  OpcionesPartida({
    this.dificultad = Dificultad.guardian,
    this.jefes,
    this.cansancio = false,
    this.encargos = false,
  });

  /// Aplica preset, override de jefes y banderas de modo, en ese orden.
  Config aplicar(Config base) {
    final c = aplicarDificultad(base, dificultad);
    if (jefes != null) c.cantidadJefes = jefes!;
    // El interruptor SUMA el Cansancio, no lo manda: en los cuatro niveles
    // altos el preset ya lo trae puesto y apagarlo ahí sería jugar otro nivel
    // con el nombre de éste. En los cuatro bajos el preset no lo toca, así que
    // el interruptor decide solo.
    if (cansancio) c.modoCansancio = true;
    c.modoEncargos = encargos;
    // El cansancio sin poder configurado no haría nada: le damos el valor
    // que `bin/sim_cansancio.dart` usa para medirlo.
    if (c.modoCansancio && c.poderCansancio == 0) c.poderCansancio = -1;
    return c;
  }

  /// Cantidad de jefes que va a tener la partida, para mostrarla sin simular.
  int jefesEfectivos(Config base) => aplicar(base).cantidadJefes;

  String toJson() => jsonEncode({
    'dificultad': dificultad.name,
    'jefes': jefes,
    'cansancio': cansancio,
    'encargos': encargos,
  });

  static OpcionesPartida fromJson(String s) {
    try {
      final j = jsonDecode(s) as Map<String, dynamic>;
      return OpcionesPartida(
        dificultad: Dificultad.values.firstWhere(
          (d) => d.name == j['dificultad'],
          orElse: () => Dificultad.guardian,
        ),
        jefes: j['jefes'] as int?,
        cansancio: j['cansancio'] ?? false,
        encargos: j['encargos'] ?? false,
      );
    } catch (_) {
      return OpcionesPartida();
    }
  }
}
