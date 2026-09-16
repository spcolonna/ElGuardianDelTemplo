// Textos de la interfaz en chino simplificado: 你, informal.
//
// Las claves y los `{placeholders}` son los de `ui_es.dart`, que es el mapa
// base. Si falta una clave o sobra un hueco, `bin/check.dart` lo detecta.

const uiZhHans = <String, String>{
  // navegación
  'nav.inicio': '首页',
  'nav.volver': '返回',
  'medita.confirmar': '移除{carta}吗？',
  'medita.confirmarSub': '永久离开这局。不会回到牌堆。',
  'medita.eliminar': '移除',
  'logro.primer_dia.titulo': '第一天',
  'logro.primer_dia.desc': '你赢下了第一局。',
  'logro.sin_una_derrota.titulo': '毫发无伤',
  'logro.sin_una_derrota.desc': '你一场对战都没输就赢了。',
  'logro.mente_limpia.titulo': '心无杂念',
  'logro.mente_limpia.desc': '你移除８张以上的牌之后赢了。',
  'logro.nada_que_soltar.titulo': '无物可舍',
  'logro.nada_que_soltar.desc': '你一次都没打坐就赢了。',
  'logro.pulmon.titulo': '底气',
  'logro.pulmon.desc': '你在气１２以上时赢了。',
  'logro.por_un_pelo.titulo': '险之又险',
  'logro.por_un_pelo.desc': '你在气２以下时赢了。',
  'logro.sin_pagar_nada.titulo': '分文未花',
  'logro.sin_pagar_nada.desc': '你没为抽牌花过气就赢了。',
  'logro.relampago.titulo': '闪电',
  'logro.relampago.desc': '你在２０回合以内赢了。',
  'logro.alba_intacta.titulo': '黎明无损',
  'logro.alba_intacta.desc': '你一场没输就过了黎明。',
  'logro.tres_jefes.titulo': '三个一起来',
  'logro.tres_jefes.desc': '你赢下了有三个最终对手的一局。',
  'logro.contra_el_cansancio.titulo': '跟疲劳硬扛',
  'logro.contra_el_cansancio.desc': '你在开着疲劳牌堆的情况下赢了。',
  'logro.alumno_aplicado.titulo': '用功的弟子',
  'logro.alumno_aplicado.desc': '你完成了师父交代的一件事。',
  'logro.maraton.titulo': '马拉松',
  'logro.maraton.desc': '你玩了２５局。',
  'logro.perseverante.titulo': '不服输',
  'logro.perseverante.desc': '你输了１０次还在玩。',
  'logro.racha7.titulo': '寺庙守护者',
  'logro.racha7.desc': '连着七天守住了寺庙。',
  'nav.logros': '交代',
  'nav.modos': '模式',
  'nav.ajustes': '设置',
  'nav.mazo': '牌堆',
  'logros.titulo': '交代与成就',
  'logros.contador': '已解锁{a}／{b}',
  'logros.bloqueado': '你还没做到。',
  'logros.nuevo': '解锁了一项成就！',
  'modos.titulo': '开始之前',
  'modos.dificultad': '路',
  'modos.jefes': '最终对手',
  'modos.extras': '可选规则',
  'modos.empezar': '开始',
  'modos.jefesAuto': '自动',
  'modos.energia': '气{n}',
  'modos.jefes1': '一个最终对手',
  'modos.jefesN': '{n}个最终对手',
  'modos.peligros': '每阶段{n}个危机',
  'modos.roboExtra': '额外牌：{n}',
  'modos.cansFase': '每阶段结束时加疲劳',
  'modos.cansBarajar': '洗牌时加疲劳',
  'modos.cansAmbos': '阶段结束和洗牌时都加疲劳',
  'dif.aprendiz': '学徒',
  'dif.aprendizSub': '不吃苦头地把游戏学会。',
  'dif.novato': '新弟子',
  'dif.novatoSub': '你已经知道该干什么了。还是会疼。',
  'dif.guardian': '守护者',
  'dif.guardianSub': '按原本调好的难度来。',
  'dif.maestro': '师父级',
  'dif.maestroSub': '从这儿开始身子会沉。',
  'dif.sombraDeShifu': '师父的影子',
  'dif.sombraDeShifuSub': '几乎就是他。几乎。',
  'dif.shifu': '师父',
  'dif.shifuSub': '不可能的一天。还没人过去过。',
  'modos.encargosT': '师父的交代',
  'modos.encargosSub':
      '师父会留一张字条，上面多加一个条件。一整天都是同一个，明天会换。'
      '按条件赢下来，你下一局开局就有便宜可占。',
  'modos.encargoHoy': '今天的字条',
  'modos.encargoPremio': '按条件赢下来：{r}',
  'modos.encargoApagado': '打开它才能看到今天的字条。',
  'modos.cansancioT': '疲劳牌堆',
  'modos.cansancioSub': '会混进疲劳的牌。难得多。',
  'modos.loTraeElCamino': '第{n}条路本来就带着。',
  // la tienda
  'tienda.titulo': '完整的寺庙',
  'tienda.gancho': '只付一次。全部解锁，也不会再有广告。',
  'tienda.caminos': '六条路',
  'tienda.sinAvisos': '没有广告',
  'tienda.extras': '交代和疲劳',
  'tienda.jefesLibres': '对手你来挑',
  'tienda.comprar': '打开寺庙',
  'tienda.comprarPrecio': '打开寺庙 · {precio}',
  'tienda.restaurar': '恢复购买',
  'tienda.restaurarSub': '如果你买过，又重装了应用。',
  'privacidad.titulo': '隐私',
  'privacidad.opciones': '隐私选项',
  'privacidad.opcionesSub': '改掉你之前对广告的选择。',
  'privacidad.politica': '隐私政策',
  'privacidad.politicaSub': '游戏存什么、不存什么。会在浏览器里打开。',
  'tienda.bloqueado': '买下完整的寺庙才会打开。',
  'tienda.verMas': '看看都包含什么',
  'tienda.gracias': '谢谢。这座寺庙是你的了。',
  'tienda.noDisponible': '商店没有响应。晚点再试。',
  'tienda.pensando': '稍等…',
  'ajustes.titulo': '设置',
  'ajustes.musica': '音乐',
  'ajustes.efectos': '音效',
  'ajustes.sobre': '寺庙守护者 — 歪莲寺',
  'patio.jugar': '开玩',
  'patio.rachaCorta': '连胜{a}／{b}',
  'nav.bitacora': '战况',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano': '你赢了这场：只有输了之后才能打坐。（可以在“平衡”里改。）',
  'medita.motivoVacio': '你的弃牌堆是空的：没有可以移除的牌。',
  'medita.motivoEnergia': '打坐需要多于{n}的气。',
  'medita.explica': '选一张牌移出这局（气−{coste}）。',
  'encargo.beneficio': '已用上昨天的好处：{b}',
  'encargo.titulo': '交代：{t}',
  'encargo.cumplido': '做到了。明天你从{r}开局。',
  'encargo.fallado': '你没做到。师父什么都没说，这更难受。',
  'juego.poderBase': '基础力{a} · 降了{b}',
  'juego.teEspera': '等着你的是{n}。',
  'juego.sinPeligro': '还没翻出危机。翻开{fase}牌堆最上面那张。',
  'juego.revelar': '翻开',
  'juego.enfrentarJefe': '迎战对手',
  'juego.finGano': '师父的点心一块没少。',
  'juego.finPerdio': '你在{fase}倒下，当时气还有{n}。',
  'juego.resGanados': '赢了{n}',
  'juego.resPerdidos': '输了{n}',
  'juego.resEliminadas': '移除的牌{n}',
  'juego.resEnergiaRobos': '抽牌花掉的气{n}',
  'juego.resCansancio': '累积的疲劳{n}',
  'juego.semanaCompleta': '一周凑齐了！拿到成就',
  'juego.diaMarcado': '今天记上了 · 连胜{a}／{b}',
  'nav.jugar': '开玩',
  'nav.progreso': '进度',
  'progreso.logroTitulo': '一周凑齐了！',
  'nav.balance': '平衡',
  'nav.simulador': '模拟',
  'nav.reglas': '规则',

  // partida
  'juego.empezar': '开始这一局',
  'juego.nueva': '新的一局',
  'juego.robarGratis': '抽牌',
  'juego.robarPago': '抽牌（−{n}）',
  'juego.resolverGanas': '结算',
  'juego.rendirse': '认输',
  'juego.jefeNoSeRinde': '这个对手躲不掉',
  'juego.jefeTeVence': '他会赢你',
  'juego.rendirseConfirmar': '要认输吗？',
  'juego.rendirseConfirmarSub': '你会失去{n}的气，危机也会把它的功夫留住。没法反悔。',
  'juego.rendirseSeguir': '接着打',
  'juego.continuarPeligro': '继续',
  'juego.diario': '新弟子的日记',
  'juego.peligrosRestantes': '还剩{n}个危机',
  'juego.jefes': '对手{a}／{b}',
  'juego.mazo': '牌堆{n}',
  'juego.barajando': '你把弃牌洗了',
  'juego.barajandoSub': '牌堆按另一个顺序重新组好',
  'juego.cansancioEntra': '疲劳在累积',
  'juego.cansancioSub': '被洗进你的牌堆',
  'juego.descarte': '弃牌{n}',
  'juego.eliminadas': '已移除{n}',
  'juego.racha': '连胜{a}／{b}',
  'juego.danoSiPerdes': '输了要掉：{n}',
  'juego.cartasGratis': '免费牌：{a}／{b}',
  'juego.recompensa': '奖励：',
  'juego.enMesa': '场上{n}张 · 合计{s}',
  'juego.tuSumaGana': '你的合计{s} ≥ {o} — 现在结算就赢。',
  'juego.tuSumaFalta': '你的合计{s} · 还差{f}。',
  'juego.ganaste': '你守住了寺庙！',
  'juego.perdiste': '寺庙失守了',
  'juego.turnos': '回合{n}',

  // meditar

  // cómic
  'comic.saltar': '跳过',
  'comic.siguiente': '下一页',
  'comic.anterior': '上一页',
  'comic.continuar': '继续',
  'comic.verResumen': '看看总结',
  'comic.enfrentar': '迎战冠军',
  'comic.seguir': '接着玩',
  'comic.ilustracion': '插图',

  // progreso
  'progreso.titulo': '守护者的一周',
  'progreso.explicacion':
      '每天赢一局。日期不变，第二天就不会开。整整一天没赢，这条链就断了，'
      '七天得重新来过。',
  'progreso.dia': '第{n}天',
  'progreso.hecho': '今天寺庙扛住了。',
  'progreso.pendiente': '今天还没守住寺庙。',
  'progreso.volveManana': '明天再来走第{n}天。',
  'progreso.ganaHoy': '赢一局才能记上第{n}天。',
  'progreso.rachaActual': '当前连胜{a}／{b}',
  'progreso.mejorRacha': '最长连胜{n}',
  'progreso.semanas': '凑齐的周数{n}',
  'progreso.logro': '寺庙守护者',
  'progreso.logroSub': '连着七天。师父不会知道，但你知道。',
  'progreso.perderCorta': '输一局同样会断掉连胜',
  'progreso.perderCortaSub': '关：当天想试几次就试几次。开：输一次就归零。',
  'progreso.reiniciar': '重来连胜',
  'progreso.aviso': '进度存在这台设备上，用的是它的时钟：改掉系统日期就能跳过等待。',
  'progreso.encargoHoy': '今天的交代：{t}',
  'progreso.recompensa': '奖励：{r}',

  // tutorial
  'tutorial.titulo': '怎么玩',
  'tutorial.siguiente': '下一步',
  'tutorial.saltar': '跳过',
  'tutorial.terminar': '开始玩',
  'tutorial.ver': '看新手教学',
  'tutorial.tuTurno': '点亮着的那个按钮',

  // ajustes
  'ajustes.idioma': '语言',
  'ajustes.idiomaSistema': '跟随系统',
  'ajustes.salir': '要退出这一局吗？',
  'ajustes.salirSub': '这一局的进度会丢掉。',
  'ajustes.cancelar': '取消',
  'ajustes.salirOk': '退出',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      '这是你的气。它是唯一让你留在局里的东西：掉到零以下就结束了。停在零'
      '不会让你出局，但下一下就会。',
  'tutorial.p02':
      '这是轮到你面对的危机。大的那个数字是它的力：你要靠加牌追平或者超过'
      '它。',
  'tutorial.p03': '裂开的心表示你没到那个数时会掉多少气。这里是两点。',
  'tutorial.p04':
      '这个数字你以后看得最多：你能免费抽几张牌。用完之后，每多抽一张都要'
      '花气。',
  'tutorial.p05':
      '看这条线：它把牌从中间分开。上面是你要面对的危机，下面是你打赢之后'
      '拿到的功夫。',
  'tutorial.p06':
      '对，下半张是倒着印的。这是故意的：你赢了就把牌转半圈，那一半就正过'
      '来了。“赢下一张牌”就只是这么回事。',
  'tutorial.p07': '试一下。抽你的第一张牌。',
  'tutorial.p08': '就是它：它的力加进了你的合计。看那条横杠，它会告诉你还差多少。',
  'tutorial.p09': '还不够。再抽一张。',
  'tutorial.p10': '够了。结算这一场。',
  'tutorial.p11':
      '你赢了，要紧的是这个：危机牌翻过来，背面那招功夫就归你了。牌堆就是'
      '这么攒起来的。继续。',
  'tutorial.p12': '新的危机，更硬。把你的免费牌抽了。',
  'tutorial.p13':
      '抽到的都是废牌。胜负就在这儿定：接着抽每张要花１点气，而且你不知道'
      '会来什么。这次认输吧。',
  'tutorial.p14':
      '你掉了气，牌也没拿到：认输从来不给奖励。但输掉这件事，是清理牌堆唯'
      '一的那扇门。把“人生怀疑”移除掉。',
  'tutorial.p15':
      '这就是打坐：花气，把一张烂牌永远移出这局。牌堆越小，好牌出得越'
      '勤。\n\n'
      '真正的一局有三个阶段——黎明、正午、黄昏——最后会来两位冠军。好运。',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': '目标',
  'reglas.objetivo.l1':
      '你要一边把功夫牌堆练好，一边扛过三个危机阶段（黎明、正午、黄昏），'
      '然后迎战大赛的冠军。',
  'reglas.objetivo.l2': '要面对几位冠军，由你选的难度决定。',
  'reglas.objetivo.l3': '气到０或者更低就算输。',
  'reglas.preparacion.titulo': '准备',
  'reglas.preparacion.l1': '洗好起始的对战牌堆（{cartas}张）。',
  'reglas.preparacion.l2': '把三个危机牌堆分开，再按你的难度随机抽出对手：这套设置是{jefes}个。',
  'reglas.preparacion.l3': '这套设置下你从气{inicial}开始（回复上限{maxima}）。',
  'reglas.turno.titulo': '回合',
  'reglas.turno.l1': '１．翻开当前阶段牌堆最上面的危机。',
  'reglas.turno.l2Ilimitado': '２．一张一张免费抽对战牌，想停就停。',
  'reglas.turno.l2Limitado': '２．按危机上“免费牌”的数字免费抽。多抽一张要花{coste}的气。',
  'reglas.turno.l3': '３．把打出的牌的力加起来，跟危机的力比。',
  'reglas.turno.l4': '４．合计不低于危机就赢：危机牌作为奖励功夫进你的弃牌堆。',
  'reglas.turno.l5Sale': '５．输了就从气里减掉危机的伤害，那张危机牌离开这局。',
  'reglas.turno.l5Vuelve': '５．输了就从气里减掉危机的伤害，那张牌回到牌堆底。',
  'reglas.turno.l6': '６．打出的牌全部进弃牌堆。牌堆抽完了就把弃牌洗一遍。',
  'reglas.combate.titulo': '一场对战的输赢（要紧）',
  'reglas.combate.l1':
      '你的牌合计不低于危机的力就赢。危机牌翻过来，变成奖励功夫进你的弃牌'
      '堆：从那以后它就是你牌堆里的一张。',
  'reglas.combate.l2':
      '没到那个力就收手，算输。从气里减掉危机的伤害，危机牌离开这局：你拿'
      '不到它。输掉一场对战永远不会让你得到一张牌。',
  'reglas.combate.l3':
      '没到就收手，不是你为了留下那张牌付的“价钱”：那是认输。有时候还是划'
      '算的，就是多抽牌要花的气比伤害本身还多的时候。',
  'reglas.combate.l4': '不管赢还是输，你打出的牌都会进你的弃牌堆。',
  'reglas.energia.titulo': '气怎么回来',
  'reglas.energia.l1': '没有任何回气的动作：你不能“歇着”，也不能花一个回合回复。',
  'reglas.energia.l2':
      '气只会因为对战牌的效果上升，而这些效果在牌于对战中出现的那一刻自动'
      '生效。你没法选什么时候用。',
  'reglas.energia.l3':
      '“气＋Ｘ”的效果在你抽到牌的那一刻生效，之后是赢是输都一样。例：反应'
      '＋１、自律＋２、龙鳞＋１、龙拳＋２、静心＋３、圣水＋２、顿悟＋１。',
  'reglas.energia.l4':
      '“赢了气＋Ｘ”的效果要到结算时才生效，而且只在你赢下那一场时。例：竹'
      '拳＋１、鹤翼＋１、鹤飞＋２。',
  'reglas.energia.l5': '你永远不会超过{maxima}的气上限：多出来的就没了。',
  'reglas.energia.l6':
      '这是设计上的结果：能不能回气，取决于你有没有把回气的牌放进牌堆，以'
      '及它们出不出得来。所以打坐移除烂牌是值得的：牌堆越小，好牌出得越'
      '勤。',
  'reglas.meditar.titulo': '打坐：把烂牌从牌堆里拿走',
  'reglas.meditar.l1': '打坐是把牌从牌堆里拿走的唯一办法。没有别的。',
  'reglas.meditar.cuandoSoloAlPerder': '什么时候：只在你输掉的那场对战之后那一步。',
  'reglas.meditar.cuandoSiempre': '什么时候：任何一场对战之后那一步，不管赢还是输。',
  'reglas.meditar.l3Una':
      '怎么做：付{coste}的气，从弃牌堆里移除一张牌。它永久离开这局：不会'
      '回到牌堆。',
  'reglas.meditar.l3':
      '怎么做：付{coste}的气，从弃牌堆里移除{cartas}张牌。它们永久离开这'
      '局：不会回到牌堆。',
  'reglas.meditar.l4': '只要还有气，你可以连着做几次，每次都付。',
  'reglas.meditar.l5':
      '关键限制：你只能移除在弃牌堆里的牌。还埋在牌堆里的“人生怀疑”动不'
      '了：它得先在某一场对战里出来。所以打坐最好的时机，就是你最烂的牌刚'
      '刚一起出来的那一场之后：你刚打出的全都在弃牌堆里。',
  'reglas.meditar.l6':
      '牌堆抽完之后，弃牌会被洗成新的牌堆：到那时你就失去了清掉那些牌的机'
      '会，要等它们再出来。',
  'reglas.meditar.l7':
      '为什么值得：拿掉一张“人生怀疑”（−１）或者“喘不上气”（０）并不会提'
      '高你的总力，但牌堆变小了，好牌和回气的牌就出得更勤。',
  'reglas.final.titulo': '最终对决',
  'reglas.final.l1': '翻开对手，像对付普通危机一样按顺序迎战。',
  'reglas.final.l2':
      '对上最终对手不能认输：只要还有牌可抽，你就得打。输了就减掉他的伤'
      '害，再来一次。',
  'reglas.final.l3': '打倒最后一个，这一局就赢了。',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': '抽{n}',
  'efecto.energia': '{recurso}{n}',
  'efecto.energiaSiGanas': '赢了{recurso}{n}',
  'efecto.reducePeligro': '危机−{n}',
  'reglas.ui.bajada': '照着你在“平衡”里设的数值来。',
  'reglas.ui.mazoDe': '{fase}牌堆',
  'reglas.ui.peligro':
      '{nombre} — 力{poder}，伤害{dano}，免费{gratis} → {tecnica}（{tecnicaPoder}）',
  'reglas.ui.jefes': '最终对手',
  'reglas.ui.jefe': '{nombre} — 力{poder}，伤害{dano}，免费{gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': '气',
  'log.arranca': '师父走了。黎明开始。',
  'log.jefeFinal': '最终对手：{nombre}（力{poder}，伤害{dano}）',
  'log.peligro': '危机：{nombre}（力{poder}，伤害{dano}）',
  'log.pagasRobo': '你花了{n}的{recurso}多抽一张。',
  'log.barajas': '你把弃牌洗了，重新组成牌堆。',
  'log.energia': '{carta}：{recurso}{n}。',
  'log.topado': '（封顶在{max}）',
  'log.bajaPeligro': '{carta}：危机的力降了{n}。',
  'log.siGanas': '{carta}：赢下这一场的话，{recurso}{n}。',
  'log.sinEnergia': '你的{recurso}没了。寺庙失守。',
  'log.efectosVictoria': '胜利的效果：{recurso}{n}（{detalle}）。',
  'log.derrotasteJefe': '你打倒了{nombre}！（{suma} 对 {poder}）',
  'log.ganaste': '你赢了！（{suma} 对 {poder}）你得到{tecnica}（{tecnicaPoder}）。',
  'log.perdiste': '你输了（{suma} 对 {poder}）。{recurso}−{dano}。',
  'log.enCero': '你的{recurso}到０了：还站得住，但下一次花费就会倒。',
  'log.cansancio': '疲劳在累积：{carta}（{poder}）进了你的牌堆。',
  'log.meditas': '你打坐：把{carta}移出这局。',
  'log.victoria': '你守住了寺庙！点心的事师父永远不会知道。',
  'log.mediodia': '正午到了。开始动真格的。',
  'log.ocaso': '黄昏到了。真正的危机来了。',
  'log.campeones': '大赛的冠军到了寺门口：{nombres}。',
  'log.y': '和',
};
