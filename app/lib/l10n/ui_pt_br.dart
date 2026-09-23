// Textos de la interfaz en portugués de Brasil: você, informal.
//
// Las claves y los `{placeholders}` son los de `ui_es.dart`, que es el mapa
// base. Si falta una clave o sobra un hueco, `bin/check.dart` lo detecta.

const uiPtBr = <String, String>{
  // navegación
  'nav.inicio': 'Início',
  'nav.volver': 'Voltar',
  'medita.confirmar': 'Eliminar {carta}?',
  'medita.confirmarSub': 'Sai do jogo para sempre. Não volta para o baralho.',
  'medita.eliminar': 'Eliminar',
  'logro.primer_dia.titulo': 'Primeiro dia',
  'logro.primer_dia.desc': 'Você venceu sua primeira partida.',
  'logro.sin_una_derrota.titulo': 'Sem um arranhão',
  'logro.sin_una_derrota.desc': 'Você venceu sem perder um só combate.',
  'logro.mente_limpia.titulo': 'Mente limpa',
  'logro.mente_limpia.desc': 'Você venceu depois de eliminar 8 cartas ou mais.',
  'logro.nada_que_soltar.titulo': 'Nada a soltar',
  'logro.nada_que_soltar.desc': 'Você venceu sem meditar nenhuma vez.',
  'logro.pulmon.titulo': 'Fôlego',
  'logro.pulmon.desc': 'Você venceu com 12 de Energia ou mais.',
  'logro.por_un_pelo.titulo': 'Por um triz',
  'logro.por_un_pelo.desc': 'Você venceu com 2 de Energia ou menos.',
  'logro.sin_pagar_nada.titulo': 'Sem pagar nada',
  'logro.sin_pagar_nada.desc': 'Você venceu sem gastar Energia em compras.',
  'logro.relampago.titulo': 'Relâmpago',
  'logro.relampago.desc': 'Você venceu em 20 turnos ou menos.',
  'logro.alba_intacta.titulo': 'Amanhecer intacto',
  'logro.alba_intacta.desc': 'Você cruzou o Amanhecer sem perder um combate.',
  'logro.tres_jefes.titulo': 'Os três',
  'logro.tres_jefes.desc': 'Você venceu uma partida com três chefes finais.',
  'logro.contra_el_cansancio.titulo': 'Contra o cansaço',
  'logro.contra_el_cansancio.desc':
      'Você venceu com o Baralho de Cansaço ativado.',
  'logro.alumno_aplicado.titulo': 'Aluno aplicado',
  'logro.alumno_aplicado.desc': 'Você cumpriu uma tarefa do Shifu.',
  'logro.maraton.titulo': 'Maratona',
  'logro.maraton.desc': 'Você jogou 25 partidas.',
  'logro.perseverante.titulo': 'Perseverante',
  'logro.perseverante.desc': 'Você perdeu 10 vezes e continuou jogando.',
  'logro.racha7.titulo': 'Guardião do Templo',
  'logro.racha7.desc': 'Sete dias seguidos defendendo o templo.',
  'nav.logros': 'Missões',
  'nav.modos': 'Modos',
  'nav.ajustes': 'Ajustes',
  'coleccion.iniciales': 'Baralho inicial',
  'coleccion.girar': 'Girar a carta',
  'nav.contenido': 'Conteúdo',
  'logros.titulo': 'Missões e conquistas',
  'logros.contador': '{a} de {b} desbloqueadas',
  'logros.bloqueado': 'Você ainda não conseguiu.',
  'logros.nuevo': 'Conquista desbloqueada!',
  'modos.titulo': 'Antes de começar',
  'modos.dificultad': 'O caminho',
  'modos.jefes': 'Chefes finais',
  'modos.extras': 'Regras opcionais',
  'modos.empezar': 'Começar',
  'modos.jefesAuto': 'Auto',
  'modos.energia': '{n} de Energia',
  'modos.jefes1': 'Um chefe final',
  'modos.jefesN': '{n} chefes',
  'modos.peligros': '{n} perigos por fase',
  'modos.roboExtra': 'Carta extra: {n}',
  'modos.cansFase': 'Cansaço ao fechar cada fase',
  'modos.cansBarajar': 'Cansaço ao embaralhar',
  'modos.cansAmbos': 'Cansaço ao fechar fase e ao embaralhar',
  'dif.aprendiz': 'Aprendiz',
  'dif.aprendizSub': 'Para aprender o jogo sem sofrer.',
  'dif.novato': 'Novato',
  'dif.novatoSub': 'Você já sabe o que fazer. Ainda assim dói.',
  'dif.guardian': 'Guardião',
  'dif.guardianSub': 'O jogo como foi balanceado.',
  'dif.maestro': 'Mestre',
  'dif.maestroSub': 'Aqui o corpo começa a pesar.',
  'dif.sombraDeShifu': 'Sombra do Shifu',
  'dif.sombraDeShifuSub': 'Quase ele. Quase.',
  'dif.shifu': 'Shifu',
  'dif.shifuSub': 'O dia impossível. Ninguém superou ainda.',
  'modos.encargosT': 'Tarefas do Shifu',
  'modos.encargosSub':
      'Shifu deixa um bilhete com uma condição extra. É a mesma o dia '
      'inteiro e muda amanhã. Se você vencer cumprindo, sua próxima partida '
      'começa com uma vantagem.',
  'modos.encargoHoy': 'O bilhete de hoje',
  'modos.encargoPremio': 'Se vencer cumprindo: {r}',
  'modos.encargoApagado': 'Ligue para ver o bilhete de hoje.',
  'modos.cansancioT': 'Baralho de Cansaço',
  'modos.cansancioSub': 'Cartas de fadiga se infiltram. Bem mais difícil.',
  'modos.loTraeElCamino': 'O caminho {n} já vem com isso.',
  // la tienda
  'tienda.titulo': 'O templo completo',
  'tienda.gancho': 'Um pagamento só. Abre tudo e nunca mais há anúncios.',
  'tienda.caminos': 'Os seis caminhos',
  'tienda.sinAvisos': 'Sem publicidade',
  'tienda.extras': 'Tarefas e Cansaço',
  'tienda.jefesLibres': 'Você escolhe os chefes',
  'tienda.comprar': 'Abrir o templo',
  'tienda.comprarPrecio': 'Abrir o templo · {precio}',
  'tienda.restaurar': 'Restaurar compra',
  'tienda.restaurarSub': 'Se você já comprou e reinstalou o app.',
  'privacidad.titulo': 'Privacidade',
  'privacidad.opciones': 'Opções de privacidade',
  'privacidad.opcionesSub': 'Mudar o que você escolheu sobre os anúncios.',
  'privacidad.politica': 'Política de privacidade',
  'privacidad.politicaSub':
      'O que o jogo guarda e o que não. Abre no navegador.',
  'tienda.bloqueado': 'Abre com o templo completo.',
  'tienda.verMas': 'Ver o que inclui',
  'tienda.gracias': 'Obrigado. O templo é seu.',
  'tienda.noDisponible': 'A loja não responde. Tente mais tarde.',
  'tienda.pensando': 'Um momento…',
  'ajustes.titulo': 'Ajustes',
  'ajustes.musica': 'Música',
  'ajustes.efectos': 'Efeitos sonoros',
  'ajustes.sobre': 'O Guardião do Templo — Lótus Torto',
  'patio.jugar': 'Jogar',
  'patio.rachaCorta': 'Sequência {a}/{b}',
  'nav.bitacora': 'Diário de bordo',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano':
      'Você venceu o combate: só dá para meditar depois de perder. (Dá para mudar em Balanço.)',
  'medita.motivoVacio':
      'Seu descarte está vazio: não há nenhuma carta que você possa eliminar.',
  'medita.motivoEnergia':
      'Você precisa de mais de {n} de Energia para meditar.',
  'medita.explica':
      'Escolha uma carta para eliminar do jogo (−{coste} de Energia).',
  'encargo.beneficio': 'Benefício de ontem aplicado: {b}',
  'encargo.titulo': 'Tarefa: {t}',
  'encargo.cumplido': 'Cumprida. Amanhã você começa com: {r}.',
  'encargo.fallado': 'Você não cumpriu. Shifu não diz nada, o que é pior.',
  'juego.poderBase': 'Poder base {a} · reduzido em {b}',
  'juego.teEspera': '{n} espera por você.',
  'juego.sinPeligro':
      'Sem perigo revelado. Vire a carta do topo do baralho do {fase}.',
  'juego.revelar': 'Revelar',
  'juego.enfrentarJefe': 'Enfrentar o chefe',
  'juego.finGano': 'Os biscoitos do Shifu continuam intactos.',
  'juego.finPerdio': 'Você caiu em {fase} com {n} de Energia.',
  'juego.resGanados': 'Vencidos {n}',
  'juego.resPerdidos': 'Perdidos {n}',
  'juego.resEliminadas': 'Cartas eliminadas {n}',
  'juego.resEnergiaRobos': 'Energia em compras {n}',
  'juego.resCansancio': 'Cansaço acumulado {n}',
  'juego.semanaCompleta': 'Semana completa! Conquista obtida',
  'juego.diaMarcado': 'Dia marcado · sequência {a}/{b}',
  'nav.jugar': 'Jogar',
  'nav.progreso': 'Progresso',
  'progreso.logroTitulo': 'Semana completa!',
  'nav.balance': 'Balanço',
  'nav.simulador': 'Simulador',
  'nav.reglas': 'Regras',

  // partida
  'juego.empezar': 'Começar partida',
  'juego.nueva': 'Nova partida',
  'juego.robarGratis': 'Comprar',
  'juego.robarPago': 'Comprar (−{n})',
  'juego.resolverGanas': 'Resolver',
  'juego.rendirse': 'Desistir',
  'juego.jefeNoSeRinde': 'Dele não se foge',
  'juego.jefeTeVence': 'Ele vence você',
  'juego.rendirseConfirmar': 'Vai desistir?',
  'juego.rendirseConfirmarSub':
      'Você perde {n} de Energia e o perigo fica com a técnica dele. '
      'Não tem volta.',
  'juego.rendirseTeMata': 'Desistir encerra a partida',
  'juego.rendirseTeMataSub':
      'O perigo tira {n} de Energia e você tem {e}. O templo cai aqui: '
      'não tem volta.',
  'juego.rendirseAlBordeSub':
      'Você perde {n} de Energia e fica em zero: continua de pé, mas o '
      'próximo golpe te derruba.',
  'juego.rendirseSeguir': 'Continuar lutando',
  'juego.continuarPeligro': 'Continuar',
  'juego.diario': 'Diário do Novato',
  'juego.peligrosRestantes': 'Perigos restantes {n}',
  'juego.jefes': 'Chefes {a}/{b}',
  'juego.mazo': 'Baralho {n}',
  'juego.barajando': 'Você embaralha o descarte',
  'juego.barajandoSub': 'O baralho se refaz em outra ordem',
  'juego.cansancioEntra': 'O cansaço se acumula',
  'juego.cansancioSub': 'É embaralhado no seu baralho',
  'juego.descarte': 'Descarte {n}',
  'juego.eliminadas': 'Eliminadas {n}',
  'juego.racha': 'Sequência {a}/{b}',
  'juego.danoSiPerdes': 'Dano se perder: {n}',
  'juego.cartasGratis': 'Cartas grátis: {a}/{b}',
  'juego.recompensa': 'Recompensa: ',
  'juego.enMesa': 'Na mesa ({n} cartas · soma {s})',
  'juego.tuSumaGana': 'Sua soma {s} ≥ {o} — você vence se resolver agora.',
  'juego.tuSumaFalta': 'Sua soma {s} · faltam {f}.',
  'juego.ganaste': 'Você protegeu o templo!',
  'juego.perdiste': 'O templo caiu',
  'juego.turnos': 'Turnos {n}',

  // meditar

  // cómic
  'comic.saltar': 'Pular',
  'comic.siguiente': 'Seguinte',
  'comic.anterior': 'Anterior',
  'comic.continuar': 'Continuar',
  'comic.verResumen': 'Ver o resumo',
  'comic.enfrentar': 'Enfrentar os Campeões',
  'comic.seguir': 'Continuar jogando',
  'comic.ilustracion': 'ILUSTRAÇÃO',

  // progreso
  'progreso.titulo': 'A semana do Guardião',
  'progreso.explicacion':
      'Vença uma partida por dia. O dia seguinte não libera até que a data '
      'mude. Se passar um dia inteiro sem vencer, a corrente se corta e é '
      'preciso refazer os sete.',
  'progreso.dia': 'Dia {n}',
  'progreso.hecho': 'O templo aguentou hoje.',
  'progreso.pendiente': 'O templo ainda não está defendido hoje.',
  'progreso.volveManana': 'Volte amanhã para o dia {n}.',
  'progreso.ganaHoy': 'Vença uma partida para marcar o dia {n}.',
  'progreso.rachaActual': 'Sequência atual {a}/{b}',
  'progreso.mejorRacha': 'Melhor sequência {n}',
  'progreso.semanas': 'Semanas completadas {n}',
  'progreso.logro': 'Guardião do Templo',
  'progreso.logroSub':
      'Sete dias seguidos. Shifu não vai ficar sabendo, mas você sim.',
  'progreso.perderCorta': 'Perder uma partida também corta a sequência',
  'progreso.perderCortaSub':
      'Desligado: você pode tentar quantas vezes quiser dentro do dia. '
      'Ligado: uma derrota te volta a zero.',
  'progreso.reiniciar': 'Reiniciar a sequência',
  'progreso.aviso':
      'O progresso é salvo neste aparelho e usa o relógio dele: mudando a '
      'data do sistema você pula a espera.',
  'progreso.encargoHoy': 'Tarefa de hoje: {t}',
  'progreso.recompensa': 'Recompensa: {r}',

  // tutorial
  'tutorial.titulo': 'Como se joga',
  'tutorial.siguiente': 'Seguinte',
  'tutorial.saltar': 'Pular',
  'tutorial.terminar': 'Começar a jogar',
  'tutorial.ver': 'Ver o tutorial',
  'tutorial.tuTurno': 'Toque no botão destacado',

  // ajustes
  'ajustes.idioma': 'Idioma',
  'ajustes.idiomaSistema': 'O do sistema',
  'ajustes.salir': 'Sair da partida?',
  'ajustes.salirSub': 'Você vai perder o progresso desta partida.',
  'ajustes.cancelar': 'Cancelar',
  'ajustes.salirOk': 'Sair',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'Isto é a sua Energia. É a única coisa que te mantém no jogo: se cair '
      'abaixo de zero, acabou. Ficar em zero não te elimina, mas o próximo '
      'golpe sim.',
  'tutorial.p02':
      'Este é o perigo que te calhou. O número grande é o Poder dele: é o '
      'que você tem que igualar ou superar somando cartas.',
  'tutorial.p03':
      'O coração partido é o que você perde de Energia se não chegar a esse '
      'número. Neste caso, dois.',
  'tutorial.p04':
      'E este é o número que você mais vai olhar: quantas cartas dá para '
      'comprar DE GRAÇA. Quando acabam, cada carta extra custa Energia.',
  'tutorial.p05':
      'Repare nesta linha: parte a carta ao meio. Em cima está o perigo que '
      'você enfrenta. Embaixo, a técnica que você ganha se vencer.',
  'tutorial.p06':
      'E sim, a metade de baixo está impressa de cabeça para baixo. É de '
      'propósito: quando você vencer, gira a carta meia volta e essa metade '
      'fica de pé. É só isso que significa "ganhar uma carta".',
  'tutorial.p07': 'Vamos testar. Compre sua primeira carta.',
  'tutorial.p08':
      'Aí está: o Poder dela entrou no seu total. Olhe a barra, ela diz '
      'quanto falta.',
  'tutorial.p09': 'Ainda não basta. Compre outra.',
  'tutorial.p10': 'Você chegou. Resolva o combate.',
  'tutorial.p11':
      'Você venceu, e isto é o importante: a carta de perigo vira e a técnica '
      'do outro lado passa a ser sua. É assim que se constrói o baralho. '
      'Continue.',
  'tutorial.p12': 'Perigo novo, mais duro. Compre suas cartas grátis.',
  'tutorial.p13':
      'Saiu lixo. Aqui o jogo se decide: continuar comprando custa 1 de '
      'Energia por carta, e você não sabe o que vem. Desta vez, desista.',
  'tutorial.p14':
      'Você perdeu Energia e NÃO levou a carta: desistir nunca te dá a '
      'recompensa. Mas perder abre a única porta para limpar o baralho. '
      'Elimine a Dúvida Existencial.',
  'tutorial.p15':
      'Isso é meditar: você paga Energia e tira uma carta ruim do jogo para '
      'sempre. Um baralho menor faz as boas saírem com mais frequência.\n\n'
      'Uma partida de verdade são três fases —Amanhecer, Meio-dia e '
      'Anoitecer— e no fim chegam dois Campeões. Boa sorte.',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': 'Objetivo',
  'reglas.objetivo.l1':
      'Você sobrevive a três fases de perigo (Amanhecer, Meio-dia, '
      'Anoitecer) melhorando seu baralho de técnicas, e depois enfrenta os '
      'Campeões do Torneio.',
  'reglas.objetivo.l2':
      'Quantos Campeões você enfrenta é decidido pelo nível de dificuldade '
      'que você escolher.',
  'reglas.objetivo.l3': 'Você perde se sua Energia chegar a 0 ou menos.',
  'reglas.preparacion.titulo': 'Preparação',
  'reglas.preparacion.l1':
      'Embaralhe o baralho inicial de combate ({cartas} cartas).',
  'reglas.preparacion.l2':
      'Separe os três baralhos de perigo e sorteie os chefes que seu nível '
      'pedir: {jefes} nesta configuração.',
  'reglas.preparacion.l3':
      'Você começa com {inicial} de Energia nesta configuração (limite ao '
      'se curar: {maxima}).',
  'reglas.turno.titulo': 'Turno',
  'reglas.turno.l1': '1. Revele o perigo do topo do baralho da fase atual.',
  'reglas.turno.l2Ilimitado':
      '2. Compre cartas de combate uma a uma, sem custo, até querer parar.',
  'reglas.turno.l2Limitado':
      '2. Compre de graça até o número de "cartas grátis" do perigo. Cada '
      'carta adicional custa {coste} de Energia.',
  'reglas.turno.l3':
      '3. Some o Poder das cartas jogadas e compare com o Poder do perigo.',
  'reglas.turno.l4':
      '4. Se sua soma ≥ o perigo, você vence: a carta de perigo entra no seu '
      'descarte como a técnica de recompensa.',
  'reglas.turno.l5Sale':
      '5. Se você perde, subtrai o Dano do perigo da sua Energia e a carta '
      'de perigo sai do jogo.',
  'reglas.turno.l5Vuelve':
      '5. Se você perde, subtrai o Dano do perigo da sua Energia e a carta '
      'volta para o fundo do baralho.',
  'reglas.turno.l6':
      '6. Todas as cartas jogadas vão para o descarte. Quando o baralho '
      'acabar, embaralhe o descarte.',
  'reglas.combate.titulo': 'Vencer ou perder um combate (importante)',
  'reglas.combate.l1':
      'VOCÊ VENCE se a soma das suas cartas ≥ o Poder do perigo. A carta de '
      'perigo vira e entra na sua pilha de descarte convertida na técnica de '
      'recompensa: a partir daí é mais uma carta do seu baralho.',
  'reglas.combate.l2':
      'VOCÊ PERDE se parar abaixo do Poder. Subtrai o Dano do perigo da sua '
      'Energia e a carta de perigo sai do jogo: você NÃO a leva. Nunca se '
      'ganha uma carta perdendo um combate.',
  'reglas.combate.l3':
      'Parar abaixo não é um "preço" que você paga para ficar com a carta: é '
      'desistir. Às vezes vale a pena mesmo assim, quando pagar mais compras '
      'custaria mais Energia do que o próprio Dano.',
  'reglas.combate.l4':
      'Vencendo ou perdendo, todas as cartas que você jogou vão para o seu '
      'descarte.',
  'reglas.energia.titulo': 'Como se recupera Energia',
  'reglas.energia.l1':
      'Não existe nenhuma ação para se curar: você não pode "descansar" nem '
      'gastar um turno se recuperando.',
  'reglas.energia.l2':
      'A Energia sobe SÓ por efeitos de cartas de combate, e esses efeitos '
      'disparam automaticamente quando a carta sai durante um combate. Você '
      'não escolhe quando usá-las.',
  'reglas.energia.l3':
      'Efeito "+X Energia": aplica-se no momento em que você compra a carta, '
      'vença ou perca depois. Ex.: Reflexo +1, Disciplina +2, Escama de '
      'Dragão +1, Soco do Dragão +2, Serenidade +3, Água Sagrada +2, '
      'Iluminação +1.',
  'reglas.energia.l4':
      'Efeito "+X Energia se vencer": aplica-se só na hora de resolver, e só '
      'se você venceu aquele combate. Ex.: Soco do Bambu +1, Asa do Grou +1, '
      'Voo do Grou +2.',
  'reglas.energia.l5':
      'Você nunca passa do limite de {maxima} de Energia: o que sobra se '
      'perde.',
  'reglas.energia.l6':
      'Consequência de projeto: se curar depende de ter colocado cartas de '
      'cura no seu baralho e de que elas saiam. Por isso vale meditar para '
      'eliminar cartas ruins: um baralho menor faz as boas aparecerem com '
      'mais frequência.',
  'reglas.meditar.titulo': 'Meditar: tirar cartas ruins do seu baralho',
  'reglas.meditar.l1':
      'Meditar é a ÚNICA forma de tirar cartas do seu baralho. Não há outra.',
  'reglas.meditar.cuandoSoloAlPerder':
      'Quando: só no passo posterior a um combate que você PERDEU.',
  'reglas.meditar.cuandoSiempre':
      'Quando: no passo posterior a qualquer combate, tenha você vencido ou '
      'perdido.',
  'reglas.meditar.l3Una':
      'Como: pague {coste} de Energia e elimine uma carta da sua pilha de '
      'descarte. Sai do jogo para sempre: não volta para o baralho.',
  'reglas.meditar.l3':
      'Como: pague {coste} de Energia e elimine {cartas} carta(s) da sua '
      'pilha de descarte. Saem do jogo para sempre: não voltam para o '
      'baralho.',
  'reglas.meditar.l4':
      'Você pode repetir várias vezes seguidas, pagando cada vez, enquanto '
      'tiver Energia.',
  'reglas.meditar.l5':
      'LIMITAÇÃO CHAVE: você só pode eliminar cartas que estejam no '
      'DESCARTE. Uma Dúvida Existencial ainda enterrada no baralho é '
      'intocável: primeiro ela tem que sair em algum combate. Por isso a '
      'melhor hora de meditar é logo depois de um combate onde saíram suas '
      'piores cartas: todas as que você acabou de jogar estão no descarte.',
  'reglas.meditar.l6':
      'Quando o baralho acaba, o descarte é embaralhado e vira baralho de '
      'novo: aí você perde a chance de purgar essas cartas até que voltem a '
      'sair.',
  'reglas.meditar.l7':
      'Por que vale a pena: tirar uma Dúvida Existencial (-1) ou uma '
      'Respiração Ofegante (0) não sobe seu poder total, mas encolhe o '
      'baralho e faz as cartas boas (e as que curam Energia) saírem com mais '
      'frequência.',
  'reglas.final.titulo': 'Confronto final',
  'reglas.final.l1':
      'Revele os chefes e enfrente-os em ordem, igual a um perigo normal.',
  'reglas.final.l2':
      'Contra um chefe você não pode desistir: enquanto tiver uma carta para '
      'comprar, você luta. Se perder, subtrai o Dano dele e volta a '
      'enfrentá-lo.',
  'reglas.final.l3': 'Você vence a partida quando derrota o último.',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': 'Compra {n}',
  'efecto.energia': '{n} {recurso}',
  'efecto.energiaSiGanas': '{n} {recurso} se vencer',
  'efecto.reducePeligro': '-{n} ao perigo',
  'reglas.ui.bajada': 'Reflete os valores que você tiver em Balanço.',
  'reglas.ui.mazoDe': 'Baralho do {fase}',
  'reglas.ui.peligro':
      '{nombre} — Poder {poder}, Dano {dano}, grátis {gratis} → {tecnica} '
      '({tecnicaPoder})',
  'reglas.ui.jefes': 'Chefes',
  'reglas.ui.jefe': '{nombre} — Poder {poder}, Dano {dano}, grátis {gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': 'Energia',
  'log.arranca': 'O Mestre Shifu foi embora. Começa o Amanhecer.',
  'log.jefeFinal': 'CHEFE FINAL: {nombre} (Poder {poder}, Dano {dano})',
  'log.peligro': 'Perigo: {nombre} (Poder {poder}, Dano {dano})',
  'log.pagasRobo': 'Você paga {n} de {recurso} por uma carta extra.',
  'log.barajas': 'Você embaralha o descarte para refazer o baralho.',
  'log.energia': '{carta}: {n} {recurso}.',
  'log.topado': '(limitado em {max})',
  'log.bajaPeligro': '{carta}: o perigo baixa {n} de Poder.',
  'log.siGanas': '{carta}: se você vencer este combate, {n} {recurso}.',
  'log.sinEnergia': 'Você ficou sem {recurso}. O templo cai.',
  'log.efectosVictoria': 'Efeitos de vitória: {n} {recurso} ({detalle}).',
  'log.derrotasteJefe': 'Você derrotou {nombre}! ({suma} vs {poder})',
  'log.ganaste':
      'Você venceu! ({suma} vs {poder}) Você ganha {tecnica} '
      '({tecnicaPoder}).',
  'log.perdiste': 'Você perdeu ({suma} vs {poder}). -{dano} de {recurso}.',
  'log.enCero':
      'Você ficou em 0 de {recurso}: segue de pé, mas o próximo gasto te '
      'derruba.',
  'log.cansancio':
      'O cansaço se acumula: {carta} ({poder}) entra no seu baralho.',
  'log.meditas': 'Você medita: elimina {carta} do jogo.',
  'log.victoria':
      'Você protegeu o templo! Shifu nunca vai ficar sabendo do caso dos '
      'biscoitos.',
  'log.mediodia': 'Cai o Meio-dia. As coisas ficam sérias.',
  'log.ocaso': 'Cai o Anoitecer. O verdadeiro perigo chega.',
  'log.campeones': 'Os Campeões do Torneio chegam ao templo: {nombres}.',
  'log.y': 'e',
};
