// Textos de la interfaz en español: uruguayo, con voseo.
//
// Vive aparte de `l10n.dart` porque con siete idiomas el archivo único pasaba
// de las dos mil líneas y el diff de una traducción tapaba cualquier otra cosa.
// La clase y la lógica están en `l10n.dart`; acá no hay más que datos.
//
// Este es el mapa BASE: las claves que define acá son las que `bin/check.dart`
// le exige a todos los demás idiomas, con los mismos `{placeholders}`.

const uiEs = <String, String>{
  // navegación
  'nav.inicio': 'Inicio',
  'nav.volver': 'Volver',
  'medita.confirmar': '¿Eliminar {carta}?',
  'medita.confirmarSub': 'Sale del juego para siempre. No vuelve al mazo.',
  'medita.eliminar': 'Eliminar',
  'logro.primer_dia.titulo': 'Primer día',
  'logro.primer_dia.desc': 'Ganaste tu primera partida.',
  'logro.sin_una_derrota.titulo': 'Sin un rasguño',
  'logro.sin_una_derrota.desc': 'Ganaste sin perder un solo combate.',
  'logro.mente_limpia.titulo': 'Mente limpia',
  'logro.mente_limpia.desc': 'Ganaste después de eliminar 8 cartas o más.',
  'logro.nada_que_soltar.titulo': 'Nada que soltar',
  'logro.nada_que_soltar.desc': 'Ganaste sin meditar ni una vez.',
  'logro.pulmon.titulo': 'Pulmón',
  'logro.pulmon.desc': 'Ganaste con 12 de Energía o más.',
  'logro.por_un_pelo.titulo': 'Por un pelo',
  'logro.por_un_pelo.desc': 'Ganaste con 2 de Energía o menos.',
  'logro.sin_pagar_nada.titulo': 'Sin pagar nada',
  'logro.sin_pagar_nada.desc': 'Ganaste sin gastar Energía en robos.',
  'logro.relampago.titulo': 'Relámpago',
  'logro.relampago.desc': 'Ganaste en 20 turnos o menos.',
  'logro.alba_intacta.titulo': 'Alba intacta',
  'logro.alba_intacta.desc': 'Cruzaste el Alba sin perder un combate.',
  'logro.tres_jefes.titulo': 'Los tres',
  'logro.tres_jefes.desc': 'Ganaste una partida con tres jefes finales.',
  'logro.contra_el_cansancio.titulo': 'Contra el cansancio',
  'logro.contra_el_cansancio.desc':
      'Ganaste con el Mazo de Cansancio activado.',
  'logro.alumno_aplicado.titulo': 'Alumno aplicado',
  'logro.alumno_aplicado.desc': 'Cumpliste un encargo de Shifu.',
  'logro.maraton.titulo': 'Maratón',
  'logro.maraton.desc': 'Jugaste 25 partidas.',
  'logro.perseverante.titulo': 'Perseverante',
  'logro.perseverante.desc': 'Perdiste 10 veces y seguiste jugando.',
  'logro.racha7.titulo': 'Guardián del Templo',
  'logro.racha7.desc': 'Siete días seguidos defendiendo el templo.',
  'nav.logros': 'Misiones',
  'nav.modos': 'Modos',
  'nav.ajustes': 'Ajustes',
  'nav.mazo': 'Mazo',
  'logros.titulo': 'Misiones y logros',
  'logros.contador': '{a} de {b} desbloqueados',
  'logros.bloqueado': 'Todavía no lo conseguiste.',
  'logros.nuevo': '¡Logro desbloqueado!',
  'modos.titulo': 'Antes de empezar',
  'modos.dificultad': 'El camino',
  'modos.jefes': 'Jefes finales',
  'modos.extras': 'Reglas opcionales',
  'modos.empezar': 'Empezar',
  'modos.jefesAuto': 'Auto',
  'modos.energia': '{n} de Energía',
  'modos.jefes1': 'Un jefe final',
  'modos.jefesN': '{n} jefes',
  'modos.peligros': '{n} peligros por fase',
  'modos.roboExtra': 'Carta extra: {n}',
  'modos.cansFase': 'Cansancio al cerrar cada fase',
  'modos.cansBarajar': 'Cansancio al barajar',
  'modos.cansAmbos': 'Cansancio al cerrar fase y al barajar',
  'dif.aprendiz': 'Aprendiz',
  'dif.aprendizSub': 'Para aprender el juego sin sufrir.',
  'dif.novato': 'Novato',
  'dif.novatoSub': 'Ya sabés qué hacer. Igual duele.',
  'dif.guardian': 'Guardián',
  'dif.guardianSub': 'El juego como fue balanceado.',
  'dif.maestro': 'Maestro',
  'dif.maestroSub': 'Acá empieza a pesarte el cuerpo.',
  'dif.sombraDeShifu': 'Sombra de Shifu',
  'dif.sombraDeShifuSub': 'Casi él. Casi.',
  'dif.shifu': 'Shifu',
  'dif.shifuSub': 'El día imposible. Nadie lo superó todavía.',
  'modos.encargosT': 'Encargos de Shifu',
  'modos.encargosSub':
      'Shifu deja una nota con una condición extra. Es la misma todo el '
      'día y cambia mañana. Si ganás cumpliéndola, tu próxima partida '
      'arranca con una ventaja.',
  'modos.encargoHoy': 'La nota de hoy',
  'modos.encargoPremio': 'Si ganás cumpliéndola: {r}',
  'modos.encargoApagado': 'Prendelo para ver la nota de hoy.',
  'modos.cansancioT': 'Mazo de Cansancio',
  'modos.cansancioSub': 'Se te cuelan cartas de fatiga. Mucho más difícil.',
  'modos.loTraeElCamino': 'El camino {n} ya lo trae puesto.',
  // la tienda
  'tienda.titulo': 'El templo completo',
  'tienda.gancho': 'Un solo pago. Se abre todo y no vuelve a haber avisos.',
  'tienda.caminos': 'Los seis caminos',
  'tienda.sinAvisos': 'Sin publicidad',
  'tienda.extras': 'Encargos y Cansancio',
  'tienda.jefesLibres': 'Elegís los jefes',
  'tienda.comprar': 'Abrir el templo',
  'tienda.comprarPrecio': 'Abrir el templo · {precio}',
  'tienda.restaurar': 'Restaurar compra',
  'tienda.restaurarSub': 'Si ya lo compraste y reinstalaste la app.',
  'privacidad.titulo': 'Privacidad',
  'privacidad.opciones': 'Opciones de privacidad',
  'privacidad.opcionesSub': 'Cambiar lo que elegiste sobre los avisos.',
  'privacidad.politica': 'Política de privacidad',
  'privacidad.politicaSub':
      'Qué guarda el juego y qué no. Se abre en el navegador.',
  'tienda.bloqueado': 'Se abre con el templo completo.',
  'tienda.verMas': 'Ver qué incluye',
  'tienda.gracias': 'Gracias. El templo es tuyo.',
  'tienda.noDisponible': 'La tienda no responde. Probá más tarde.',
  'tienda.pensando': 'Un momento…',
  'ajustes.titulo': 'Ajustes',
  'ajustes.musica': 'Música',
  'ajustes.efectos': 'Efectos de sonido',
  'ajustes.sobre': 'El Guardián del Templo — Loto Torcido',
  'patio.jugar': 'Jugar',
  'patio.rachaCorta': 'Racha {a}/{b}',
  'nav.bitacora': 'Bitácora',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano':
      'Ganaste el combate: sólo podés meditar después de perder. (Se puede cambiar en Balance.)',
  'medita.motivoVacio':
      'Tu descarte está vacío: no hay ninguna carta que puedas eliminar.',
  'medita.motivoEnergia': 'Necesitás más de {n} de Energía para meditar.',
  'medita.explica':
      'Elegí una carta para eliminar del juego (−{coste} de Energía).',
  'encargo.beneficio': 'Beneficio de ayer aplicado: {b}',
  'encargo.titulo': 'Encargo: {t}',
  'encargo.cumplido': 'Cumplido. Mañana arrancás con: {r}.',
  'encargo.fallado': 'No lo cumpliste. Shifu no dice nada, que es peor.',
  'juego.poderBase': 'Poder base {a} · reducido en {b}',
  'juego.teEspera': 'Te espera {n}.',
  'juego.sinPeligro':
      'Sin peligro revelado. Da vuelta la carta superior del mazo del {fase}.',
  'juego.revelar': 'Revelar',
  'juego.enfrentarJefe': 'Enfrentar al jefe',
  'juego.finGano': 'Las galletas de Shifu siguen intactas.',
  'juego.finPerdio': 'Caíste en {fase} con {n} de Energía.',
  'juego.resGanados': 'Ganados {n}',
  'juego.resPerdidos': 'Perdidos {n}',
  'juego.resEliminadas': 'Cartas eliminadas {n}',
  'juego.resEnergiaRobos': 'Energía en robos {n}',
  'juego.resCansancio': 'Cansancio acumulado {n}',
  'juego.semanaCompleta': '¡Semana completa! Logro conseguido',
  'juego.diaMarcado': 'Día marcado · racha {a}/{b}',
  'nav.jugar': 'Jugar',
  'nav.progreso': 'Progreso',
  'progreso.logroTitulo': '¡Semana completa!',
  'nav.balance': 'Balance',
  'nav.simulador': 'Simulador',
  'nav.reglas': 'Reglas',

  // partida
  'juego.empezar': 'Empezar partida',
  'juego.nueva': 'Nueva partida',
  'juego.robarGratis': 'Robar',
  'juego.robarPago': 'Robar (−{n})',
  'juego.resolverGanas': 'Resolver',
  'juego.rendirse': 'Rendirse',
  'juego.jefeNoSeRinde': 'No se le huye',
  'juego.jefeTeVence': 'Te vence',
  'juego.rendirseConfirmar': '¿Te rendís?',
  'juego.rendirseConfirmarSub':
      'Perdés {n} de Energía y el peligro se queda con su técnica. '
      'No hay vuelta atrás.',
  'juego.rendirseSeguir': 'Seguir peleando',
  'juego.continuarPeligro': 'Continuar',
  'juego.diario': 'Diario del Novato',
  'juego.peligrosRestantes': 'Peligros restantes {n}',
  'juego.jefes': 'Jefes {a}/{b}',
  'juego.mazo': 'Mazo {n}',
  'juego.barajando': 'Barajás el descarte',
  'juego.barajandoSub': 'El mazo se rehace en otro orden',
  'juego.cansancioEntra': 'El cansancio se acumula',
  'juego.cansancioSub': 'Se baraja en tu mazo',
  'juego.descarte': 'Descarte {n}',
  'juego.eliminadas': 'Eliminadas {n}',
  'juego.racha': 'Racha {a}/{b}',
  'juego.danoSiPerdes': 'Daño si perdés: {n}',
  'juego.cartasGratis': 'Cartas gratis: {a}/{b}',
  'juego.recompensa': 'Recompensa: ',
  'juego.enMesa': 'En mesa ({n} cartas · suma {s})',
  'juego.tuSumaGana': 'Tu suma {s} ≥ {o} — ganás si resolvés ahora.',
  'juego.tuSumaFalta': 'Tu suma {s} · te faltan {f}.',
  'juego.ganaste': '¡Protegiste el templo!',
  'juego.perdiste': 'El templo cayó',
  'juego.turnos': 'Turnos {n}',

  // meditar

  // cómic
  'comic.saltar': 'Saltar',
  'comic.siguiente': 'Siguiente',
  'comic.anterior': 'Anterior',
  'comic.continuar': 'Continuar',
  'comic.verResumen': 'Ver el resumen',
  'comic.enfrentar': 'Enfrentar a los Campeones',
  'comic.seguir': 'Seguir jugando',
  'comic.ilustracion': 'ILUSTRACIÓN',

  // progreso
  'progreso.titulo': 'La semana del Guardián',
  'progreso.explicacion':
      'Ganá una partida por día. El día siguiente no se habilita hasta que '
      'cambie la fecha. Si pasa un día entero sin ganar, la cadena se '
      'corta y hay que rehacer los siete.',
  'progreso.dia': 'Día {n}',
  'progreso.hecho': 'El templo aguantó hoy.',
  'progreso.pendiente': 'El templo todavía no está defendido hoy.',
  'progreso.volveManana': 'Volvé mañana para el día {n}.',
  'progreso.ganaHoy': 'Ganá una partida para marcar el día {n}.',
  'progreso.rachaActual': 'Racha actual {a}/{b}',
  'progreso.mejorRacha': 'Mejor racha {n}',
  'progreso.semanas': 'Semanas completadas {n}',
  'progreso.logro': 'Guardián del Templo',
  'progreso.logroSub':
      'Siete días seguidos. Shifu no se va a enterar, pero vos sí.',
  'progreso.perderCorta': 'Perder una partida también corta la racha',
  'progreso.perderCortaSub':
      'Apagado: podés reintentar todas las veces que quieras dentro del día. '
      'Prendido: una derrota te vuelve a cero.',
  'progreso.reiniciar': 'Reiniciar la racha',
  'progreso.aviso':
      'El progreso se guarda en este dispositivo y usa su reloj: cambiando la '
      'fecha del sistema se saltea la espera.',
  'progreso.encargoHoy': 'Encargo de hoy: {t}',
  'progreso.recompensa': 'Recompensa: {r}',

  // tutorial
  'tutorial.titulo': 'Cómo se juega',
  'tutorial.siguiente': 'Siguiente',
  'tutorial.saltar': 'Saltar',
  'tutorial.terminar': 'Empezar a jugar',
  'tutorial.ver': 'Ver el tutorial',
  'tutorial.tuTurno': 'Tocá el botón resaltado',

  // ajustes
  'ajustes.idioma': 'Idioma',
  'ajustes.idiomaSistema': 'El del sistema',
  'ajustes.salir': '¿Salir de la partida?',
  'ajustes.salirSub': 'Vas a perder el progreso de esta partida.',
  'ajustes.cancelar': 'Cancelar',
  'ajustes.salirOk': 'Salir',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'Esto es tu Energía. Es lo único que te mantiene en el juego: si baja '
      'de cero, se terminó. Quedarte en cero no te elimina, pero el próximo '
      'golpe sí.',
  'tutorial.p02':
      'Este es el peligro que te toca. El número grande es su Poder: es lo '
      'que tenés que igualar o superar sumando cartas.',
  'tutorial.p03':
      'El corazón roto es lo que perdés de Energía si no llegás a ese número.'
      'En este caso, dos.',
  'tutorial.p04':
      'Y este es el número que más vas a mirar: cuántas cartas podés robar '
      'GRATIS. Cuando se te acaban, cada carta extra cuesta Energía.',
  'tutorial.p05':
      'Fijate en esta línea: parte la carta al medio. Arriba está el peligro '
      'que enfrentás. Abajo, la técnica que ganás si lo vencés.',
  'tutorial.p06':
      'Y sí, la mitad de abajo está impresa al revés. Es a propósito: cuando '
      'ganes, girás la carta media vuelta y esa mitad queda derecha. Eso es'
      'todo lo que significa "ganar una carta".',
  'tutorial.p07': 'Probemos. Robá tu primera carta.',
  'tutorial.p08':
      'Ahí está: su Poder se sumó a tu total. Mirá la barra, te dice cuánto '
      'te falta.',
  'tutorial.p09': 'Todavía no alcanza. Robá otra.',
  'tutorial.p10': 'Llegaste. Resolvé el combate.',
  'tutorial.p11':
      'Ganaste, y esto es lo importante: la carta de peligro se da vuelta y '
      'la técnica del otro lado pasa a ser tuya. Así se construye el mazo.'
      'Seguí.',
  'tutorial.p12': 'Peligro nuevo, más duro. Robá tus cartas gratis.',
  'tutorial.p13':
      'Salió basura. Acá se decide el juego: seguir robando cuesta 1 de '
      'Energía por carta, y no sabés qué va a salir. Esta vez rendite.',
  'tutorial.p14':
      'Perdiste Energía y NO te llevaste la carta: rendirse nunca te da la '
      'recompensa. Pero perder abre la única puerta para limpiar el mazo.'
      'Eliminá la Duda Existencial.',
  'tutorial.p15':
      'Eso es meditar: pagás Energía y sacás una carta mala del juego para '
      'siempre. Un mazo más chico hace que las buenas salgan más seguido.\n\n'
      'Una partida real son tres fases —Alba, Mediodía y Ocaso— y al final '
      'llegan dos Campeones. Suerte.',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': 'Objetivo',
  'reglas.objetivo.l1':
      'Sobrevivís tres fases de peligro (Alba, Mediodía, Ocaso) mejorando tu '
      'mazo de técnicas, y después enfrentás a los Campeones del Torneo.',
  'reglas.objetivo.l2':
      'Cuántos Campeones enfrentás lo decide el nivel de dificultad que '
      'elijas.',
  'reglas.objetivo.l3': 'Perdés si tu Energía llega a 0 o menos.',
  'reglas.preparacion.titulo': 'Preparación',
  'reglas.preparacion.l1':
      'Barajá el mazo inicial de combate ({cartas} cartas).',
  'reglas.preparacion.l2':
      'Separá los tres mazos de peligro y elegí al azar los jefes que pida tu '
      'nivel: {jefes} en esta configuración.',
  'reglas.preparacion.l3':
      'Empezás con {inicial} de Energía en esta configuración (tope al '
      'curarte: {maxima}).',
  'reglas.turno.titulo': 'Turno',
  'reglas.turno.l1':
      '1. Revelá el peligro superior del mazo de la fase actual.',
  'reglas.turno.l2Ilimitado':
      '2. Robá cartas de combate una a una, sin coste, hasta que quieras '
      'parar.',
  'reglas.turno.l2Limitado':
      '2. Robá gratis hasta el número de "cartas gratis" del peligro. Cada '
      'carta adicional cuesta {coste} de Energía.',
  'reglas.turno.l3':
      '3. Sumá el Poder de las cartas jugadas y comparalo con el Poder del '
      'peligro.',
  'reglas.turno.l4':
      '4. Si tu suma ≥ el peligro, ganás: la carta de peligro entra a tu '
      'descarte como la técnica de recompensa.',
  'reglas.turno.l5Sale':
      '5. Si perdés, restás el Daño del peligro a tu Energía y la carta de '
      'peligro sale del juego.',
  'reglas.turno.l5Vuelve':
      '5. Si perdés, restás el Daño del peligro a tu Energía y la carta '
      'vuelve al fondo del mazo.',
  'reglas.turno.l6':
      '6. Todas las cartas jugadas van al descarte. Cuando el mazo se acaba, '
      'barajá el descarte.',
  'reglas.combate.titulo': 'Ganar o perder un combate (importante)',
  'reglas.combate.l1':
      'GANÁS si la suma de tus cartas ≥ el Poder del peligro. La carta de '
      'peligro se da vuelta y entra a tu pila de descarte convertida en la '
      'técnica de recompensa: a partir de ahí es una carta más de tu mazo.',
  'reglas.combate.l2':
      'PERDÉS si te plantás por debajo del Poder. Restás el Daño del peligro '
      'a tu Energía y la carta de peligro se descarta del juego: NO te la '
      'llevás. Nunca ganás una carta perdiendo un combate.',
  'reglas.combate.l3':
      'Plantarse por debajo no es un "precio" que pagás para quedarte la '
      'carta: es rendirte. A veces conviene igual, cuando pagar más robos '
      'costaría más Energía que el propio Daño.',
  'reglas.combate.l4':
      'Ganes o pierdas, todas las cartas que jugaste van a tu descarte.',
  'reglas.energia.titulo': 'Cómo se recupera Energía',
  'reglas.energia.l1':
      'No existe ninguna acción para curarte: no podés "descansar" ni gastar '
      'un turno en recuperarte.',
  'reglas.energia.l2':
      'La Energía sube SÓLO por efectos de cartas de combate, y esos efectos '
      'se disparan automáticamente cuando la carta sale durante un combate. '
      'No elegís cuándo usarlas.',
  'reglas.energia.l3':
      'Efecto "+X Energía": se aplica en el momento en que robás la carta, '
      'ganes o pierdas después. Ej.: Reflejo +1, Disciplina +2, Escama de '
      'Dragón +1, Puño del Dragón +2, Serenidad +3, Agua Sagrada +2, '
      'Iluminación +1.',
  'reglas.energia.l4':
      'Efecto "+X Energía si ganás": se aplica recién al resolver, y sólo si '
      'ganaste ese combate. Ej.: Puño del Bambú +1, Ala de Grulla +1, Vuelo '
      'de Grulla +2.',
  'reglas.energia.l5':
      'Nunca superás el tope de {maxima} de Energía: lo que sobra se pierde.',
  'reglas.energia.l6':
      'Consecuencia de diseño: curarte depende de haber metido cartas de '
      'curación en tu mazo y de que salgan. Por eso conviene meditar para '
      'eliminar cartas malas: un mazo más chico hace que las buenas aparezcan '
      'más seguido.',
  'reglas.meditar.titulo': 'Meditar: sacar cartas malas de tu mazo',
  'reglas.meditar.l1':
      'Meditar es la ÚNICA forma de sacar cartas de tu mazo. No hay otra.',
  'reglas.meditar.cuandoSoloAlPerder':
      'Cuándo: sólo en el paso posterior a un combate que PERDISTE.',
  'reglas.meditar.cuandoSiempre':
      'Cuándo: en el paso posterior a cualquier combate, lo hayas ganado o '
      'perdido.',
  'reglas.meditar.l3Una':
      'Cómo: pagá {coste} de Energía y eliminá una carta de tu pila de '
      'descarte. Sale del juego para siempre: no vuelve al mazo.',
  'reglas.meditar.l3':
      'Cómo: pagá {coste} de Energía y eliminá {cartas} carta(s) de tu pila '
      'de descarte. Salen del juego para siempre: no vuelven al mazo.',
  'reglas.meditar.l4':
      'Podés repetirlo varias veces seguidas, pagando cada vez, mientras te '
      'quede Energía.',
  'reglas.meditar.l5':
      'LIMITACIÓN CLAVE: sólo podés eliminar cartas que estén en el DESCARTE. '
      'Una Duda Existencial que sigue enterrada en el mazo es intocable: '
      'primero tiene que salir en algún combate. Por eso el mejor momento '
      'para meditar es justo después de un combate donde salieron tus peores '
      'cartas: todas las que acabás de jugar están en el descarte.',
  'reglas.meditar.l6':
      'Cuando el mazo se agota, el descarte se baraja y vuelve a ser mazo: '
      'ahí perdés la oportunidad de purgar esas cartas hasta que vuelvan a '
      'salir.',
  'reglas.meditar.l7':
      'Por qué conviene: quitar una Duda Existencial (-1) o una Respiración '
      'Agitada (0) no sube tu poder total, pero achica el mazo y hace que las '
      'cartas buenas (y las que curan Energía) salgan más seguido.',
  'reglas.final.titulo': 'Enfrentamiento final',
  'reglas.final.l1':
      'Revelá los jefes y enfrentalos en orden, igual que un peligro normal.',
  'reglas.final.l2':
      'Contra un jefe no podés rendirte: mientras te quede una carta para '
      'robar, la peleás. Si perdés, restás su Daño y volvés a enfrentarlo.',
  'reglas.final.l3': 'Ganás la partida cuando derrotás al último.',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': 'Roba {n}',
  'efecto.energia': '{n} {recurso}',
  'efecto.energiaSiGanas': '{n} {recurso} si ganás',
  'efecto.reducePeligro': '-{n} al peligro',
  'reglas.ui.bajada': 'Refleja los valores que tengas en Balance.',
  'reglas.ui.mazoDe': 'Mazo del {fase}',
  'reglas.ui.peligro':
      '{nombre} — Poder {poder}, Daño {dano}, gratis {gratis} → {tecnica} '
      '({tecnicaPoder})',
  'reglas.ui.jefes': 'Jefes',
  'reglas.ui.jefe': '{nombre} — Poder {poder}, Daño {dano}, gratis {gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': 'Energía',
  'log.arranca': 'El Maestro Shifu se fue. Empieza el Alba.',
  'log.jefeFinal': 'JEFE FINAL: {nombre} (Poder {poder}, Daño {dano})',
  'log.peligro': 'Peligro: {nombre} (Poder {poder}, Daño {dano})',
  'log.pagasRobo': 'Pagás {n} de {recurso} por una carta extra.',
  'log.barajas': 'Barajás el descarte para rehacer el mazo.',
  'log.energia': '{carta}: {n} {recurso}.',
  'log.topado': '(topado en {max})',
  'log.bajaPeligro': '{carta}: el peligro baja {n} de Poder.',
  'log.siGanas': '{carta}: si ganás este combate, {n} {recurso}.',
  'log.sinEnergia': 'Te quedaste sin {recurso}. El templo cae.',
  'log.efectosVictoria': 'Efectos de victoria: {n} {recurso} ({detalle}).',
  'log.derrotasteJefe': '¡Derrotaste a {nombre}! ({suma} vs {poder})',
  'log.ganaste':
      '¡Ganaste! ({suma} vs {poder}) Ganás {tecnica} ({tecnicaPoder}).',
  'log.perdiste': 'Perdiste ({suma} vs {poder}). -{dano} de {recurso}.',
  'log.enCero':
      'Quedaste en 0 de {recurso}: seguís en pie, pero el próximo gasto te '
      'tumba.',
  'log.cansancio':
      'El cansancio se acumula: {carta} ({poder}) entra a tu mazo.',
  'log.meditas': 'Meditás: eliminás {carta} del juego.',
  'log.victoria':
      '¡Protegiste el templo! Shifu nunca se va a enterar de lo de las '
      'galletas.',
  'log.mediodia': 'Cae el Mediodía. Las cosas se ponen serias.',
  'log.ocaso': 'Cae el Ocaso. El verdadero peligro llega.',
  'log.campeones': 'Los Campeones del Torneo llegan al templo: {nombres}.',
  'log.y': 'y',
};
