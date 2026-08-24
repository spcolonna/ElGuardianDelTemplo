'use strict';
/* La prosa de los dos librillos.
 *
 * REGLA DE ESTE ARCHIVO: acá no hay un solo número escrito a mano. Todo lo que
 * el motor sabe se pide con {n:ruta} y lo resuelve `referencias.js` contra
 * `imprenta/datos/juego_templo_es.json`, que genera `bin/export_libro.dart`.
 *
 * La única excepción está marcada y explicada: los tres niveles de dificultad
 * que el reglamento agrega y la app no tiene. Ésos no se pueden exportar
 * porque no existen en el motor, y por eso el propio reglamento los muestra
 * con el cartel de "sin simular".
 */

// ------------------------------------------------------------------ helpers
const p = (texto) => ({ t: 'parrafo', texto });
const h = (nivel, texto) => ({ t: 'titulo', nivel, texto });
const ul = (items) => ({ t: 'lista', orden: 'punto', items });
const ol = (items) => ({ t: 'lista', orden: 'numero', items });
const cap = (id, titulo) => ({ t: 'capitulo', id, titulo, empiezaImpar: true });
const ojo = (texto) => ({ t: 'aparte', tono: 'ojo', texto });
const bien = (texto) => ({ t: 'aparte', tono: 'bien', texto });
const mal = (texto) => ({ t: 'aparte', tono: 'mal', texto });

/** Los tres niveles que el reglamento inventa y el motor no tiene.
 *
 * No salen del JSON porque no existen en `modos/dificultad.dart`: son para
 * jugar en la mesa. Sus números NO están simulados —los cuatro de la app sí,
 * y `bin/sim.dart` mide Guardián en 14 % de victorias—, así que van marcados.
 */
const NIVELES_DE_PAPEL = [
  {
    nombre: 'Vigilia',
    bajada: 'La primera noche en que el cansancio pesa.',
    energia: 22, peligros: 8, jefes: 3, cansancio: '2 · Al caer el sol', robo: 1,
  },
  {
    nombre: 'El Séptimo Día',
    bajada: 'El último día del plazo de Shifu. No queda margen.',
    energia: 26, peligros: 9, jefes: 4, cansancio: '4 · Sin descanso', robo: 2,
  },
  {
    nombre: 'Shifu',
    bajada: 'No sabemos si se puede ganar. En serio.',
    energia: 30, peligros: 10, jefes: 5, cansancio: '5 · Ya venías cansado', robo: 2,
  },
];

const MODOS_CANSANCIO = [
  ['1', 'Sin Cansancio', 'El mazo de Cansancio se queda en la caja.', 'sí'],
  ['2', 'Al caer el sol', 'Entra una fatiga al terminar cada fase: tres por partida.', 'sí'],
  ['3', 'Al segundo aire', 'Entra una fatiga cada vez que se te acaba el mazo y barajás el descarte.', 'sí'],
  ['4', 'Sin descanso', 'Las dos anteriores a la vez.', 'no'],
  ['5', 'Ya venías cansado', 'Las diez fatigas barajadas dentro del mazo inicial, desde el primer turno.', 'no'],
];

// --------------------------------------------------------------- reglamento
function reglamento(d) {
  const b = [];

  b.push({
    t: 'portada',
    titulo: d.juego.nombre,
    bajada: d.juego.bajada,
    linea: 'Reglamento · 1 jugador · unos 25 minutos',
  });

  // ---------------------------------------------------------- de qué se trata
  b.push(cap('intro', 'De qué se trata'));
  b.push(p(
    'Shifu se fue siete días y te dejó a cargo del templo. Vos sos el Novato. ' +
    'Cada partida es <b>un día de guardia</b>, y el día va Alba, Mediodía y Ocaso. ' +
    'Al final del día llegan los Campeones del Torneo.'
  ));
  b.push(p(
    'Empezás con un mazo de peleador malo y {n:config.energiaInicial} de Energía. ' +
    'Cada peligro que superás se da vuelta y se convierte en una técnica que se suma ' +
    'a tu mazo: <b>el juego que jugás al final lo construiste ganando</b>.'
  ));
  b.push(mal(
    'Perdés en el instante en que tu Energía baja de 0. Es la única forma de perder, ' +
    'y no hay ninguna acción para curarte.'
  ));
  b.push(p(
    'Los siete días de Shifu <b>no son la duración de una partida</b>: son el plazo. ' +
    'Se defiende un día por vez, y la semana entera es la racha.'
  ));

  // ------------------------------------------------------------- componentes
  b.push(cap('componentes', 'Qué hay en la caja'));
  b.push({
    t: 'tabla',
    cabeceras: ['Componente', 'Cantidad', 'Medida'],
    filas: [
      ['Cartas de técnica inicial', '{n:mazoInicial.length} diseños, 20 cartas', '57 × 89 mm'],
      ['Cartas de peligro / técnica', '30', '57 × 89 mm'],
      ['Cartas de Cansancio', '{n:cansancio.cartas.length}', '57 × 89 mm'],
      ['Cartas de Jefe', '{n:jefes.length}', '112 × 70 mm'],
      ['Tablero de Energía', '1', '0 a 30'],
      ['Ficha de Energía', '1', '20 mm'],
    ],
  });
  b.push(ojo(
    'Los jefes son <b>físicamente más grandes</b> que el resto y tienen su propio dorso. ' +
    'Es a propósito: cuando salen a la mesa tiene que cambiar el clima.'
  ));

  b.push(h(2, 'La carta partida'));
  b.push({
    t: 'anatomia',
    carta: 'alba3.jpg',
    texto:
      'Ésta es la idea que sostiene todo el juego: <b>el peligro y su recompensa son la ' +
      'misma carta física</b>. Arriba está el peligro; abajo, impresa al revés, está la ' +
      'técnica que ganás si lo superás. Ganar es literalmente <b>dar vuelta la carta</b> ' +
      'y meterla en tu mazo.',
    llamadas: [
      'Arriba, el peligro: su Poder en el medallón rojo, y al costado el Daño que te ' +
      'hace si perdés y las cartas que podés robar gratis.',
      'La línea gruesa del medio separa las dos mitades. Es la que evita que sumes el ' +
      'número equivocado: mirá siempre de qué lado está el medallón.',
      'Abajo y al revés, la técnica: su Poder en el medallón azul, y su efecto.',
    ],
  });
  b.push(bien(
    'Por eso hay <b>un solo dorso</b> para todas las cartas. Si el dorso llevara el color ' +
    'de la fase, en tu propio mazo boca abajo sabrías qué carta viene: sería una fuga de ' +
    'información, no una decisión estética.'
  ));

  // ------------------------------------------------------------------ reglas
  b.push(cap('preparacion', 'Cómo se juega'));
  b.push(p(
    'Lo que sigue son las reglas exactas del juego tal como está balanceado hoy, ' +
    'con el nivel <b>Guardián</b>. Los demás niveles cambian algunos de estos ' +
    'números: están en la página {ref:capitulo:dificultad}.'
  ));
  b.push({ t: 'reglas' }); // se expande desde d.reglas

  // ---------------------------------------------------------------- glosario
  b.push(cap('efectos', 'Los cuatro efectos'));
  b.push(p(
    'Todas las técnicas del juego hacen alguna de estas cuatro cosas, o ninguna. ' +
    'No hay más. Y ninguna se elige: <b>se disparan solas</b> en cuanto la carta sale.'
  ));
  b.push({
    t: 'tabla',
    cabeceras: ['Efecto', 'Cuándo', 'Qué hace'],
    filas: [
      ['Roba N', 'al salir la carta', 'Robás N cartas más, y no te gastan robos gratis.'],
      ['+X Energía', 'al salir la carta', 'Sumás X. Ganes o pierdas después el combate.'],
      ['+X Energía si ganás', 'al resolver', 'Sumás X sólo si ganaste ese combate.'],
      ['−N al peligro', 'al salir la carta', 'Le bajás N al Poder del peligro. Nunca por debajo de 0.'],
    ],
  });
  b.push(ojo(
    'La diferencia entre las dos de Energía es el momento, y es la que más se ' +
    'malinterpreta. «+2 Energía» ya lo cobraste. «+2 Energía si ganás» todavía no.'
  ));

  b.push(cap('ejemplos', 'Cinco cartas que se malinterpretan'));
  b.push(p('Una página por carta, con la carta al lado y el paso a paso.'));

  b.push({
    t: 'ejemplo',
    carta: 'oca10.jpg',
    titulo: 'Iluminación — el robo en cascada',
    pasos: [
      'Iluminación tiene <b>Roba 2</b> y <b>+1 Energía</b>. Sale durante un combate.',
      'Primero cobrás el +1 de Energía.',
      'Después robás dos cartas. <b>Esas dos cartas también disparan sus efectos.</b>',
      'Si una de ellas es otra carta que roba, robás más todavía. El efecto encadena ' +
      'hasta que salga algo que no robe.',
      'Ninguno de esos robos te gasta cartas gratis: son robos por efecto, no por decisión.',
    ],
  });
  b.push({
    t: 'ejemplo',
    carta: 'med4.jpg',
    titulo: 'Colmillo de Serpiente — la única que baja el peligro',
    pasos: [
      'Es la <b>única carta del juego</b> con «−1 al peligro».',
      'No sube tu suma: <b>baja el número al que tenés que llegar</b>.',
      'Contra un peligro de Poder 5, con Colmillo en la mesa te alcanza con 4.',
      'Se acumula si sacás más de una, y nunca baja el peligro por debajo de 0.',
      'Sólo sirve si sale <b>antes</b> de que te plantes. Después de resolver no hace nada.',
    ],
  });
  b.push({
    t: 'ejemplo',
    carta: 'inicial_patada_descuidada.jpg',
    titulo: 'Patada Descuidada — un castigo por ganar',
    pasos: [
      'Tiene Poder 2, que para el mazo inicial es mucho. Y <b>−1 Energía si ganás</b>.',
      'Si perdés el combate, no pagás nada.',
      'Si ganás, perdés 1 de Energía. Es la única carta que te cobra por ganar.',
      'Por eso al meditar no siempre conviene tirar la carta de menos Poder: a veces ' +
      'la que te está desangrando es ésta.',
    ],
  });
  b.push({
    t: 'ejemplo',
    carta: 'oca7.jpg',
    titulo: 'Serenidad — y el tope que se come lo que sobra',
    pasos: [
      'Es la cura más grande del juego: <b>+3 Energía</b>.',
      'Se cobra al salir la carta, no al resolver.',
      'Pero nunca pasás de {n:config.energiaMaxima} de Energía: <b>lo que sobra se pierde</b>, ' +
      'y no hay ningún aviso.',
      'Con {n:config.energiaMaxima} de Energía, Serenidad no hace absolutamente nada. ' +
      'Conviene guardarla para cuando estés golpeado, salvo que no puedas elegir — y casi nunca podés.',
    ],
  });
  b.push({
    t: 'ejemplo',
    carta: 'inicial_postura_flamenco.jpg',
    titulo: 'Postura del Flamenco — Poder 0 que no es una carta muerta',
    pasos: [
      'Poder 0 y <b>Roba 1</b>. Parece basura y no lo es.',
      'El robo por efecto <b>no consume</b> tus cartas gratis.',
      'O sea: Flamenco es gratis. Ocupa un lugar en la mesa, no aporta Poder, pero ' +
      'trae otra carta sin costarte nada.',
      'Al meditar, pensalo dos veces antes de purgarla: adelgaza el mazo por sí sola.',
    ],
  });

  // ------------------------------------------------------------- dificultad
  b.push(cap('dificultad', 'Los niveles'));
  b.push(p(
    'Siete niveles, del más suave al que probablemente no se pueda ganar. ' +
    'Los cuatro primeros están en la app y <b>medidos</b>; los tres últimos son ' +
    'para la mesa y sus números son estimados.'
  ));
  b.push({ t: 'tabla-dificultades' });
  b.push(mal(
    'Los tres últimos niveles <b>no están simulados</b>. Los números son una estimación ' +
    'a mano: ajustalos jugando. El nivel <b>Guardián</b>, que es el balanceado, se gana ' +
    'sólo el 14 % de las veces — así que «duro» acá quiere decir duro.'
  ));

  b.push(h(2, 'Por qué los niveles difíciles dan MÁS Energía'));
  b.push(p(
    'Mirando la tabla parece un error: de Vigilia para arriba sube la Energía inicial ' +
    '<i>y</i> suben los peligros por fase. No es un error.'
  ));
  b.push(ul([
    '<b>Más peligros por fase es un mazo más fuerte</b>, no más difícil. Cada peligro ' +
    'que ganás es una técnica que te llevás. Enfrentar los 10 del Alba en vez de 7 ' +
    'significa llegar al Mediodía con tres cartas buenas más.',
    '<b>Las fatigas y los jefes de más hay que poder pagarlos.</b> Con cinco jefes y ' +
    'diez cartas de Cansancio en el mazo, 20 de Energía no alcanza para llegar al ' +
    'segundo jefe.',
    'Bajar los tres números a la vez no da un juego difícil: da uno imposible, y ' +
    'aburrido, porque perdés siempre en el mismo lugar.',
  ]));

  b.push(h(2, 'El Cansancio'));
  b.push(p(
    'Las {n:cansancio.cartas.length} cartas de Cansancio son cartas malas que se meten ' +
    'en tu mazo mientras jugás. Dos reglas valen para todos los modos:'
  ));
  b.push(ol([
    'La fatiga entra <b>barajada dentro del mazo</b>, nunca al descarte. Así no la ' +
    'podés purgar meditando antes de haberla jugado: primero te tiene que tocar.',
    '<b>Nunca se repite.</b> Son {n:cansancio.cartas.length} cartas distintas; cuando ' +
    'se agotan, no entra ninguna más en esa partida.',
  ]));
  b.push({
    t: 'tabla',
    cabeceras: ['', 'Modo', 'Cuándo entra una fatiga', '¿App?'],
    filas: MODOS_CANSANCIO,
  });
  b.push(ojo(
    'Los modos <b>4</b> y <b>5</b> existen sólo en este reglamento: la app no los tiene. ' +
    'Si los jugás en la mesa y te gustan, se pueden agregar.'
  ));

  // ------------------------------------------------------------- modo libre
  b.push(cap('libre', 'Modo Libre'));
  b.push(p(
    'El tablero de Energía llega hasta <b>30</b> y el juego sólo necesita ' +
    '{n:dificultades.0.energiaInicial}. Los que sobran son para esto: armar tu propio nivel.'
  ));
  b.push({
    t: 'tabla',
    cabeceras: ['Perilla', 'Rango', 'Qué mueve'],
    filas: [
      ['Energía inicial', '{n:libre.energiaInicial.min} a {n:libre.energiaInicial.max}',
       'Abajo de 12 el juego se vuelve una carrera y se decide temprano.'],
      ['Peligros por fase', '{n:libre.peligrosPorFase.min} a {n:libre.peligrosPorFase.max}',
       'Cuántas cartas de cada mazo entran en juego. <b>Sube la dificultad al bajar.</b>'],
      ['Jefes', '{n:libre.jefes.min} a {n:libre.jefes.max}', 'Cuántos Campeones enfrentás.'],
      ['Modo de Cansancio', '{n:libre.modosCansancio.min} a {n:libre.modosCansancio.max}',
       'La tabla de la página {ref:capitulo:dificultad}.'],
      ['Dureza del Cansancio', '0, −1 o −2', 'Cuánto Poder resta cada fatiga.'],
    ],
  });
  b.push(h(2, 'Cómo compensar'));
  b.push(p('Reglas de dedo para no quedar del lado imposible:'));
  b.push(ul([
    'Cada <b>jefe</b> de más: sumá 4 de Energía.',
    'Cada <b>peligro por fase</b> de menos: sumá 1 de Energía.',
    'Prender el <b>Cansancio</b> (modo 2 o 3): sumá 2. El modo 4: sumá 4. El modo 5: sumá 8.',
    'Subir el <b>coste de robo extra</b> a 2: sumá 3.',
  ]));
  b.push(bien(
    'Anotá con qué configuración jugaste y si ganaste. En cuatro o cinco partidas vas ' +
    'a saber dónde está tu nivel mejor que cualquier tabla.'
  ));

  // ------------------------------------------------------------- referencia
  b.push(cap('referencia', 'Todas las cartas'));
  b.push(p('Para consultar, no para leer de corrido.'));
  b.push({ t: 'referencia-cartas' });

  b.push(cap('comic', 'El cómic'));
  b.push(p(
    'La historia va en un librillo aparte, y se lee <b>mientras jugás</b>: cada vez ' +
    'que se te acaba el mazo de una fase, hay unas páginas esperándote. El librillo ' +
    'te va diciendo cuándo seguir.'
  ));
  b.push(p('Empezá por su primera página antes de tu primera partida.'));

  return b;
}

// --------------------------------------------------------------------- cómic
const INTERLUDIOS = {
  intro: {
    entrada: 'Leé esto antes de tu primera partida.',
    cierre: 'Hasta acá se lee sin jugar.',
    jugar: 'el <b>Alba</b>',
    gana: 'Si superaste el Alba',
  },
  mediodia: {
    entrada: 'Leé esto recién cuando se te acabe el mazo del Alba.',
    cierre: 'Se terminó el Alba.',
    jugar: 'el <b>Mediodía</b>',
    gana: 'Si superaste el Mediodía',
  },
  ocaso: {
    entrada: 'Leé esto recién cuando se te acabe el mazo del Mediodía.',
    cierre: 'Se terminó el Mediodía.',
    jugar: 'el <b>Ocaso</b>',
    gana: 'Si superaste el Ocaso',
  },
  jefes: {
    entrada: 'Leé esto recién cuando se te acabe el mazo del Ocaso.',
    cierre: 'Se terminó el Ocaso.',
    jugar: 'a los <b>Campeones</b>',
    gana: 'Si derrotaste a todos los Campeones',
  },
  victoria: {
    entrada: 'Leé esto cuando derrotes al último Campeón.',
    cierre: '',
  },
  derrota: {
    entrada: 'Leé esto si te quedaste sin Energía, en la fase que sea.',
    cierre: '',
  },
};
function comic(d) {
  const b = [];
  b.push({
    t: 'portada',
    titulo: d.juego.nombre,
    bajada: 'La historia del Novato',
    linea: 'Se lee mientras jugás. El librillo te dice cuándo.',
  });

  b.push(cap('como', 'Cómo se lee esto'));
  b.push(p(
    'Este librillo <b>no se lee de corrido</b>. Se lee a los saltos, intercalado con la ' +
    'partida: cada tanda de viñetas cuenta lo que acaba de pasar en la mesa.'
  ));
  b.push(ul([
    'Cada tanda termina en una página que dice <b>ALTO</b>. Ahí se corta la lectura: ' +
    'cerrás el librillo y jugás la fase que te indica.',
    'La página de ALTO te da dos salidas, una si superaste la fase y otra si te quedaste ' +
    'sin Energía. Cada una dice a qué página ir.',
    'Arriba de la primera viñeta de cada tanda hay un recuadro que repite en qué momento ' +
    'de la partida corresponde leerla. Si no coincide con lo que te pasó, no es tu tanda.',
    'La derrota es <b>una sola</b> y sirve para todas las fases: si te quedás sin Energía, ' +
    'vayas por donde vayas terminás en la misma página.',
  ]));
  b.push(p(
    '<b>No leas de más.</b> Pasar una página de ALTO sin jugar te quema el final.'
  ));

  for (const sec of d.comic) {
    const inter = INTERLUDIOS[sec.clave] || { entrada: sec.disparo, cierre: '', jugar: '' };
    sec.paneles.forEach((pan, i) => {
      b.push({
        t: 'vineta',
        // El ancla va en la PRIMERA viñeta de la secuencia: es la página a la
        // que apuntan las bifurcaciones.
        id: i === 0 ? sec.clave : undefined,
        archivo: `comic/${pan.archivo.replace(/\.[^.]+$/, '')}.jpg`,
        narracion: pan.narracion,
        dichos: pan.dichos,
        entrada: i === 0 ? inter.entrada : '',
      });
    });

    // Página de bifurcación al final de cada tanda, salvo los dos finales.
    if (sec.clave === 'victoria' || sec.clave === 'derrota') continue;
    const siguiente = { intro: 'mediodia', mediodia: 'ocaso', ocaso: 'jefes', jefes: 'victoria' }[sec.clave];
    b.push({
      t: 'bifurcacion',
      cierre: inter.cierre,
      jugar: inter.jugar,
      ramas: [
        { condicion: inter.gana, a: `vineta:${siguiente}` },
        // Obligatoria y la impone el generador: la derrota se dispara desde
        // cualquier fase y hay un solo final para todas.
        { condicion: 'Si te quedaste sin Energía', a: 'vineta:derrota' },
      ],
    });
  }
  return b;
}

// Se asigna directo y sin variable intermedia: los cinco archivos de
// `librillo/` se cargan como <script> clásicos y comparten el ámbito
// global, así que cualquier `const` repetido tumba la página entera.
if (typeof window !== 'undefined') window.CONTENIDO_ES = { reglamento, comic, NIVELES_DE_PAPEL, MODOS_CANSANCIO };
