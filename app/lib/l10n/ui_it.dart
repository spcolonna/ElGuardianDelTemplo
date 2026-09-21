// Textos de la interfaz en italiano: tuteo, informal.
//
// Las claves y los `{placeholders}` son los de `ui_es.dart`, que es el mapa
// base. Si falta una clave o sobra un hueco, `bin/check.dart` lo detecta.

const uiIt = <String, String>{
  // navegación
  'nav.inicio': 'Inizio',
  'nav.volver': 'Indietro',
  'medita.confirmar': 'Eliminare {carta}?',
  'medita.confirmarSub': 'Esce dal gioco per sempre. Non torna nel mazzo.',
  'medita.eliminar': 'Elimina',
  'logro.primer_dia.titulo': 'Primo giorno',
  'logro.primer_dia.desc': 'Hai vinto la tua prima partita.',
  'logro.sin_una_derrota.titulo': 'Senza un graffio',
  'logro.sin_una_derrota.desc': 'Hai vinto senza perdere un solo scontro.',
  'logro.mente_limpia.titulo': 'Mente pulita',
  'logro.mente_limpia.desc': 'Hai vinto dopo aver eliminato 8 carte o più.',
  'logro.nada_que_soltar.titulo': 'Niente da lasciare',
  'logro.nada_que_soltar.desc': 'Hai vinto senza meditare nemmeno una volta.',
  'logro.pulmon.titulo': 'Fiato',
  'logro.pulmon.desc': 'Hai vinto con 12 di Energia o più.',
  'logro.por_un_pelo.titulo': 'Per un pelo',
  'logro.por_un_pelo.desc': 'Hai vinto con 2 di Energia o meno.',
  'logro.sin_pagar_nada.titulo': 'Senza pagare niente',
  'logro.sin_pagar_nada.desc': 'Hai vinto senza spendere Energia in pescate.',
  'logro.relampago.titulo': 'Fulmine',
  'logro.relampago.desc': 'Hai vinto in 20 turni o meno.',
  'logro.alba_intacta.titulo': 'Alba intatta',
  'logro.alba_intacta.desc':
      'Hai attraversato l\'Alba senza perdere uno scontro.',
  'logro.tres_jefes.titulo': 'Tutti e tre',
  'logro.tres_jefes.desc': 'Hai vinto una partita con tre boss finali.',
  'logro.contra_el_cansancio.titulo': 'Contro la stanchezza',
  'logro.contra_el_cansancio.desc':
      'Hai vinto con il Mazzo della Stanchezza attivo.',
  'logro.alumno_aplicado.titulo': 'Allievo diligente',
  'logro.alumno_aplicado.desc': 'Hai portato a termine un incarico di Shifu.',
  'logro.maraton.titulo': 'Maratona',
  'logro.maraton.desc': 'Hai giocato 25 partite.',
  'logro.perseverante.titulo': 'Perseverante',
  'logro.perseverante.desc': 'Hai perso 10 volte e hai continuato a giocare.',
  'logro.racha7.titulo': 'Guardiano del Tempio',
  'logro.racha7.desc': 'Sette giorni di fila a difendere il tempio.',
  'nav.logros': 'Missioni',
  'nav.modos': 'Modalità',
  'nav.ajustes': 'Impostazioni',
  'coleccion.iniciales': 'Mazzo iniziale',
  'coleccion.girar': 'Ruota la carta',
  'nav.contenido': 'Contenuti',
  'logros.titulo': 'Missioni e obiettivi',
  'logros.contador': '{a} di {b} sbloccati',
  'logros.bloqueado': 'Non ci sei ancora riuscito.',
  'logros.nuevo': 'Obiettivo sbloccato!',
  'modos.titulo': 'Prima di cominciare',
  'modos.dificultad': 'Il cammino',
  'modos.jefes': 'Boss finali',
  'modos.extras': 'Regole opzionali',
  'modos.empezar': 'Comincia',
  'modos.jefesAuto': 'Auto',
  'modos.energia': '{n} di Energia',
  'modos.jefes1': 'Un boss finale',
  'modos.jefesN': '{n} boss',
  'modos.peligros': '{n} pericoli per fase',
  'modos.roboExtra': 'Carta extra: {n}',
  'modos.cansFase': 'Stanchezza alla chiusura di ogni fase',
  'modos.cansBarajar': 'Stanchezza quando rimescoli',
  'modos.cansAmbos': 'Stanchezza a fine fase e quando rimescoli',
  'dif.aprendiz': 'Apprendista',
  'dif.aprendizSub': 'Per imparare il gioco senza soffrire.',
  'dif.novato': 'Novizio',
  'dif.novatoSub': 'Sai già cosa fare. Fa male lo stesso.',
  'dif.guardian': 'Guardiano',
  'dif.guardianSub': 'Il gioco come è stato bilanciato.',
  'dif.maestro': 'Maestro',
  'dif.maestroSub': 'Qui il corpo comincia a pesare.',
  'dif.sombraDeShifu': 'Ombra di Shifu',
  'dif.sombraDeShifuSub': 'Quasi lui. Quasi.',
  'dif.shifu': 'Shifu',
  'dif.shifuSub': 'Il giorno impossibile. Nessuno l\'ha ancora superato.',
  'modos.encargosT': 'Incarichi di Shifu',
  'modos.encargosSub':
      'Shifu lascia un biglietto con una condizione in più. È lo stesso per '
      'tutto il giorno e cambia domani. Se vinci rispettandola, la tua '
      'prossima partita comincia con un vantaggio.',
  'modos.encargoHoy': 'Il biglietto di oggi',
  'modos.encargoPremio': 'Se vinci rispettandolo: {r}',
  'modos.encargoApagado': 'Attivalo per vedere il biglietto di oggi.',
  'modos.cansancioT': 'Mazzo della Stanchezza',
  'modos.cansancioSub': 'Ti si infilano carte di fatica. Molto più difficile.',
  'modos.loTraeElCamino': 'Il cammino {n} ce l\'ha già di suo.',
  // la tienda
  'tienda.titulo': 'Il tempio completo',
  'tienda.gancho':
      'Un pagamento solo. Si apre tutto e non ci sono più annunci.',
  'tienda.caminos': 'I sei cammini',
  'tienda.sinAvisos': 'Senza pubblicità',
  'tienda.extras': 'Incarichi e Stanchezza',
  'tienda.jefesLibres': 'Scegli tu i boss',
  'tienda.comprar': 'Apri il tempio',
  'tienda.comprarPrecio': 'Apri il tempio · {precio}',
  'tienda.restaurar': 'Ripristina acquisto',
  'tienda.restaurarSub': 'Se l\'hai già comprato e hai reinstallato l\'app.',
  'privacidad.titulo': 'Privacy',
  'privacidad.opciones': 'Opzioni sulla privacy',
  'privacidad.opcionesSub': 'Cambiare quello che hai scelto sugli annunci.',
  'privacidad.politica': 'Informativa sulla privacy',
  'privacidad.politicaSub':
      'Cosa salva il gioco e cosa no. Si apre nel browser.',
  'tienda.bloqueado': 'Si apre con il tempio completo.',
  'tienda.verMas': 'Vedi cosa include',
  'tienda.gracias': 'Grazie. Il tempio è tuo.',
  'tienda.noDisponible': 'Il negozio non risponde. Riprova più tardi.',
  'tienda.pensando': 'Un momento…',
  'ajustes.titulo': 'Impostazioni',
  'ajustes.musica': 'Musica',
  'ajustes.efectos': 'Effetti sonori',
  'ajustes.sobre': 'Il Guardiano del Tempio — Loto Storto',
  'patio.jugar': 'Gioca',
  'patio.rachaCorta': 'Serie {a}/{b}',
  'nav.bitacora': 'Diario di bordo',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano':
      'Hai vinto lo scontro: puoi meditare solo dopo aver perso. (Si può cambiare in Bilanciamento.)',
  'medita.motivoVacio':
      'I tuoi scarti sono vuoti: non c\'è nessuna carta da eliminare.',
  'medita.motivoEnergia': 'Ti serve più di {n} di Energia per meditare.',
  'medita.explica':
      'Scegli una carta da eliminare dal gioco (−{coste} di Energia).',
  'encargo.beneficio': 'Vantaggio di ieri applicato: {b}',
  'encargo.titulo': 'Incarico: {t}',
  'encargo.cumplido': 'Compiuto. Domani cominci con: {r}.',
  'encargo.fallado':
      'Non l\'hai compiuto. Shifu non dice niente, il che è peggio.',
  'juego.poderBase': 'Potere base {a} · ridotto di {b}',
  'juego.teEspera': 'Ti aspetta {n}.',
  'juego.sinPeligro':
      'Nessun pericolo rivelato. Gira la carta in cima al mazzo del {fase}.',
  'juego.revelar': 'Rivela',
  'juego.enfrentarJefe': 'Affronta il boss',
  'juego.finGano': 'I biscotti di Shifu sono ancora intatti.',
  'juego.finPerdio': 'Sei caduto a {fase} con {n} di Energia.',
  'juego.resGanados': 'Vinti {n}',
  'juego.resPerdidos': 'Persi {n}',
  'juego.resEliminadas': 'Carte eliminate {n}',
  'juego.resEnergiaRobos': 'Energia nelle pescate {n}',
  'juego.resCansancio': 'Stanchezza accumulata {n}',
  'juego.semanaCompleta': 'Settimana completa! Obiettivo raggiunto',
  'juego.diaMarcado': 'Giorno segnato · serie {a}/{b}',
  'nav.jugar': 'Gioca',
  'nav.progreso': 'Progressi',
  'progreso.logroTitulo': 'Settimana completa!',
  'nav.balance': 'Bilanciamento',
  'nav.simulador': 'Simulatore',
  'nav.reglas': 'Regole',

  // partida
  'juego.empezar': 'Comincia la partita',
  'juego.nueva': 'Nuova partita',
  'juego.robarGratis': 'Pesca',
  'juego.robarPago': 'Pesca (−{n})',
  'juego.resolverGanas': 'Risolvi',
  'juego.rendirse': 'Arrenditi',
  'juego.jefeNoSeRinde': 'Da lui non si scappa',
  'juego.jefeTeVence': 'Ti batte',
  'juego.rendirseConfirmar': 'Ti arrendi?',
  'juego.rendirseConfirmarSub':
      'Perdi {n} di Energia e il pericolo si tiene la sua tecnica. '
      'Non si torna indietro.',
  'juego.rendirseSeguir': 'Continua a combattere',
  'juego.continuarPeligro': 'Continua',
  'juego.diario': 'Diario del Novizio',
  'juego.peligrosRestantes': 'Pericoli rimasti {n}',
  'juego.jefes': 'Boss {a}/{b}',
  'juego.mazo': 'Mazzo {n}',
  'juego.barajando': 'Rimescoli gli scarti',
  'juego.barajandoSub': 'Il mazzo si rifà in un altro ordine',
  'juego.cansancioEntra': 'La stanchezza si accumula',
  'juego.cansancioSub': 'Viene mescolata nel tuo mazzo',
  'juego.descarte': 'Scarti {n}',
  'juego.eliminadas': 'Eliminate {n}',
  'juego.racha': 'Serie {a}/{b}',
  'juego.danoSiPerdes': 'Danno se perdi: {n}',
  'juego.cartasGratis': 'Carte gratis: {a}/{b}',
  'juego.recompensa': 'Ricompensa: ',
  'juego.enMesa': 'In tavola ({n} carte · somma {s})',
  'juego.tuSumaGana': 'La tua somma {s} ≥ {o} — vinci se risolvi adesso.',
  'juego.tuSumaFalta': 'La tua somma {s} · ti mancano {f}.',
  'juego.ganaste': 'Hai protetto il tempio!',
  'juego.perdiste': 'Il tempio è caduto',
  'juego.turnos': 'Turni {n}',

  // meditar

  // cómic
  'comic.saltar': 'Salta',
  'comic.siguiente': 'Avanti',
  'comic.anterior': 'Indietro',
  'comic.continuar': 'Continua',
  'comic.verResumen': 'Vedi il riepilogo',
  'comic.enfrentar': 'Affronta i Campioni',
  'comic.seguir': 'Continua a giocare',
  'comic.ilustracion': 'ILLUSTRAZIONE',

  // progreso
  'progreso.titulo': 'La settimana del Guardiano',
  'progreso.explicacion':
      'Vinci una partita al giorno. Il giorno dopo non si sblocca finché non '
      'cambia la data. Se passa un giorno intero senza vincere, la catena si '
      'spezza e bisogna rifare tutti e sette.',
  'progreso.dia': 'Giorno {n}',
  'progreso.hecho': 'Oggi il tempio ha retto.',
  'progreso.pendiente': 'Oggi il tempio non è ancora difeso.',
  'progreso.volveManana': 'Torna domani per il giorno {n}.',
  'progreso.ganaHoy': 'Vinci una partita per segnare il giorno {n}.',
  'progreso.rachaActual': 'Serie attuale {a}/{b}',
  'progreso.mejorRacha': 'Serie migliore {n}',
  'progreso.semanas': 'Settimane completate {n}',
  'progreso.logro': 'Guardiano del Tempio',
  'progreso.logroSub':
      'Sette giorni di fila. Shifu non lo saprà mai, ma tu sì.',
  'progreso.perderCorta': 'Anche perdere una partita spezza la serie',
  'progreso.perderCortaSub':
      'Spento: puoi riprovare tutte le volte che vuoi nella giornata. '
      'Acceso: una sconfitta ti riporta a zero.',
  'progreso.reiniciar': 'Azzera la serie',
  'progreso.aviso':
      'I progressi si salvano su questo dispositivo e usano il suo orologio: '
      'cambiando la data di sistema si salta l\'attesa.',
  'progreso.encargoHoy': 'Incarico di oggi: {t}',
  'progreso.recompensa': 'Ricompensa: {r}',

  // tutorial
  'tutorial.titulo': 'Come si gioca',
  'tutorial.siguiente': 'Avanti',
  'tutorial.saltar': 'Salta',
  'tutorial.terminar': 'Comincia a giocare',
  'tutorial.ver': 'Guarda il tutorial',
  'tutorial.tuTurno': 'Tocca il pulsante evidenziato',

  // ajustes
  'ajustes.idioma': 'Lingua',
  'ajustes.idiomaSistema': 'Quella del sistema',
  'ajustes.salir': 'Uscire dalla partita?',
  'ajustes.salirSub': 'Perderai i progressi di questa partita.',
  'ajustes.cancelar': 'Annulla',
  'ajustes.salirOk': 'Esci',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'Questa è la tua Energia. È l\'unica cosa che ti tiene in gioco: se '
      'scende sotto zero, è finita. Restare a zero non ti elimina, ma il '
      'colpo dopo sì.',
  'tutorial.p02':
      'Questo è il pericolo che ti è capitato. Il numero grande è il suo '
      'Potere: è quello che devi pareggiare o superare sommando carte.',
  'tutorial.p03':
      'Il cuore spezzato è quanta Energia perdi se non arrivi a quel numero. '
      'In questo caso, due.',
  'tutorial.p04':
      'E questo è il numero che guarderai di più: quante carte puoi pescare '
      'GRATIS. Quando finiscono, ogni carta in più costa Energia.',
  'tutorial.p05':
      'Guarda questa linea: taglia la carta a metà. Sopra c\'è il pericolo '
      'che affronti. Sotto, la tecnica che ottieni se lo batti.',
  'tutorial.p06':
      'E sì, la metà di sotto è stampata al contrario. È voluto: quando '
      'vinci, giri la carta di mezzo giro e quella metà si raddrizza. È '
      'tutto qui il significato di "ottenere una carta".',
  'tutorial.p07': 'Proviamo. Pesca la tua prima carta.',
  'tutorial.p08':
      'Ecco: il suo Potere si è sommato al tuo totale. Guarda la barra, ti '
      'dice quanto ti manca.',
  'tutorial.p09': 'Non basta ancora. Pescane un\'altra.',
  'tutorial.p10': 'Ci sei arrivato. Risolvi lo scontro.',
  'tutorial.p11':
      'Hai vinto, e questa è la cosa importante: la carta pericolo si gira e '
      'la tecnica dall\'altro lato diventa tua. È così che si costruisce il '
      'mazzo. Vai avanti.',
  'tutorial.p12': 'Pericolo nuovo, più duro. Pesca le tue carte gratis.',
  'tutorial.p13':
      'È uscita spazzatura. Qui si decide la partita: continuare a pescare '
      'costa 1 di Energia a carta, e non sai cosa uscirà. Stavolta arrenditi.',
  'tutorial.p14':
      'Hai perso Energia e NON ti sei preso la carta: arrendersi non dà mai '
      'la ricompensa. Ma perdere apre l\'unica porta per ripulire il mazzo. '
      'Elimina il Dubbio Esistenziale.',
  'tutorial.p15':
      'Questo è meditare: paghi Energia e togli dal gioco per sempre una '
      'carta cattiva. Un mazzo più piccolo fa uscire le buone più spesso.\n\n'
      'Una partita vera sono tre fasi —Alba, Mezzogiorno e Tramonto— e alla '
      'fine arrivano due Campioni. Buona fortuna.',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': 'Obiettivo',
  'reglas.objetivo.l1':
      'Sopravvivi a tre fasi di pericolo (Alba, Mezzogiorno, Tramonto) '
      'migliorando il tuo mazzo di tecniche, e poi affronti i Campioni del '
      'Torneo.',
  'reglas.objetivo.l2':
      'Quanti Campioni affronti lo decide il livello di difficoltà che '
      'scegli.',
  'reglas.objetivo.l3': 'Perdi se la tua Energia arriva a 0 o meno.',
  'reglas.preparacion.titulo': 'Preparazione',
  'reglas.preparacion.l1':
      'Mescola il mazzo iniziale di combattimento ({cartas} carte).',
  'reglas.preparacion.l2':
      'Separa i tre mazzi di pericolo e sorteggia i boss che chiede il tuo '
      'livello: {jefes} in questa configurazione.',
  'reglas.preparacion.l3':
      'Cominci con {inicial} di Energia in questa configurazione (tetto '
      'quando ti curi: {maxima}).',
  'reglas.turno.titulo': 'Turno',
  'reglas.turno.l1':
      '1. Rivela il pericolo in cima al mazzo della fase corrente.',
  'reglas.turno.l2Ilimitado':
      '2. Pesca carte di combattimento una alla volta, senza costo, finché '
      'vuoi fermarti.',
  'reglas.turno.l2Limitado':
      '2. Pesca gratis fino al numero di "carte gratis" del pericolo. Ogni '
      'carta in più costa {coste} di Energia.',
  'reglas.turno.l3':
      '3. Somma il Potere delle carte giocate e confrontalo con il Potere '
      'del pericolo.',
  'reglas.turno.l4':
      '4. Se la tua somma ≥ il pericolo, vinci: la carta pericolo entra nei '
      'tuoi scarti come la tecnica di ricompensa.',
  'reglas.turno.l5Sale':
      '5. Se perdi, sottrai il Danno del pericolo dalla tua Energia e la '
      'carta pericolo esce dal gioco.',
  'reglas.turno.l5Vuelve':
      '5. Se perdi, sottrai il Danno del pericolo dalla tua Energia e la '
      'carta torna in fondo al mazzo.',
  'reglas.turno.l6':
      '6. Tutte le carte giocate vanno negli scarti. Quando il mazzo '
      'finisce, mescola gli scarti.',
  'reglas.combate.titulo': 'Vincere o perdere uno scontro (importante)',
  'reglas.combate.l1':
      'VINCI se la somma delle tue carte ≥ il Potere del pericolo. La carta '
      'pericolo si gira ed entra nella tua pila degli scarti trasformata '
      'nella tecnica di ricompensa: da lì in poi è una carta del tuo mazzo.',
  'reglas.combate.l2':
      'PERDI se ti fermi sotto il Potere. Sottrai il Danno del pericolo dalla '
      'tua Energia e la carta pericolo esce dal gioco: NON te la prendi. Non '
      'si ottiene mai una carta perdendo uno scontro.',
  'reglas.combate.l3':
      'Fermarsi sotto non è un "prezzo" che paghi per tenerti la carta: è '
      'arrendersi. A volte conviene lo stesso, quando pagare altre pescate '
      'costerebbe più Energia del Danno stesso.',
  'reglas.combate.l4':
      'Che tu vinca o perda, tutte le carte che hai giocato vanno nei tuoi '
      'scarti.',
  'reglas.energia.titulo': 'Come si recupera Energia',
  'reglas.energia.l1':
      'Non esiste nessuna azione per curarti: non puoi "riposare" né spendere '
      'un turno per recuperare.',
  'reglas.energia.l2':
      'L\'Energia sale SOLO per effetti delle carte di combattimento, e quegli '
      'effetti scattano da soli quando la carta esce durante uno scontro. Non '
      'scegli tu quando usarle.',
  'reglas.energia.l3':
      'Effetto "+X Energia": si applica nel momento in cui peschi la carta, '
      'che poi tu vinca o perda. Es.: Riflesso +1, Disciplina +2, Scaglia di '
      'Drago +1, Pugno del Drago +2, Serenità +3, Acqua Sacra +2, '
      'Illuminazione +1.',
  'reglas.energia.l4':
      'Effetto "+X Energia se vinci": si applica solo alla risoluzione, e '
      'solo se hai vinto quello scontro. Es.: Pugno del Bambù +1, Ala di Gru '
      '+1, Volo di Gru +2.',
  'reglas.energia.l5':
      'Non superi mai il tetto di {maxima} di Energia: quello che avanza si '
      'perde.',
  'reglas.energia.l6':
      'Conseguenza di progetto: curarti dipende dall\'aver messo carte di '
      'cura nel mazzo e dal fatto che escano. Per questo conviene meditare '
      'per eliminare le carte cattive: un mazzo più piccolo fa comparire le '
      'buone più spesso.',
  'reglas.meditar.titulo': 'Meditare: togliere carte cattive dal mazzo',
  'reglas.meditar.l1':
      'Meditare è l\'UNICO modo di togliere carte dal tuo mazzo. Non ce n\'è '
      'un altro.',
  'reglas.meditar.cuandoSoloAlPerder':
      'Quando: solo nel passo successivo a uno scontro che hai PERSO.',
  'reglas.meditar.cuandoSiempre':
      'Quando: nel passo successivo a qualsiasi scontro, che tu l\'abbia '
      'vinto o perso.',
  'reglas.meditar.l3Una':
      'Come: paga {coste} di Energia ed elimina una carta dalla tua pila '
      'degli scarti. Esce dal gioco per sempre: non torna nel mazzo.',
  'reglas.meditar.l3':
      'Come: paga {coste} di Energia ed elimina {cartas} carta/e dalla tua '
      'pila degli scarti. Escono dal gioco per sempre: non tornano nel mazzo.',
  'reglas.meditar.l4':
      'Puoi ripeterlo più volte di fila, pagando ogni volta, finché ti resta '
      'Energia.',
  'reglas.meditar.l5':
      'LIMITE FONDAMENTALE: puoi eliminare solo carte che stanno negli '
      'SCARTI. Un Dubbio Esistenziale ancora sepolto nel mazzo è intoccabile: '
      'prima deve uscire in qualche scontro. Per questo il momento migliore '
      'per meditare è subito dopo uno scontro in cui sono uscite le tue carte '
      'peggiori: tutte quelle che hai appena giocato sono negli scarti.',
  'reglas.meditar.l6':
      'Quando il mazzo si esaurisce, gli scarti si mescolano e tornano a '
      'essere mazzo: lì perdi l\'occasione di purgare quelle carte finché non '
      'riescono.',
  'reglas.meditar.l7':
      'Perché conviene: togliere un Dubbio Esistenziale (-1) o un Respiro '
      'Affannato (0) non alza il tuo potere totale, ma rimpicciolisce il '
      'mazzo e fa uscire più spesso le carte buone (e quelle che curano '
      'Energia).',
  'reglas.final.titulo': 'Scontro finale',
  'reglas.final.l1':
      'Rivela i boss e affrontali in ordine, come un pericolo qualsiasi.',
  'reglas.final.l2':
      'Contro un boss non puoi arrenderti: finché ti resta una carta da '
      'pescare, combatti. Se perdi, sottrai il suo Danno e lo affronti di '
      'nuovo.',
  'reglas.final.l3': 'Vinci la partita quando batti l\'ultimo.',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': 'Pesca {n}',
  'efecto.energia': '{n} {recurso}',
  'efecto.energiaSiGanas': '{n} {recurso} se vinci',
  'efecto.reducePeligro': '-{n} al pericolo',
  'reglas.ui.bajada': 'Riflette i valori che hai in Bilanciamento.',
  'reglas.ui.mazoDe': 'Mazzo del {fase}',
  'reglas.ui.peligro':
      '{nombre} — Potere {poder}, Danno {dano}, gratis {gratis} → {tecnica} '
      '({tecnicaPoder})',
  'reglas.ui.jefes': 'Boss',
  'reglas.ui.jefe': '{nombre} — Potere {poder}, Danno {dano}, gratis {gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': 'Energia',
  'log.arranca': 'Il Maestro Shifu è partito. Comincia l\'Alba.',
  'log.jefeFinal': 'BOSS FINALE: {nombre} (Potere {poder}, Danno {dano})',
  'log.peligro': 'Pericolo: {nombre} (Potere {poder}, Danno {dano})',
  'log.pagasRobo': 'Paghi {n} di {recurso} per una carta in più.',
  'log.barajas': 'Rimescoli gli scarti per rifare il mazzo.',
  'log.energia': '{carta}: {n} {recurso}.',
  'log.topado': '(limitato a {max})',
  'log.bajaPeligro': '{carta}: il pericolo cala di {n} di Potere.',
  'log.siGanas': '{carta}: se vinci questo scontro, {n} {recurso}.',
  'log.sinEnergia': 'Sei rimasto senza {recurso}. Il tempio cade.',
  'log.efectosVictoria': 'Effetti di vittoria: {n} {recurso} ({detalle}).',
  'log.derrotasteJefe': 'Hai battuto {nombre}! ({suma} vs {poder})',
  'log.ganaste':
      'Hai vinto! ({suma} vs {poder}) Ottieni {tecnica} ({tecnicaPoder}).',
  'log.perdiste': 'Hai perso ({suma} vs {poder}). -{dano} di {recurso}.',
  'log.enCero':
      'Sei rimasto a 0 di {recurso}: sei ancora in piedi, ma la prossima '
      'spesa ti stende.',
  'log.cansancio':
      'La stanchezza si accumula: {carta} ({poder}) entra nel tuo mazzo.',
  'log.meditas': 'Mediti: elimini {carta} dal gioco.',
  'log.victoria':
      'Hai protetto il tempio! Shifu non saprà mai la storia dei biscotti.',
  'log.mediodia': 'Cala il Mezzogiorno. Le cose si fanno serie.',
  'log.ocaso': 'Cala il Tramonto. Arriva il vero pericolo.',
  'log.campeones': 'I Campioni del Torneo arrivano al tempio: {nombres}.',
  'log.y': 'e',
};
