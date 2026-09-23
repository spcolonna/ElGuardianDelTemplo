import 'l10n.dart';
import 'mecanica.dart';
import 'models.dart';
import 'temas/temas.dart';
import 'tutorial_zonas.dart';

/// TUTORIAL: una partida de verdad con el mazo y los peligros trucados.
///
/// No es una simulación ni una animación: corre el mismo `Juego` que el juego
/// real, con `barajar: false` para que todo salga en el orden del guion. Si el
/// paso dice "tocá Robar y sale un Puño Torpe", sale un Puño Torpe.
///
/// `bin/check.dart` verifica que el orden se cumpla.

/// Qué espera cada paso del jugador.
enum AccionTutorial {
  /// Sólo leer y tocar Siguiente.
  leer,

  /// Tocar el botón de robar.
  robar,

  /// Tocar el botón de resolver/rendirse.
  resolver,

  /// Elegir una carta del descarte para meditar.
  meditar,

  /// Tocar continuar.
  continuar,
}

/// Qué se resalta en el paso: o un widget de la pantalla, o una región
/// concreta de la imagen de la carta.
enum FocoTutorial { nada, energia, mesa, botones, descarte, carta }

class PasoTutorial {
  /// La clave del texto en `TextosUi`: `tutorial.p01`, `tutorial.p02`…
  ///
  /// El guion no vive acá. Antes eran dos campos, `textoEs` y `textoEn`, y un
  /// `idioma == 'en' ? ... : ...`: con siete idiomas eso son siete párrafos por
  /// paso y un chequeo propio para validarlos. Con la clave, el paso queda de
  /// puro mecanismo y el chequeo de claves de UI que ya existe cubre el guion
  /// gratis. Arriba de cada paso hay un comentario con su primera línea para
  /// que leer este archivo siga contando la historia.
  final String clave;
  final AccionTutorial accion;
  final FocoTutorial foco;

  /// Región de la carta a resaltar cuando [foco] es `carta`.
  final ZonaCarta? zona;

  /// Si es true, el botón de robar saca TODAS las cartas gratis de una.
  /// Lo usa el paso donde el jugador ve salir basura de golpe.
  final bool robarTodas;

  const PasoTutorial({
    required this.clave,
    this.accion = AccionTutorial.leer,
    this.foco = FocoTutorial.nada,
    this.zona,
    this.robarTodas = false,
  });

  String texto(TextosUi t) => t(clave);
}

/// Ids de las cartas del mazo trucado, en el orden exacto en que se roban.
/// Elegido para que cada dinámica aparezca cuando la explica el guion.
const mazoTutorial = <String>[
  'puno_torpe', // paso 7: primera carta, poder 1: todavía no alcanza
  'puno_torpe', // paso 9: llega a 2 y gana
  'duda_existencial', // paso 8: sale una mala en el peligro difícil
  'respiracion_agitada',
  'puno_torpe',
  'postura_flamenco',
  'puno_torpe',
  'patada_descuidada',
];

/// Ids de los peligros del tutorial, en orden.
const peligrosTutorial = <String>[
  // Poder 2 y daño 2 no son casualidad: son los números que el guión nombra.
  // El paso 3 dice «el corazón roto… en este caso, dos» y el 9 dice
  // «todavía no alcanza» después de la primera carta. Con un peligro de poder
  // 1 el tutorial se contradecía con la carta que tenía delante.
  'alba4', // Despertar Brusco: poder 2, daño 2, 3 gratis → se gana con dos
  'alba8', // Soga de Saltar Rota: poder 2, daño 2, 3 gratis → se pierde
];

/// Arma el contenido trucado reusando los mismos números de `mecanica.dart`:
/// el tutorial enseña el juego real, no una versión inventada.
Contenido contenidoTutorial(Tema tema, String idioma) {
  CartaCombate combate(String id) {
    final m = mecCombates.firstWhere((c) => c.id == id);
    return CartaCombate(
      id: m.id,
      nombre: tema.nombreDe(id, idioma),
      poder: m.poder,
      efecto: m.efecto,
      sabor: tema.saborDe(id, idioma),
    );
  }

  CartaPeligro peligro(String id) {
    final p = mecPeligros.firstWhere((x) => x.id == id);
    return CartaPeligro(
      id: p.id,
      nombre: tema.nombreDe(p.id, idioma),
      fase: Fase.alba,
      poder: p.poder,
      dano: p.dano,
      cartasGratis: p.cartasGratis,
      recompensa: combate(p.recompensa),
    );
  }

  return Contenido(
    mazoInicial: [for (final id in mazoTutorial) (combate(id), 1)],
    alba: [for (final id in peligrosTutorial) peligro(id)],
    mediodia: const [],
    ocaso: const [],
    jefes: const [],
  );
}

/// Config del tutorial: energía cómoda para que nadie pierda aprendiendo.
Config configTutorial() => Config(energiaInicial: 12, energiaMaxima: 12);

const guionTutorial = <PasoTutorial>[
  // Esto es tu Energía. Es lo único que te mantiene en el juego: si...
  PasoTutorial(clave: 'tutorial.p01', foco: FocoTutorial.energia),
  // Este es el peligro que te toca. El número grande es su Poder:...
  PasoTutorial(
    clave: 'tutorial.p02',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.poderPeligro,
  ),
  // El corazón roto es lo que perdés de Energía si no llegás a ese...
  PasoTutorial(
    clave: 'tutorial.p03',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.dano,
  ),
  // Y este es el número que más vas a mirar: cuántas cartas podés...
  PasoTutorial(
    clave: 'tutorial.p04',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.cartasGratis,
  ),
  // Fijate en esta línea: parte la carta al medio. Arriba está el...
  PasoTutorial(
    clave: 'tutorial.p05',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.divisor,
  ),
  // Y sí, la mitad de abajo está impresa al revés. Es a propósito:...
  PasoTutorial(
    clave: 'tutorial.p06',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.mitadTecnica,
  ),
  // Probemos. Robá tu primera carta.
  PasoTutorial(
    clave: 'tutorial.p07',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
  ),
  // Ahí está: su Poder se sumó a tu total. Mirá la barra, te dice...
  PasoTutorial(clave: 'tutorial.p08', foco: FocoTutorial.mesa),
  // Todavía no alcanza. Robá otra.
  PasoTutorial(
    clave: 'tutorial.p09',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
  ),
  // Llegaste. Resolvé el combate.
  PasoTutorial(
    clave: 'tutorial.p10',
    accion: AccionTutorial.resolver,
    foco: FocoTutorial.botones,
  ),
  // Ganaste, y esto es lo importante: la carta de peligro se da...
  PasoTutorial(
    clave: 'tutorial.p11',
    accion: AccionTutorial.continuar,
    foco: FocoTutorial.botones,
  ),
  // Peligro nuevo, más duro. Robá tus cartas gratis.
  PasoTutorial(
    clave: 'tutorial.p12',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
    robarTodas: true,
  ),
  // Salió basura. Acá se decide el juego: seguir robando cuesta 1...
  PasoTutorial(
    clave: 'tutorial.p13',
    accion: AccionTutorial.resolver,
    foco: FocoTutorial.botones,
  ),
  // Perdiste Energía y NO te llevaste la carta: rendirse nunca te...
  PasoTutorial(
    clave: 'tutorial.p14',
    accion: AccionTutorial.meditar,
    foco: FocoTutorial.descarte,
  ),
  // Eso es meditar: pagás Energía y sacás una carta mala del juego...
  PasoTutorial(clave: 'tutorial.p15', foco: FocoTutorial.nada),
];
