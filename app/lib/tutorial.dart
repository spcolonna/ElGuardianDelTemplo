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
  final String textoEs;
  final String textoEn;
  final AccionTutorial accion;
  final FocoTutorial foco;

  /// Región de la carta a resaltar cuando [foco] es `carta`.
  final ZonaCarta? zona;

  /// Si es true, el botón de robar saca TODAS las cartas gratis de una.
  /// Lo usa el paso donde el jugador ve salir basura de golpe.
  final bool robarTodas;

  const PasoTutorial({
    required this.textoEs,
    required this.textoEn,
    this.accion = AccionTutorial.leer,
    this.foco = FocoTutorial.nada,
    this.zona,
    this.robarTodas = false,
  });

  String texto(String idioma) => idioma == 'en' ? textoEn : textoEs;
}

/// Ids de las cartas del mazo trucado, en el orden exacto en que se roban.
/// Elegido para que cada dinámica aparezca cuando la explica el guion.
const mazoTutorial = <String>[
  'puno_torpe', // paso 4: primera carta, poder 1
  'puno_torpe', // paso 6: llega a 2 y gana
  'duda_existencial', // paso 8: sale una mala en el peligro difícil
  'respiracion_agitada',
  'puno_torpe',
  'postura_flamenco',
  'puno_torpe',
  'patada_descuidada',
];

/// Ids de los peligros del tutorial, en orden.
const peligrosTutorial = <String>[
  'alba1', // Mosquito: poder 1, daño 1, 2 gratis → se gana fácil
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
  PasoTutorial(
    textoEs:
        'Esto es tu Energía. Es lo único que te mantiene en el juego: si '
        'baja de cero, se terminó. Quedarte en cero no te elimina, pero el '
        'próximo golpe sí.',
    textoEn:
        'This is your Energy. It is the only thing keeping you in the '
        'game: if it drops below zero, you are done. Hitting zero does not '
        'kill you, but the next hit will.',
    foco: FocoTutorial.energia,
  ),
  PasoTutorial(
    textoEs:
        'Este es el peligro que te toca. El número grande es su Poder: '
        'es lo que tenés que igualar o superar sumando cartas.',
    textoEn:
        'This is the danger you are facing. The big number is its Power: '
        'that is what you have to match or beat by adding up cards.',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.poderPeligro,
  ),
  PasoTutorial(
    textoEs:
        'El corazón roto es lo que perdés de Energía si no llegás a ese '
        'número. En este caso, dos.',
    textoEn:
        'The broken heart is the Energy you lose if you fall short of that '
        'number. Two, in this case.',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.dano,
  ),
  PasoTutorial(
    textoEs:
        'Y este es el número que más vas a mirar: cuántas cartas podés robar '
        'GRATIS. Cuando se te acaban, cada carta extra cuesta Energía.',
    textoEn:
        'And this is the number you will stare at the most: how many cards you '
        'can draw for FREE. Once they run out, every extra card costs Energy.',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.cartasGratis,
  ),
  PasoTutorial(
    textoEs:
        'Fijate en esta línea: parte la carta al medio. Arriba está el peligro '
        'que enfrentás. Abajo, la técnica que ganás si lo vencés.',
    textoEn:
        'Look at this line: it splits the card in half. The danger you are '
        'facing is on top. The technique you win is at the bottom.',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.divisor,
  ),
  PasoTutorial(
    textoEs:
        'Y sí, la mitad de abajo está impresa al revés. Es a propósito: cuando '
        'ganes, girás la carta media vuelta y esa mitad queda derecha. Eso es '
        'todo lo que significa "ganar una carta".',
    textoEn:
        'And yes, the bottom half is printed upside down. That is on purpose: '
        'when you win, you turn the card around and that half reads right. '
        'That is all "winning a card" means.',
    foco: FocoTutorial.carta,
    zona: ZonaCarta.mitadTecnica,
  ),
  PasoTutorial(
    textoEs: 'Probemos. Robá tu primera carta.',
    textoEn: 'Let us try. Draw your first card.',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
  ),
  PasoTutorial(
    textoEs:
        'Ahí está: su Poder se sumó a tu total. Mirá la barra, te dice '
        'cuánto te falta.',
    textoEn:
        'There it is: its Power was added to your total. The bar tells '
        'you how much you still need.',
    foco: FocoTutorial.mesa,
  ),
  PasoTutorial(
    textoEs: 'Todavía no alcanza. Robá otra.',
    textoEn: 'Not enough yet. Draw another one.',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
  ),
  PasoTutorial(
    textoEs: 'Llegaste. Resolvé el combate.',
    textoEn: 'You made it. Resolve the fight.',
    accion: AccionTutorial.resolver,
    foco: FocoTutorial.botones,
  ),
  PasoTutorial(
    textoEs:
        'Ganaste, y esto es lo importante: la carta de peligro se da '
        'vuelta y la técnica del otro lado pasa a ser tuya. Así se construye '
        'el mazo. Seguí.',
    textoEn:
        'You won, and here is the key part: the danger card flips over '
        'and the technique on its other side becomes yours. That is how you '
        'build your deck. Carry on.',
    accion: AccionTutorial.continuar,
    foco: FocoTutorial.botones,
  ),
  PasoTutorial(
    textoEs: 'Peligro nuevo, más duro. Robá tus cartas gratis.',
    textoEn: 'A new, tougher danger. Draw your free cards.',
    accion: AccionTutorial.robar,
    foco: FocoTutorial.botones,
    robarTodas: true,
  ),
  PasoTutorial(
    textoEs:
        'Salió basura. Acá se decide el juego: seguir robando cuesta 1 de '
        'Energía por carta, y no sabés qué va a salir. Esta vez rendite.',
    textoEn:
        'You drew junk. This is where the game is decided: drawing more '
        'costs 1 Energy per card, and you do not know what is coming. This '
        'time, give up.',
    accion: AccionTutorial.resolver,
    foco: FocoTutorial.botones,
  ),
  PasoTutorial(
    textoEs:
        'Perdiste Energía y NO te llevaste la carta: rendirse nunca te da '
        'la recompensa. Pero perder abre la única puerta para limpiar el mazo. '
        'Eliminá la Duda Existencial.',
    textoEn:
        'You lost Energy and did NOT get the card: giving up never earns '
        'you the reward. But losing opens the only door to clean your deck. '
        'Remove the Existential Doubt.',
    accion: AccionTutorial.meditar,
    foco: FocoTutorial.descarte,
  ),
  PasoTutorial(
    textoEs:
        'Eso es meditar: pagás Energía y sacás una carta mala del juego '
        'para siempre. Un mazo más chico hace que las buenas salgan más '
        'seguido.\n\nUna partida real son tres fases —Alba, Mediodía y Ocaso— '
        'y al final llegan dos Campeones. Suerte.',
    textoEn:
        'That is meditating: you pay Energy and remove a bad card from '
        'the game for good. A smaller deck means the good cards come up more '
        'often.\n\nA real game has three phases — Dawn, Noon and Dusk — and '
        'two Champions at the end. Good luck.',
    foco: FocoTutorial.nada,
  ),
];
