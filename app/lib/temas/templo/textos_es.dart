import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en español.
const textosTemploEs = TextosTema(
  nombre: 'El Guardián del Templo',
  protagonista: 'El Novato',
  bajada: 'Shifu se fue siete días. No quemés el templo.',
  recurso: 'Energía',
  nombreFase: {
    Fase.alba: 'Alba',
    Fase.mediodia: 'Mediodía',
    Fase.ocaso: 'Ocaso',
    Fase.jefes: 'Enfrentamiento Final',
  },
  cartas: {
    'puno_torpe': TextoCarta('Puño Torpe'),
    'postura_flamenco': TextoCarta(
      'Postura del Flamenco',
      'No es una postura Shaolin, pero funciona.',
    ),
    'patada_descuidada': TextoCarta(
      'Patada Descuidada',
      'Casi te caés para atrás.',
    ),
    'respiracion_agitada': TextoCarta(
      'Respiración Agitada',
      'Sonás como un fuelle roto.',
    ),
    'duda_existencial': TextoCarta(
      'Duda Existencial',
      '¿Y si el Kung Fu es aeróbic con actitud?',
    ),
    'alba1': TextoCarta('Mosquito del Templo'),
    'garra_inicial': TextoCarta(
      'Garra Inicial',
      'Tu primer movimiento que parece intencional.',
    ),
    'alba2': TextoCarta('Bandido con Palo Podrido'),
    'puno_bambu': TextoCarta('Puño del Bambú'),
    'alba3': TextoCarta('Jarra de Té Volcada'),
    'equilibrio': TextoCarta(
      'Equilibrio',
      'Aprendiste a no tropezar con tu propio pie.',
    ),
    'alba4': TextoCarta('Siesta Tentadora'),
    'despertar_brusco': TextoCarta(
      'Despertar Brusco',
      'El Maestro te tiró un balde de agua fría.',
    ),
    'alba5': TextoCarta('Gato Guardián del Templo'),
    'rascada_felina': TextoCarta(
      'Rascada Felina',
      'Aprendiste del mejor luchador del templo.',
    ),
    'alba6': TextoCarta('Compañero Burlón'),
    'mirada_fija': TextoCarta(
      'Mirada Fija',
      'Lo asustaste con tus ojos de novato hambriento.',
    ),
    'alba7': TextoCarta('Piedra en el Zapato'),
    'paso_firme': TextoCarta(
      'Paso Firme',
      'Por fin usás zapatillas de entrenamiento.',
    ),
    'alba8': TextoCarta('Soga de Saltar Rota'),
    'salto_novato': TextoCarta(
      'Salto del Novato',
      'Tocaste las campanas del templo con la cabeza.',
    ),
    'alba9': TextoCarta('Araña en el Tazón de Arroz'),
    'reflejo': TextoCarta('Reflejo', 'La araña sobrevivió. Vos también.'),
    'alba10': TextoCarta('Viento Frío de la Mañana'),
    'resistencia': TextoCarta(
      'Resistencia',
      'El frío fortalece el espíritu. Vos solo querés una frazada.',
    ),
    'med1': TextoCarta('Tres Bandidos Hambrientos'),
    'puno_tigre': TextoCarta(
      'Puño del Tigre',
      'Ruge como un gatito. Pega como un tigre.',
    ),
    'med2': TextoCarta('Mercenario con Espada de Juguete'),
    'ala_grulla': TextoCarta('Ala de Grulla', 'Elegancia sobre fuerza.'),
    'med3': TextoCarta('Duda: "¿Sirve esto?"'),
    'fe_renovada': TextoCarta(
      'Fe Renovada',
      'Shifu nunca mintió. Bueno, casi nunca.',
    ),
    'med4': TextoCarta('Ira Incontrolable'),
    'colmillo_serpiente': TextoCarta('Colmillo de Serpiente'),
    'med5': TextoCarta('Soldado del Gobernador Corrupto'),
    'zancada_leopardo': TextoCarta(
      'Zancada de Leopardo',
      'Rápido. Elegante. Confuso para el enemigo.',
    ),
    'med6': TextoCarta('Tentación de la Alacena'),
    'disciplina': TextoCarta(
      'Disciplina',
      'Las galletas de Shifu siguen ahí. Intactas. Sos un héroe.',
    ),
    'med7': TextoCarta('Maestro Falso de la Calle'),
    'escama_dragon': TextoCarta(
      'Escama de Dragón',
      'Aprendiste lo que NO hay que hacer. Eso cuenta.',
    ),
    'med8': TextoCarta('Puente Colgante Roto'),
    'vuelo_bambu': TextoCarta(
      'Vuelo del Bambú',
      'Cruzaste el abismo. Con estilo.',
    ),
    'med9': TextoCarta('Compañero Traidor'),
    'lealtad': TextoCarta(
      'Lealtad',
      'Perdonaste al traidor. Sos mejor persona que luchador.',
    ),
    'med10': TextoCarta('Tormenta de Arena Repentina'),
    'resistencia_desierto': TextoCarta(
      'Resistencia del Desierto',
      'La arena en los ojos es entrenamiento avanzado.',
    ),
    'oca1': TextoCarta('Líder de los Bandidos'),
    'rugido_tigre': TextoCarta(
      'Rugido del Tigre',
      'Ahora sí ruge como un tigre de verdad.',
    ),
    'oca2': TextoCarta('Asesino Silencioso'),
    'vuelo_grulla': TextoCarta(
      'Vuelo de Grulla',
      'Ni lo viste venir. Él tampoco te vio a vos.',
    ),
    'oca3': TextoCarta('Demonio del Orgullo'),
    'humildad': TextoCarta('Humildad', 'Te bajaste de tu nube. A los golpes.'),
    'oca4': TextoCarta('Demonio de la Pereza'),
    'determinacion': TextoCarta(
      'Determinación',
      'Te levantaste a las 4 AM. Una vez. Pero cuenta.',
    ),
    'oca5': TextoCarta('Maestro del Templo Rival'),
    'puno_dragon': TextoCarta(
      'Puño del Dragón',
      'Su templo tiene mejor presupuesto. Vos tenés corazón.',
    ),
    'oca6': TextoCarta('Ejército de Mercenarios'),
    'patada_tigre': TextoCarta(
      'Patada del Tigre',
      'Una patada. Muchos mercenarios. Matemática simple.',
    ),
    'oca7': TextoCarta('Demonio de la Ira'),
    'serenidad': TextoCarta('Serenidad', 'Respiraste hondo. El demonio no.'),
    'oca8': TextoCarta('Incendio en la Cocina del Templo'),
    'agua_sagrada': TextoCarta(
      'Agua Sagrada',
      'Apagaste el fuego. Nadie sabe cómo empezó. Fue Shifu, ¿no?',
    ),
    'oca9': TextoCarta('Traición del Discípulo Favorito'),
    'perdon': TextoCarta(
      'Perdón',
      'Le diste una segunda oportunidad. Y una patada.',
    ),
    'oca10': TextoCarta('Prueba del Gran Maestro (en sueños)'),
    'iluminacion': TextoCarta(
      'Iluminación',
      'Te despertaste empapado. Pero iluminado.',
    ),
    'jefe1': TextoCarta(
      'El Monje Caído',
      'Ex alumno estrella. Busca venganza... y galletas.',
    ),
    'jefe2': TextoCarta(
      'Tu Propio Reflejo',
      'Tenía tu cara. Y tenía razón en todo.',
    ),
    'jefe3': TextoCarta(
      'El Señor de los Mercenarios',
      'Paga bien a sus hombres. Huele mal. Muy mal.',
    ),
    'jefe4': TextoCarta(
      'El Gran Maestro del Templo del Loto Negro',
      'Su templo tiene pileta, sauna y tenedor libre. El tuyo tiene una piedra.',
    ),
    'jefe5': TextoCarta(
      'El Dragón de Papel',
      'Imponente, escupe fuego. Pero si llueve, se hace papilla.',
    ),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    //
    // LORE: una partida es UN día de guardia, y el día va Alba → Mediodía →
    // Ocaso. Los siete días son el plazo de Shifu, no la duración de la
    // partida: se defiende un día por vez, y la semana completa es la racha.
    // Nada de acá adentro puede contar días, salvo ese plazo.
    '01_templo_amanecer.png': TextoPanel(
      narracion:
          'En lo alto de la montaña, donde el viento se queja y el té nunca está lo bastante caliente, está el Templo del Loto Torcido.',
      conversacion: [
        Dicho('', '(Ciento ocho escalones hasta el portón.)'),
        Dicho('', '(El Novato los barre todas las mañanas. Todas las mañanas se vuelven a ensuciar.)'),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion:
          'Esta mañana, el Gran Maestro Shifu se fue al Congreso Anual de Maestros de Artes Marciales y Té de Jazmín.',
      conversacion: [
        Dicho('Shifu', 'Vuelvo en siete días. Confío en vos.'),
        Dicho('Novato', '¿Siete días yo solo?'),
        Dicho('Shifu', 'Solo no. Está Mei.'),
        Dicho('', '(Mei ya se había ido a dormir.)'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion:
          'Antes de irse dejó una nota, escrita con caligrafía impecable.',
      conversacion: [
        Dicho(
          'La nota',
          'Querido novato: no quemés el templo. No te comas las galletas de la alacena (son mías). Barré el patio todas las mañanas.',
        ),
        Dicho('La nota', 'Y sobre todo: NO DEJES ENTRAR A EXTRAÑOS.'),
        Dicho('Novato', 'Fácil.'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'Y abajo, con letra más chica, una posdata.',
      conversacion: [
        Dicho(
          'La nota',
          'P.D.: Si alguien pregunta por el "Gran Torneo Ilegal de Artes Marciales", decile que nos negamos rotundamente.',
        ),
        Dicho('Novato', '¿El qué?'),
        Dicho('Novato', '¿Nos negamos a QUÉ?'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion:
          'Shifu dobló la primera curva del camino. Doce segundos después, empezaron a subir.',
      conversacion: [
        Dicho('Novato', 'Bueno. Esto escaló rápido.'),
        Dicho('', '(Al principio eran catorce.)'),
      ],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: 'Y lo peor de todo no venía de afuera.',
      conversacion: [
        Dicho('Novato', 'Una sola galleta no se va a notar.'),
        Dicho('Novato', 'Ni las contó, seguro.'),
        Dicho('', '(Shifu las había contado.)'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion:
          'El día recién empieza. Vas a entrenar con lo que venga y vas a convertir cada paliza en una técnica nueva.',
      conversacion: [
        Dicho('', '(Alba. Mediodía. Ocaso.)'),
        Dicho('', '(Tres veces sube la montaña, y cada vez sube algo peor.)'),
        Dicho('Novato', 'Puedo con esto.'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion:
          'Y cuando el sol se hunda detrás de la montaña, dos Campeones del Torneo van a golpear el portón para quedarse con el templo.',
      conversacion: [
        Dicho('Novato', '¿Voy a poder proteger el templo?'),
        Dicho('Novato', '¿Y las galletas de Shifu?'),
        Dicho('', '(Una de las dos respuestas iba a ser que no.)'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion:
          'Aguantaste el Alba. Te duele todo, pero seguís parado y el patio sigue siendo tuyo.',
      conversacion: [
        Dicho('Novato', 'Uno menos.'),
        Dicho('', '(El sol recién estaba subiendo.)'),
      ],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion:
          'Mei, la gata guardiana, evaluó tu desempeño desde el techo. No quedó impresionada.',
      conversacion: [
        Dicho('Mei', '(silencio felino demoledor)'),
        Dicho('Novato', 'Gané, ¿sabés?'),
        Dicho('Mei', '(parpadeo lento)'),
        Dicho('Novato', 'Bueno. Empaté.'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion:
          'Al Mediodía ya no suben curiosos. Suben los que cobran por estar acá.',
      conversacion: [
        Dicho(
          'Tao',
          'Nada mal para alguien que a la mañana no sabía cerrar el puño.',
        ),
        Dicho('Tao', 'Igual los de esta hora pegan distinto, eh.'),
        Dicho('Novato', '¿Y vos de qué lado estás?'),
        Dicho('Tao', 'Del que gana.'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion:
          'El Mediodía te dejó las manos en carne viva, pero el portón nunca se abrió para nadie que no quisieras.',
      conversacion: [
        Dicho('Novato', 'Dos.'),
        Dicho('', '(Las sombras del patio ya empezaban a estirarse.)'),
      ],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion: 'Tao se fue cuando el sol empezó a bajar. No se despidió.',
      conversacion: [
        Dicho('Novato', 'Ah. Así que era eso.'),
        Dicho('Tao', 'Del que gana, pibe. Te lo dije de entrada.'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion:
          'Con el Ocaso dejan de subir bandidos: los bandidos también le tienen miedo a la montaña a oscuras. Sube lo otro.',
      conversacion: [
        Dicho('', '(Las sombras del patio dejaron de coincidir con el patio.)'),
        Dicho('Novato', 'No hay nadie ahí.'),
        Dicho('Novato', 'No hay nadie ahí.'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion:
          'Aguantaste el Ocaso entero, incluidos los que tenían tu cara. La montaña quedó en silencio.',
      conversacion: [
        Dicho('Novato', 'Se terminó.'),
        Dicho('', '(No se había terminado.)'),
      ],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: 'Tres golpes en el portón. Ninguno pidió permiso.',
      conversacion: [
        Dicho('', '(Uno.)'),
        Dicho('', '(Dos.)'),
        Dicho('', '(Tres.)'),
        Dicho('Novato', 'Está bien. Vengan.'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion:
          'El Gran Torneo Ilegal de Artes Marciales necesita sede. Vinieron a buscar la tuya.',
      conversacion: [
        Dicho('Los Campeones', 'Nos dijeron que acá no había nadie.'),
        Dicho('Novato', 'Les dijeron mal.'),
      ],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion:
          'Los dos Campeones se fueron por donde vinieron. Uno de ellos cojeando.',
      conversacion: [
        Dicho('Novato', 'El templo no está en venta.'),
        Dicho('', '(Mei bajó del techo por primera vez en todo el día.)'),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion:
          'Cumplido el plazo, Shifu volvió. El mismo sombrero, el mismo bolso, la misma cara.',
      conversacion: [
        Dicho('Shifu', 'El patio está barrido. El templo está en pie. Bien.'),
        Dicho('Novato', 'Estuvo tranquilo.'),
        Dicho('Shifu', 'Mm.'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'Después abrió la alacena.',
      conversacion: [
        Dicho('Shifu', 'Faltan dos.'),
        Dicho('Novato', 'Mei.'),
        Dicho('Mei', '(ya no estaba en el cuadro)'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion: 'No te quedó nada. Ni Energía, ni técnicas, ni excusas.',
      conversacion: [Dicho('', '(El portón quedó abierto. Nadie lo cerró.)')],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: 'Shifu volvió puntual, como siempre.',
      conversacion: [
        Dicho('Shifu', '...'),
        Dicho('Novato', 'Puedo explicarlo.'),
        Dicho('Shifu', '...'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'Y después hizo la única pregunta que importaba.',
      conversacion: [
        Dicho('Shifu', '¿Y las galletas?'),
        Dicho('', '(Ésa fue la parte difícil de explicar.)'),
      ],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: 'Nada de meditar',
      nota: 'Meditar está sobrevalorado. Aguantate el mazo que tenés.',
      recompensa: '+2 de Energía inicial mañana',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: 'Terminá entero',
      nota: 'No me sirve un guardián que gana y queda tirado en el patio.',
      recompensa: '+2 de Energía inicial mañana',
    ),
    'alba_impecable': TextoEncargo(
      titulo: 'El Alba impecable',
      nota:
          'Si perdés contra un mosquito, no quiero saber nada del'
          'resto. ',
      recompensa: 'Meditar sale gratis mañana',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: 'Sin gastar de más',
      nota:
          'La Energía no crece en el bambú. Arreglate con lo que te'
          'toca. ',
      recompensa: '+1 carta gratis en todos los peligros mañana',
    ),
    'purga_profunda': TextoEncargo(
      titulo: 'Limpieza de técnica',
      nota: 'Sacate de encima esas dudas. Todas. Hoy.',
      recompensa: 'Meditar elimina 2 cartas mañana',
    ),
    'partida_corta': TextoEncargo(
      titulo: 'Rápido y limpio',
      nota:
          'El templo no se defiende solo, pero tampoco tenés todo el'
          'día. ',
      recompensa: '+3 de Energía inicial mañana',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: 'Perdé poco',
      nota: 'Perder tres veces es aprendizaje. Perder ocho es otra cosa.',
      recompensa: '+2 de Energía inicial mañana',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: 'El Mediodía sin caídas',
      nota: 'Los que suben al mediodía cobran por venir. Que no cobren.',
      recompensa: '+1 carta gratis en todos los peligros mañana',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: 'Los Campeones de una',
      nota:
          'A los Campeones se los vence una vez. Repetir es de mala'
          'educación. ',
      recompensa: '+3 de Energía inicial mañana',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: 'Que sobre',
      nota:
          'Quiero encontrar el templo en pie y a vos con ganas de'
          'barrer. ',
      recompensa: 'Tope de Energía +5 mañana',
    ),
    'sin_curarse': TextoEncargo(
      titulo: 'Aguantar sin ayuda',
      nota: 'El agua sagrada es para el fuego, no para tus excusas.',
      recompensa: '+1 carta gratis en todos los peligros mañana',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: 'Al filo',
      nota:
          'Ganar con cinco de Energía tiene más mérito. Y menos'
          'sentido común. ',
      recompensa: '+4 de Energía inicial mañana',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: 'Alba',
      queCartasLleva: 'Las 10 cartas peligro/técnica del mazo del Alba',
      descripcion:
          'Loto tallado centrado, sol asomando bajo en el horizonte detrás.',
    ),
    'Mediodía': TextoReverso(
      nombre: 'Mediodía',
      queCartasLleva: 'Las 10 cartas peligro/técnica del mazo del Mediodía',
      descripcion: 'Mismo loto, sol alto y pleno detrás.',
    ),
    'Ocaso': TextoReverso(
      nombre: 'Ocaso',
      queCartasLleva: 'Las 10 cartas peligro/técnica del mazo del Ocaso',
      descripcion: 'Mismo loto, sol hundiéndose detrás, sombras largas.',
    ),
    'Jefes': TextoReverso(
      nombre: 'Jefes',
      queCartasLleva: 'Las 5 cartas de Campeón del Torneo',
      descripcion:
          'Loto negro, marco más recargado, sin sol. Debe verse más pesado que los otros tres.',
    ),
    'Combate': TextoReverso(
      nombre: 'Combate',
      queCartasLleva: 'Las 20 técnicas iniciales',
      descripcion:
          'Loto simple, patrón sobrio, sin sol. Es el mazo que el jugador tiene en la mano todo el tiempo: mantenelo tranquilo.',
    ),
  },
);
