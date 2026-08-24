import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en inglés.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
const textosTemploEn = TextosTema(
  nombre: 'Guardian of the Temple',
  protagonista: 'The Rookie',
  bajada: "Shifu is gone for seven days. Don't burn the temple down.",
  recurso: 'Energy',
  nombreFase: {
    Fase.alba: 'Dawn',
    Fase.mediodia: 'Noon',
    Fase.ocaso: 'Dusk',
    Fase.jefes: 'Final Showdown',
  },
  cartas: {
    // técnicas iniciales
    'puno_torpe': TextoCarta('Clumsy Punch'),
    'postura_flamenco': TextoCarta(
      'Flamingo Stance',
      "Not a Shaolin stance, but it does the job.",
    ),
    'patada_descuidada': TextoCarta(
      'Sloppy Kick',
      'You almost fell over backwards.',
    ),
    'respiracion_agitada': TextoCarta(
      'Ragged Breathing',
      'You sound like a broken bellows.',
    ),
    'duda_existencial': TextoCarta(
      'Existential Doubt',
      'What if kung fu is just aerobics with attitude?',
    ),

    // alba
    'alba1': TextoCarta('Temple Mosquito'),
    'garra_inicial': TextoCarta(
      'First Claw',
      'Your first move that looks like you meant it.',
    ),
    'alba2': TextoCarta('Bandit with a Rotten Stick'),
    'puno_bambu': TextoCarta('Bamboo Fist'),
    'alba3': TextoCarta('Spilled Teapot'),
    'equilibrio': TextoCarta(
      'Balance',
      'You learned not to trip over your own foot.',
    ),
    'alba4': TextoCarta('Tempting Nap'),
    'despertar_brusco': TextoCarta(
      'Rude Awakening',
      'The Master threw a bucket of cold water at you.',
    ),
    'alba5': TextoCarta('Temple Guard Cat'),
    'rascada_felina': TextoCarta(
      'Cat Scratch',
      'You learned from the best fighter in the temple.',
    ),
    'alba6': TextoCarta('Smug Classmate'),
    'mirada_fija': TextoCarta(
      'Dead Stare',
      'You scared him off with your hungry rookie eyes.',
    ),
    'alba7': TextoCarta('Pebble in Your Shoe'),
    'paso_firme': TextoCarta(
      'Steady Step',
      'You finally got proper training shoes.',
    ),
    'alba8': TextoCarta('Snapped Jump Rope'),
    'salto_novato': TextoCarta(
      'Rookie Leap',
      'You rang the temple bells with your head.',
    ),
    'alba9': TextoCarta('Spider in the Rice Bowl'),
    'reflejo': TextoCarta('Reflex', 'The spider made it. So did you.'),
    'alba10': TextoCarta('Cold Morning Wind'),
    'resistencia': TextoCarta(
      'Endurance',
      'Cold strengthens the spirit. You just want a blanket.',
    ),

    // mediodía
    'med1': TextoCarta('Three Hungry Bandits'),
    'puno_tigre': TextoCarta(
      'Tiger Fist',
      'Roars like a kitten. Hits like a tiger.',
    ),
    'med2': TextoCarta('Mercenary with a Toy Sword'),
    'ala_grulla': TextoCarta('Crane Wing', 'Grace over force.'),
    'med3': TextoCarta('Doubt: "Is Any of This Working?"'),
    'fe_renovada': TextoCarta(
      'Renewed Faith',
      'Shifu never lied. Well, almost never.',
    ),
    'med4': TextoCarta('Uncontrollable Rage'),
    'colmillo_serpiente': TextoCarta('Snake Fang'),
    'med5': TextoCarta("The Crooked Governor's Soldier"),
    'zancada_leopardo': TextoCarta(
      'Leopard Stride',
      'Fast. Elegant. Confusing for the enemy.',
    ),
    'med6': TextoCarta('The Cupboard Calls'),
    'disciplina': TextoCarta(
      'Discipline',
      "Shifu's cookies are still there. Untouched. You are a hero.",
    ),
    'med7': TextoCarta('Street-Corner Fake Master'),
    'escama_dragon': TextoCarta(
      'Dragon Scale',
      'You learned what NOT to do. That counts.',
    ),
    'med8': TextoCarta('Broken Rope Bridge'),
    'vuelo_bambu': TextoCarta(
      'Bamboo Flight',
      'You crossed the gorge. With style.',
    ),
    'med9': TextoCarta('The Classmate Who Sold You Out'),
    'lealtad': TextoCarta(
      'Loyalty',
      'You forgave the traitor. Better person than fighter.',
    ),
    'med10': TextoCarta('Sudden Sandstorm'),
    'resistencia_desierto': TextoCarta(
      'Desert Endurance',
      'Sand in the eyes is just advanced training.',
    ),

    // ocaso
    'oca1': TextoCarta('The Bandit Chief'),
    'rugido_tigre': TextoCarta(
      'Tiger Roar',
      'Now it really does roar like a tiger.',
    ),
    'oca2': TextoCarta('Silent Assassin'),
    'vuelo_grulla': TextoCarta(
      'Crane Flight',
      'You never saw him coming. He never saw you either.',
    ),
    'oca3': TextoCarta('Demon of Pride'),
    'humildad': TextoCarta(
      'Humility',
      'You came down off your cloud. The hard way.',
    ),
    'oca4': TextoCarta('Demon of Sloth'),
    'determinacion': TextoCarta(
      'Resolve',
      'You got up at 4 AM. Once. But it counts.',
    ),
    'oca5': TextoCarta('Master of the Rival Temple'),
    'puno_dragon': TextoCarta(
      'Dragon Fist',
      'His temple has a bigger budget. You have heart.',
    ),
    'oca6': TextoCarta('Mercenary Army'),
    'patada_tigre': TextoCarta(
      'Tiger Kick',
      'One kick. Many mercenaries. Simple math.',
    ),
    'oca7': TextoCarta('Demon of Wrath'),
    'serenidad': TextoCarta(
      'Serenity',
      "You took a deep breath. The demon didn't.",
    ),
    'oca8': TextoCarta('Fire in the Temple Kitchen'),
    'agua_sagrada': TextoCarta(
      'Sacred Water',
      'You put it out. Nobody knows how it started. It was Shifu, right?',
    ),
    'oca9': TextoCarta("The Favorite Disciple's Betrayal"),
    'perdon': TextoCarta(
      'Forgiveness',
      'You gave him a second chance. And a kick.',
    ),
    'oca10': TextoCarta("The Grandmaster's Test (In a Dream)"),
    'iluminacion': TextoCarta(
      'Enlightenment',
      'You woke up soaked. But enlightened.',
    ),

    // jefes
    'jefe1': TextoCarta(
      'The Fallen Monk',
      'Star pupil. Left because Shifu never gave him the cookies he wanted. '
          'Now he wants revenge. And cookies.',
    ),
    'jefe2': TextoCarta(
      'Your Own Reflection',
      'It had your face. And it was right about everything.',
    ),
    'jefe3': TextoCarta(
      'The Mercenary Lord',
      'Pays his men well. Smells terrible. Genuinely terrible.',
    ),
    'jefe4': TextoCarta(
      'Grandmaster of the Black Lotus Temple',
      'His temple has a pool, a sauna and an all-you-can-eat buffet. '
          'Yours has a rock.',
    ),
    'jefe5': TextoCarta(
      'The Paper Dragon',
      'Imposing, breathes fire. But if it rains, it turns to mush.',
    ),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    //
    // LORE: one game is ONE day of watch, and the day runs Dawn → Noon →
    // Dusk. The seven days are Shifu's deadline, not the length of a game:
    // you hold one day at a time, and the full week is the streak. Nothing in
    // here counts days except that deadline.
    '01_templo_amanecer.png': TextoPanel(
      narracion:
          'High on the mountain, where the wind complains and the tea is never '
          'quite hot enough, stands the Temple of the Crooked Lotus.',
      conversacion: [
        Dicho('', '(One hundred and eight steps up to the gate.)'),
        Dicho(
          '',
          '(The Rookie sweeps them every morning. Every morning they get '
              'dirty again.)',
        ),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion:
          'This morning, Grandmaster Shifu left for the Annual Congress of '
          'Martial Arts Masters and Jasmine Tea.',
      conversacion: [
        Dicho('Shifu', 'Back in seven days. I trust you.'),
        Dicho('Rookie', 'Seven days on my own?'),
        Dicho('Shifu', 'Not on your own. Mei is here.'),
        Dicho('', '(Mei had already gone to sleep.)'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion: 'Before leaving he left a note, in flawless calligraphy.',
      conversacion: [
        Dicho(
          'The note',
          "Dear rookie: don't burn the temple down. Don't eat the cookies "
              'in the cupboard (they are mine). Sweep the courtyard every '
              'morning.',
        ),
        Dicho('The note', 'And above all: DO NOT LET STRANGERS IN.'),
        Dicho('Rookie', 'Easy.'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'And below, in smaller letters, a postscript.',
      conversacion: [
        Dicho(
          'The note',
          'P.S.: If anyone asks about the "Great Illegal Martial Arts '
              'Tournament", tell them we firmly declined.',
        ),
        Dicho('Rookie', 'The what?'),
        Dicho('Rookie', 'We declined WHAT?'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion:
          'Shifu rounded the first bend in the road. Twelve seconds '
          'later, they started climbing.',
      conversacion: [
        Dicho('Rookie', 'Well. That escalated fast.'),
        Dicho('', '(There were fourteen of them, to begin with.)'),
      ],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: "And the worst of it wasn't coming from outside.",
      conversacion: [
        Dicho('Rookie', 'One cookie is not going to show.'),
        Dicho('Rookie', "He didn't count them. No way he counted them."),
        Dicho('', '(Shifu had counted them.)'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion:
          'The day is only starting. You will train with whatever shows up, '
          'and turn every beating into a new technique.',
      conversacion: [
        Dicho('', '(Dawn. Noon. Dusk.)'),
        Dicho(
          '',
          '(Three times the mountain gets climbed, and each time by '
              'something worse.)',
        ),
        Dicho('Rookie', 'I can do this.'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion:
          'And once the sun sinks behind the mountain, two Tournament '
          'Champions will knock on the gate to take the temple.',
      conversacion: [
        Dicho('Rookie', 'Can I protect the temple?'),
        Dicho('Rookie', "And Shifu's cookies?"),
        Dicho('', '(One of those two answers was going to be no.)'),
      ],
    ),

    // ------------------------------------------------------------------- noon
    '10_fin_alba.png': TextoPanel(
      narracion:
          'You held the Dawn. Everything hurts, but you are still standing '
          'and the courtyard is still yours.',
      conversacion: [
        Dicho('Rookie', 'One down.'),
        Dicho('', '(The sun was only just climbing.)'),
      ],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion:
          'Mei, the guardian cat, reviewed your performance from the roof. '
          'She was not impressed.',
      conversacion: [
        Dicho('Mei', '(devastating feline silence)'),
        Dicho('Rookie', 'I won, you know.'),
        Dicho('Mei', '(slow blink)'),
        Dicho('Rookie', 'Fine. I tied.'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion:
          'By Noon the curious have stopped climbing. Now it is the ones who '
          'get paid to be here.',
      conversacion: [
        Dicho(
          'Tao',
          "Not bad for someone who couldn't make a fist this morning.",
        ),
        Dicho('Tao', 'The ones at this hour hit different, though.'),
        Dicho('Rookie', 'And whose side are you on?'),
        Dicho('Tao', 'The winning one.'),
      ],
    ),

    // ------------------------------------------------------------------- dusk
    '20_fin_mediodia.png': TextoPanel(
      narracion:
          'Noon left your hands raw, but the gate never opened for anyone you '
          "didn't want in.",
      conversacion: [
        Dicho('Rookie', 'Two.'),
        Dicho('', '(The shadows in the courtyard were already stretching.)'),
      ],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion:
          'Tao left as the sun started going down. He did not say goodbye.',
      conversacion: [
        Dicho('Rookie', 'Ah. So that was it.'),
        Dicho('Tao', 'The winning one, kid. I told you up front.'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion:
          'At Dusk the bandits stop climbing: bandits are afraid of the '
          'mountain in the dark too. Something else climbs.',
      conversacion: [
        Dicho(
          '',
          '(The shadows in the courtyard stopped matching the courtyard.)',
        ),
        Dicho('Rookie', 'There is nobody there.'),
        Dicho('Rookie', 'There is nobody there.'),
      ],
    ),

    // ---------------------------------------------------------------- bosses
    '30_fin_ocaso.png': TextoPanel(
      narracion:
          'You held the whole Dusk, the ones wearing your face included. The '
          'mountain went quiet.',
      conversacion: [
        Dicho('Rookie', 'It is over.'),
        Dicho('', '(It was not over.)'),
      ],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: 'Three knocks on the gate. Not one of them asked permission.',
      conversacion: [
        Dicho('', '(One.)'),
        Dicho('', '(Two.)'),
        Dicho('', '(Three.)'),
        Dicho('Rookie', 'All right. Come in.'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion:
          'The Great Illegal Martial Arts Tournament needs a venue. They came '
          'for yours.',
      conversacion: [
        Dicho('The Champions', 'We were told nobody was here.'),
        Dicho('Rookie', 'You were told wrong.'),
      ],
    ),

    // --------------------------------------------------------------- victory
    '40_victoria_campeones.png': TextoPanel(
      narracion:
          'Both Champions left the way they came. One of them limping.',
      conversacion: [
        Dicho('Rookie', 'The temple is not for sale.'),
        Dicho('', '(Mei came down from the roof for the first time all day.)'),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion:
          'When the deadline was up, Shifu came back. Same hat, same bag, '
          'same face.',
      conversacion: [
        Dicho('Shifu', 'The courtyard is swept. The temple stands. Good.'),
        Dicho('Rookie', 'It was quiet.'),
        Dicho('Shifu', 'Mm.'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'Then he opened the cupboard.',
      conversacion: [
        Dicho('Shifu', 'Two are missing.'),
        Dicho('Rookie', 'Mei.'),
        Dicho('Mei', '(was no longer in frame)'),
      ],
    ),

    // ---------------------------------------------------------------- defeat
    '50_derrota_patio.png': TextoPanel(
      narracion:
          'You have nothing left. No Energy, no techniques, no excuses.',
      conversacion: [
        Dicho('', '(The gate stayed open. Nobody closed it.)'),
      ],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: 'Shifu came back on time, as always.',
      conversacion: [
        Dicho('Shifu', '...'),
        Dicho('Rookie', 'I can explain.'),
        Dicho('Shifu', '...'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'And then he asked the only question that mattered.',
      conversacion: [
        Dicho('Shifu', 'And the cookies?'),
        Dicho('', '(That was the hard part to explain.)'),
      ],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: 'No meditating',
      nota: 'Meditation is overrated. Live with the deck you have.',
      recompensa: '+2 starting Energy tomorrow',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: 'Finish in one piece',
      nota:
          'A guardian who wins and then collapses in the courtyard is no '
          'use to me.',
      recompensa: '+2 starting Energy tomorrow',
    ),
    'alba_impecable': TextoEncargo(
      titulo: 'A flawless Dawn',
      nota: "If a mosquito beats you, I don't want to hear about the rest.",
      recompensa: 'Meditating is free tomorrow',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: 'No overspending',
      nota: 'Energy does not grow on bamboo. Make do with what you get.',
      recompensa: '+1 free card on every danger tomorrow',
    ),
    'purga_profunda': TextoEncargo(
      titulo: 'Clean up your technique',
      nota: 'Get rid of those doubts. All of them. Today.',
      recompensa: 'Meditating removes 2 cards tomorrow',
    ),
    'partida_corta': TextoEncargo(
      titulo: 'Quick and clean',
      nota:
          "The temple won't defend itself, but you don't have all day either.",
      recompensa: '+3 starting Energy tomorrow',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: 'Lose less',
      nota: 'Losing three times is learning. Losing eight is something else.',
      recompensa: '+2 starting Energy tomorrow',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: 'Noon without a scratch',
      nota:
          'The ones who come at noon get paid to show up. Make sure they '
          'do not get paid.',
      recompensa: '+1 free card on every danger tomorrow',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: 'Champions in one go',
      nota: 'Champions are beaten once. Repeating is bad manners.',
      recompensa: '+3 starting Energy tomorrow',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: 'Have some left over',
      nota: 'I want to find the temple standing and you still up for sweeping.',
      recompensa: 'Energy cap +5 tomorrow',
    ),
    'sin_curarse': TextoEncargo(
      titulo: 'Hold out unaided',
      nota: 'Sacred water is for fires, not for your excuses.',
      recompensa: '+1 free card on every danger tomorrow',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: 'On the edge',
      nota: 'Winning on five Energy takes more merit. And less common sense.',
      recompensa: '+4 starting Energy tomorrow',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: 'Dawn',
      queCartasLleva: 'The 10 danger/technique cards of the Dawn deck',
      descripcion:
          'Carved lotus centred, sun rising low on the horizon '
          'behind it.',
    ),
    'Mediodía': TextoReverso(
      nombre: 'Noon',
      queCartasLleva: 'The 10 danger/technique cards of the Noon deck',
      descripcion: 'Same lotus, sun high and full behind it.',
    ),
    'Ocaso': TextoReverso(
      nombre: 'Dusk',
      queCartasLleva: 'The 10 danger/technique cards of the Dusk deck',
      descripcion: 'Same lotus, sun sinking behind it, long shadows.',
    ),
    'Jefes': TextoReverso(
      nombre: 'Champions',
      queCartasLleva: 'The 5 Tournament Champion cards',
      descripcion:
          'Black lotus, heavier border, no sun. It must feel weightier '
          'than the other three.',
    ),
    'Combate': TextoReverso(
      nombre: 'Combat',
      queCartasLleva: 'The 20 starting techniques',
      descripcion:
          'Simple lotus, plain pattern, no sun. This is the deck the '
          'player holds all game: keep it quiet.',
    ),
  },
);
