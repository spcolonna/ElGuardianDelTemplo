import 'dart:convert';

import '../models.dart';

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
enum Dificultad { aprendiz, novato, guardian, maestro }

extension DificultadX on Dificultad {
  /// Clave de traducción del nombre y de la línea de sabor.
  String get clave => switch (this) {
    Dificultad.aprendiz => 'aprendiz',
    Dificultad.novato => 'novato',
    Dificultad.guardian => 'guardian',
    Dificultad.maestro => 'maestro',
  };
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
    c.modoCansancio = cansancio;
    c.modoEncargos = encargos;
    // El cansancio sin poder configurado no haría nada: le damos el valor
    // que `bin/sim_cansancio.dart` usa para medirlo.
    if (cansancio && c.poderCansancio == 0) c.poderCansancio = -1;
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
