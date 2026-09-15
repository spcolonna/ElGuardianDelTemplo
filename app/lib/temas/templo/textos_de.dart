import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en alemán.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
///
/// Registro: **du**, informal. Y es el idioma más largo de los siete: cuando
/// algo no entra en una caja, entra acá primero. Por eso los nombres de carta
/// se eligieron cortos donde se pudo, sin inventar palabras.
const textosTemploDe = TextosTema(
  nombre: 'Der Wächter des Tempels',
  protagonista: 'Der Neuling',
  bajada: 'Shifu ist sieben Tage weg. Brenn den Tempel nicht ab.',
  recurso: 'Energie',
  nombreFase: {
    Fase.alba: 'Morgen',
    Fase.mediodia: 'Mittag',
    Fase.ocaso: 'Abend',
    Fase.jefes: 'Letztes Duell',
  },
  cartas: {
    'puno_torpe': TextoCarta('Plumper Fauststoß'),
    'postura_flamenco': TextoCarta(
      'Flamingo-Stand',
      'Keine Shaolin-Haltung, aber sie wirkt.',
    ),
    'patada_descuidada': TextoCarta(
      'Schlampiger Tritt',
      'Fast wärst du rückwärts umgefallen.',
    ),
    'respiracion_agitada': TextoCarta(
      'Kurzatmigkeit',
      'Du klingst wie ein löchriger Blasebalg.',
    ),
    'duda_existencial': TextoCarta(
      'Sinnkrise',
      'Und wenn Kung-Fu nur Aerobic mit Haltung ist?',
    ),
    'alba1': TextoCarta('Tempelmücke'),
    'garra_inicial': TextoCarta(
      'Erste Kralle',
      'Deine erste Bewegung, die absichtlich aussieht.',
    ),
    'alba2': TextoCarta('Bandit mit morschem Knüppel'),
    'puno_bambu': TextoCarta('Bambusfaust'),
    'alba3': TextoCarta('Umgekippte Teekanne'),
    'equilibrio': TextoCarta(
      'Gleichgewicht',
      'Du stolperst nicht mehr über den eigenen Fuß.',
    ),
    'alba4': TextoCarta('Verlockendes Nickerchen'),
    'despertar_brusco': TextoCarta(
      'Hartes Erwachen',
      'Der Meister hat dir einen Eimer kaltes Wasser verpasst.',
    ),
    'alba5': TextoCarta('Tempelkatze'),
    'rascada_felina': TextoCarta(
      'Katzenkralle',
      'Du hast vom besten Kämpfer des Tempels gelernt.',
    ),
    'alba6': TextoCarta('Spöttischer Mitschüler'),
    'mirada_fija': TextoCarta(
      'Starrer Blick',
      'Deine hungrigen Neulingsaugen haben ihn erschreckt.',
    ),
    'alba7': TextoCarta('Stein im Schuh'),
    'paso_firme': TextoCarta(
      'Fester Schritt',
      'Endlich trägst du Trainingsschuhe.',
    ),
    'alba8': TextoCarta('Gerissenes Springseil'),
    'salto_novato': TextoCarta(
      'Sprung des Neulings',
      'Du hast die Tempelglocken mit dem Kopf getroffen.',
    ),
    'alba9': TextoCarta('Spinne in der Reisschale'),
    'reflejo': TextoCarta('Reflex', 'Die Spinne hat überlebt. Du auch.'),
    'alba10': TextoCarta('Kalter Morgenwind'),
    'resistencia': TextoCarta(
      'Ausdauer',
      'Kälte stählt den Geist. Du wolltest nur eine Decke.',
    ),
    'med1': TextoCarta('Drei hungrige Banditen'),
    'puno_tigre': TextoCarta(
      'Tigerfaust',
      'Brüllt wie ein Kätzchen. Schlägt wie ein Tiger.',
    ),
    'med2': TextoCarta('Söldner mit Spielzeugschwert'),
    'ala_grulla': TextoCarta('Kranichflügel', 'Eleganz vor Kraft.'),
    'med3': TextoCarta('Zweifel: "Bringt das was?"'),
    'fe_renovada': TextoCarta(
      'Neuer Glaube',
      'Shifu hat nie gelogen. Na ja, fast nie.',
    ),
    'med4': TextoCarta('Unbändiger Zorn'),
    'colmillo_serpiente': TextoCarta('Schlangenzahn'),
    'med5': TextoCarta('Soldat des korrupten Statthalters'),
    'zancada_leopardo': TextoCarta(
      'Leopardenschritt',
      'Schnell. Elegant. Verwirrend für den Gegner.',
    ),
    'med6': TextoCarta('Verlockung der Vorratskammer'),
    'disciplina': TextoCarta(
      'Disziplin',
      'Shifus Kekse sind noch da. Unangetastet. Du bist ein Held.',
    ),
    'med7': TextoCarta('Falscher Straßenmeister'),
    'escama_dragon': TextoCarta(
      'Drachenschuppe',
      'Du hast gelernt, was man NICHT tut. Das zählt auch.',
    ),
    'med8': TextoCarta('Zerrissene Hängebrücke'),
    'vuelo_bambu': TextoCarta(
      'Bambusflug',
      'Du hast den Abgrund überquert. Mit Stil.',
    ),
    'med9': TextoCarta('Verräterischer Mitschüler'),
    'lealtad': TextoCarta(
      'Treue',
      'Du hast dem Verräter verziehen. Als Mensch bist du besser denn als Kämpfer.',
    ),
    'med10': TextoCarta('Plötzlicher Sandsturm'),
    'resistencia_desierto': TextoCarta(
      'Wüstenausdauer',
      'Sand in den Augen ist Training für Fortgeschrittene.',
    ),
    'oca1': TextoCarta('Anführer der Banditen'),
    'rugido_tigre': TextoCarta(
      'Tigerbrüllen',
      'Jetzt brüllt er wirklich wie ein Tiger.',
    ),
    'oca2': TextoCarta('Lautloser Meuchler'),
    'vuelo_grulla': TextoCarta(
      'Kranichflug',
      'Du hast ihn nicht kommen sehen. Er dich auch nicht.',
    ),
    'oca3': TextoCarta('Dämon des Stolzes'),
    'humildad': TextoCarta(
      'Demut',
      'Du bist von deiner Wolke runter. Mit Nachhilfe.',
    ),
    'oca4': TextoCarta('Dämon der Faulheit'),
    'determinacion': TextoCarta(
      'Entschlossenheit',
      'Du bist um 4 Uhr aufgestanden. Einmal. Zählt aber.',
    ),
    'oca5': TextoCarta('Meister des Rivalentempels'),
    'puno_dragon': TextoCarta(
      'Drachenfaust',
      'Sein Tempel hat mehr Budget. Du hast Herz.',
    ),
    'oca6': TextoCarta('Söldnerheer'),
    'patada_tigre': TextoCarta(
      'Tigertritt',
      'Ein Tritt. Viele Söldner. Einfache Mathematik.',
    ),
    'oca7': TextoCarta('Dämon des Zorns'),
    'serenidad': TextoCarta(
      'Gelassenheit',
      'Du hast tief durchgeatmet. Der Dämon nicht.',
    ),
    'oca8': TextoCarta('Feuer in der Tempelküche'),
    'agua_sagrada': TextoCarta(
      'Heiliges Wasser',
      'Du hast das Feuer gelöscht. Keiner weiß, wie es anfing. War Shifu, oder?',
    ),
    'oca9': TextoCarta('Verrat des Lieblingsschülers'),
    'perdon': TextoCarta(
      'Vergebung',
      'Du hast ihm eine zweite Chance gegeben. Und einen Tritt.',
    ),
    'oca10': TextoCarta('Prüfung des Großmeisters (im Traum)'),
    'iluminacion': TextoCarta(
      'Erleuchtung',
      'Du bist klatschnass aufgewacht. Aber erleuchtet.',
    ),
    'jefe1': TextoCarta(
      'Der gefallene Mönch',
      'Ehemaliger Musterschüler. Sucht Rache… und Kekse.',
    ),
    'jefe2': TextoCarta(
      'Dein eigenes Spiegelbild',
      'Es hatte dein Gesicht. Und in allem recht.',
    ),
    'jefe3': TextoCarta(
      'Der Herr der Söldner',
      'Zahlt seine Leute gut. Riecht schlecht. Sehr schlecht.',
    ),
    'jefe4': TextoCarta(
      'Der Großmeister des Schwarzen Lotos',
      'Sein Tempel hat Pool, Sauna und All-you-can-eat. Deiner hat einen Stein.',
    ),
    'jefe5': TextoCarta(
      'Der Papierdrache',
      'Mächtig, speit Feuer. Aber wenn es regnet, wird er Brei.',
    ),

    // Las diez del mazo de Cansancio. Los NÚMEROS siguen en
    // `lib/modos/cansancio.dart`: acá va sólo lo que se traduce.
    'cans_bostezo': TextoCarta(
      'Gähnen',
      'Ansteckend. Sogar der Bandit hat gegähnt.',
    ),
    'cans_vista': TextoCarta(
      'Trübe Sicht',
      'Das sind zwei Banditen. Oder einer. Schwer zu sagen.',
    ),
    'cans_piernas': TextoCarta(
      'Wackelbeine',
      'Sie sind da unten, antworten aber nicht.',
    ),
    'cans_hombro': TextoCarta(
      'Eingeschlafene Schulter',
      'Sie war vor dir wach und ist wieder eingeschlafen.',
    ),
    'cans_ampolla': TextoCarta('Blase', 'Winzig. Unerträglich.'),
    'cans_nudillo': TextoCarta(
      'Aufgeplatzter Knöchel',
      'Shifu würde sagen, das ist Charakter. Shifu ist nicht da.',
    ),
    'cans_calambre': TextoCarta('Krampf', 'Genau jetzt. Genau da.'),
    'cans_zumbido': TextoCarta(
      'Ohrensausen',
      'Die Mücke vom Morgen hatte das letzte Wort.',
    ),
    'cans_espalda': TextoCarta(
      'Alter Rücken',
      'Du bist sechzehn und hast Shifus Rücken.',
    ),
    'cans_renunciar': TextoCarta(
      'Lust aufzugeben',
      'Die Nudelbude im Dorf sucht auch Leute.',
    ),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    '01_templo_amanecer.png': TextoPanel(
      narracion:
          'Hoch oben auf dem Berg, wo der Wind jammert und der Tee nie heiß genug ist, steht der Tempel des Schiefen Lotos.',
      conversacion: [
        Dicho('', '(Hundertacht Stufen bis zum Tor.)'),
        Dicho(
          '',
          '(Der Neuling fegt sie jeden Morgen. Jeden Morgen werden sie wieder schmutzig.)',
        ),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion:
          'Heute Morgen ist Großmeister Shifu zum Jahreskongress der Meister für Kampfkunst und Jasmintee aufgebrochen.',
      conversacion: [
        Dicho('Shifu', 'Ich bin in sieben Tagen zurück. Ich vertraue dir.'),
        Dicho('Neuling', 'Sieben Tage allein?'),
        Dicho('Shifu', 'Nicht allein. Mei ist da.'),
        Dicho('', '(Mei war schon schlafen gegangen.)'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion:
          'Vor dem Aufbruch hat er einen Zettel dagelassen, in makelloser Handschrift.',
      conversacion: [
        Dicho(
          'Der Zettel',
          'Lieber Neuling: Brenn den Tempel nicht ab. Iss die Kekse aus der Kammer nicht (die sind meine). Feg jeden Morgen den Hof.',
        ),
        Dicho('Der Zettel', 'Und vor allem: LASS KEINE FREMDEN HEREIN.'),
        Dicho('Neuling', 'Einfach.'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'Und darunter, kleiner geschrieben, ein Nachsatz.',
      conversacion: [
        Dicho(
          'Der Zettel',
          'P.S.: Wenn jemand nach dem "Großen Illegalen Kampfkunstturnier" fragt, sag ihm, wir haben entschieden abgelehnt.',
        ),
        Dicho('Neuling', 'Nach was?'),
        Dicho('Neuling', 'Wir haben WAS abgelehnt?'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion:
          'Shifu bog um die erste Kurve des Wegs. Zwölf Sekunden später fingen sie an hochzusteigen.',
      conversacion: [
        Dicho('Neuling', 'Gut. Das ist schnell eskaliert.'),
        Dicho('', '(Am Anfang waren es vierzehn.)'),
      ],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: 'Und das Schlimmste kam nicht von draußen.',
      conversacion: [
        Dicho('Neuling', 'Ein Keks fällt doch nicht auf.'),
        Dicho('Neuling', 'Der hat sie sicher nicht mal gezählt.'),
        Dicho('', '(Shifu hatte sie gezählt.)'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion:
          'Der Tag fängt gerade erst an. Du trainierst mit dem, was kommt, und machst aus jeder Tracht Prügel eine neue Technik.',
      conversacion: [
        Dicho('', '(Morgen. Mittag. Abend.)'),
        Dicho(
          '',
          '(Dreimal steigt der Berg, und jedes Mal steigt etwas Schlimmeres.)',
        ),
        Dicho('Neuling', 'Das schaffe ich.'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion:
          'Und wenn die Sonne hinter dem Berg versinkt, klopfen zwei Turnierchampions ans Tor, um sich den Tempel zu holen.',
      conversacion: [
        Dicho('Neuling', 'Schaffe ich es, den Tempel zu schützen?'),
        Dicho('Neuling', 'Und Shifus Kekse?'),
        Dicho('', '(Eine der beiden Antworten würde Nein lauten.)'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion:
          'Du hast den Morgen überstanden. Alles tut weh, aber du stehst noch und der Hof gehört weiter dir.',
      conversacion: [
        Dicho('Neuling', 'Einer weniger.'),
        Dicho('', '(Die Sonne war gerade erst am Steigen.)'),
      ],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion:
          'Mei, die Wächterkatze, hat deine Vorstellung vom Dach aus bewertet. Beeindruckt war sie nicht.',
      conversacion: [
        Dicho('Mei', '(vernichtendes Katzenschweigen)'),
        Dicho('Neuling', 'Ich habe gewonnen, weißt du?'),
        Dicho('Mei', '(langsames Blinzeln)'),
        Dicho('Neuling', 'Gut. Unentschieden.'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion:
          'Am Mittag steigen keine Neugierigen mehr hoch. Es steigen die, die dafür Geld nehmen.',
      conversacion: [
        Dicho(
          'Tao',
          'Nicht schlecht für jemanden, der heute früh keine Faust machen konnte.',
        ),
        Dicho('Tao', 'Die um diese Zeit schlagen aber anders zu.'),
        Dicho('Neuling', 'Und auf welcher Seite stehst du?'),
        Dicho('Tao', 'Auf der, die gewinnt.'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion:
          'Der Mittag hat dir die Hände wundgescheuert, aber das Tor hat sich für niemanden geöffnet, den du nicht wolltest.',
      conversacion: [
        Dicho('Neuling', 'Zwei.'),
        Dicho('', '(Die Schatten im Hof fingen schon an, länger zu werden.)'),
      ],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion:
          'Tao ist gegangen, als die Sonne zu sinken begann. Ohne sich zu verabschieden.',
      conversacion: [
        Dicho('Neuling', 'Ah. Das war es also.'),
        Dicho(
          'Tao',
          'Auf der, die gewinnt, Junge. Habe ich dir gleich gesagt.',
        ),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion:
          'Am Abend steigen keine Banditen mehr hoch: auch Banditen fürchten den Berg im Dunkeln. Es steigt das andere.',
      conversacion: [
        Dicho('', '(Die Schatten im Hof passten nicht mehr zum Hof.)'),
        Dicho('Neuling', 'Da ist niemand.'),
        Dicho('Neuling', 'Da ist niemand.'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion:
          'Du hast den ganzen Abend überstanden, auch die mit deinem Gesicht. Der Berg wurde still.',
      conversacion: [
        Dicho('Neuling', 'Vorbei.'),
        Dicho('', '(Es war nicht vorbei.)'),
      ],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: 'Drei Schläge ans Tor. Keiner davon hat gefragt.',
      conversacion: [
        Dicho('', '(Eins.)'),
        Dicho('', '(Zwei.)'),
        Dicho('', '(Drei.)'),
        Dicho('Neuling', 'Also gut. Kommt rein.'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion:
          'Das Große Illegale Kampfkunstturnier braucht einen Austragungsort. Sie sind gekommen, um deinen zu holen.',
      conversacion: [
        Dicho('Die Champions', 'Uns wurde gesagt, hier sei niemand.'),
        Dicho('Neuling', 'Da wurde euch was Falsches gesagt.'),
      ],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion:
          'Die beiden Champions sind zurückgegangen, wo sie hergekommen sind. Einer davon humpelnd.',
      conversacion: [
        Dicho('Neuling', 'Der Tempel steht nicht zum Verkauf.'),
        Dicho('', '(Mei kam zum ersten Mal an diesem Tag vom Dach herunter.)'),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion:
          'Als die Frist um war, kam Shifu zurück. Derselbe Hut, dieselbe Tasche, dasselbe Gesicht.',
      conversacion: [
        Dicho('Shifu', 'Der Hof ist gefegt. Der Tempel steht. Gut.'),
        Dicho('Neuling', 'Es war ruhig.'),
        Dicho('Shifu', 'Hm.'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'Dann hat er die Vorratskammer geöffnet.',
      conversacion: [
        Dicho('Shifu', 'Es fehlen zwei.'),
        Dicho('Neuling', 'Mei.'),
        Dicho('Mei', '(war nicht mehr im Bild)'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion:
          'Dir ist nichts geblieben. Keine Energie, keine Techniken, keine Ausreden.',
      conversacion: [
        Dicho('', '(Das Tor blieb offen. Niemand hat es zugemacht.)'),
      ],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: 'Shifu kam pünktlich zurück, wie immer.',
      conversacion: [
        Dicho('Shifu', '…'),
        Dicho('Neuling', 'Ich kann das erklären.'),
        Dicho('Shifu', '…'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'Und dann stellte er die einzige Frage, die zählte.',
      conversacion: [
        Dicho('Shifu', 'Und die Kekse?'),
        Dicho('', '(Das war der schwierige Teil der Erklärung.)'),
      ],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: 'Kein Meditieren',
      nota: 'Meditieren wird überschätzt. Komm mit dem Deck klar, das du hast.',
      recompensa: 'Morgen +2 Startenergie',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: 'Bleib heil',
      nota: 'Ein Wächter, der gewinnt und im Hof liegt, nützt mir nichts.',
      recompensa: 'Morgen +2 Startenergie',
    ),
    'alba_impecable': TextoEncargo(
      titulo: 'Der makellose Morgen',
      nota:
          'Wenn du gegen eine Mücke verlierst, will ich vom Rest nichts hören. ',
      recompensa: 'Morgen kostet Meditieren nichts',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: 'Ohne zu verschwenden',
      nota:
          'Energie wächst nicht am Bambus. Komm mit dem aus, was du kriegst. ',
      recompensa: 'Morgen +1 Gratiskarte bei allen Gefahren',
    ),
    'purga_profunda': TextoEncargo(
      titulo: 'Technik entrümpeln',
      nota: 'Wirf diese Zweifel raus. Alle. Heute.',
      recompensa: 'Morgen entfernt Meditieren 2 Karten',
    ),
    'partida_corta': TextoEncargo(
      titulo: 'Schnell und sauber',
      nota:
          'Der Tempel verteidigt sich nicht allein, aber du hast auch nicht den ganzen Tag. ',
      recompensa: 'Morgen +3 Startenergie',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: 'Verlier wenig',
      nota: 'Dreimal verlieren ist Lernen. Achtmal ist etwas anderes.',
      recompensa: 'Morgen +2 Startenergie',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: 'Der Mittag ohne Niederlage',
      nota:
          'Wer mittags hochsteigt, nimmt Geld dafür. Sollen sie nichts kriegen.',
      recompensa: 'Morgen +1 Gratiskarte bei allen Gefahren',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: 'Die Champions beim ersten Mal',
      nota: 'Champions schlägt man einmal. Wiederholen ist unhöflich. ',
      recompensa: 'Morgen +3 Startenergie',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: 'Lass was übrig',
      nota: 'Ich will den Tempel stehen sehen und dich mit Lust zum Fegen. ',
      recompensa: 'Morgen Energieobergrenze +5',
    ),
    'sin_curarse': TextoEncargo(
      titulo: 'Ohne Hilfe durchhalten',
      nota: 'Das heilige Wasser ist fürs Feuer, nicht für deine Ausreden.',
      recompensa: 'Morgen +1 Gratiskarte bei allen Gefahren',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: 'Auf der Kippe',
      nota:
          'Mit fünf Energie zu gewinnen hat mehr Verdienst. Und weniger Verstand. ',
      recompensa: 'Morgen +4 Startenergie',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: 'Morgen',
      queCartasLleva: 'Die 10 Gefahr-/Technikkarten des Morgen-Decks',
      descripcion:
          'Geschnitzter Lotos mittig, dahinter die Sonne tief am Horizont.',
    ),
    'Mediodía': TextoReverso(
      nombre: 'Mittag',
      queCartasLleva: 'Die 10 Gefahr-/Technikkarten des Mittag-Decks',
      descripcion: 'Gleicher Lotos, dahinter die Sonne hoch und voll.',
    ),
    'Ocaso': TextoReverso(
      nombre: 'Abend',
      queCartasLleva: 'Die 10 Gefahr-/Technikkarten des Abend-Decks',
      descripcion:
          'Gleicher Lotos, dahinter die sinkende Sonne, lange Schatten.',
    ),
    'Jefes': TextoReverso(
      nombre: 'Champions',
      queCartasLleva: 'Die 5 Turnierchampion-Karten',
      descripcion:
          'Schwarzer Lotos, schwererer Rahmen, keine Sonne. Muss schwerer wirken als die anderen drei.',
    ),
    'Combate': TextoReverso(
      nombre: 'Kampf',
      queCartasLleva: 'Die 20 Starttechniken',
      descripcion:
          'Schlichter Lotos, ruhiges Muster, keine Sonne. Dieses Deck hat der Spieler die ganze Zeit in der Hand: halt es zurückhaltend.',
    ),
  },
);
