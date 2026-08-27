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
/// Los seis caminos, del más suave al más brutal, en el mismo orden y con los
/// mismos números que la tabla del reglamento de papel.
///
/// LA ESCALERA ES UN INVARIANTE MEDIDO, no una intención. Cada camino gana
/// alrededor de diez puntos porcentuales menos que el anterior, y eso lo
/// verifica `bin/sim_dificultad.dart` y lo defiende `test/escalera_test.dart`.
/// Antes de tocar un número de acá, corré el simulador; la versión anterior de
/// esta tabla tenía cuatro caminos que medían todos 0,1 % y nadie se enteró.
///
/// Los cuatro primeros aprietan **sacándote recursos**: menos Energía y más
/// jefes. De `sombraDeShifu` para arriba la dificultad cambia de forma: te
/// devuelve Energía y te pone a pelear contra tu propio mazo, que se ensucia
/// de Cansancio mientras jugás.
///
/// `maestro` es el único que recorta los peligros por fase, y es lo que lo
/// define: menos peligros son menos técnicas ganadas, o sea un mazo más pobre
/// para los jefes. En los otros cinco se enfrenta el mazo entero.
enum Dificultad { aprendiz, novato, guardian, maestro, sombraDeShifu, shifu }

extension DificultadX on Dificultad {
  /// Clave de traducción del nombre y de la línea de sabor.
  String get clave => switch (this) {
    Dificultad.aprendiz => 'aprendiz',
    Dificultad.novato => 'novato',
    Dificultad.guardian => 'guardian',
    Dificultad.maestro => 'maestro',
    Dificultad.sombraDeShifu => 'sombraDeShifu',
    Dificultad.shifu => 'shifu',
  };

  /// Los dos caminos altos traen el mazo de Cansancio puesto: no es un extra
  /// que se prende aparte, es lo que los define.
  bool get traeCansancio => index >= Dificultad.sombraDeShifu.index;
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
    // Medido con `bin/sim_dificultad.dart`, 2000 partidas, semilla 42. El
    // número de cada caso es lo que gana el bot codicioso; es un PISO, porque
    // el bot no planifica y casi no medita.
    case Dificultad.aprendiz: // 66,7 %
      c.energiaInicial = 26;
      c.energiaMaxima = 26;
      c.cantidadJefes = 1;
    // Sin concesiones especiales, y es a propósito. Antes traía
    // `cartasGratisExtra = 1` y `meditarSoloAlPerder = false`. La primera lo
    // dejaba en 99 %: eso no es un camino, es un paseo, y encima es el
    // camino de la versión gratis, o sea la vidriera del juego. La segunda
    // no se puede medir con este bot —medita cinco veces por combate y se
    // funde la Energía—, y una palanca que no se puede validar es peor que
    // ninguna. Con más Energía y un solo jefe alcanza.
    case Dificultad.novato: // ~54 %
      c.energiaInicial = 25;
      c.energiaMaxima = 25;
      c.cantidadJefes = 2;
    case Dificultad.guardian: // ~44 %
      break; // La identidad: el juego tal como está balanceado.
    case Dificultad.maestro: // ~36 %
      c.cantidadJefes = 3;
      // Lo único que lo separa de Guardián además del jefe: dos peligros menos
      // por fase, o sea dos técnicas menos en el mazo cuando llegan los jefes.
      c.peligrosPorFase = 8;

    // De acá para arriba el Cansancio es parte del camino. `poderCansancio` no
    // se fija acá: lo pone `OpcionesPartida.aplicar()` en -1, que es el valor
    // con el que se imprimieron las diez cartas de Cansancio.
    //
    // Los dos usan `alRebarajar` y no `finDeFase` porque es la regla con la
    // que se jugaron de verdad en la mesa. Ninguno usa `ambos`: medido, es 10
    // a 20 veces más duro que cualquiera de los dos solo, o sea un acantilado
    // y no un escalón. El valor del enum sigue vivo como variante de mesa.
    case Dificultad.sombraDeShifu: // ~27 %
      // Ésta es, exactamente, la partida que el autor ganó una vez de tres.
      c.energiaInicial = 30;
      c.energiaMaxima = 30;
      c.cantidadJefes = 5;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.alRebarajar.index;
    case Dificultad.shifu: // ~16 %
      // La misma mesa que Sombra de Shifu con dos de Energía menos. No hay
      // nada más duro disponible sin cambiar de regla: 10 peligros son todas
      // las cartas de la fase, 5 son todos los jefes, y 30 es el borde del
      // tablero impreso.
      c.energiaInicial = 28;
      c.energiaMaxima = 28;
      c.cantidadJefes = 5;
      c.modoCansancio = true;
      c.disparoCansancio = DisparoCansancio.alRebarajar.index;
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

  /// Los dos caminos que se retiraron al pasar de ocho a seis.
  ///
  /// Sin esto caerían en el `orElse` y aterrizarían en Guardián: seis
  /// escalones más fácil Y **sin el mazo de Cansancio**, o sea otro juego, en
  /// silencio, y justo al jugador que compró y llegó arriba. Los dos eran el
  /// primer camino con Cansancio de su escalera; `sombraDeShifu` es el primer
  /// camino con Cansancio de ésta.
  static const _retirados = {
    'granMaestro': 'sombraDeShifu',
    'ancianoDelTemplo': 'sombraDeShifu',
  };

  static OpcionesPartida fromJson(String s) {
    try {
      final j = jsonDecode(s) as Map<String, dynamic>;
      final guardado = j['dificultad'];
      final nombre = _retirados[guardado] ?? guardado;
      return OpcionesPartida(
        dificultad: Dificultad.values.firstWhere(
          (d) => d.name == nombre,
          // Red final para basura de verdad, no para migrar.
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
