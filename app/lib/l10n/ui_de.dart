// Textos de la interfaz en alemán: du, informal.
//
// Las claves y los `{placeholders}` son los de `ui_es.dart`, que es el mapa
// base. Si falta una clave o sobra un hueco, `bin/check.dart` lo detecta.
//
// Es el idioma más largo de los siete. Cuando una caja de la interfaz no da,
// no da acá primero: las etiquetas de botón se eligieron cortas a propósito.

const uiDe = <String, String>{
  // navegación
  'nav.inicio': 'Start',
  'nav.volver': 'Zurück',
  'medita.confirmar': '{carta} entfernen?',
  'medita.confirmarSub':
      'Sie verlässt das Spiel für immer. Sie kommt nicht ins Deck zurück.',
  'medita.eliminar': 'Entfernen',
  'logro.primer_dia.titulo': 'Erster Tag',
  'logro.primer_dia.desc': 'Du hast deine erste Partie gewonnen.',
  'logro.sin_una_derrota.titulo': 'Ohne einen Kratzer',
  'logro.sin_una_derrota.desc':
      'Du hast gewonnen, ohne einen einzigen Kampf zu verlieren.',
  'logro.mente_limpia.titulo': 'Klarer Kopf',
  'logro.mente_limpia.desc':
      'Du hast gewonnen, nachdem du 8 Karten oder mehr entfernt hast.',
  'logro.nada_que_soltar.titulo': 'Nichts loszulassen',
  'logro.nada_que_soltar.desc':
      'Du hast gewonnen, ohne ein einziges Mal zu meditieren.',
  'logro.pulmon.titulo': 'Lunge',
  'logro.pulmon.desc': 'Du hast mit 12 Energie oder mehr gewonnen.',
  'logro.por_un_pelo.titulo': 'Um Haaresbreite',
  'logro.por_un_pelo.desc': 'Du hast mit 2 Energie oder weniger gewonnen.',
  'logro.sin_pagar_nada.titulo': 'Ohne zu zahlen',
  'logro.sin_pagar_nada.desc':
      'Du hast gewonnen, ohne Energie fürs Ziehen auszugeben.',
  'logro.relampago.titulo': 'Blitz',
  'logro.relampago.desc': 'Du hast in 20 Zügen oder weniger gewonnen.',
  'logro.alba_intacta.titulo': 'Morgen makellos',
  'logro.alba_intacta.desc':
      'Du bist durch den Morgen gekommen, ohne einen Kampf zu verlieren.',
  'logro.tres_jefes.titulo': 'Alle drei',
  'logro.tres_jefes.desc': 'Du hast eine Partie mit drei Endgegnern gewonnen.',
  'logro.contra_el_cansancio.titulo': 'Gegen die Müdigkeit',
  'logro.contra_el_cansancio.desc':
      'Du hast mit aktivem Müdigkeitsdeck gewonnen.',
  'logro.alumno_aplicado.titulo': 'Fleißiger Schüler',
  'logro.alumno_aplicado.desc': 'Du hast einen Auftrag von Shifu erfüllt.',
  'logro.maraton.titulo': 'Marathon',
  'logro.maraton.desc': 'Du hast 25 Partien gespielt.',
  'logro.perseverante.titulo': 'Beharrlich',
  'logro.perseverante.desc': 'Du hast 10-mal verloren und weitergespielt.',
  'logro.racha7.titulo': 'Wächter des Tempels',
  'logro.racha7.desc': 'Sieben Tage in Folge den Tempel verteidigt.',
  'nav.logros': 'Aufträge',
  'nav.modos': 'Modi',
  'nav.ajustes': 'Einstellungen',
  'coleccion.iniciales': 'Startdeck',
  'coleccion.girar': 'Karte drehen',
  'nav.contenido': 'Inhalt',
  'logros.titulo': 'Aufträge und Erfolge',
  'logros.contador': '{a} von {b} freigeschaltet',
  'logros.bloqueado': 'Noch nicht geschafft.',
  'logros.nuevo': 'Erfolg freigeschaltet!',
  'modos.titulo': 'Bevor es losgeht',
  'modos.dificultad': 'Der Weg',
  'modos.jefes': 'Endgegner',
  'modos.extras': 'Zusatzregeln',
  'modos.empezar': 'Los',
  'modos.jefesAuto': 'Auto',
  'modos.energia': '{n} Energie',
  'modos.jefes1': 'Ein Endgegner',
  'modos.jefesN': '{n} Endgegner',
  'modos.peligros': '{n} Gefahren pro Phase',
  'modos.roboExtra': 'Extrakarte: {n}',
  'modos.cansFase': 'Müdigkeit am Ende jeder Phase',
  'modos.cansBarajar': 'Müdigkeit beim Mischen',
  'modos.cansAmbos': 'Müdigkeit am Phasenende und beim Mischen',
  'dif.aprendiz': 'Lehrling',
  'dif.aprendizSub': 'Um das Spiel ohne Leiden zu lernen.',
  'dif.novato': 'Neuling',
  'dif.novatoSub': 'Du weißt schon, was zu tun ist. Weh tut es trotzdem.',
  'dif.guardian': 'Wächter',
  'dif.guardianSub': 'Das Spiel, wie es austariert wurde.',
  'dif.maestro': 'Meister',
  'dif.maestroSub': 'Hier fängt der Körper an zu wiegen.',
  'dif.sombraDeShifu': 'Shifus Schatten',
  'dif.sombraDeShifuSub': 'Fast er. Fast.',
  'dif.shifu': 'Shifu',
  'dif.shifuSub': 'Der unmögliche Tag. Noch hat ihn niemand geschafft.',
  'modos.encargosT': 'Shifus Aufträge',
  'modos.encargosSub':
      'Shifu hinterlässt einen Zettel mit einer Zusatzbedingung. Sie gilt den '
      'ganzen Tag und wechselt morgen. Wenn du gewinnst und sie erfüllst, '
      'startet deine nächste Partie mit einem Vorteil.',
  'modos.encargoHoy': 'Der Zettel von heute',
  'modos.encargoPremio': 'Wenn du sie erfüllst und gewinnst: {r}',
  'modos.encargoApagado': 'Schalt es ein, um den Zettel von heute zu sehen.',
  'modos.cansancioT': 'Müdigkeitsdeck',
  'modos.cansancioSub':
      'Es schleichen sich Ermüdungskarten ein. Deutlich schwerer.',
  'modos.loTraeElCamino': 'Der Weg {n} bringt das schon mit.',
  // la tienda
  'tienda.titulo': 'Der ganze Tempel',
  'tienda.gancho': 'Eine einzige Zahlung. Alles offen, nie wieder Werbung.',
  'tienda.caminos': 'Die sechs Wege',
  'tienda.sinAvisos': 'Keine Werbung',
  'tienda.extras': 'Aufträge und Müdigkeit',
  'tienda.jefesLibres': 'Du wählst die Endgegner',
  'tienda.comprar': 'Tempel öffnen',
  'tienda.comprarPrecio': 'Tempel öffnen · {precio}',
  'tienda.restaurar': 'Kauf wiederherstellen',
  'tienda.restaurarSub':
      'Falls du ihn schon gekauft und die App neu installiert hast.',
  'privacidad.titulo': 'Datenschutz',
  'privacidad.opciones': 'Datenschutzoptionen',
  'privacidad.opcionesSub': 'Deine Wahl zur Werbung ändern.',
  'privacidad.politica': 'Datenschutzerklärung',
  'privacidad.politicaSub':
      'Was das Spiel speichert und was nicht. Öffnet im Browser.',
  'tienda.bloqueado': 'Wird mit dem ganzen Tempel freigeschaltet.',
  'tienda.verMas': 'Ansehen, was dabei ist',
  'tienda.gracias': 'Danke. Der Tempel gehört dir.',
  'tienda.noDisponible': 'Der Store antwortet nicht. Versuch es später.',
  'tienda.pensando': 'Einen Moment…',
  'ajustes.titulo': 'Einstellungen',
  'ajustes.musica': 'Musik',
  'ajustes.efectos': 'Soundeffekte',
  'ajustes.sobre': 'Der Wächter des Tempels — Schiefer Lotos',
  'patio.jugar': 'Spielen',
  'patio.rachaCorta': 'Serie {a}/{b}',
  'nav.bitacora': 'Logbuch',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano':
      'Du hast den Kampf gewonnen: meditieren geht nur nach einer Niederlage. (Lässt sich unter Balance ändern.)',
  'medita.motivoVacio':
      'Dein Ablagestapel ist leer: es gibt keine Karte zum Entfernen.',
  'medita.motivoEnergia': 'Du brauchst mehr als {n} Energie zum Meditieren.',
  'medita.explica':
      'Wähl eine Karte, die aus dem Spiel soll (−{coste} Energie).',
  'encargo.beneficio': 'Vorteil von gestern angewendet: {b}',
  'encargo.titulo': 'Auftrag: {t}',
  'encargo.cumplido': 'Erfüllt. Morgen startest du mit: {r}.',
  'encargo.fallado':
      'Du hast ihn nicht erfüllt. Shifu sagt nichts, was schlimmer ist.',
  'juego.poderBase': 'Grundkraft {a} · um {b} gesenkt',
  'juego.teEspera': 'Auf dich wartet {n}.',
  'juego.sinPeligro':
      'Keine Gefahr aufgedeckt. Dreh die oberste Karte des {fase}-Decks um.',
  'juego.revelar': 'Aufdecken',
  'juego.enfrentarJefe': 'Endgegner stellen',
  'juego.finGano': 'Shifus Kekse sind noch unangetastet.',
  'juego.finPerdio': 'Du bist am {fase} mit {n} Energie gefallen.',
  'juego.resGanados': 'Gewonnen {n}',
  'juego.resPerdidos': 'Verloren {n}',
  'juego.resEliminadas': 'Entfernte Karten {n}',
  'juego.resEnergiaRobos': 'Energie fürs Ziehen {n}',
  'juego.resCansancio': 'Angesammelte Müdigkeit {n}',
  'juego.semanaCompleta': 'Woche komplett! Erfolg geschafft',
  'juego.diaMarcado': 'Tag eingetragen · Serie {a}/{b}',
  'nav.jugar': 'Spielen',
  'nav.progreso': 'Fortschritt',
  'progreso.logroTitulo': 'Woche komplett!',
  'nav.balance': 'Balance',
  'nav.simulador': 'Simulator',
  'nav.reglas': 'Regeln',

  // partida
  'juego.empezar': 'Partie starten',
  'juego.nueva': 'Neue Partie',
  'juego.robarGratis': 'Ziehen',
  'juego.robarPago': 'Ziehen (−{n})',
  'juego.resolverGanas': 'Auswerten',
  'juego.rendirse': 'Aufgeben',
  'juego.jefeNoSeRinde': 'Vor ihm gibt es kein Weglaufen',
  'juego.jefeTeVence': 'Er besiegt dich',
  'juego.rendirseConfirmar': 'Aufgeben?',
  'juego.rendirseConfirmarSub':
      'Du verlierst {n} Energie und die Gefahr behält ihre Technik. '
      'Das lässt sich nicht rückgängig machen.',
  'juego.rendirseTeMata': 'Aufgeben beendet die Partie',
  'juego.rendirseTeMataSub':
      'Die Gefahr nimmt dir {n} Energie, und du hast {e}. Hier fällt der '
      'Tempel: das lässt sich nicht rückgängig machen.',
  'juego.rendirseAlBordeSub':
      'Du verlierst {n} Energie und stehst bei null: noch auf den Beinen, '
      'aber der nächste Schlag wirft dich um.',
  'juego.rendirseSeguir': 'Weiterkämpfen',
  'juego.continuarPeligro': 'Weiter',
  'juego.diario': 'Tagebuch des Neulings',
  'juego.peligrosRestantes': 'Verbleibende Gefahren {n}',
  'juego.jefes': 'Endgegner {a}/{b}',
  'juego.mazo': 'Deck {n}',
  'juego.barajando': 'Du mischst den Ablagestapel',
  'juego.barajandoSub': 'Das Deck entsteht in neuer Reihenfolge',
  'juego.cansancioEntra': 'Die Müdigkeit sammelt sich an',
  'juego.cansancioSub': 'Sie wird in dein Deck gemischt',
  'juego.descarte': 'Ablage {n}',
  'juego.eliminadas': 'Entfernt {n}',
  'juego.racha': 'Serie {a}/{b}',
  'juego.danoSiPerdes': 'Schaden bei Niederlage: {n}',
  'juego.cartasGratis': 'Gratiskarten: {a}/{b}',
  'juego.recompensa': 'Belohnung: ',
  'juego.enMesa': 'Im Spiel ({n} Karten · Summe {s})',
  'juego.tuSumaGana':
      'Deine Summe {s} ≥ {o} — du gewinnst, wenn du jetzt auswertest.',
  'juego.tuSumaFalta': 'Deine Summe {s} · dir fehlen {f}.',
  'juego.ganaste': 'Du hast den Tempel beschützt!',
  'juego.perdiste': 'Der Tempel ist gefallen',
  'juego.turnos': 'Züge {n}',

  // meditar

  // cómic
  'comic.saltar': 'Überspringen',
  'comic.siguiente': 'Weiter',
  'comic.anterior': 'Zurück',
  'comic.continuar': 'Weiter',
  'comic.verResumen': 'Zusammenfassung ansehen',
  'comic.enfrentar': 'Den Champions entgegentreten',
  'comic.seguir': 'Weiterspielen',
  'comic.ilustracion': 'ILLUSTRATION',

  // progreso
  'progreso.titulo': 'Die Woche des Wächters',
  'progreso.explicacion':
      'Gewinn eine Partie pro Tag. Der nächste Tag wird erst frei, wenn das '
      'Datum wechselt. Vergeht ein ganzer Tag ohne Sieg, reißt die Kette und '
      'du musst alle sieben neu machen.',
  'progreso.dia': 'Tag {n}',
  'progreso.hecho': 'Der Tempel hat heute gehalten.',
  'progreso.pendiente': 'Der Tempel ist heute noch nicht verteidigt.',
  'progreso.volveManana': 'Komm morgen für Tag {n} wieder.',
  'progreso.ganaHoy': 'Gewinn eine Partie, um Tag {n} einzutragen.',
  'progreso.rachaActual': 'Aktuelle Serie {a}/{b}',
  'progreso.mejorRacha': 'Beste Serie {n}',
  'progreso.semanas': 'Abgeschlossene Wochen {n}',
  'progreso.logro': 'Wächter des Tempels',
  'progreso.logroSub':
      'Sieben Tage in Folge. Shifu wird es nie erfahren, du schon.',
  'progreso.perderCorta': 'Eine verlorene Partie reißt die Serie auch',
  'progreso.perderCortaSub':
      'Aus: Du kannst es am selben Tag beliebig oft versuchen. '
      'An: Eine Niederlage setzt dich auf null zurück.',
  'progreso.reiniciar': 'Serie zurücksetzen',
  'progreso.aviso':
      'Der Fortschritt wird auf diesem Gerät gespeichert und nutzt dessen '
      'Uhr: wer das Systemdatum ändert, überspringt die Wartezeit.',
  'progreso.encargoHoy': 'Auftrag von heute: {t}',
  'progreso.recompensa': 'Belohnung: {r}',

  // tutorial
  'tutorial.titulo': 'So wird gespielt',
  'tutorial.siguiente': 'Weiter',
  'tutorial.saltar': 'Überspringen',
  'tutorial.terminar': 'Losspielen',
  'tutorial.ver': 'Tutorial ansehen',
  'tutorial.tuTurno': 'Tipp auf die hervorgehobene Schaltfläche',

  // ajustes
  'ajustes.idioma': 'Sprache',
  'ajustes.idiomaSistema': 'Die des Systems',
  'ajustes.salir': 'Partie verlassen?',
  'ajustes.salirSub': 'Du verlierst den Fortschritt dieser Partie.',
  'ajustes.cancelar': 'Abbrechen',
  'ajustes.salirOk': 'Verlassen',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'Das ist deine Energie. Sie ist das Einzige, was dich im Spiel hält: '
      'fällt sie unter null, ist Schluss. Bei null zu stehen scheidet dich '
      'nicht aus, aber der nächste Treffer schon.',
  'tutorial.p02':
      'Das ist die Gefahr, die dir begegnet. Die große Zahl ist ihre Kraft: '
      'die musst du mit Karten erreichen oder übertreffen.',
  'tutorial.p03':
      'Das gebrochene Herz zeigt, wie viel Energie du verlierst, wenn du '
      'diese Zahl nicht erreichst. Hier also zwei.',
  'tutorial.p04':
      'Und das ist die Zahl, auf die du am meisten schaust: wie viele Karten '
      'du GRATIS ziehen darfst. Sind sie aufgebraucht, kostet jede weitere '
      'Karte Energie.',
  'tutorial.p05':
      'Schau dir diese Linie an: sie teilt die Karte in der Mitte. Oben die '
      'Gefahr, der du gegenüberstehst. Unten die Technik, die du bekommst, '
      'wenn du sie besiegst.',
  'tutorial.p06':
      'Und ja, die untere Hälfte ist auf dem Kopf gedruckt. Das ist Absicht: '
      'wenn du gewinnst, drehst du die Karte um und diese Hälfte steht '
      'richtig herum. Mehr heißt "eine Karte gewinnen" nicht.',
  'tutorial.p07': 'Probieren wir es. Zieh deine erste Karte.',
  'tutorial.p08':
      'Da ist sie: ihre Kraft wurde zu deiner Summe addiert. Sieh auf den '
      'Balken, er sagt dir, wie viel dir fehlt.',
  'tutorial.p09': 'Das reicht noch nicht. Zieh noch eine.',
  'tutorial.p10': 'Geschafft. Wert den Kampf aus.',
  'tutorial.p11':
      'Du hast gewonnen, und das ist das Wichtige: die Gefahrenkarte wird '
      'umgedreht und die Technik auf der anderen Seite gehört jetzt dir. So '
      'baut man das Deck auf. Weiter.',
  'tutorial.p12': 'Neue Gefahr, härter. Zieh deine Gratiskarten.',
  'tutorial.p13':
      'Das war nichts. Hier entscheidet sich das Spiel: weiterziehen kostet '
      '1 Energie pro Karte, und du weißt nicht, was kommt. Gib diesmal auf.',
  'tutorial.p14':
      'Du hast Energie verloren und die Karte NICHT bekommen: Aufgeben bringt '
      'nie die Belohnung. Aber Verlieren öffnet die einzige Tür, um das Deck '
      'zu säubern. Entferne die Sinnkrise.',
  'tutorial.p15':
      'Das ist Meditieren: du zahlst Energie und nimmst eine schlechte Karte '
      'für immer aus dem Spiel. Ein kleineres Deck lässt die guten öfter '
      'kommen.\n\n'
      'Eine echte Partie sind drei Phasen —Morgen, Mittag und Abend— und am '
      'Ende kommen zwei Champions. Viel Glück.',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': 'Ziel',
  'reglas.objetivo.l1':
      'Du überstehst drei Gefahrenphasen (Morgen, Mittag, Abend) und '
      'verbesserst dabei dein Technikdeck; danach trittst du gegen die '
      'Champions des Turniers an.',
  'reglas.objetivo.l2':
      'Wie viele Champions du bekommst, entscheidet die Schwierigkeit, die '
      'du wählst.',
  'reglas.objetivo.l3':
      'Du verlierst, wenn deine Energie 0 oder weniger erreicht.',
  'reglas.preparacion.titulo': 'Vorbereitung',
  'reglas.preparacion.l1': 'Misch das Startkampfdeck ({cartas} Karten).',
  'reglas.preparacion.l2':
      'Trenn die drei Gefahrendecks und zieh zufällig die Endgegner, die '
      'dein Level verlangt: {jefes} in dieser Konfiguration.',
  'reglas.preparacion.l3':
      'Du startest in dieser Konfiguration mit {inicial} Energie (Obergrenze '
      'beim Heilen: {maxima}).',
  'reglas.turno.titulo': 'Zug',
  'reglas.turno.l1':
      '1. Deck die oberste Gefahr des Decks der aktuellen Phase auf.',
  'reglas.turno.l2Ilimitado':
      '2. Zieh Kampfkarten einzeln und kostenlos, so lange du willst.',
  'reglas.turno.l2Limitado':
      '2. Zieh gratis bis zur Zahl der "Gratiskarten" der Gefahr. Jede '
      'weitere Karte kostet {coste} Energie.',
  'reglas.turno.l3':
      '3. Addier die Kraft der gespielten Karten und vergleich sie mit der '
      'Kraft der Gefahr.',
  'reglas.turno.l4':
      '4. Ist deine Summe ≥ der Gefahr, gewinnst du: die Gefahrenkarte '
      'kommt als Belohnungstechnik in deine Ablage.',
  'reglas.turno.l5Sale':
      '5. Verlierst du, ziehst du den Schaden der Gefahr von deiner Energie '
      'ab und die Gefahrenkarte verlässt das Spiel.',
  'reglas.turno.l5Vuelve':
      '5. Verlierst du, ziehst du den Schaden der Gefahr von deiner Energie '
      'ab und die Karte kommt unter das Deck zurück.',
  'reglas.turno.l6':
      '6. Alle gespielten Karten wandern in die Ablage. Ist das Deck leer, '
      'misch die Ablage.',
  'reglas.combate.titulo': 'Einen Kampf gewinnen oder verlieren (wichtig)',
  'reglas.combate.l1':
      'DU GEWINNST, wenn die Summe deiner Karten ≥ der Kraft der Gefahr ist. '
      'Die Gefahrenkarte wird umgedreht und kommt als Belohnungstechnik in '
      'deinen Ablagestapel: ab da ist sie eine Karte deines Decks.',
  'reglas.combate.l2':
      'DU VERLIERST, wenn du unter der Kraft stehen bleibst. Du ziehst den '
      'Schaden der Gefahr von deiner Energie ab und die Gefahrenkarte '
      'verlässt das Spiel: du bekommst sie NICHT. Man gewinnt nie eine Karte, '
      'indem man einen Kampf verliert.',
  'reglas.combate.l3':
      'Unter der Kraft stehen zu bleiben ist kein "Preis", den du zahlst, um '
      'die Karte zu behalten: es ist Aufgeben. Manchmal lohnt es sich '
      'trotzdem, wenn weitere Züge mehr Energie kosten würden als der '
      'Schaden selbst.',
  'reglas.combate.l4':
      'Ob Sieg oder Niederlage: alle gespielten Karten wandern in deine '
      'Ablage.',
  'reglas.energia.titulo': 'Wie man Energie zurückbekommt',
  'reglas.energia.l1':
      'Es gibt keine Aktion zum Heilen: du kannst weder "rasten" noch einen '
      'Zug fürs Erholen ausgeben.',
  'reglas.energia.l2':
      'Energie steigt NUR durch Effekte von Kampfkarten, und diese Effekte '
      'lösen automatisch aus, wenn die Karte im Kampf erscheint. Du wählst '
      'nicht, wann du sie einsetzt.',
  'reglas.energia.l3':
      'Effekt "+X Energie": wirkt in dem Moment, in dem du die Karte ziehst, '
      'egal ob du danach gewinnst oder verlierst. Z.B.: Reflex +1, Disziplin '
      '+2, Drachenschuppe +1, Drachenfaust +2, Gelassenheit +3, Heiliges '
      'Wasser +2, Erleuchtung +1.',
  'reglas.energia.l4':
      'Effekt "+X Energie bei Sieg": wirkt erst beim Auswerten, und nur wenn '
      'du diesen Kampf gewonnen hast. Z.B.: Bambusfaust +1, Kranichflügel '
      '+1, Kranichflug +2.',
  'reglas.energia.l5':
      'Die Obergrenze von {maxima} Energie überschreitest du nie: was '
      'darüber liegt, verfällt.',
  'reglas.energia.l6':
      'Folge aus dem Design: Heilung hängt davon ab, ob du Heilkarten ins '
      'Deck gebracht hast und ob sie kommen. Darum lohnt es sich, zu '
      'meditieren und schlechte Karten zu entfernen: ein kleineres Deck '
      'lässt die guten öfter erscheinen.',
  'reglas.meditar.titulo': 'Meditieren: schlechte Karten aus dem Deck nehmen',
  'reglas.meditar.l1':
      'Meditieren ist der EINZIGE Weg, Karten aus deinem Deck zu nehmen. Es '
      'gibt keinen anderen.',
  'reglas.meditar.cuandoSoloAlPerder':
      'Wann: nur im Schritt nach einem Kampf, den du VERLOREN hast.',
  'reglas.meditar.cuandoSiempre':
      'Wann: im Schritt nach jedem Kampf, ob gewonnen oder verloren.',
  'reglas.meditar.l3Una':
      'Wie: zahl {coste} Energie und entferne eine Karte aus deinem '
      'Ablagestapel. Sie verlässt das Spiel für immer: sie kommt nicht ins '
      'Deck zurück.',
  'reglas.meditar.l3':
      'Wie: zahl {coste} Energie und entferne {cartas} Karte(n) aus deinem '
      'Ablagestapel. Sie verlassen das Spiel für immer: sie kommen nicht ins '
      'Deck zurück.',
  'reglas.meditar.l4':
      'Du kannst das mehrmals hintereinander machen und jedes Mal zahlen, '
      'solange dir Energie bleibt.',
  'reglas.meditar.l5':
      'ENTSCHEIDENDE EINSCHRÄNKUNG: du kannst nur Karten entfernen, die in '
      'der ABLAGE liegen. Eine Sinnkrise, die noch im Deck vergraben ist, '
      'ist unantastbar: sie muss erst in einem Kampf erscheinen. Darum ist '
      'der beste Moment zum Meditieren direkt nach einem Kampf, in dem deine '
      'schlechtesten Karten kamen: alles, was du gerade gespielt hast, liegt '
      'in der Ablage.',
  'reglas.meditar.l6':
      'Ist das Deck leer, wird die Ablage gemischt und wird wieder zum Deck: '
      'dann ist die Gelegenheit vorbei, diese Karten loszuwerden, bis sie '
      'wieder erscheinen.',
  'reglas.meditar.l7':
      'Warum es sich lohnt: eine Sinnkrise (-1) oder eine Kurzatmigkeit (0) '
      'zu entfernen hebt deine Gesamtkraft nicht, aber es verkleinert das '
      'Deck und lässt die guten Karten (und die, die Energie geben) öfter '
      'kommen.',
  'reglas.final.titulo': 'Letztes Duell',
  'reglas.final.l1':
      'Deck die Endgegner auf und tritt der Reihe nach gegen sie an, wie '
      'gegen eine normale Gefahr.',
  'reglas.final.l2':
      'Gegen einen Endgegner kannst du nicht aufgeben: solange dir eine '
      'Karte zum Ziehen bleibt, kämpfst du. Verlierst du, ziehst du seinen '
      'Schaden ab und trittst erneut an.',
  'reglas.final.l3': 'Du gewinnst die Partie, wenn du den letzten besiegst.',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': 'Zieh {n}',
  'efecto.energia': '{n} {recurso}',
  'efecto.energiaSiGanas': '{n} {recurso} bei Sieg',
  'efecto.reducePeligro': '-{n} auf die Gefahr',
  'reglas.ui.bajada': 'Zeigt die Werte, die du unter Balance eingestellt hast.',
  'reglas.ui.mazoDe': '{fase}-Deck',
  'reglas.ui.peligro':
      '{nombre} — Kraft {poder}, Schaden {dano}, gratis {gratis} → {tecnica} '
      '({tecnicaPoder})',
  'reglas.ui.jefes': 'Endgegner',
  'reglas.ui.jefe': '{nombre} — Kraft {poder}, Schaden {dano}, gratis {gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': 'Energie',
  'log.arranca': 'Meister Shifu ist fort. Der Morgen beginnt.',
  'log.jefeFinal': 'ENDGEGNER: {nombre} (Kraft {poder}, Schaden {dano})',
  'log.peligro': 'Gefahr: {nombre} (Kraft {poder}, Schaden {dano})',
  'log.pagasRobo': 'Du zahlst {n} {recurso} für eine Extrakarte.',
  'log.barajas': 'Du mischst die Ablage, um das Deck neu zu bilden.',
  'log.energia': '{carta}: {n} {recurso}.',
  'log.topado': '(gedeckelt bei {max})',
  'log.bajaPeligro': '{carta}: die Gefahr verliert {n} Kraft.',
  'log.siGanas': '{carta}: wenn du diesen Kampf gewinnst, {n} {recurso}.',
  'log.sinEnergia': 'Dir ist die {recurso} ausgegangen. Der Tempel fällt.',
  'log.efectosVictoria': 'Siegeseffekte: {n} {recurso} ({detalle}).',
  'log.derrotasteJefe': 'Du hast {nombre} besiegt! ({suma} vs {poder})',
  'log.ganaste':
      'Gewonnen! ({suma} vs {poder}) Du erhältst {tecnica} ({tecnicaPoder}).',
  'log.perdiste': 'Verloren ({suma} vs {poder}). -{dano} {recurso}.',
  'log.enCero':
      'Du stehst bei 0 {recurso}: du hältst dich noch, aber die nächste '
      'Ausgabe legt dich um.',
  'log.cansancio':
      'Die Müdigkeit sammelt sich an: {carta} ({poder}) kommt in dein Deck.',
  'log.meditas': 'Du meditierst: {carta} verlässt das Spiel.',
  'log.victoria':
      'Du hast den Tempel beschützt! Shifu wird die Sache mit den Keksen nie '
      'erfahren.',
  'log.mediodia': 'Der Mittag bricht an. Jetzt wird es ernst.',
  'log.ocaso': 'Der Abend bricht an. Die wirkliche Gefahr kommt.',
  'log.campeones':
      'Die Champions des Turniers erreichen den Tempel: {nombres}.',
  'log.y': 'und',
};
