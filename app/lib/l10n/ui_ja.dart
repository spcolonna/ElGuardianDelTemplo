// Textos de la interfaz en japonés: です／ます coloquial.
//
// Las claves y los `{placeholders}` son los de `ui_es.dart`, que es el mapa
// base. Si falta una clave o sobra un hueco, `bin/check.dart` lo detecta.
//
// Ojo con las cajas de `maxLines: 1`: el japonés no tiene espacios y corta de
// línea en cualquier carácter, así que lo que se rompe no es el ancho sino el
// alto, y los glifos son cuadrados y más altos que la equis latina.

const uiJa = <String, String>{
  // navegación
  'nav.inicio': 'ホーム',
  'nav.volver': '戻る',
  'medita.confirmar': '{carta}を除去しますか？',
  'medita.confirmarSub': '永久にゲームから外れます。山札には戻りません。',
  'medita.eliminar': '除去',
  'logro.primer_dia.titulo': '初日',
  'logro.primer_dia.desc': '初めての一戦に勝ちました。',
  'logro.sin_una_derrota.titulo': '無傷',
  'logro.sin_una_derrota.desc': '一度も戦いに負けずに勝ちました。',
  'logro.mente_limpia.titulo': '澄んだ心',
  'logro.mente_limpia.desc': '札を８枚以上除去してから勝ちました。',
  'logro.nada_que_soltar.titulo': '手放すものなし',
  'logro.nada_que_soltar.desc': '一度も瞑想せずに勝ちました。',
  'logro.pulmon.titulo': '肺活量',
  'logro.pulmon.desc': '気が１２以上の状態で勝ちました。',
  'logro.por_un_pelo.titulo': '紙一重',
  'logro.por_un_pelo.desc': '気が２以下の状態で勝ちました。',
  'logro.sin_pagar_nada.titulo': '無出費',
  'logro.sin_pagar_nada.desc': '引くために気を使わずに勝ちました。',
  'logro.relampago.titulo': '稲妻',
  'logro.relampago.desc': '２０手以内で勝ちました。',
  'logro.alba_intacta.titulo': '無傷の暁',
  'logro.alba_intacta.desc': '一度も負けずに暁を越えました。',
  'logro.tres_jefes.titulo': '三人がかり',
  'logro.tres_jefes.desc': '最終決戦の相手が三人の一戦に勝ちました。',
  'logro.contra_el_cansancio.titulo': '疲労に抗して',
  'logro.contra_el_cansancio.desc': '疲労の山札を入れた状態で勝ちました。',
  'logro.alumno_aplicado.titulo': '勤勉な弟子',
  'logro.alumno_aplicado.desc': '師父の言いつけを果たしました。',
  'logro.maraton.titulo': '長丁場',
  'logro.maraton.desc': '２５回遊びました。',
  'logro.perseverante.titulo': '粘り強さ',
  'logro.perseverante.desc': '１０回負けても続けました。',
  'logro.racha7.titulo': '寺院の守り手',
  'logro.racha7.desc': '七日続けて寺を守りました。',
  'nav.logros': '言いつけ',
  'nav.modos': 'モード',
  'nav.ajustes': '設定',
  'nav.mazo': '山札',
  'logros.titulo': '言いつけと記録',
  'logros.contador': '{b}件中{a}件を達成',
  'logros.bloqueado': 'まだ達成していません。',
  'logros.nuevo': '記録を達成しました！',
  'modos.titulo': '始める前に',
  'modos.dificultad': '道',
  'modos.jefes': '最終決戦の相手',
  'modos.extras': '追加の決まり',
  'modos.empezar': '始める',
  'modos.jefesAuto': '自動',
  'modos.energia': '気{n}',
  'modos.jefes1': '相手は一人',
  'modos.jefesN': '相手は{n}人',
  'modos.peligros': '一段階につき危機{n}',
  'modos.roboExtra': '追加の札：{n}',
  'modos.cansFase': '段階の終わりに疲労',
  'modos.cansBarajar': '切り直しのときに疲労',
  'modos.cansAmbos': '段階の終わりと切り直しに疲労',
  'dif.aprendiz': '見習い',
  'dif.aprendizSub': '痛い思いをせずに覚えるための道です。',
  'dif.novato': '新入り',
  'dif.novatoSub': 'やることは分かっています。それでも痛いです。',
  'dif.guardian': '守り手',
  'dif.guardianSub': '釣り合いを取ったとおりの難しさです。',
  'dif.maestro': '師範',
  'dif.maestroSub': 'ここから体が重くなってきます。',
  'dif.sombraDeShifu': '師父の影',
  'dif.sombraDeShifuSub': 'ほぼ師父です。ほぼ。',
  'dif.shifu': '師父',
  'dif.shifuSub': '不可能な一日です。まだ誰も越えていません。',
  'modos.encargosT': '師父の言いつけ',
  'modos.encargosSub':
      '師父が条件をひとつ書いた紙を残していきます。その日は同じ条件で、明日'
      '変わります。条件を守って勝つと、次の一戦が有利に始まります。',
  'modos.encargoHoy': '今日の紙',
  'modos.encargoPremio': '守って勝てば：{r}',
  'modos.encargoApagado': '今日の紙を見るには、これを入にしてください。',
  'modos.cansancioT': '疲労の山札',
  'modos.cansancioSub': '疲れの札が紛れ込みます。かなり難しくなります。',
  'modos.loTraeElCamino': '{n}の道には最初から入っています。',
  // la tienda
  'tienda.titulo': '寺のすべて',
  'tienda.gancho': '一度きりの支払いです。すべて開き、広告も出なくなります。',
  'tienda.caminos': '六つの道',
  'tienda.sinAvisos': '広告なし',
  'tienda.extras': '言いつけと疲労',
  'tienda.jefesLibres': '相手を自分で選べます',
  'tienda.comprar': '寺を開く',
  'tienda.comprarPrecio': '寺を開く · {precio}',
  'tienda.restaurar': '購入を復元',
  'tienda.restaurarSub': '購入済みで、入れ直した場合はこちらです。',
  'privacidad.titulo': 'プライバシー',
  'privacidad.opciones': 'プライバシーの設定',
  'privacidad.opcionesSub': '広告について選んだ内容を変更します。',
  'privacidad.politica': 'プライバシーポリシー',
  'privacidad.politicaSub': '何を保存し、何を保存しないか。ブラウザで開きます。',
  'tienda.bloqueado': '「寺のすべて」で開きます。',
  'tienda.verMas': '内容を見る',
  'tienda.gracias': 'ありがとうございます。寺はあなたのものです。',
  'tienda.noDisponible': 'ストアが応答しません。あとで試してください。',
  'tienda.pensando': '少々お待ちください…',
  'ajustes.titulo': '設定',
  'ajustes.musica': '音楽',
  'ajustes.efectos': '効果音',
  'ajustes.sobre': '寺院の守り手 — 曲がった蓮',
  'patio.jugar': '遊ぶ',
  'patio.rachaCorta': '連続{a}/{b}',
  'nav.bitacora': '記録',
  'medita.noAhora': '{motivo}',
  'medita.motivoGano': '戦いに勝ちました。瞑想は負けたあとにだけできます。（釣り合いの画面で変えられます。）',
  'medita.motivoVacio': '捨て札がありません。除去できる札がありません。',
  'medita.motivoEnergia': '瞑想するには気が{n}より多く必要です。',
  'medita.explica': '除去する札を選んでください（気−{coste}）。',
  'encargo.beneficio': '昨日の恩恵を適用：{b}',
  'encargo.titulo': '言いつけ：{t}',
  'encargo.cumplido': '果たしました。明日は{r}で始まります。',
  'encargo.fallado': '果たせませんでした。師父は何も言いません。そのほうが応えます。',
  'juego.poderBase': '基本の力{a} · {b}下がっています',
  'juego.teEspera': '{n}が待っています。',
  'juego.sinPeligro': '危機がめくられていません。{fase}の山札の一番上をめくってください。',
  'juego.revelar': 'めくる',
  'juego.enfrentarJefe': '相手に向かう',
  'juego.finGano': '師父の菓子は無事のままです。',
  'juego.finPerdio': '{fase}で気{n}のときに倒れました。',
  'juego.resGanados': '勝ち{n}',
  'juego.resPerdidos': '負け{n}',
  'juego.resEliminadas': '除去した札{n}',
  'juego.resEnergiaRobos': '引くのに使った気{n}',
  'juego.resCansancio': 'たまった疲労{n}',
  'juego.semanaCompleta': '一週間そろいました！記録を達成',
  'juego.diaMarcado': '今日を記帳 · 連続{a}/{b}',
  'nav.jugar': '遊ぶ',
  'nav.progreso': '歩み',
  'progreso.logroTitulo': '一週間そろいました！',
  'nav.balance': '釣り合い',
  'nav.simulador': '試算',
  'nav.reglas': '遊び方',

  // partida
  'juego.empezar': '一戦を始める',
  'juego.nueva': '新しい一戦',
  'juego.robarGratis': '引く',
  'juego.robarPago': '引く（−{n}）',
  'juego.resolverGanas': '決着',
  'juego.rendirse': '引き下がる',
  'juego.jefeNoSeRinde': 'この相手からは逃げられません',
  'juego.jefeTeVence': '負けます',
  'juego.rendirseConfirmar': '引き下がりますか？',
  'juego.rendirseConfirmarSub': '気を{n}失い、危機はその技を手放しません。取り消せません。',
  'juego.rendirseSeguir': '戦い続ける',
  'juego.continuarPeligro': '続ける',
  'juego.diario': '新入りの日記',
  'juego.peligrosRestantes': '残りの危機{n}',
  'juego.jefes': '相手{a}/{b}',
  'juego.mazo': '山札{n}',
  'juego.barajando': '捨て札を切り直します',
  'juego.barajandoSub': '山札が別の順で組み直されます',
  'juego.cansancioEntra': '疲労がたまります',
  'juego.cansancioSub': 'あなたの山札に混ぜられます',
  'juego.descarte': '捨て札{n}',
  'juego.eliminadas': '除去{n}',
  'juego.racha': '連続{a}/{b}',
  'juego.danoSiPerdes': '負けたときの痛手：{n}',
  'juego.cartasGratis': '無料の札：{a}/{b}',
  'juego.recompensa': '褒美：',
  'juego.enMesa': '場に{n}枚 · 合計{s}',
  'juego.tuSumaGana': '合計{s} ≥ {o} — いま決着すれば勝ちです。',
  'juego.tuSumaFalta': '合計{s} · あと{f}足りません。',
  'juego.ganaste': '寺を守りました！',
  'juego.perdiste': '寺は落ちました',
  'juego.turnos': '手数{n}',

  // meditar

  // cómic
  'comic.saltar': '飛ばす',
  'comic.siguiente': '次へ',
  'comic.anterior': '前へ',
  'comic.continuar': '続ける',
  'comic.verResumen': 'まとめを見る',
  'comic.enfrentar': '覇者に向かう',
  'comic.seguir': '続けて遊ぶ',
  'comic.ilustracion': '挿絵',

  // progreso
  'progreso.titulo': '守り手の一週間',
  'progreso.explicacion':
      '一日に一戦、勝ってください。日付が変わるまで次の日は開きません。丸一日'
      '勝てないと連なりは切れ、七日をやり直すことになります。',
  'progreso.dia': '{n}日目',
  'progreso.hecho': '今日、寺は持ちこたえました。',
  'progreso.pendiente': '今日はまだ寺を守っていません。',
  'progreso.volveManana': '{n}日目は明日また来てください。',
  'progreso.ganaHoy': '{n}日目を記帳するには一戦勝ってください。',
  'progreso.rachaActual': '今の連続{a}/{b}',
  'progreso.mejorRacha': '最長の連続{n}',
  'progreso.semanas': 'そろえた週{n}',
  'progreso.logro': '寺院の守り手',
  'progreso.logroSub': '七日続けて。師父は知りませんが、あなたは知っています。',
  'progreso.perderCorta': '負けても連なりは切れます',
  'progreso.perderCortaSub': '切：その日のうちは何度でもやり直せます。入：一度負けると０に戻ります。',
  'progreso.reiniciar': '連なりをやり直す',
  'progreso.aviso':
      '歩みはこの端末に保存され、端末の時計を使います。日付を変えれば待ち時間は'
      '飛ばせます。',
  'progreso.encargoHoy': '今日の言いつけ：{t}',
  'progreso.recompensa': '褒美：{r}',

  // tutorial
  'tutorial.titulo': '遊び方',
  'tutorial.siguiente': '次へ',
  'tutorial.saltar': '飛ばす',
  'tutorial.terminar': '遊び始める',
  'tutorial.ver': '手ほどきを見る',
  'tutorial.tuTurno': '光っているボタンを押してください',

  // ajustes
  'ajustes.idioma': '言語',
  'ajustes.idiomaSistema': '端末に合わせる',
  'ajustes.salir': '一戦をやめますか？',
  'ajustes.salirSub': 'この一戦の進みは失われます。',
  'ajustes.cancelar': 'やめる',
  'ajustes.salirOk': '出る',

  // ----------------------------------------------- guion del tutorial
  'tutorial.p01':
      'これがあなたの気です。あなたを戦いにとどめている唯一のものです。０を'
      '下回ったら終わりです。０で止まっても外れはしませんが、次の一撃で終わ'
      'ります。',
  'tutorial.p02':
      'これが当たった危機です。大きな数字がその力です。札を足して、この数に'
      '追いつくか追い越す必要があります。',
  'tutorial.p03':
      '割れた心は、その数に届かなかったときに失う気の量です。ここでは二つで'
      'す。',
  'tutorial.p04':
      'そして一番よく見ることになる数字がこれです。無料で引ける札の枚数で'
      'す。使い切ると、以降は一枚ごとに気がかかります。',
  'tutorial.p05':
      'この線を見てください。札を真ん中で分けています。上があなたの相手にな'
      'る危機、下が勝ったときに手に入る技です。',
  'tutorial.p06':
      'そう、下半分は逆さに刷られています。わざとです。勝ったら札を半回転さ'
      'せると、その半分が正しい向きになります。「札を手に入れる」とはそれだ'
      'けのことです。',
  'tutorial.p07': '試してみましょう。最初の一枚を引いてください。',
  'tutorial.p08':
      'そのとおり、その力が合計に足されました。棒を見てください。あとどれだ'
      'け足りないかが出ています。',
  'tutorial.p09': 'まだ足りません。もう一枚引いてください。',
  'tutorial.p10': '届きました。決着をつけてください。',
  'tutorial.p11':
      '勝ちました。ここが肝心です。危機の札が裏返り、反対側の技があなたのも'
      'のになります。こうして山札が育ちます。次へ。',
  'tutorial.p12': '新しい危機、さっきより手強いです。無料の札を引いてください。',
  'tutorial.p13':
      'ろくな札が出ませんでした。ここが勝負どころです。引き続けると一枚につ'
      'き気が１かかり、何が出るかは分かりません。今回は引き下がってくださ'
      'い。',
  'tutorial.p14':
      '気を失い、札も手に入りませんでした。引き下がって褒美が出ることはあり'
      'ません。ただ、負けることだけが山札を整える扉を開けます。実存的な迷い'
      'を除去してください。',
  'tutorial.p15':
      'これが瞑想です。気を払って、悪い札を永久に外します。山札が小さいほ'
      'ど、よい札が出やすくなります。\n\n'
      '本当の一戦は暁・正午・夕暮れの三段階で、最後に覇者が二人来ます。武運'
      'を。',

  // --------------------------------------------------------- reglas
  'reglas.objetivo.titulo': '目的',
  'reglas.objetivo.l1':
      '技の山札を育てながら三つの危機の段階（暁・正午・夕暮れ）を生き延び、'
      'そのあと大会の覇者に立ち向かいます。',
  'reglas.objetivo.l2': '覇者の人数は、選んだ難しさで決まります。',
  'reglas.objetivo.l3': '気が０以下になったら負けです。',
  'reglas.preparacion.titulo': '準備',
  'reglas.preparacion.l1': '初期の戦いの山札（{cartas}枚）を切ります。',
  'reglas.preparacion.l2':
      '三つの危機の山札を分け、難しさが求める人数の覇者を無作為に選びます。'
      'この設定では{jefes}人です。',
  'reglas.preparacion.l3': 'この設定では気{inicial}で始まります（回復の上限は{maxima}）。',
  'reglas.turno.titulo': '手番',
  'reglas.turno.l1': '１．今の段階の山札の一番上の危機をめくります。',
  'reglas.turno.l2Ilimitado': '２．戦いの札を一枚ずつ、費用なしで、やめたくなるまで引きます。',
  'reglas.turno.l2Limitado':
      '２．危機の「無料の札」の枚数まで無料で引けます。それ以降は一枚につき'
      '気が{coste}かかります。',
  'reglas.turno.l3': '３．出した札の力を合計し、危機の力と比べます。',
  'reglas.turno.l4':
      '４．合計が危機以上なら勝ちです。危機の札は褒美の技として捨て札に入り'
      'ます。',
  'reglas.turno.l5Sale': '５．負けたら危機の痛手を気から引き、その危機の札はゲームから外れます。',
  'reglas.turno.l5Vuelve': '５．負けたら危機の痛手を気から引き、その札は山札の一番下に戻ります。',
  'reglas.turno.l6':
      '６．出した札はすべて捨て札になります。山札が尽きたら捨て札を切り直し'
      'ます。',
  'reglas.combate.titulo': '戦いの勝ち負け（大事なところ）',
  'reglas.combate.l1':
      '札の合計が危機の力以上なら勝ちです。危機の札は裏返り、褒美の技になっ'
      'て捨て札の山に入ります。そこから先はあなたの山札の一枚です。',
  'reglas.combate.l2':
      '力に届かないまま止めたら負けです。危機の痛手を気から引き、危機の札は'
      'ゲームから外れます。手には入りません。戦いに負けて札を得ることは決して'
      'ありません。',
  'reglas.combate.l3':
      '届かないまま止めるのは、札をもらうための「代金」ではありません。引き'
      '下がることです。それでも得な場合はあります。引き足す気のほうが痛手よ'
      'り大きいときです。',
  'reglas.combate.l4': '勝っても負けても、出した札はすべて捨て札に行きます。',
  'reglas.energia.titulo': '気の戻し方',
  'reglas.energia.l1':
      '回復のための行動はありません。「休む」ことも、手番を回復に使うことも'
      'できません。',
  'reglas.energia.l2':
      '気が増えるのは戦いの札の効果によるときだけで、その効果は戦いの最中に'
      'その札が出た時点で自動で働きます。使う時機は選べません。',
  'reglas.energia.l3':
      '「気＋Ｘ」の効果は、そのあと勝っても負けても、札を引いた時点で働きま'
      'す。例：反射＋１、鍛錬＋２、龍の鱗＋１、龍の拳＋２、静けさ＋３、聖な'
      'る水＋２、悟り＋１。',
  'reglas.energia.l4':
      '「勝てば気＋Ｘ」の効果は決着のときにだけ、しかもその戦いに勝った場合'
      'にだけ働きます。例：竹の拳＋１、鶴の翼＋１、鶴の飛翔＋２。',
  'reglas.energia.l5': '気の上限{maxima}は決して超えません。あふれた分は消えます。',
  'reglas.energia.l6':
      '仕組みの帰結として、回復は回復の札を山札に入れてあるかどうかと、それ'
      'が出るかどうかで決まります。だから瞑想で悪い札を外す価値があります。'
      '山札が小さいほど、よい札が出やすくなります。',
  'reglas.meditar.titulo': '瞑想：悪い札を山札から外す',
  'reglas.meditar.l1': '瞑想は山札から札を外す唯一の方法です。ほかにはありません。',
  'reglas.meditar.cuandoSoloAlPerder': 'いつ：負けた戦いの直後の段でだけです。',
  'reglas.meditar.cuandoSiempre': 'いつ：勝ち負けにかかわらず、どの戦いの直後の段でもできます。',
  'reglas.meditar.l3Una':
      'やり方：気を{coste}払い、捨て札の山から一枚を除去します。永久にゲーム'
      'から外れ、山札には戻りません。',
  'reglas.meditar.l3':
      'やり方：気を{coste}払い、捨て札の山から{cartas}枚を除去します。永久に'
      'ゲームから外れ、山札には戻りません。',
  'reglas.meditar.l4': '気が残っているかぎり、そのつど払って何度でも繰り返せます。',
  'reglas.meditar.l5':
      '大事な制限：除去できるのは捨て札にある札だけです。まだ山札に埋もれて'
      'いる実存的な迷いには手が出せません。まずどこかの戦いで出てもらう必要'
      'があります。だから瞑想に一番よいのは、ひどい札がそろって出た戦いの直'
      '後です。いま出した札はすべて捨て札にあります。',
  'reglas.meditar.l6':
      '山札が尽きると捨て札が切り直されてまた山札になります。そうなると、そ'
      'の札がまた出てくるまで外す機会はありません。',
  'reglas.meditar.l7':
      '得な理由：実存的な迷い（−１）や乱れた呼吸（０）を外しても合計の力は'
      '上がりませんが、山札が小さくなり、よい札や気を戻す札が出やすくなりま'
      'す。',
  'reglas.final.titulo': '最終決戦',
  'reglas.final.l1': '相手をめくり、普通の危機と同じように順に立ち向かいます。',
  'reglas.final.l2':
      'この相手からは引き下がれません。引ける札が残っているかぎり戦います。'
      '負けたらその痛手を引き、もう一度立ち向かいます。',
  'reglas.final.l3': '最後の一人を倒したときに勝ちです。',

  // ------------------------------------------ efectos y hoja de reglas
  'efecto.roba': '{n}引く',
  'efecto.energia': '{recurso}{n}',
  'efecto.energiaSiGanas': '勝てば{recurso}{n}',
  'efecto.reducePeligro': '危機に−{n}',
  'reglas.ui.bajada': '「釣り合い」で設定した値を映します。',
  'reglas.ui.mazoDe': '{fase}の山札',
  'reglas.ui.peligro':
      '{nombre} — 力{poder}、痛手{dano}、無料{gratis} → {tecnica}（{tecnicaPoder}）',
  'reglas.ui.jefes': '最終決戦の相手',
  'reglas.ui.jefe': '{nombre} — 力{poder}、痛手{dano}、無料{gratis}',

  // ------------------------------------------------ bitácora del motor
  'juego.recurso': '気',
  'log.arranca': '師父が発ちました。暁が始まります。',
  'log.jefeFinal': '最終決戦：{nombre}（力{poder}、痛手{dano}）',
  'log.peligro': '危機：{nombre}（力{poder}、痛手{dano}）',
  'log.pagasRobo': '追加の一枚に{recurso}を{n}払います。',
  'log.barajas': '山札を組み直すために捨て札を切ります。',
  'log.energia': '{carta}：{recurso}{n}。',
  'log.topado': '（{max}で頭打ち）',
  'log.bajaPeligro': '{carta}：危機の力が{n}下がります。',
  'log.siGanas': '{carta}：この戦いに勝てば{recurso}{n}。',
  'log.sinEnergia': '{recurso}が尽きました。寺が落ちます。',
  'log.efectosVictoria': '勝ちの効果：{recurso}{n}（{detalle}）。',
  'log.derrotasteJefe': '{nombre}を倒しました！（{suma} 対 {poder}）',
  'log.ganaste': '勝ちました！（{suma} 対 {poder}）{tecnica}（{tecnicaPoder}）を得ます。',
  'log.perdiste': '負けました（{suma} 対 {poder}）。{recurso}−{dano}。',
  'log.enCero': '{recurso}が０になりました。まだ立っていますが、次の出費で倒れます。',
  'log.cansancio': '疲労がたまります：{carta}（{poder}）が山札に入ります。',
  'log.meditas': '瞑想します：{carta}をゲームから外します。',
  'log.victoria': '寺を守りました！菓子の件を師父が知ることは決してありません。',
  'log.mediodia': '正午になりました。ここから真剣です。',
  'log.ocaso': '夕暮れになりました。本当の危機が来ます。',
  'log.campeones': '大会の覇者が寺に着きました：{nombres}。',
  'log.y': 'と',
};
