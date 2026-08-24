import '../../models.dart';
import '../tema.dart';

/// Todo lo del tema Templo que NO depende del idioma: paleta, sujetos de
/// ilustración (en español, para pegar en el generador de imágenes) y los
/// archivos de cada viñeta.

const coloresTemplo = <Fase, int>{
  Fase.alba: 0xFF4F9E63,
  Fase.mediodia: 0xFFBE8A22,
  Fase.ocaso: 0xFFB2403C,
  Fase.jefes: 0xFF7048A8,
};

const sufijoEstiloTemplo =
    'ilustración de caricatura para una carta de juego de mesa, línea de tinta suelta y gruesa con manchas de acuarela planas, paleta cálida apagada, textura de papel crema, fondo simple y despejado, un solo sujeto centrado y grande, expresivo y con humor, ambientación de templo shaolin. NADA de fotorrealismo, ni 3D, ni brillos metálicos. FORMATO: imagen CUADRADA de 1024x1024 px; se coloca reducida dentro de la carta, no es el tamaño de la carta. Sin texto, sin letras, sin marcas de agua, sin bordes ni marcos.';

/// Reverso de carta. Un único diseño para las 65: la carta de peligro se muda
/// a tu mazo de combate cuando la ganás, así que un dorso por fase te delataría
/// en tu propio mazo qué carta estás por robar.
///
/// La simetría RADIAL no es capricho: la mitad de técnica se lee girando la
/// carta 180° y los cinco jefes son apaisados. Un dorso con arriba y abajo
/// filtraría información en las tres orientaciones.
const sufijoReversoTemplo =
    'diseño de reverso de carta, ocupa la carta entera, mandala centrado con simetría radial de ocho ejes que se ve idéntico girado 90, 180 y 270 grados, sin arriba ni abajo, sin personaje protagonista, paleta cálida apagada, textura de papel crema, estilo grabado en madera, colores planos. FORMATO: imagen VERTICAL de 744x1122 px, que es la carta completa con sangrado (corte a 57x89 mm). Sin texto, sin letras, sin números, sin marcas de agua, sin logos.';

/// Cartas de CASTIGO (modo Cansancio).
///
/// A diferencia de `sufijoEstiloTemplo` —que pide una viñeta cuadrada para
/// meter adentro de una carta— acá se pide la CARTA ENTERA, porque así está
/// hecho el resto del mazo: escena a sangre, cenefa dorada, nombre arriba y
/// frase de sabor abajo. Son gemelas de las cinco cartas iniciales en formato;
/// lo único que cambia es el medallón, que va en gris pizarra en vez de azul
/// para que se lean como basura de un vistazo, incluso en abanico.
const sufijoCastigoTemplo =
    'ilustración de carta de juego de mesa COMPLETA, escena a sangre que llena la carta entera, línea de tinta suelta y gruesa con manchas de acuarela planas, paleta cálida apagada y DESATURADA, textura de papel crema, ambientación de templo shaolin, tono de comedia física. El sujeto es el propio monje novato flaco de túnica naranja: no hay enemigo, el cuerpo se le rebeló solo. Cenefa dorada ornamentada tipo grecas de templo enmarcando la carta a 4 mm del borde, con esquinas decoradas. En la esquina superior izquierda, un medallón circular GRIS PIZARRA (#6B6259) con borde de tinta, vacío, reservado para el número. Franja libre de detalle en el borde superior y en el inferior para el nombre y la frase. NADA de fotorrealismo, ni 3D, ni brillos metálicos. FORMATO: imagen VERTICAL de 1024x1620 px, que es la carta completa. Sin texto, sin letras, sin números, sin marcas de agua.';

/// Logotipo del juego. El ISOTIPO ya existe (`assets/ui/logo.jpeg`): esto es
/// el título lletreado que le falta, montado encima del emblema.
const sufijoLogoTemplo =
    'logotipo de juego de mesa, fondo TRANSPARENTE, composición vertical centrada en tres bloques: emblema circular arriba, una línea de texto chica en banda de acuarela roja en el medio, y una línea de texto MUY grande abajo ocupando todo el ancho. Lletreado a mano con pincel, mayúsculas, trazos gruesos e irregulares, ligeramente desprolijo y con humor, nunca rígido ni geométrico. NO usar tipografías falsamente orientales de palotes quebrados. Letras en tinta marrón oscuro #4A3728 con contorno crema #F7F1E1 de 6 px y sombra plana dorada #C99A2E desplazada 8 px abajo a la derecha. NADA de 3D, ni metal, ni relieve, ni degradados, ni brillos. Tiene que leerse a 40 mm de ancho impreso y en blanco y negro. FORMATO: imagen CUADRADA de 2048x2048 px con canal alfa.';

/// Tapa de la caja. El tercio superior queda vacío a propósito: ahí va el
/// logotipo, y si el generador mete detalle lo tapa.
const sufijoCajaTemplo =
    'ilustración de tapa de caja de juego de mesa, caricatura, línea de tinta suelta y gruesa, manchas de acuarela planas, paleta cálida apagada, textura de papel crema, tono de comedia. El TERCIO SUPERIOR queda DESPEJADO —cielo liso, sin ningún detalle— porque ahí se coloca el logotipo. NADA de fotorrealismo, ni 3D, ni pintura digital realista, ni brillos metálicos. La imagen llega hasta el borde del lienzo (sangrado). FORMATO: imagen VERTICAL de 921x1441 px (tapa de 72x116 mm con 3 mm de sangrado a 300 dpi). Sin texto, sin letras, sin números, sin logos, sin marcas de agua.';

const sujetosTemplo = <String, String>{
  'puno_torpe':
      'un monje novato flaco lanzando un puñetazo mal formado, con el pulgar metido dentro del puño, haciendo una mueca',
  'postura_flamenco':
      'un monje novato flaco haciendo equilibrio en una pierna como un flamenco, los brazos agitándose, a punto de caerse',
  'patada_descuidada':
      'un monje novato flaco en plena patada, ya cayéndose hacia atrás, con una sandalia saliendo volando',
  'respiracion_agitada':
      'un monje novato flaco doblado con las manos en las rodillas, sin aire, con gotas de sudor saltando',
  'duda_existencial':
      'un monje novato flaco sentado con las piernas cruzadas mirando al vacío, con un enorme signo de pregunta hecho de humo de incienso sobre su cabeza',
  'alba1':
      'un mosquito enorme y engreído flotando en el aire, las alas zumbando, ojitos furiosos',
  'garra_inicial':
      'un monje novato sosteniendo una postura de garra que por fin parece intencional, con una pequeña sonrisa de orgullo',
  'alba2':
      'un bandido desaliñado blandiendo un palo de madera podrido que se le está desarmando en la mano',
  'puno_bambu':
      'un monje novato golpeando limpiamente una caña de bambú, con una onda de energía verde alrededor del puño',
  'alba3':
      'una tetera de barro volcada derramando té sobre las tablas del templo, con vapor subiendo',
  'equilibrio':
      'un monje novato parado perfectamente quieto sobre un pie en un poste de piedra, calmo y centrado',
  'alba4':
      'una estera de dormir enrollada que brilla invitante como un tesoro, con pequeños símbolos de sueño flotando alrededor',
  'despertar_brusco':
      'un monje novato empapado y completamente despierto, con un balde de madera vacío todavía girando sobre su cabeza',
  'alba5':
      'una gata atigrada gorda y tuerta sentada sobre las tejas del templo, mirando con desprecio absoluto',
  'rascada_felina':
      'un monje novato lanzando un zarpazo con los dedos en garra, con tres marcas de arañazo cortando el aire',
  'alba6':
      'un monje adolescente con sonrisa burlona y cinturón verde apoyado en un poste, señalando y riéndose',
  'mirada_fija':
      'primerísimo plano de la mirada intensa y sin parpadeo de un monje novato, hambriento y un poco perturbado',
  'alba7':
      'un pie descalzo levantado de dolor con una piedrita filosa clavada en la planta, con líneas de movimiento',
  'paso_firme':
      'un monje novato plantando con firmeza una zapatilla de entrenamiento sobre la piedra, con polvo saliendo alrededor de la suela',
  'alba8':
      'una soga de saltar partida al medio, con los dos extremos deshilachados saliendo volando en el aire',
  'salto_novato':
      'un monje novato saltando alto y golpeando con la cabeza una campana colgante del templo',
  'alba9':
      'una araña chiquita sentada tranquila en el medio de un tazón de arroz blanco',
  'reflejo':
      'un monje novato atrapando en el aire con dos dedos un grano de arroz que caía, con estela de movimiento',
  'alba10':
      'una ráfaga de viento frío de la mañana doblando cañas de bambú, con líneas de viento blancas arremolinadas y escarcha en las hojas',
  'resistencia':
      'un monje novato firme contra el viento frío, con la túnica azotada hacia atrás y la mandíbula apretada',
  'med1':
      'tres bandidos flacos y hambrientos amontonados compartiendo una sola mirada hostil, con las tripas sonando',
  'puno_tigre':
      'un monje novato lanzando un puñetazo recto hacia adelante con la cabeza fantasmal de un tigre rugiendo sobre su puño',
  'med2':
      'un mercenario fanfarrón sosteniendo una espada de juguete de madera pintada de colores, completamente serio',
  'ala_grulla':
      'un monje novato en una postura elegante de ala de grulla, los brazos extendidos como plumas y el peso en una pierna',
  'med3':
      'un monje novato mirándose las propias manos con evidente duda, con signos de pregunta tenues flotando en el aire',
  'fe_renovada':
      'un monje novato mirando hacia arriba con la convicción tranquila recuperada, con luz cálida y suave sobre la cara',
  'med4':
      'una figura de furia pura con la cara roja gruñendo, con vapor saliéndole de las orejas y los puños apretados',
  'colmillo_serpiente':
      'un monje novato atacando con dos dedos rígidos como colmillos de serpiente, con la sombra de una serpiente enroscada detrás',
  'med5':
      'un soldado con armadura y el escudo de un gobernador corrupto en el peto, con gesto despectivo y armado',
  'zancada_leopardo':
      'un monje novato saliendo disparado en una carrera baja y rápida, con estelas de manchas de leopardo detrás',
  'med6':
      'una alacena abierta con un frasco de galletas adentro, iluminado como una reliquia sagrada',
  'disciplina':
      'un monje novato cerrando deliberadamente la puerta de una alacena sobre un frasco de galletas, con los ojos apretados de aguante',
  'med7':
      'un charlatán callejero escandaloso con túnica llamativa haciendo una postura de kung fu falsa, obviamente un fraude',
  'escama_dragon':
      'un monje novato levantando el antebrazo para bloquear, con escamas de dragón brillantes formándose sobre su piel',
  'med8':
      'un puente colgante al que le faltan varias tablas sobre un barranco con niebla, con las sogas deshilachándose',
  'vuelo_bambu':
      'un monje novato cruzando un barranco con una pértiga de bambú, con el arco del movimiento marcado detrás',
  'med9':
      'un monje adolescente de cinturón verde alejándose con una bolsa de monedas, sin mirar atrás',
  'lealtad':
      'un monje novato extendiendo una mano abierta para ayudar a alguien a levantarse, con expresión de perdón',
  'med10':
      'una pared de arena repentina barriendo el patio, con todo tapado en tonos ocres',
  'resistencia_desierto':
      'un monje novato caminando hacia adelante entre la arena que vuela, con los ojos entrecerrados, sin inmutarse',
  'oca1':
      'un jefe bandido corpulento y lleno de cicatrices con capa de piel y una espada enorme mellada, sonriendo',
  'rugido_tigre':
      'un monje novato rugiendo con todo lo que tiene, con la cabeza translúcida de un tigre rugiendo junto a él',
  'oca2':
      'un asesino enmascarado apenas visible, solo los ojos y una hoja fina reflejando la luz de la luna',
  'vuelo_grulla':
      'un monje novato en el aire en pleno vuelo de grulla, con una pierna recogida y los brazos abiertos como alas',
  'oca3':
      'un demonio con la forma del propio monje novato, con una corona de papel torcida y el pecho inflado',
  'humildad':
      'un monje novato arrodillado inclinando la cabeza bien abajo, con polvo en los hombros, en paz',
  'oca4':
      'un demonio gordo y perezoso tirado sobre una almohada con forma de nube, bostezando enormemente',
  'determinacion':
      'un monje novato levantándose del piso al amanecer, agotado pero incorporándose, con los puños apretados',
  'oca5':
      'un maestro de un templo rival con túnicas de seda impecables, brazos cruzados, mirando por encima del hombro',
  'puno_dragon':
      'un monje novato golpeando con una cabeza de dragón de energía dorada saliendo de su puño',
  'oca6':
      'una pared de mercenarios con armadura idénticos que se extiende hasta el fondo, con las lanzas en alto',
  'patada_tigre':
      'un monje novato lanzando una patada giratoria enorme, con energía de rayas de tigre cruzando el aire',
  'oca7':
      'un demonio rojo chiquito de furia pura, demasiado enojado para su tamaño, dientes apretados y venas saltadas',
  'serenidad':
      'un monje novato sentado perfectamente calmo en medio del caos, con todo borroso menos él',
  'oca8':
      'llamas saliendo por la puerta de la cocina del templo, con ollas y sartenes volando y humo espeso',
  'agua_sagrada':
      'un monje novato arrojando un balde de agua bendita, con el arco del agua brillando apenas',
  'oca9':
      'un discípulo favorito bajando la hoja después de una traición, con culpa en la cara',
  'perdon':
      'un monje novato ofreciendo la mano a un oponente derrotado, todavía con cara de fastidio',
  'oca10':
      'una visión onírica de un viejo gran maestro flotando entre niebla arremolinada, con los ojos brillando en blanco',
  'iluminacion':
      'un monje novato despertándose empapado en sudor con un halo de luz suave detrás de la cabeza',
  'jefe1':
      'un monje caído con la túnica negra del templo rota, ojos amargos, aferrando una única galleta como si fuera una reliquia sagrada',
  'jefe2':
      'el reflejo del propio monje novato saliendo de un espejo de bronce rajado, con la misma cara pero '
      'los ojos vacíos y una sonrisa que sabe demasiado, hecho de humo oscuro de la cintura para abajo',
  'jefe3':
      'un señor mercenario enorme con armadura cara y mugrienta, con moscas zumbando alrededor, engreído',
  'jefe4':
      'un gran maestro impecable con seda al viento y un sirviente diminuto sosteniéndole una toalla y una bebida',
  'jefe5':
      'un dragón de desfile chino gigante asomándose y rugiendo, claramente construido con papel y bambú',
  // Las diez cartas de CASTIGO (modo Cansancio). No son enemigos: son el
  // propio cuerpo del novato pasándole la factura. El sujeto es siempre él,
  // desinflado, y el chiste es que la traición viene de adentro.
  'cans_bostezo':
      'un monje novato en plena postura de combate arruinada por un bostezo enorme e incontenible, con los ojos cerrados y lagrimeando, mientras un bandido chiquito frente a él también bosteza contagiado',
  'cans_vista':
      'primer plano de un monje novato bizqueando y frotándose los ojos, con dos siluetas borrosas y superpuestas del mismo bandido flotando delante de él',
  'cans_piernas':
      'un monje novato de torso firme y decidido cuyas piernas se doblaron como trapos mojados y se enroscaron solas en el piso, mirándolas con incredulidad',
  'cans_hombro':
      'un monje novato intentando levantar un brazo que le cuelga muerto del hombro, sosteniéndoselo con la otra mano, con pequeñas zetas de sueño saliéndole del hombro dormido',
  'cans_ampolla':
      'un monje novato gigante encogido de dolor señalando con horror una ampolla diminuta y brillante en el talón, con líneas de dolor rojas irradiando desde ese punto',
  'cans_nudillo':
      'primer plano del puño de un monje novato con un nudillo partido y vendado con un trapo sucio, temblando, mientras él aprieta los dientes',
  'cans_calambre':
      'un monje novato congelado en el aire a mitad de una patada perfecta, con la cara deformada por un calambre y un rayo de dolor cruzándole el muslo',
  'cans_zumbido':
      'un monje novato con la cabeza torcida golpeándose la oreja con la palma abierta, con espirales de zumbido saliendo del oído y un mosquito engreído alejándose volando al fondo',
  'cans_espalda':
      'un monje novato adolescente doblado en noventa grados con las dos manos en la zona lumbar, caminando como un anciano, con la columna dibujada como una rama a punto de quebrarse',
  'cans_renunciar':
      'un monje novato sentado en el escalón del templo con la mirada perdida, soñando con un puesto de fideos humeante que flota sobre su cabeza como una nube de pensamiento',
};

/// Archivo y boceto de cada viñeta. El boceto es para quien ilustra: no lo
/// ve el jugador, por eso no se traduce.
const panelesTemplo = <String, List<PanelArte>>{
  'intro': [
    PanelArte(
      archivo: '01_templo_amanecer.png',
      boceto:
          'Plano general del templo en la cima de la montaña, al amanecer. Niebla baja, escalinata larga, patio de piedra, un loto tallado y torcido sobre el portón.',
    ),
    PanelArte(
      archivo: '02_shifu_se_va.png',
      anclaX: 0.40,
      anclaY: 0.45,
      boceto:
          'Shifu de espaldas, bolso al hombro y sombrero de paja, bajando la escalinata. El Novato lo saluda desde el portón. Mei, la gata, mira desde una teja.',
    ),
    PanelArte(
      archivo: '03_la_nota.png',
      boceto:
          'Primer plano de una nota apoyada en la mesa del templo, junto a una taza de té. Caligrafía impecable. El Novato la lee de costado.',
    ),
    PanelArte(
      archivo: '04_posdata.png',
      boceto:
          'Detalle del pie de la nota. El Novato la sostiene con cara de confusión total, una ceja levantada.',
    ),
    PanelArte(
      archivo: '05_llegan_los_problemas.png',
      anclaX: 0.50,
      anclaY: 1.02,
      boceto:
          'Contrapicado desde el portón: siluetas en el horizonte subiendo la montaña. Bandidos con palos, un mercenario, y el Vendedor Ambulante con espadas de juguete colgadas del cinturón.',
    ),
    PanelArte(
      archivo: '06_tentaciones.png',
      anclaX: 0.61,
      anclaY: 0.28,
      boceto:
          'El Novato frente a la alacena abierta, el frasco de galletas iluminado como un tesoro. En el hombro, un demonio chiquito de la pereza bostezando.',
    ),
    PanelArte(
      archivo: '07_entrenamiento.png',
      boceto:
          'Montaje de entrenamiento: el Novato golpeando un poste, cayéndose, levantándose. Alrededor, cartas de técnica flotando como si se sumaran a su mazo.',
    ),
    PanelArte(
      archivo: '08_campeones.png',
      anclaX: 0.53,
      anclaY: 0.20,
      boceto:
          'Dos siluetas enormes recortadas contra el atardecer rojo, paradas en el portón. El Novato, chiquito, de espaldas, en guardia.',
    ),
  ],
  'mediodia': [
    PanelArte(
      archivo: '10_fin_alba.png',
      boceto:
          'El patio hecho un desastre: jarras rotas, un palo partido, plumas en el aire. El Novato de pie, despeinado y con un moretón, pero entero. Sol subiendo.',
    ),
    PanelArte(
      archivo: '11_mei_juzga.png',
      boceto:
          'Mei, la gata guardiana del templo, sentada en una teja, mirando al Novato con desprecio absoluto. El Novato le devuelve la mirada.',
    ),
    PanelArte(
      archivo: '12_llega_tao.png',
      anclaX: 0.35,
      anclaY: 0.17,
      boceto:
          'Tao, compañero de entrenamiento, apoyado en el portón masticando algo, sonrisa torcida. Detrás, en el camino, se ven soldados con armadura subiendo.',
    ),
  ],
  'ocaso': [
    PanelArte(
      archivo: '20_fin_mediodia.png',
      boceto:
          'Sol alto y sombras cortas. El patio lleno de gente retirándose derrotada. El Novato apoyado en el poste de entrenamiento, agotado, con las manos vendadas.',
    ),
    PanelArte(
      archivo: '21_traicion_tao.png',
      boceto:
          'Tao bajando la escalinata con una bolsa de monedas, sin mirar atrás. Un soldado del Gobernador le palmea el hombro. El Novato lo ve desde arriba.',
    ),
    PanelArte(
      archivo: '22_cae_la_noche.png',
      boceto:
          'El sol hundiéndose detrás de la montaña, el patio en penumbra. Sombras raras y alargadas que no corresponden a ningún objeto real.',
    ),
  ],
  'jefes': [
    PanelArte(
      archivo: '30_fin_ocaso.png',
      boceto:
          'El Novato solo en el patio a la madrugada, rodeado de demonios que se deshacen en humo. Está temblando pero de pie.',
    ),
    PanelArte(
      archivo: '31_golpean_el_porton.png',
      boceto:
          'Primer plano del portón del templo vibrando por tres golpes secos. Polvo cayendo de las vigas. Mei erizada, huyendo del cuadro.',
    ),
    PanelArte(
      archivo: '32_los_campeones.png',
      boceto:
          'Los dos Campeones del Torneo entrando al patio, enormes, a contraluz. El Novato en guardia en el centro, chiquito y decidido.',
    ),
  ],
  'victoria': [
    PanelArte(
      archivo: '40_victoria_campeones.png',
      boceto:
          'Los dos Campeones tirados en el patio, aturdidos. El Novato de pie en el medio, respirando fuerte, la ropa destrozada. Mei sentada en el pecho de uno de ellos.',
    ),
    PanelArte(
      archivo: '41_vuelve_shifu.png',
      boceto:
          'Shifu subiendo la escalinata con el sombrero de paja y el bolso, igual que se fue. El patio detrás, recién barrido. Séptimo atardecer.',
    ),
    PanelArte(
      archivo: '42_las_galletas.png',
      boceto:
          'Shifu de espaldas frente a la alacena abierta, contando galletas con un dedo. El Novato mira a Mei. Mei mira decididamente hacia otro lado.',
    ),
  ],
  'derrota': [
    PanelArte(
      archivo: '50_derrota_patio.png',
      boceto:
          'El Novato de rodillas en el patio vacío, cabeza gacha, el mazo de técnicas desparramado por el piso. Amanece gris.',
    ),
    PanelArte(
      archivo: '51_shifu_ve_el_desastre.png',
      boceto:
          'Shifu parado en el portón con el bolso todavía al hombro, mirando el desastre. Cara completamente inexpresiva, que es peor que el enojo.',
    ),
    PanelArte(
      archivo: '52_la_pregunta.png',
      boceto:
          'Primerísimo plano de Shifu abriendo la alacena vacía. Reflejo del Novato en el vidrio del frasco, chiquito y culpable.',
    ),
  ],
};

const reversosTemplo = <ReversoArte>[
  ReversoArte(
    mazo: 'Alba',
    colorFondoHex: '#7BC67E',
    prompt:
        'medallón de una flor de loto tallada, centrado, con un sol naciente '
        'bajo en el horizonte detrás, fondo verde pálido, borde decorativo '
        'simétrico, $sufijoReversoTemplo',
  ),
  ReversoArte(
    mazo: 'Mediodía',
    colorFondoHex: '#E0B14A',
    prompt:
        'medallón de una flor de loto tallada, centrado, con un sol de '
        'mediodía alto y pleno detrás, fondo dorado cálido, borde decorativo '
        'simétrico, $sufijoReversoTemplo',
  ),
  ReversoArte(
    mazo: 'Ocaso',
    colorFondoHex: '#C85450',
    prompt:
        'medallón de una flor de loto tallada, centrado, con un sol '
        'hundiéndose detrás, fondo rojo profundo, sombras largas, borde '
        'decorativo simétrico, $sufijoReversoTemplo',
  ),
  ReversoArte(
    mazo: 'Jefes',
    colorFondoHex: '#9B6BD6',
    prompt:
        'medallón de una flor de loto negra, centrado, sin sol, borde '
        'recargado y pesado, fondo violeta profundo, $sufijoReversoTemplo',
  ),
  ReversoArte(
    mazo: 'Combate',
    colorFondoHex: '#6FA8DC',
    prompt:
        'emblema simple de flor de loto, centrado, patrón repetido sobrio, '
        'fondo azul apagado, borde fino, $sufijoReversoTemplo',
  ),
];
