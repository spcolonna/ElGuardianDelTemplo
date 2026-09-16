import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en chino simplificado.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
///
/// Registro: **你**, informal. Y simplificado: quien tiene el teléfono en
/// `zh-Hant` también cae acá, porque leer tradicional con formas simplificadas
/// es incómodo pero posible, y leer inglés no es ninguna de las dos cosas.
const textosTemploZhHans = TextosTema(
  nombre: '寺庙守护者',
  protagonista: '新弟子',
  bajada: '师父外出七天。别把寺庙烧了。',
  recurso: '气',
  nombreFase: {
    Fase.alba: '黎明',
    Fase.mediodia: '正午',
    Fase.ocaso: '黄昏',
    Fase.jefes: '最终对决',
  },
  cartas: {
    'puno_torpe': TextoCarta('笨拙一拳'),
    'postura_flamenco': TextoCarta('火烈鸟式', '不是少林的架势，但管用。'),
    'patada_descuidada': TextoCarta('随便一脚', '你差点向后摔倒。'),
    'respiracion_agitada': TextoCarta('喘不上气', '你听起来像个破风箱。'),
    'duda_existencial': TextoCarta('人生怀疑', '万一功夫只是带态度的健身操呢？'),
    'alba1': TextoCarta('寺里的蚊子'),
    'garra_inicial': TextoCarta('初爪', '你第一个看起来像故意的动作。'),
    'alba2': TextoCarta('拿烂棍的强盗'),
    'puno_bambu': TextoCarta('竹拳'),
    'alba3': TextoCarta('打翻的茶壶'),
    'equilibrio': TextoCarta('平衡', '你学会了不被自己的脚绊倒。'),
    'alba4': TextoCarta('诱人的午觉'),
    'despertar_brusco': TextoCarta('猛然惊醒', '师父给你泼了一桶冷水。'),
    'alba5': TextoCarta('看门的寺猫'),
    'rascada_felina': TextoCarta('猫抓', '你跟寺里最强的高手学的。'),
    'alba6': TextoCarta('爱起哄的师兄'),
    'mirada_fija': TextoCarta('死盯', '你用饿坏了的新弟子眼神把他吓住了。'),
    'alba7': TextoCarta('鞋里的石子'),
    'paso_firme': TextoCarta('稳步', '你终于穿上了练功鞋。'),
    'alba8': TextoCarta('断掉的跳绳'),
    'salto_novato': TextoCarta('新弟子一跃', '你用脑袋撞响了寺里的钟。'),
    'alba9': TextoCarta('饭碗里的蜘蛛'),
    'reflejo': TextoCarta('反应', '蜘蛛活下来了。你也是。'),
    'alba10': TextoCarta('清晨的冷风'),
    'resistencia': TextoCarta('耐力', '寒冷磨炼心志。你只想要一床被子。'),
    'med1': TextoCarta('三个饿肚子的强盗'),
    'puno_tigre': TextoCarta('虎拳', '吼起来像小猫。打起来像老虎。'),
    'med2': TextoCarta('拿玩具刀的雇佣兵'),
    'ala_grulla': TextoCarta('鹤翼', '以巧胜力。'),
    'med3': TextoCarta('疑问：“这有用吗？”'),
    'fe_renovada': TextoCarta('重拾信心', '师父从不说谎。好吧，几乎不。'),
    'med4': TextoCarta('压不住的怒火'),
    'colmillo_serpiente': TextoCarta('蛇牙'),
    'med5': TextoCarta('贪官的兵'),
    'zancada_leopardo': TextoCarta('豹步', '快。利落。敌人看不懂。'),
    'med6': TextoCarta('橱柜的诱惑'),
    'disciplina': TextoCarta('自律', '师父的点心还在。一块没少。你是英雄。'),
    'med7': TextoCarta('街头假师父'),
    'escama_dragon': TextoCarta('龙鳞', '你学到了什么不能做。这也算。'),
    'med8': TextoCarta('断掉的吊桥'),
    'vuelo_bambu': TextoCarta('竹飞', '你跨过了深谷。还挺好看。'),
    'med9': TextoCarta('叛变的师兄'),
    'lealtad': TextoCarta('义气', '你原谅了叛徒。你做人比做武者强。'),
    'med10': TextoCarta('突如其来的沙暴'),
    'resistencia_desierto': TextoCarta('沙漠耐力', '沙子进眼睛是高级训练。'),
    'oca1': TextoCarta('强盗头子'),
    'rugido_tigre': TextoCarta('虎啸', '这回真像老虎了。'),
    'oca2': TextoCarta('无声的刺客'),
    'vuelo_grulla': TextoCarta('鹤飞', '你没看见他来。他也没看见你。'),
    'oca3': TextoCarta('傲慢之魔'),
    'humildad': TextoCarta('谦卑', '你从云端下来了。是被打下来的。'),
    'oca4': TextoCarta('懒惰之魔'),
    'determinacion': TextoCarta('决心', '你凌晨四点起来过。一次。但算数。'),
    'oca5': TextoCarta('对家寺庙的师父'),
    'puno_dragon': TextoCarta('龙拳', '他的寺庙预算更足。你有心。'),
    'oca6': TextoCarta('雇佣兵大队'),
    'patada_tigre': TextoCarta('虎腿', '一脚。很多雇佣兵。简单算术。'),
    'oca7': TextoCarta('暴怒之魔'),
    'serenidad': TextoCarta('静心', '你深吸了一口气。魔没有。'),
    'oca8': TextoCarta('寺庙厨房起火'),
    'agua_sagrada': TextoCarta('圣水', '火你扑灭了。没人知道怎么烧起来的。是师父吧？'),
    'oca9': TextoCarta('大弟子的背叛'),
    'perdon': TextoCarta('宽恕', '你给了他第二次机会。还有一脚。'),
    'oca10': TextoCarta('大师父的考验（梦里）'),
    'iluminacion': TextoCarta('顿悟', '你满身大汗醒来。但顿悟了。'),
    'jefe1': TextoCarta('堕落的僧人', '从前的得意门生。来寻仇……还有点心。'),
    'jefe2': TextoCarta('你自己的倒影', '长着你的脸。而且样样都说得对。'),
    'jefe3': TextoCarta('雇佣兵之主', '给手下开得起价。身上味道很冲。非常冲。'),
    'jefe4': TextoCarta('黑莲寺的大师父', '他的寺庙有池子、桑拿和自助餐。你的有一块石头。'),
    'jefe5': TextoCarta('纸龙', '气派，会喷火。可是一下雨就成了糊。'),

    // Las diez del mazo de Cansancio. Los NÚMEROS siguen en
    // `lib/modos/cansancio.dart`: acá va sólo lo que se traduce.
    'cans_bostezo': TextoCarta('打哈欠', '会传染。连强盗都打了。'),
    'cans_vista': TextoCarta('眼前发花', '是两个强盗。还是一个。看不清。'),
    'cans_piernas': TextoCarta('腿软如布', '它们在下面，但不听使唤。'),
    'cans_hombro': TextoCarta('肩膀发麻', '它比你先醒，然后又睡了。'),
    'cans_ampolla': TextoCarta('水泡', '很小。很难受。'),
    'cans_nudillo': TextoCarta('指节开裂', '师父会说这是骨气。师父不在。'),
    'cans_calambre': TextoCarta('抽筋', '偏偏这会儿。偏偏这地方。'),
    'cans_zumbido': TextoCarta('耳鸣', '黎明那只蚊子留了最后一句话。'),
    'cans_espalda': TextoCarta('老腰', '你十六岁，腰是师父的。'),
    'cans_renunciar': TextoCarta('想撂挑子', '村口的面摊也在招人。'),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    '01_templo_amanecer.png': TextoPanel(
      narracion: '山顶之上，风在抱怨，茶从来不够烫，那里就是歪莲寺。',
      conversacion: [
        Dicho('', '（到山门一百零八级台阶。）'),
        Dicho('', '（新弟子每天早上扫一遍。每天早上又脏了。）'),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion: '今天早上，大师父去参加一年一度的武术与茉莉花茶大会了。',
      conversacion: [
        Dicho('师父', '七天后回来。我信得过你。'),
        Dicho('新弟子', '七天就我一个人？'),
        Dicho('师父', '不是一个人。还有小梅。'),
        Dicho('', '（小梅已经去睡了。）'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion: '临走前他留了张字条，字写得一丝不苟。',
      conversacion: [
        Dicho('字条', '新弟子：别把寺庙烧了。别吃橱柜里的点心（那是我的）。每天早上扫院子。'),
        Dicho('字条', '最要紧的是：不许放生人进来。'),
        Dicho('新弟子', '简单。'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: '下面还有一行小字，是附言。',
      conversacion: [
        Dicho('字条', '又及：要是有人问起“地下武术大赛”，就说我们断然拒绝了。'),
        Dicho('新弟子', '问起什么？'),
        Dicho('新弟子', '我们拒绝了什么？'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion: '师父刚拐过山路的第一道弯。十二秒后，他们开始往上爬了。',
      conversacion: [Dicho('新弟子', '行吧。升级得真快。'), Dicho('', '（一开始是十四个。）')],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: '而最难对付的那个，不是从外面来的。',
      conversacion: [
        Dicho('新弟子', '就一块，看不出来的。'),
        Dicho('新弟子', '他肯定没数过。'),
        Dicho('', '（师父数过。）'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion: '这一天才刚开始。来什么你就练什么，把每一顿揍都变成一招新的功夫。',
      conversacion: [
        Dicho('', '（黎明。正午。黄昏。）'),
        Dicho('', '（这山要上三回，每一回上来的东西都更难缠。）'),
        Dicho('新弟子', '我扛得住。'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion: '等太阳沉到山背后，两位大赛冠军就会来敲门，要把这座寺庙拿走。',
      conversacion: [
        Dicho('新弟子', '我守得住这座寺庙吗？'),
        Dicho('新弟子', '还有师父的点心？'),
        Dicho('', '（两个问题里，有一个的答案是守不住。）'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion: '你扛过了黎明。浑身都疼，但你还站着，院子还是你的。',
      conversacion: [Dicho('新弟子', '过了一关。'), Dicho('', '（太阳才刚刚升起来。）')],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion: '守门的猫小梅在屋顶上给你打了分。她并不满意。',
      conversacion: [
        Dicho('小梅', '（猫的、要命的沉默）'),
        Dicho('新弟子', '我赢了，你知道吧？'),
        Dicho('小梅', '（慢慢眨了下眼）'),
        Dicho('新弟子', '好吧。打平。'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion: '到了正午，看热闹的就不上来了。上来的是收钱办事的。',
      conversacion: [
        Dicho('陶', '对一个早上还不会握拳的人来说，不算差。'),
        Dicho('陶', '不过这个点上来的，下手不一样。'),
        Dicho('新弟子', '那你站哪边？'),
        Dicho('陶', '赢的那边。'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion: '正午把你的手磨破了，可那道门从没为你不想放进来的人开过。',
      conversacion: [Dicho('新弟子', '两关。'), Dicho('', '（院子里的影子已经开始拉长了。）')],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion: '太阳开始往下走的时候，陶走了。没打招呼。',
      conversacion: [
        Dicho('新弟子', '啊。原来是这么回事。'),
        Dicho('陶', '赢的那边，小子。我一上来就跟你说了。'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion: '到了黄昏，强盗就不上来了：强盗也怕黑着的山。上来的是别的东西。',
      conversacion: [
        Dicho('', '（院子里的影子，和院子对不上了。）'),
        Dicho('新弟子', '那儿没人。'),
        Dicho('新弟子', '那儿没人。'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion: '你把整个黄昏都扛下来了，包括那些长着你的脸的。山静了下来。',
      conversacion: [Dicho('新弟子', '结束了。'), Dicho('', '（并没有结束。）')],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: '门上三下。没有一下是在请示。',
      conversacion: [
        Dicho('', '（一。）'),
        Dicho('', '（二。）'),
        Dicho('', '（三。）'),
        Dicho('新弟子', '好。来吧。'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion: '地下武术大赛需要一个场地。他们是来拿你这一个的。',
      conversacion: [Dicho('冠军们', '有人跟我们说这儿没人。'), Dicho('新弟子', '他们说错了。')],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion: '两位冠军从来路回去了。其中一个一瘸一拐。',
      conversacion: [Dicho('新弟子', '这座寺庙不卖。'), Dicho('', '（小梅一整天里第一次从屋顶上下来了。）')],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion: '日子一到，师父回来了。同一顶斗笠，同一个包袱，同一张脸。',
      conversacion: [
        Dicho('师父', '院子扫了。寺庙还在。不错。'),
        Dicho('新弟子', '挺太平的。'),
        Dicho('师父', '嗯。'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: '然后他打开了橱柜。',
      conversacion: [
        Dicho('师父', '少了两块。'),
        Dicho('新弟子', '小梅。'),
        Dicho('小梅', '（已经不在画面里了）'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion: '你什么都没剩下。没有气，没有功夫，也没有借口。',
      conversacion: [Dicho('', '（门开着。没人去关。）')],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: '师父照例准时回来了。',
      conversacion: [
        Dicho('师父', '……'),
        Dicho('新弟子', '我可以解释。'),
        Dicho('师父', '……'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: '然后他问了唯一要紧的那个问题。',
      conversacion: [Dicho('师父', '点心呢？'), Dicho('', '（难解释的是这一句。）')],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: '不许打坐',
      nota: '打坐被高估了。手里有什么牌就用什么牌。',
      recompensa: '明天起始气＋２',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: '全须全尾地收场',
      nota: '我不要一个赢了却躺在院子里的守护者。',
      recompensa: '明天起始气＋２',
    ),
    'alba_impecable': TextoEncargo(
      titulo: '干净的黎明',
      nota: '要是连蚊子都打不过，后面的我不想听。',
      recompensa: '明天打坐不花钱',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: '别乱花',
      nota: '气不长在竹子上。发到什么就用什么。',
      recompensa: '明天所有危机免费牌＋１',
    ),
    'purga_profunda': TextoEncargo(
      titulo: '清理功夫',
      nota: '把那些怀疑扔掉。全部。就今天。',
      recompensa: '明天打坐清掉２张牌',
    ),
    'partida_corta': TextoEncargo(
      titulo: '又快又利落',
      nota: '寺庙不会自己守，可你也没有一整天。',
      recompensa: '明天起始气＋３',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: '少输几场',
      nota: '输三回是学东西。输八回是另一回事。',
      recompensa: '明天起始气＋２',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: '不失手的正午',
      nota: '正午上山的都是收了钱来的。别让他们拿到。',
      recompensa: '明天所有危机免费牌＋１',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: '冠军一次解决',
      nota: '冠军打一次就该赢。返工是没礼貌。',
      recompensa: '明天起始气＋３',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: '留点富余',
      nota: '我要看见寺庙还立着，你还有力气扫院子。',
      recompensa: '明天气的上限＋５',
    ),
    'sin_curarse': TextoEncargo(
      titulo: '不靠人扛下来',
      nota: '圣水是用来灭火的，不是给你找借口的。',
      recompensa: '明天所有危机免费牌＋１',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: '险胜',
      nota: '剩五点气赢下来更有分量。也更没脑子。',
      recompensa: '明天起始气＋４',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: '黎明',
      queCartasLleva: '黎明牌堆的１０张危机／功夫牌',
      descripcion: '正中一朵雕刻的莲花，背后是低伏在地平线上的初日。',
    ),
    'Mediodía': TextoReverso(
      nombre: '正午',
      queCartasLleva: '正午牌堆的１０张危机／功夫牌',
      descripcion: '同一朵莲花，背后是高悬的满日。',
    ),
    'Ocaso': TextoReverso(
      nombre: '黄昏',
      queCartasLleva: '黄昏牌堆的１０张危机／功夫牌',
      descripcion: '同一朵莲花，背后是下沉的日头和长长的影子。',
    ),
    'Jefes': TextoReverso(
      nombre: '冠军',
      queCartasLleva: '５张大赛冠军牌',
      descripcion: '黑色莲花，边框更繁重，没有日头。要比另外三种看上去更沉。',
    ),
    'Combate': TextoReverso(
      nombre: '对战',
      queCartasLleva: '２０张起始功夫牌',
      descripcion: '简单的莲花，素净的纹样，没有日头。这是玩家一直拿在手里的牌堆：让它安静些。',
    ),
  },
);
