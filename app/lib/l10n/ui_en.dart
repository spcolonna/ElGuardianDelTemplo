// Textos de la interfaz en inglés.
//
// Vive aparte de `l10n.dart` porque con siete idiomas el archivo único pasaba
// de las dos mil líneas y el diff de una traducción tapaba cualquier otra cosa.
// La clase y la lógica están en `l10n.dart`; acá no hay más que datos.
//
// Es una adaptación, no una traducción literal: el chiste que no viaja se
// cambia por otro que sí. Lo que no se negocia son las claves ni los
// `{placeholders}`, que `bin/check.dart` compara contra `ui_es.dart`.

const uiEn = <String, String>{
  'nav.inicio': 'Home',
  'nav.volver': 'Back',
  'medita.confirmar': 'Remove {carta}?',
  'medita.confirmarSub': 'It leaves the game for good. It never comes back.',
  'medita.eliminar': 'Remove',
  'logro.primer_dia.titulo': 'First day',
  'logro.primer_dia.desc': 'You won your first run.',
  'logro.sin_una_derrota.titulo': 'Not a scratch',
  'logro.sin_una_derrota.desc': 'You won without losing a single fight.',
  'logro.mente_limpia.titulo': 'Clear mind',
  'logro.mente_limpia.desc': 'You won after removing 8 cards or more.',
  'logro.nada_que_soltar.titulo': 'Nothing to let go',
  'logro.nada_que_soltar.desc': 'You won without meditating once.',
  'logro.pulmon.titulo': 'Deep breath',
  'logro.pulmon.desc': 'You won with 12 Energy or more.',
  'logro.por_un_pelo.titulo': 'By a hair',
  'logro.por_un_pelo.desc': 'You won with 2 Energy or less.',
  'logro.sin_pagar_nada.titulo': 'Nothing paid',
  'logro.sin_pagar_nada.desc': 'You won without spending Energy on draws.',
  'logro.relampago.titulo': 'Lightning',
  'logro.relampago.desc': 'You won in 20 turns or fewer.',
  'logro.alba_intacta.titulo': 'Flawless dawn',
  'logro.alba_intacta.desc': 'You crossed Dawn without losing a fight.',
  'logro.tres_jefes.titulo': 'All three',
  'logro.tres_jefes.desc': 'You won a run with three final bosses.',
  'logro.contra_el_cansancio.titulo': 'Against fatigue',
  'logro.contra_el_cansancio.desc': 'You won with the Fatigue Deck on.',
  'logro.alumno_aplicado.titulo': 'Model student',
  'logro.alumno_aplicado.desc': "You completed one of Shifu's errands.",
  'logro.maraton.titulo': 'Marathon',
  'logro.maraton.desc': 'You played 25 runs.',
  'logro.perseverante.titulo': 'Stubborn',
  'logro.perseverante.desc': 'You lost 10 times and kept playing.',
  'logro.racha7.titulo': 'Guardian of the Temple',
  'logro.racha7.desc': 'Seven days in a row defending the temple.',
  'nav.logros': 'Quests',
  'nav.modos': 'Modes',
  'nav.ajustes': 'Settings',
  'nav.mazo': 'Deck',
  'logros.titulo': 'Quests and achievements',
  'logros.contador': '{a} of {b} unlocked',
  'logros.bloqueado': 'Not earned yet.',
  'logros.nuevo': 'Achievement unlocked!',
  'modos.titulo': 'Before you start',
  'modos.dificultad': 'The path',
  'modos.jefes': 'Final bosses',
  'modos.extras': 'Optional rules',
  'modos.empezar': 'Start',
  'modos.jefesAuto': 'Auto',
  'modos.energia': '{n} Energy',
  'modos.jefesN': '{n} bosses',
  'modos.peligros': '{n} dangers per phase',
  'modos.roboExtra': 'Extra card: {n}',
  'modos.cansFase': 'Fatigue at each phase end',
  'modos.cansBarajar': 'Fatigue on every reshuffle',
  'modos.cansAmbos': 'Fatigue at phase end and on reshuffle',
  'dif.aprendiz': 'Apprentice',
  'dif.aprendizSub': 'Learn the game without suffering.',
  'dif.novato': 'Novice',
  'dif.novatoSub': 'You know what to do. It still hurts.',
  'dif.guardian': 'Guardian',
  'dif.guardianSub': 'The game as it was balanced.',
  'dif.maestro': 'Master',
  'dif.maestroSub': 'This is where the body starts to weigh.',
  'dif.sombraDeShifu': "Shifu's Shadow",
  'dif.sombraDeShifuSub': 'Almost him. Almost.',
  'dif.shifu': 'Shifu',
  'dif.shifuSub': 'The impossible day. Nobody has beaten it yet.',
  'modos.encargosT': "Shifu's errands",
  'modos.encargosSub':
      'Shifu leaves a note with an extra condition. It stays the same all '
      'day and changes tomorrow. Win while meeting it and your next game '
      'starts with an edge.',
  'modos.encargoHoy': "Today's note",
  'modos.encargoPremio': 'Win while meeting it: {r}',
  'modos.encargoApagado': "Turn it on to see today's note.",
  'modos.cansancioT': 'Fatigue Deck',
  'modos.cansancioSub': 'Fatigue cards sneak into your deck. Much harder.',
  'modos.loTraeElCamino': 'The {n} path already includes it.',
  // the shop
  'tienda.titulo': 'The whole temple',
  'tienda.gancho': 'One payment. Everything opens, and the ads are gone.',
  'tienda.caminos': 'All six paths',
  'tienda.sinAvisos': 'No ads',
  'tienda.extras': 'Errands and Fatigue',
  'tienda.jefesLibres': 'You pick the bosses',
  'tienda.comprar': 'Open the temple',
  'tienda.comprarPrecio': 'Open the temple · {precio}',
  'tienda.restaurar': 'Restore purchase',
  'tienda.restaurarSub': 'If you already bought it and reinstalled the app.',
  'privacidad.titulo': 'Privacy',
  'privacidad.opciones': 'Privacy options',
  'privacidad.opcionesSub': 'Change what you chose about ads.',
  'privacidad.politica': 'Privacy policy',
  'privacidad.politicaSub':
      'What the game stores and what it does not. Opens in your browser.',
  'tienda.bloqueado': 'Opens with the whole temple.',
  'tienda.verMas': 'See what you get',
  'tienda.gracias': 'Thank you. The temple is yours.',
  'tienda.noDisponible': 'The store is not answering. Try again later.',
  'tienda.pensando': 'One moment…',
  'ajustes.titulo': 'Settings',
  'ajustes.musica': 'Music',
  'ajustes.efectos': 'Sound effects',
  'ajustes.sobre': 'Guardian of the Temple — Loto Torcido',
  'patio.jugar': 'Play',
  'patio.rachaCorta': 'Streak {a}/{b}',
  'nav.bitacora': 'Log',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano':
      'You won the fight: you can only meditate after losing. (Changeable in Balance.)',
  'medita.motivoVacio':
      'Your discard pile is empty: there is no card you could remove.',
  'medita.motivoEnergia': 'You need more than {n} Energy to meditate.',
  'medita.explica': 'Pick a card to remove from the game (−{coste} Energy).',
  'encargo.beneficio': "Yesterday's benefit applied: {b}",
  'encargo.titulo': 'Errand: {t}',
  'encargo.cumplido': 'Done. Tomorrow you start with: {r}.',
  'encargo.fallado': 'You did not do it. Shifu says nothing, which is worse.',
  'juego.poderBase': 'Base power {a} · reduced by {b}',
  'juego.teEspera': '{n} awaits you.',
  'juego.sinPeligro':
      'No danger revealed. Flip the top card of the {fase} deck.',
  'juego.revelar': 'Reveal',
  'juego.enfrentarJefe': 'Face the boss',
  'juego.finGano': "Shifu's cookies are still intact.",
  'juego.finPerdio': 'You fell in {fase} with {n} Energy.',
  'juego.resGanados': 'Won {n}',
  'juego.resPerdidos': 'Lost {n}',
  'juego.resEliminadas': 'Cards removed {n}',
  'juego.resEnergiaRobos': 'Energy spent drawing {n}',
  'juego.resCansancio': 'Fatigue accumulated {n}',
  'juego.semanaCompleta': 'Week complete! Achievement unlocked',
  'juego.diaMarcado': 'Day marked · streak {a}/{b}',
  'nav.jugar': 'Play',
  'nav.progreso': 'Progress',
  'progreso.logroTitulo': 'Week complete!',
  'nav.balance': 'Balance',
  'nav.simulador': 'Simulator',
  'nav.reglas': 'Rules',

  'juego.empezar': 'Start game',
  'juego.nueva': 'New game',
  'juego.robarGratis': 'Draw',
  'juego.robarPago': 'Draw (−{n})',
  'juego.resolverGanas': 'Resolve',
  'juego.rendirse': 'Give up',
  'juego.jefeNoSeRinde': 'No running',
  'juego.jefeTeVence': 'It beats you',
  'juego.rendirseConfirmar': 'Give up?',
  'juego.rendirseConfirmarSub':
      'You lose {n} Energy and the danger keeps its technique. '
      'There is no going back.',
  'juego.rendirseSeguir': 'Keep fighting',
  'juego.continuarPeligro': 'Continue',
  'juego.diario': "Rookie's Diary",
  'juego.peligrosRestantes': 'Dangers left {n}',
  'juego.jefes': 'Champions {a}/{b}',
  'juego.mazo': 'Deck {n}',
  'juego.barajando': 'You shuffle the discard',
  'juego.barajandoSub': 'The deck is rebuilt in a new order',
  'juego.cansancioEntra': 'Fatigue builds up',
  'juego.cansancioSub': 'Shuffled into your deck',
  'juego.descarte': 'Discard {n}',
  'juego.eliminadas': 'Removed {n}',
  'juego.racha': 'Streak {a}/{b}',
  'juego.danoSiPerdes': 'Damage if you lose: {n}',
  'juego.cartasGratis': 'Free cards: {a}/{b}',
  'juego.recompensa': 'Reward: ',
  'juego.enMesa': 'On the table ({n} cards · total {s})',
  'juego.tuSumaGana': 'Your total {s} ≥ {o} — resolve now and you win.',
  'juego.tuSumaFalta': 'Your total {s} · {f} to go.',
  'juego.ganaste': 'You saved the temple!',
  'juego.perdiste': 'The temple fell',
  'juego.turnos': 'Turns {n}',

  'comic.saltar': 'Skip',
  'comic.siguiente': 'Next',
  'comic.anterior': 'Previous',
  'comic.continuar': 'Continue',
  'comic.verResumen': 'See the summary',
  'comic.enfrentar': 'Face the Champions',
  'comic.seguir': 'Keep playing',
  'comic.ilustracion': 'ARTWORK',

  'progreso.titulo': "The Guardian's Week",
  'progreso.explicacion':
      'Win one game per day. The next day does not unlock until the date '
      'changes. If a whole day goes by without a win, the chain breaks '
      'and you start the seven over.',
  'progreso.dia': 'Day {n}',
  'progreso.hecho': 'The temple held today.',
  'progreso.pendiente': 'The temple has not been defended today.',
  'progreso.volveManana': 'Come back tomorrow for day {n}.',
  'progreso.ganaHoy': 'Win a game to mark day {n}.',
  'progreso.rachaActual': 'Current streak {a}/{b}',
  'progreso.mejorRacha': 'Best streak {n}',
  'progreso.semanas': 'Weeks completed {n}',
  'progreso.logro': 'Guardian of the Temple',
  'progreso.logroSub':
      'Seven days straight. Shifu will never know, but you will.',
  'progreso.perderCorta': 'Losing a game also breaks the streak',
  'progreso.perderCortaSub':
      'Off: retry as many times as you like within the day. '
      'On: one loss sends you back to zero.',
  'progreso.reiniciar': 'Reset the streak',
  'progreso.aviso':
      'Progress is stored on this device and uses its clock: changing the '
      'system date skips the wait.',
  'progreso.encargoHoy': "Today's errand: {t}",
  'progreso.recompensa': 'Reward: {r}',

  'tutorial.titulo': 'How to play',
  'tutorial.siguiente': 'Next',
  'tutorial.saltar': 'Skip',
  'tutorial.terminar': 'Start playing',
  'tutorial.ver': 'Replay the tutorial',
  'tutorial.tuTurno': 'Tap the highlighted button',

  'ajustes.idioma': 'Language',
  'ajustes.idiomaSistema': 'System default',
  'ajustes.salir': 'Leave the game?',
  'ajustes.salirSub': 'You will lose this run.',
  'ajustes.cancelar': 'Cancel',
  'ajustes.salirOk': 'Leave',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'This is your Energy. It is the only thing keeping you in the game: if'
      'it drops below zero, you are done. Hitting zero does not kill you, but'
      'the next hit will.',
  'tutorial.p02':
      'This is the danger you are facing. The big number is its Power: that'
      'is what you have to match or beat by adding up cards.',
  'tutorial.p03':
      'The broken heart is the Energy you lose if you fall short of that'
      'number. Two, in this case.',
  'tutorial.p04':
      'And this is the number you will stare at the most: how many cards you'
      'can draw for FREE. Once they run out, every extra card costs Energy.',
  'tutorial.p05':
      'Look at this line: it splits the card in half. The danger you are'
      'facing is on top. The technique you win is at the bottom.',
  'tutorial.p06':
      'And yes, the bottom half is printed upside down. That is on purpose:'
      'when you win, you turn the card around and that half reads right. That'
      'is all "winning a card" means.',
  'tutorial.p07': 'Let us try. Draw your first card.',
  'tutorial.p08':
      'There it is: its Power was added to your total. The bar tells you how'
      'much you still need.',
  'tutorial.p09': 'Not enough yet. Draw another one.',
  'tutorial.p10': 'You made it. Resolve the fight.',
  'tutorial.p11':
      'You won, and here is the key part: the danger card flips over and the'
      'technique on its other side becomes yours. That is how you build your'
      'deck. Carry on.',
  'tutorial.p12': 'A new, tougher danger. Draw your free cards.',
  'tutorial.p13':
      'You drew junk. This is where the game is decided: drawing more costs 1'
      'Energy per card, and you do not know what is coming. This time, give'
      'up.',
  'tutorial.p14':
      'You lost Energy and did NOT get the card: giving up never earns you'
      'the reward. But losing opens the only door to clean your deck. Remove'
      'the Existential Doubt.',
  'tutorial.p15':
      'That is meditating: you pay Energy and remove a bad card from the game'
      'for good. A smaller deck means the good cards come up more often.\n\nA'
      'real game has three phases — Dawn, Noon and Dusk — and two Champions'
      'at the end. Good luck.',
};
