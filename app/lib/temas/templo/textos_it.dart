import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en italiano.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
///
/// Registro: **tu**, informal. El juego lo lee un chico de dieciséis años que
/// barre un patio; el «Lei» sonaría a manual de electrodomésticos.
const textosTemploIt = TextosTema(
  nombre: 'Il Guardiano del Tempio',
  protagonista: 'Il Novizio',
  bajada: 'Shifu è via per sette giorni. Non bruciare il tempio.',
  recurso: 'Energia',
  nombreFase: {
    Fase.alba: 'Alba',
    Fase.mediodia: 'Mezzogiorno',
    Fase.ocaso: 'Tramonto',
    Fase.jefes: 'Scontro Finale',
  },
  cartas: {
    'puno_torpe': TextoCarta('Pugno Maldestro'),
    'postura_flamenco': TextoCarta(
      'Posizione del Fenicottero',
      'Non è una posizione Shaolin, ma funziona.',
    ),
    'patada_descuidada': TextoCarta(
      'Calcio Sbadato',
      'Per poco non cadevi all\'indietro.',
    ),
    'respiracion_agitada': TextoCarta(
      'Respiro Affannato',
      'Sembri un mantice bucato.',
    ),
    'duda_existencial': TextoCarta(
      'Dubbio Esistenziale',
      'E se il Kung Fu fosse aerobica con attitudine?',
    ),
    'alba1': TextoCarta('Zanzara del Tempio'),
    'garra_inicial': TextoCarta(
      'Artiglio Iniziale',
      'La tua prima mossa che sembra voluta.',
    ),
    'alba2': TextoCarta('Bandito col Bastone Marcio'),
    'puno_bambu': TextoCarta('Pugno del Bambù'),
    'alba3': TextoCarta('Teiera Rovesciata'),
    'equilibrio': TextoCarta(
      'Equilibrio',
      'Hai imparato a non inciampare nel tuo stesso piede.',
    ),
    'alba4': TextoCarta('Pisolino Tentatore'),
    'despertar_brusco': TextoCarta(
      'Risveglio Brusco',
      'Il Maestro ti ha buttato addosso un secchio d\'acqua gelata.',
    ),
    'alba5': TextoCarta('Gatto Guardiano del Tempio'),
    'rascada_felina': TextoCarta(
      'Graffio Felino',
      'Hai imparato dal miglior lottatore del tempio.',
    ),
    'alba6': TextoCarta('Compagno Beffardo'),
    'mirada_fija': TextoCarta(
      'Sguardo Fisso',
      'L\'hai spaventato con i tuoi occhi da novizio affamato.',
    ),
    'alba7': TextoCarta('Sasso nella Scarpa'),
    'paso_firme': TextoCarta(
      'Passo Fermo',
      'Finalmente porti le scarpe da allenamento.',
    ),
    'alba8': TextoCarta('Corda per Saltare Rotta'),
    'salto_novato': TextoCarta(
      'Salto del Novizio',
      'Hai suonato le campane del tempio con la testa.',
    ),
    'alba9': TextoCarta('Ragno nella Ciotola di Riso'),
    'reflejo': TextoCarta('Riflesso', 'Il ragno è sopravvissuto. Anche tu.'),
    'alba10': TextoCarta('Vento Freddo del Mattino'),
    'resistencia': TextoCarta(
      'Resistenza',
      'Il freddo tempra lo spirito. Tu volevi solo una coperta.',
    ),
    'med1': TextoCarta('Tre Banditi Affamati'),
    'puno_tigre': TextoCarta(
      'Pugno della Tigre',
      'Ruggisce come un gattino. Picchia come una tigre.',
    ),
    'med2': TextoCarta('Mercenario con Spada Giocattolo'),
    'ala_grulla': TextoCarta('Ala di Gru', 'Eleganza sopra la forza.'),
    'med3': TextoCarta('Dubbio: "Ma serve davvero?"'),
    'fe_renovada': TextoCarta(
      'Fede Rinnovata',
      'Shifu non ha mai mentito. Be\', quasi mai.',
    ),
    'med4': TextoCarta('Ira Incontrollabile'),
    'colmillo_serpiente': TextoCarta('Zanna di Serpente'),
    'med5': TextoCarta('Soldato del Governatore Corrotto'),
    'zancada_leopardo': TextoCarta(
      'Falcata del Leopardo',
      'Veloce. Elegante. Confusa per il nemico.',
    ),
    'med6': TextoCarta('Tentazione della Dispensa'),
    'disciplina': TextoCarta(
      'Disciplina',
      'I biscotti di Shifu sono ancora lì. Intatti. Sei un eroe.',
    ),
    'med7': TextoCarta('Falso Maestro di Strada'),
    'escama_dragon': TextoCarta(
      'Scaglia di Drago',
      'Hai imparato cosa NON si fa. Conta anche quello.',
    ),
    'med8': TextoCarta('Ponte Sospeso Rotto'),
    'vuelo_bambu': TextoCarta(
      'Volo del Bambù',
      'Hai attraversato il baratro. Con stile.',
    ),
    'med9': TextoCarta('Compagno Traditore'),
    'lealtad': TextoCarta(
      'Lealtà',
      'Hai perdonato il traditore. Sei più bravo come persona che come lottatore.',
    ),
    'med10': TextoCarta('Tempesta di Sabbia Improvvisa'),
    'resistencia_desierto': TextoCarta(
      'Resistenza del Deserto',
      'La sabbia negli occhi è allenamento avanzato.',
    ),
    'oca1': TextoCarta('Capo dei Banditi'),
    'rugido_tigre': TextoCarta(
      'Ruggito della Tigre',
      'Adesso sì che ruggisce come una tigre vera.',
    ),
    'oca2': TextoCarta('Assassino Silenzioso'),
    'vuelo_grulla': TextoCarta(
      'Volo di Gru',
      'Non l\'hai visto arrivare. Nemmeno lui ha visto te.',
    ),
    'oca3': TextoCarta('Demone dell\'Orgoglio'),
    'humildad': TextoCarta(
      'Umiltà',
      'Sei sceso dal piedistallo. A suon di botte.',
    ),
    'oca4': TextoCarta('Demone della Pigrizia'),
    'determinacion': TextoCarta(
      'Determinazione',
      'Ti sei alzato alle 4 del mattino. Una volta. Ma conta.',
    ),
    'oca5': TextoCarta('Maestro del Tempio Rivale'),
    'puno_dragon': TextoCarta(
      'Pugno del Drago',
      'Il suo tempio ha un budget migliore. Tu hai cuore.',
    ),
    'oca6': TextoCarta('Esercito di Mercenari'),
    'patada_tigre': TextoCarta(
      'Calcio della Tigre',
      'Un calcio. Tanti mercenari. Matematica semplice.',
    ),
    'oca7': TextoCarta('Demone dell\'Ira'),
    'serenidad': TextoCarta(
      'Serenità',
      'Hai fatto un respiro profondo. Il demone no.',
    ),
    'oca8': TextoCarta('Incendio nella Cucina del Tempio'),
    'agua_sagrada': TextoCarta(
      'Acqua Sacra',
      'Hai spento il fuoco. Nessuno sa come sia partito. È stato Shifu, vero?',
    ),
    'oca9': TextoCarta('Tradimento del Discepolo Prediletto'),
    'perdon': TextoCarta(
      'Perdono',
      'Gli hai dato una seconda occasione. E un calcio.',
    ),
    'oca10': TextoCarta('Prova del Gran Maestro (in sogno)'),
    'iluminacion': TextoCarta(
      'Illuminazione',
      'Ti sei svegliato fradicio. Ma illuminato.',
    ),
    'jefe1': TextoCarta(
      'Il Monaco Caduto',
      'Ex allievo modello. Cerca vendetta... e biscotti.',
    ),
    'jefe2': TextoCarta(
      'Il Tuo Stesso Riflesso',
      'Aveva la tua faccia. E aveva ragione su tutto.',
    ),
    'jefe3': TextoCarta(
      'Il Signore dei Mercenari',
      'Paga bene i suoi uomini. Puzza. Parecchio.',
    ),
    'jefe4': TextoCarta(
      'Il Gran Maestro del Tempio del Loto Nero',
      'Il suo tempio ha piscina, sauna e buffet libero. Il tuo ha un sasso.',
    ),
    'jefe5': TextoCarta(
      'Il Drago di Carta',
      'Imponente, sputa fuoco. Ma se piove diventa poltiglia.',
    ),

    // Las diez del mazo de Cansancio. Los NÚMEROS siguen en
    // `lib/modos/cansancio.dart`: acá va sólo lo que se traduce.
    'cans_bostezo': TextoCarta(
      'Sbadiglio',
      'È contagioso. Ha sbadigliato anche il bandito.',
    ),
    'cans_vista': TextoCarta(
      'Vista Annebbiata',
      'Sono due banditi. O uno. Difficile dirlo.',
    ),
    'cans_piernas': TextoCarta(
      'Gambe di Straccio',
      'Sono lì sotto, ma non rispondono.',
    ),
    'cans_hombro': TextoCarta(
      'Spalla Addormentata',
      'Si è svegliata prima di te e si è riaddormentata.',
    ),
    'cans_ampolla': TextoCarta('Vescica', 'Piccolissima. Insopportabile.'),
    'cans_nudillo': TextoCarta(
      'Nocca Spaccata',
      'Shifu direbbe che è carattere. Shifu non c\'è.',
    ),
    'cans_calambre': TextoCarta('Crampo', 'Proprio adesso. Proprio lì.'),
    'cans_zumbido': TextoCarta(
      'Ronzio nell\'Orecchio',
      'La zanzara dell\'Alba ha avuto l\'ultima parola.',
    ),
    'cans_espalda': TextoCarta(
      'Schiena Vecchia',
      'Hai sedici anni e la schiena di Shifu.',
    ),
    'cans_renunciar': TextoCarta(
      'Voglia di Mollare',
      'Anche il banco dei noodle al villaggio cerca gente.',
    ),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    '01_templo_amanecer.png': TextoPanel(
      narracion:
          'In cima alla montagna, dove il vento si lamenta e il tè non è mai abbastanza caldo, c\'è il Tempio del Loto Storto.',
      conversacion: [
        Dicho('', '(Centotto gradini fino al portone.)'),
        Dicho(
          '',
          '(Il Novizio li spazza tutte le mattine. Tutte le mattine si risporcano.)',
        ),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion:
          'Stamattina il Gran Maestro Shifu è partito per il Congresso Annuale dei Maestri di Arti Marziali e Tè al Gelsomino.',
      conversacion: [
        Dicho('Shifu', 'Torno fra sette giorni. Mi fido di te.'),
        Dicho('Novizio', 'Sette giorni da solo?'),
        Dicho('Shifu', 'Da solo no. C\'è Mei.'),
        Dicho('', '(Mei era già andata a dormire.)'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion:
          'Prima di andarsene ha lasciato un biglietto, scritto con calligrafia impeccabile.',
      conversacion: [
        Dicho(
          'Il biglietto',
          'Caro novizio: non bruciare il tempio. Non mangiare i biscotti della dispensa (sono miei). Spazza il cortile tutte le mattine.',
        ),
        Dicho('Il biglietto', 'E soprattutto: NON FAR ENTRARE ESTRANEI.'),
        Dicho('Novizio', 'Facile.'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'E sotto, in caratteri più piccoli, un poscritto.',
      conversacion: [
        Dicho(
          'Il biglietto',
          'P.S.: Se qualcuno chiede del "Grande Torneo Illegale di Arti Marziali", digli che abbiamo rifiutato categoricamente.',
        ),
        Dicho('Novizio', 'Il cosa?'),
        Dicho('Novizio', 'Abbiamo rifiutato COSA?'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion:
          'Shifu ha girato la prima curva del sentiero. Dodici secondi dopo, hanno cominciato a salire.',
      conversacion: [
        Dicho('Novizio', 'Bene. È degenerato in fretta.'),
        Dicho('', '(All\'inizio erano quattordici.)'),
      ],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: 'E il peggio di tutto non veniva da fuori.',
      conversacion: [
        Dicho('Novizio', 'Un biscotto solo non si nota.'),
        Dicho('Novizio', 'Non li ha nemmeno contati, di sicuro.'),
        Dicho('', '(Shifu li aveva contati.)'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion:
          'La giornata è appena iniziata. Ti allenerai con quello che capita e trasformerai ogni batosta in una tecnica nuova.',
      conversacion: [
        Dicho('', '(Alba. Mezzogiorno. Tramonto.)'),
        Dicho(
          '',
          '(Tre volte si sale la montagna, e ogni volta sale di peggio.)',
        ),
        Dicho('Novizio', 'Ce la faccio.'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion:
          'E quando il sole sprofonderà dietro la montagna, due Campioni del Torneo busseranno al portone per prendersi il tempio.',
      conversacion: [
        Dicho('Novizio', 'Riuscirò a proteggere il tempio?'),
        Dicho('Novizio', 'E i biscotti di Shifu?'),
        Dicho('', '(Una delle due risposte sarebbe stata no.)'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion:
          'Hai retto l\'Alba. Ti fa male tutto, ma sei ancora in piedi e il cortile è ancora tuo.',
      conversacion: [
        Dicho('Novizio', 'Uno in meno.'),
        Dicho('', '(Il sole stava appena salendo.)'),
      ],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion:
          'Mei, la gatta guardiana, ha valutato la tua prestazione dal tetto. Non è rimasta colpita.',
      conversacion: [
        Dicho('Mei', '(silenzio felino devastante)'),
        Dicho('Novizio', 'Ho vinto, sai?'),
        Dicho('Mei', '(battito di ciglia lento)'),
        Dicho('Novizio', 'Va bene. Pareggiato.'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion:
          'A Mezzogiorno non salgono più i curiosi. Salgono quelli che si fanno pagare per stare qui.',
      conversacion: [
        Dicho(
          'Tao',
          'Niente male per uno che stamattina non sapeva chiudere il pugno.',
        ),
        Dicho('Tao', 'Però quelli di quest\'ora picchiano diverso, eh.'),
        Dicho('Novizio', 'E tu da che parte stai?'),
        Dicho('Tao', 'Da quella che vince.'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion:
          'Il Mezzogiorno ti ha lasciato le mani a vivo, ma il portone non si è mai aperto per nessuno che tu non volessi.',
      conversacion: [
        Dicho('Novizio', 'Due.'),
        Dicho('', '(Le ombre del cortile cominciavano già ad allungarsi.)'),
      ],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion:
          'Tao se n\'è andato quando il sole ha cominciato a calare. Non ha salutato.',
      conversacion: [
        Dicho('Novizio', 'Ah. Quindi era questo.'),
        Dicho('Tao', 'Da quella che vince, ragazzo. Te l\'avevo detto subito.'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion:
          'Col Tramonto i banditi smettono di salire: anche i banditi hanno paura della montagna al buio. Sale l\'altra cosa.',
      conversacion: [
        Dicho(
          '',
          '(Le ombre del cortile hanno smesso di coincidere col cortile.)',
        ),
        Dicho('Novizio', 'Non c\'è nessuno lì.'),
        Dicho('Novizio', 'Non c\'è nessuno lì.'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion:
          'Hai retto tutto il Tramonto, compresi quelli che avevano la tua faccia. La montagna è rimasta in silenzio.',
      conversacion: [
        Dicho('Novizio', 'È finita.'),
        Dicho('', '(Non era finita.)'),
      ],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: 'Tre colpi al portone. Nessuno ha chiesto permesso.',
      conversacion: [
        Dicho('', '(Uno.)'),
        Dicho('', '(Due.)'),
        Dicho('', '(Tre.)'),
        Dicho('Novizio', 'Va bene. Venite.'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion:
          'Il Grande Torneo Illegale di Arti Marziali ha bisogno di una sede. Sono venuti a prendersi la tua.',
      conversacion: [
        Dicho('I Campioni', 'Ci avevano detto che qui non c\'era nessuno.'),
        Dicho('Novizio', 'Vi hanno detto male.'),
      ],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion:
          'I due Campioni se ne sono andati da dove erano venuti. Uno dei due zoppicando.',
      conversacion: [
        Dicho('Novizio', 'Il tempio non è in vendita.'),
        Dicho(
          '',
          '(Mei è scesa dal tetto per la prima volta in tutto il giorno.)',
        ),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion:
          'Scaduto il termine, Shifu è tornato. Stesso cappello, stessa borsa, stessa faccia.',
      conversacion: [
        Dicho('Shifu', 'Il cortile è spazzato. Il tempio è in piedi. Bene.'),
        Dicho('Novizio', 'È stato tranquillo.'),
        Dicho('Shifu', 'Mm.'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'Poi ha aperto la dispensa.',
      conversacion: [
        Dicho('Shifu', 'Ne mancano due.'),
        Dicho('Novizio', 'Mei.'),
        Dicho('Mei', '(non era più nella vignetta)'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion: 'Non ti è rimasto niente. Né Energia, né tecniche, né scuse.',
      conversacion: [
        Dicho('', '(Il portone è rimasto aperto. Nessuno l\'ha chiuso.)'),
      ],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: 'Shifu è tornato puntuale, come sempre.',
      conversacion: [
        Dicho('Shifu', '...'),
        Dicho('Novizio', 'Posso spiegare.'),
        Dicho('Shifu', '...'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'E poi ha fatto l\'unica domanda che contava.',
      conversacion: [
        Dicho('Shifu', 'E i biscotti?'),
        Dicho('', '(Quella è stata la parte difficile da spiegare.)'),
      ],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: 'Niente meditazione',
      nota: 'Meditare è sopravvalutato. Tienti il mazzo che hai.',
      recompensa: '+2 di Energia iniziale domani',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: 'Finisci intero',
      nota: 'Non mi serve un guardiano che vince e resta steso nel cortile.',
      recompensa: '+2 di Energia iniziale domani',
    ),
    'alba_impecable': TextoEncargo(
      titulo: 'L\'Alba impeccabile',
      nota:
          'Se perdi contro una zanzara, del resto non voglio nemmeno sapere. ',
      recompensa: 'Meditare è gratis domani',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: 'Senza sprecare',
      nota:
          'L\'Energia non cresce sul bambù. Arrangiati con quello che ti tocca. ',
      recompensa: '+1 carta gratis su tutti i pericoli domani',
    ),
    'purga_profunda': TextoEncargo(
      titulo: 'Pulizia di tecnica',
      nota: 'Togliti di dosso quei dubbi. Tutti. Oggi.',
      recompensa: 'Meditare elimina 2 carte domani',
    ),
    'partida_corta': TextoEncargo(
      titulo: 'Veloce e pulito',
      nota:
          'Il tempio non si difende da solo, ma nemmeno tu hai tutto il giorno. ',
      recompensa: '+3 di Energia iniziale domani',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: 'Perdi poco',
      nota: 'Perdere tre volte è imparare. Perdere otto è un\'altra cosa.',
      recompensa: '+2 di Energia iniziale domani',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: 'Il Mezzogiorno senza cadute',
      nota:
          'Quelli che salgono a mezzogiorno si fanno pagare. Che non incassino.',
      recompensa: '+1 carta gratis su tutti i pericoli domani',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: 'I Campioni al primo colpo',
      nota: 'I Campioni si battono una volta sola. Ripetere è maleducazione. ',
      recompensa: '+3 di Energia iniziale domani',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: 'Che ne avanzi',
      nota:
          'Voglio trovare il tempio in piedi e te con la voglia di spazzare. ',
      recompensa: 'Tetto di Energia +5 domani',
    ),
    'sin_curarse': TextoEncargo(
      titulo: 'Reggere senza aiuto',
      nota: 'L\'acqua sacra è per il fuoco, non per le tue scuse.',
      recompensa: '+1 carta gratis su tutti i pericoli domani',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: 'Sul filo',
      nota: 'Vincere con cinque di Energia ha più merito. E meno buonsenso. ',
      recompensa: '+4 di Energia iniziale domani',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: 'Alba',
      queCartasLleva: 'Le 10 carte pericolo/tecnica del mazzo dell\'Alba',
      descripcion:
          'Loto intagliato al centro, sole che sorge basso all\'orizzonte dietro.',
    ),
    'Mediodía': TextoReverso(
      nombre: 'Mezzogiorno',
      queCartasLleva: 'Le 10 carte pericolo/tecnica del mazzo del Mezzogiorno',
      descripcion: 'Stesso loto, sole alto e pieno dietro.',
    ),
    'Ocaso': TextoReverso(
      nombre: 'Tramonto',
      queCartasLleva: 'Le 10 carte pericolo/tecnica del mazzo del Tramonto',
      descripcion: 'Stesso loto, sole che sprofonda dietro, ombre lunghe.',
    ),
    'Jefes': TextoReverso(
      nombre: 'Campioni',
      queCartasLleva: 'Le 5 carte di Campione del Torneo',
      descripcion:
          'Loto nero, cornice più carica, senza sole. Deve sembrare più pesante degli altri tre.',
    ),
    'Combate': TextoReverso(
      nombre: 'Combattimento',
      queCartasLleva: 'Le 20 tecniche iniziali',
      descripcion:
          'Loto semplice, motivo sobrio, senza sole. È il mazzo che il giocatore ha in mano tutto il tempo: tienilo tranquillo.',
    ),
  },
);
