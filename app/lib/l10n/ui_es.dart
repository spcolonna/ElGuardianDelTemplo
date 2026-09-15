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
      'Esto es tu Energía. Es lo único que te mantiene en el juego: si baja'
      'de cero, se terminó. Quedarte en cero no te elimina, pero el próximo'
      'golpe sí.',
  'tutorial.p02':
      'Este es el peligro que te toca. El número grande es su Poder: es lo'
      'que tenés que igualar o superar sumando cartas.',
  'tutorial.p03':
      'El corazón roto es lo que perdés de Energía si no llegás a ese número.'
      'En este caso, dos.',
  'tutorial.p04':
      'Y este es el número que más vas a mirar: cuántas cartas podés robar'
      'GRATIS. Cuando se te acaban, cada carta extra cuesta Energía.',
  'tutorial.p05':
      'Fijate en esta línea: parte la carta al medio. Arriba está el peligro'
      'que enfrentás. Abajo, la técnica que ganás si lo vencés.',
  'tutorial.p06':
      'Y sí, la mitad de abajo está impresa al revés. Es a propósito: cuando'
      'ganes, girás la carta media vuelta y esa mitad queda derecha. Eso es'
      'todo lo que significa "ganar una carta".',
  'tutorial.p07': 'Probemos. Robá tu primera carta.',
  'tutorial.p08':
      'Ahí está: su Poder se sumó a tu total. Mirá la barra, te dice cuánto'
      'te falta.',
  'tutorial.p09': 'Todavía no alcanza. Robá otra.',
  'tutorial.p10': 'Llegaste. Resolvé el combate.',
  'tutorial.p11':
      'Ganaste, y esto es lo importante: la carta de peligro se da vuelta y'
      'la técnica del otro lado pasa a ser tuya. Así se construye el mazo.'
      'Seguí.',
  'tutorial.p12': 'Peligro nuevo, más duro. Robá tus cartas gratis.',
  'tutorial.p13':
      'Salió basura. Acá se decide el juego: seguir robando cuesta 1 de'
      'Energía por carta, y no sabés qué va a salir. Esta vez rendite.',
  'tutorial.p14':
      'Perdiste Energía y NO te llevaste la carta: rendirse nunca te da la'
      'recompensa. Pero perder abre la única puerta para limpiar el mazo.'
      'Eliminá la Duda Existencial.',
  'tutorial.p15':
      'Eso es meditar: pagás Energía y sacás una carta mala del juego para'
      'siempre. Un mazo más chico hace que las buenas salgan más seguido.\n\n'
      'Una partida real son tres fases —Alba, Mediodía y Ocaso— y al final'
      'llegan dos Campeones. Suerte.',
};
