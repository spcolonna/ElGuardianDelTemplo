import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en japonés.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
///
/// Registro: **です／ます** coloquial. Ni el keigo de una carta comercial ni el
/// habla llana: es un chico de dieciséis años contándole algo a alguien de
/// confianza, que es exactamente el tono del original.
///
/// El japonés no separa palabras con espacios y corta de línea en cualquier
/// carácter, así que lo que se rompe no son las cajas anchas sino las de
/// `maxLines: 1`. Y sus glifos son cuadrados y más altos que la equis latina.
const textosTemploJa = TextosTema(
  nombre: '寺院の守り手',
  protagonista: '新入り',
  bajada: '師父は七日間留守です。寺を燃やさないでください。',
  recurso: '気',
  nombreFase: {
    Fase.alba: '暁',
    Fase.mediodia: '正午',
    Fase.ocaso: '夕暮れ',
    Fase.jefes: '最終決戦',
  },
  cartas: {
    'puno_torpe': TextoCarta('不格好な拳'),
    'postura_flamenco': TextoCarta('フラミンゴの構え', '少林の型ではないけれど、効きます。'),
    'patada_descuidada': TextoCarta('雑な蹴り', 'もう少しで後ろに転ぶところでした。'),
    'respiracion_agitada': TextoCarta('乱れた呼吸', '穴の空いたふいごみたいな音です。'),
    'duda_existencial': TextoCarta('実存的な迷い', 'カンフーって、気合の入った体操なのでは？'),
    'alba1': TextoCarta('寺の蚊'),
    'garra_inicial': TextoCarta('最初の爪', 'わざとに見える初めての動きです。'),
    'alba2': TextoCarta('腐った棒の山賊'),
    'puno_bambu': TextoCarta('竹の拳'),
    'alba3': TextoCarta('倒れた急須'),
    'equilibrio': TextoCarta('均衡', '自分の足につまずかなくなりました。'),
    'alba4': TextoCarta('誘惑の昼寝'),
    'despertar_brusco': TextoCarta('乱暴な目覚め', '師父に冷水を浴びせられました。'),
    'alba5': TextoCarta('寺の番猫'),
    'rascada_felina': TextoCarta('猫の引っかき', '寺で一番強い者から学びました。'),
    'alba6': TextoCarta('からかう兄弟子'),
    'mirada_fija': TextoCarta('据わった目', '腹をすかせた新入りの目で怯ませました。'),
    'alba7': TextoCarta('靴の中の小石'),
    'paso_firme': TextoCarta('確かな足取り', 'やっと稽古用の靴を履きました。'),
    'alba8': TextoCarta('切れた縄跳び'),
    'salto_novato': TextoCarta('新入りの跳躍', '寺の鐘に頭をぶつけました。'),
    'alba9': TextoCarta('飯椀の蜘蛛'),
    'reflejo': TextoCarta('反射', '蜘蛛は生き延びました。あなたもです。'),
    'alba10': TextoCarta('朝の冷たい風'),
    'resistencia': TextoCarta('耐久', '寒さは心を鍛えます。あなたは毛布が欲しいだけです。'),
    'med1': TextoCarta('腹をすかせた山賊三人'),
    'puno_tigre': TextoCarta('虎の拳', '子猫のように吠え、虎のように打ちます。'),
    'med2': TextoCarta('玩具の剣の傭兵'),
    'ala_grulla': TextoCarta('鶴の翼', '力より優雅さです。'),
    'med3': TextoCarta('疑問「これ意味ある？」'),
    'fe_renovada': TextoCarta('新たな信', '師父は嘘をつきません。まあ、ほとんど。'),
    'med4': TextoCarta('抑えられない怒り'),
    'colmillo_serpiente': TextoCarta('蛇の牙'),
    'med5': TextoCarta('汚職代官の兵'),
    'zancada_leopardo': TextoCarta('豹の歩幅', '速い。優雅。敵には厄介です。'),
    'med6': TextoCarta('戸棚の誘惑'),
    'disciplina': TextoCarta('鍛錬', '師父の菓子はまだ無事です。あなたは英雄です。'),
    'med7': TextoCarta('路上の偽師範'),
    'escama_dragon': TextoCarta('龍の鱗', 'やってはいけないことを学びました。それも学びです。'),
    'med8': TextoCarta('壊れた吊り橋'),
    'vuelo_bambu': TextoCarta('竹の飛翔', '谷を渡りました。しかも格好よく。'),
    'med9': TextoCarta('裏切った兄弟子'),
    'lealtad': TextoCarta('忠義', '裏切り者を許しました。武人より人として上等です。'),
    'med10': TextoCarta('突然の砂嵐'),
    'resistencia_desierto': TextoCarta('砂漠の耐久', '目に入る砂は上級の稽古です。'),
    'oca1': TextoCarta('山賊の頭'),
    'rugido_tigre': TextoCarta('虎の咆哮', '今度こそ本物の虎の声です。'),
    'oca2': TextoCarta('音のない刺客'),
    'vuelo_grulla': TextoCarta('鶴の飛翔', '見えませんでした。向こうもです。'),
    'oca3': TextoCarta('傲慢の鬼'),
    'humildad': TextoCarta('謙虚', '雲から降りました。殴られながら。'),
    'oca4': TextoCarta('怠惰の鬼'),
    'determinacion': TextoCarta('決意', '朝四時に起きました。一度だけ。でも数えます。'),
    'oca5': TextoCarta('敵寺の師範'),
    'puno_dragon': TextoCarta('龍の拳', '向こうの寺は予算が上です。あなたには心があります。'),
    'oca6': TextoCarta('傭兵の軍勢'),
    'patada_tigre': TextoCarta('虎の蹴り', '蹴り一つ。傭兵多数。簡単な算数です。'),
    'oca7': TextoCarta('憤怒の鬼'),
    'serenidad': TextoCarta('静けさ', 'あなたは深く息を吸いました。鬼は吸いませんでした。'),
    'oca8': TextoCarta('寺の厨房の火事'),
    'agua_sagrada': TextoCarta('聖なる水', '火は消しました。出火の原因は誰も知りません。師父ですよね？'),
    'oca9': TextoCarta('一番弟子の裏切り'),
    'perdon': TextoCarta('赦し', '二度目の機会を与えました。あと蹴りも。'),
    'oca10': TextoCarta('大師範の試練（夢の中）'),
    'iluminacion': TextoCarta('悟り', '汗だくで目が覚めました。でも悟っていました。'),
    'jefe1': TextoCarta('堕ちた僧', '元・優等生。復讐を求めています。あと菓子も。'),
    'jefe2': TextoCarta('自分自身の影', 'あなたの顔をしていて、何もかも正しかった。'),
    'jefe3': TextoCarta('傭兵の長', '部下には気前がいい。においはひどい。かなり。'),
    'jefe4': TextoCarta('黒蓮寺の大師範', '向こうの寺には池と風呂と食べ放題があります。こちらには石が一つ。'),
    'jefe5': TextoCarta('紙の龍', '堂々として火を吐きます。でも雨が降ると粥になります。'),

    // Las diez del mazo de Cansancio. Los NÚMEROS siguen en
    // `lib/modos/cansancio.dart`: acá va sólo lo que se traduce.
    'cans_bostezo': TextoCarta('あくび', 'うつります。山賊まであくびをしました。'),
    'cans_vista': TextoCarta('かすむ目', '山賊が二人。いや一人。判断がつきません。'),
    'cans_piernas': TextoCarta('ぼろ雑巾の脚', '下にはあります。返事はしません。'),
    'cans_hombro': TextoCarta('しびれた肩', 'あなたより先に起きて、また寝ました。'),
    'cans_ampolla': TextoCarta('まめ', '小さい。耐えがたい。'),
    'cans_nudillo': TextoCarta('割れた拳', '師父なら性根だと言うでしょう。師父はいません。'),
    'cans_calambre': TextoCarta('こむら返り', 'よりによって今。よりによってそこ。'),
    'cans_zumbido': TextoCarta('耳鳴り', '暁の蚊が最後に一言残しました。'),
    'cans_espalda': TextoCarta('老いた背中', '十六歳で、師父の腰です。'),
    'cans_renunciar': TextoCarta('やめたい気持ち', '村の麺屋も人手を探しています。'),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    '01_templo_amanecer.png': TextoPanel(
      narracion: '山の上、風が愚痴をこぼし、茶が決してじゅうぶん熱くならない場所に、曲がった蓮の寺があります。',
      conversacion: [
        Dicho('', '（門まで百八段。）'),
        Dicho('', '（新入りが毎朝掃きます。毎朝また汚れます。）'),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion: '今朝、大師範の師父は武術と茉莉花茶の年次大会へ出かけました。',
      conversacion: [
        Dicho('師父', '七日で戻る。お前を信じている。'),
        Dicho('新入り', '七日も一人でですか。'),
        Dicho('師父', '一人ではない。メイがいる。'),
        Dicho('', '（メイはもう寝ていました。）'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion: '出かける前に、見事な筆跡の書き置きを残していきました。',
      conversacion: [
        Dicho('書き置き', '新入りへ。寺を燃やすな。戸棚の菓子を食べるな（わしのだ）。毎朝、庭を掃け。'),
        Dicho('書き置き', 'そして何より、よそ者を中に入れるな。'),
        Dicho('新入り', '簡単です。'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'そして下の方に、小さな字で追伸がありました。',
      conversacion: [
        Dicho('書き置き', '追伸。「闇の武術大会」について誰かに聞かれたら、きっぱり断ったと言え。'),
        Dicho('新入り', '何のことですか。'),
        Dicho('新入り', '何を断ったんですか。'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion: '師父が道の最初の曲がり角を越えました。十二秒後、彼らが登り始めました。',
      conversacion: [Dicho('新入り', 'なるほど。話が早いですね。'), Dicho('', '（最初は十四人でした。）')],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: 'そして一番厄介なものは、外から来たのではありませんでした。',
      conversacion: [
        Dicho('新入り', '一つくらい減っても分かりません。'),
        Dicho('新入り', '数えてなんかいないはずです。'),
        Dicho('', '（師父は数えていました。）'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion: '一日はまだ始まったばかりです。来るもので稽古し、受けた打撃をすべて新しい技に変えていきます。',
      conversacion: [
        Dicho('', '（暁。正午。夕暮れ。）'),
        Dicho('', '（山は三度登られ、そのたびに、より悪いものが登ってきます。）'),
        Dicho('新入り', 'できます。'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion: 'そして日が山の向こうに沈むころ、大会の覇者が二人、寺を奪いに門を叩きます。',
      conversacion: [
        Dicho('新入り', '寺を守れるでしょうか。'),
        Dicho('新入り', '師父の菓子も。'),
        Dicho('', '（二つのうち一つの答えは、否でした。）'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion: '暁を持ちこたえました。全身が痛みますが、あなたは立っていて、庭はまだあなたのものです。',
      conversacion: [Dicho('新入り', '一つ越えました。'), Dicho('', '（日はまだ昇り始めたばかりでした。）')],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion: '番猫のメイが屋根の上からあなたの働きを採点しました。感心はしませんでした。',
      conversacion: [
        Dicho('メイ', '（猫の、容赦ない沈黙）'),
        Dicho('新入り', '勝ったんですけど。'),
        Dicho('メイ', '（ゆっくりまばたき）'),
        Dicho('新入り', 'はい。引き分けです。'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion: '正午にもなると、野次馬は登ってきません。登ってくるのは、ここにいることで金をもらう者たちです。',
      conversacion: [
        Dicho('タオ', '今朝は拳も握れなかった奴にしては悪くない。'),
        Dicho('タオ', 'この時間の連中は打ち方が違うぞ。'),
        Dicho('新入り', 'あなたはどちら側ですか。'),
        Dicho('タオ', '勝つ側だ。'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion: '正午はあなたの手の皮を剥ぎましたが、門はあなたが望まない誰にも開きませんでした。',
      conversacion: [Dicho('新入り', '二つ。'), Dicho('', '（庭の影はもう伸び始めていました。）')],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion: '日が傾き始めたころ、タオは去りました。挨拶もなしに。',
      conversacion: [
        Dicho('新入り', 'ああ。そういうことでしたか。'),
        Dicho('タオ', '勝つ側だ、坊主。最初にそう言っただろう。'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion: '夕暮れになると山賊は登ってきません。山賊も暗い山は怖いのです。登ってくるのは、別のものです。',
      conversacion: [
        Dicho('', '（庭の影が、庭と合わなくなりました。）'),
        Dicho('新入り', 'そこには誰もいません。'),
        Dicho('新入り', 'そこには誰もいません。'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion: '夕暮れを最後まで持ちこたえました。あなたの顔をしたものも含めて。山は静かになりました。',
      conversacion: [Dicho('新入り', '終わりました。'), Dicho('', '（終わっていませんでした。）')],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: '門を三度叩く音。どれも許しを請うてはいませんでした。',
      conversacion: [
        Dicho('', '（一つ。）'),
        Dicho('', '（二つ。）'),
        Dicho('', '（三つ。）'),
        Dicho('新入り', 'いいでしょう。来てください。'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion: '闇の武術大会には会場が要ります。彼らはあなたの寺を取りに来ました。',
      conversacion: [
        Dicho('覇者たち', 'ここには誰もいないと聞いたが。'),
        Dicho('新入り', '聞き間違いです。'),
      ],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion: '二人の覇者は来た道を帰っていきました。片方は足を引きずって。',
      conversacion: [
        Dicho('新入り', 'この寺は売り物ではありません。'),
        Dicho('', '（メイがその日はじめて屋根から降りてきました。）'),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion: '期日どおり、師父が帰ってきました。同じ笠、同じ荷、同じ顔で。',
      conversacion: [
        Dicho('師父', '庭は掃けている。寺も立っている。よろしい。'),
        Dicho('新入り', '静かなものでした。'),
        Dicho('師父', 'ふむ。'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'それから戸棚を開けました。',
      conversacion: [
        Dicho('師父', '二つ足りん。'),
        Dicho('新入り', 'メイです。'),
        Dicho('メイ', '（もう画面にいませんでした）'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion: '何も残りませんでした。気も、技も、言い訳も。',
      conversacion: [Dicho('', '（門は開いたままでした。誰も閉めませんでした。）')],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: '師父はいつもどおり、時間どおりに帰ってきました。',
      conversacion: [
        Dicho('師父', '……'),
        Dicho('新入り', '説明できます。'),
        Dicho('師父', '……'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'そして、ただ一つ大事な問いを口にしました。',
      conversacion: [Dicho('師父', '菓子は？'), Dicho('', '（説明が難しかったのは、そこでした。）')],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: '瞑想なし',
      nota: '瞑想は過大評価だ。手持ちの山札でやりくりしろ。',
      recompensa: '明日、初期の気＋２',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: '無事に終えろ',
      nota: '勝って庭に転がっている守り手など要らん。',
      recompensa: '明日、初期の気＋２',
    ),
    'alba_impecable': TextoEncargo(
      titulo: '完璧な暁',
      nota: '蚊に負けるようなら、あとの話は聞きたくもない。',
      recompensa: '明日は瞑想が無料',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: '無駄遣いなし',
      nota: '気は竹に生るものではない。配られた分でやれ。',
      recompensa: '明日、すべての危機で無料の札＋１',
    ),
    'purga_profunda': TextoEncargo(
      titulo: '技の大掃除',
      nota: 'その迷いを捨てろ。全部だ。今日中に。',
      recompensa: '明日は瞑想で札を２枚除去',
    ),
    'partida_corta': TextoEncargo(
      titulo: '速く、綺麗に',
      nota: '寺はひとりでに守られん。だがお前にも一日の余裕はない。',
      recompensa: '明日、初期の気＋３',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: '負けを少なく',
      nota: '三度負けるのは学びだ。八度は別のものだ。',
      recompensa: '明日、初期の気＋２',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: '無敗の正午',
      nota: '正午に登る連中は金をもらって来る。払わせるな。',
      recompensa: '明日、すべての危機で無料の札＋１',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: '覇者は一度で',
      nota: '覇者は一度倒すものだ。やり直しは無作法だ。',
      recompensa: '明日、初期の気＋３',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: '余らせろ',
      nota: '寺が立っていて、お前に掃く気力が残っているのを見たい。',
      recompensa: '明日、気の上限＋５',
    ),
    'sin_curarse': TextoEncargo(
      titulo: '助けなしで耐えろ',
      nota: '聖なる水は火のためのものだ。お前の言い訳のためではない。',
      recompensa: '明日、すべての危機で無料の札＋１',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: '紙一重',
      nota: '気五つで勝つほうが値打ちがある。分別は足りんがな。',
      recompensa: '明日、初期の気＋４',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: '暁',
      queCartasLleva: '暁の山札の危機／技カード１０枚',
      descripcion: '中央に彫られた蓮、その後ろに地平線近くから昇る日。',
    ),
    'Mediodía': TextoReverso(
      nombre: '正午',
      queCartasLleva: '正午の山札の危機／技カード１０枚',
      descripcion: '同じ蓮、後ろに高く満ちた日。',
    ),
    'Ocaso': TextoReverso(
      nombre: '夕暮れ',
      queCartasLleva: '夕暮れの山札の危機／技カード１０枚',
      descripcion: '同じ蓮、後ろに沈む日と長い影。',
    ),
    'Jefes': TextoReverso(
      nombre: '覇者',
      queCartasLleva: '大会の覇者カード５枚',
      descripcion: '黒い蓮、より重い縁飾り、日はなし。ほかの三つより重く見えること。',
    ),
    'Combate': TextoReverso(
      nombre: '戦い',
      queCartasLleva: '初期の技２０枚',
      descripcion: '簡素な蓮、落ち着いた文様、日はなし。遊び手がずっと手に持つ山札なので、控えめに。',
    ),
  },
);
