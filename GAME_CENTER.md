# Game Center

La app ya reporta a Game Center los 15 logros del juego y la mejor racha. Este archivo es lo que hay que cargar en App Store Connect para que funcione: **los IDs tienen que ser exactamente estos**, porque son los que manda el código (`app/lib/game_center.dart`).

⚠️ Un logro o una tabla, una vez que sale publicado con una versión, **no se puede borrar ni cambiarle el ID**.

## Pasos en App Store Connect

1. **Apps → El Guardián del Templo → pestaña Distribución (Features) → Game Center.**
2. **Tabla (Leaderboards) → +** → *Classic*, una sola, con los datos de abajo.
3. **Logros (Achievements) → +** por cada uno de los 15. En cada uno:
   - *Reference Name*: el título en español (solo lo ves vos).
   - *Achievement ID*: el de la lista.
   - *Point Value*: el de la lista (suman 1000, el máximo).
   - *Hidden*: No. *Achievable More Than Once*: No.
   - *Localization* → una por idioma: *Title*, *Pre-earned Description* y *Earned Description* (las dos descripciones, el mismo texto) y una imagen **512×512 o 1024×1024** (puede ser la misma en todos los idiomas).
4. En la **versión** que subas (la próxima, no la 1.1.3 que ya está en revisión), sección *Game Center* → tildar la tabla y los 15 logros. Sin esto, Apple no los activa aunque estén creados.

Se puede probar antes de publicar: con un build de TestFlight y la cuenta de Game Center del teléfono, los logros y la tabla funcionan en modo *sandbox*.

## Tabla: Mejor racha

| Campo | Valor |
|---|---|
| Leaderboard ID | `racha.mejor` |
| Reference Name | Mejor racha |
| Score Format Type | Integer |
| Score Submission Type | Best Score |
| Sort Order | High to Low |
| Score Range | 0 – 10000 |

| Idioma | Name | Score Format Suffix (singular / plural) |
|---|---|---|
| Spanish | Mejor racha | día / días |
| English | Best streak | day / days |
| Portuguese (Brazil) | Melhor sequência | dia / dias |
| Italian | Serie migliore | giorno / giorni |
| German | Beste Serie | Tag / Tage |
| Japanese | 最長連続 | 日 / 日 |
| Chinese (Simplified) | 最长连胜 | 天 / 天 |

## Los 15 logros

### Primer día — `logro.primer_dia` · 20 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Primer día | Ganaste tu primera partida. |
| English | First day | You won your first run. |
| Portuguese (Brazil) | Primeiro dia | Você venceu sua primeira partida. |
| Italian | Primo giorno | Hai vinto la tua prima partita. |
| German | Erster Tag | Du hast deine erste Partie gewonnen. |
| Japanese | 初日 | 初めての一戦に勝ちました。 |
| Chinese (Simplified) | 第一天 | 你赢下了第一局。 |

### Sin un rasguño — `logro.sin_una_derrota` · 80 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Sin un rasguño | Ganaste sin perder un solo combate. |
| English | Not a scratch | You won without losing a single fight. |
| Portuguese (Brazil) | Sem um arranhão | Você venceu sem perder um só combate. |
| Italian | Senza un graffio | Hai vinto senza perdere un solo scontro. |
| German | Ohne einen Kratzer | Du hast gewonnen, ohne einen einzigen Kampf zu verlieren. |
| Japanese | 無傷 | 一度も戦いに負けずに勝ちました。 |
| Chinese (Simplified) | 毫发无伤 | 你一场对战都没输就赢了。 |

### Mente limpia — `logro.mente_limpia` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Mente limpia | Ganaste después de eliminar 8 cartas o más. |
| English | Clear mind | You won after removing 8 cards or more. |
| Portuguese (Brazil) | Mente limpa | Você venceu depois de eliminar 8 cartas ou mais. |
| Italian | Mente pulita | Hai vinto dopo aver eliminato 8 carte o più. |
| German | Klarer Kopf | Du hast gewonnen, nachdem du 8 Karten oder mehr entfernt hast. |
| Japanese | 澄んだ心 | 札を８枚以上除去してから勝ちました。 |
| Chinese (Simplified) | 心无杂念 | 你移除８张以上的牌之后赢了。 |

### Nada que soltar — `logro.nada_que_soltar` · 80 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Nada que soltar | Ganaste sin meditar ni una vez. |
| English | Nothing to let go | You won without meditating once. |
| Portuguese (Brazil) | Nada a soltar | Você venceu sem meditar nenhuma vez. |
| Italian | Niente da lasciare | Hai vinto senza meditare nemmeno una volta. |
| German | Nichts loszulassen | Du hast gewonnen, ohne ein einziges Mal zu meditieren. |
| Japanese | 手放すものなし | 一度も瞑想せずに勝ちました。 |
| Chinese (Simplified) | 无物可舍 | 你一次都没打坐就赢了。 |

### Pulmón — `logro.pulmon` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Pulmón | Ganaste con 12 de Energía o más. |
| English | Deep breath | You won with 12 Energy or more. |
| Portuguese (Brazil) | Fôlego | Você venceu com 12 de Energia ou mais. |
| Italian | Fiato | Hai vinto con 12 di Energia o più. |
| German | Lunge | Du hast mit 12 Energie oder mehr gewonnen. |
| Japanese | 肺活量 | 気が１２以上の状態で勝ちました。 |
| Chinese (Simplified) | 底气 | 你在气１２以上时赢了。 |

### Por un pelo — `logro.por_un_pelo` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Por un pelo | Ganaste con 2 de Energía o menos. |
| English | By a hair | You won with 2 Energy or less. |
| Portuguese (Brazil) | Por um triz | Você venceu com 2 de Energia ou menos. |
| Italian | Per un pelo | Hai vinto con 2 di Energia o meno. |
| German | Um Haaresbreite | Du hast mit 2 Energie oder weniger gewonnen. |
| Japanese | 紙一重 | 気が２以下の状態で勝ちました。 |
| Chinese (Simplified) | 险之又险 | 你在气２以下时赢了。 |

### Sin pagar nada — `logro.sin_pagar_nada` · 80 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Sin pagar nada | Ganaste sin gastar Energía en robos. |
| English | Nothing paid | You won without spending Energy on draws. |
| Portuguese (Brazil) | Sem pagar nada | Você venceu sem gastar Energia em compras. |
| Italian | Senza pagare niente | Hai vinto senza spendere Energia in pescate. |
| German | Ohne zu zahlen | Du hast gewonnen, ohne Energie fürs Ziehen auszugeben. |
| Japanese | 無出費 | 引くために気を使わずに勝ちました。 |
| Chinese (Simplified) | 分文未花 | 你没为抽牌花过气就赢了。 |

### Relámpago — `logro.relampago` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Relámpago | Ganaste en 20 turnos o menos. |
| English | Lightning | You won in 20 turns or fewer. |
| Portuguese (Brazil) | Relâmpago | Você venceu em 20 turnos ou menos. |
| Italian | Fulmine | Hai vinto in 20 turni o meno. |
| German | Blitz | Du hast in 20 Zügen oder weniger gewonnen. |
| Japanese | 稲妻 | ２０手以内で勝ちました。 |
| Chinese (Simplified) | 闪电 | 你在２０回合以内赢了。 |

### Alba intacta — `logro.alba_intacta` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Alba intacta | Cruzaste el Alba sin perder un combate. |
| English | Flawless dawn | You crossed Dawn without losing a fight. |
| Portuguese (Brazil) | Amanhecer intacto | Você cruzou o Amanhecer sem perder um combate. |
| Italian | Alba intatta | Hai attraversato l'Alba senza perdere uno scontro. |
| German | Morgen makellos | Du bist durch den Morgen gekommen, ohne einen Kampf zu verlieren. |
| Japanese | 無傷の暁 | 一度も負けずに暁を越えました。 |
| Chinese (Simplified) | 黎明无损 | 你一场没输就过了黎明。 |

### Los tres — `logro.tres_jefes` · 100 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Los tres | Ganaste una partida con tres jefes finales. |
| English | All three | You won a run with three final bosses. |
| Portuguese (Brazil) | Os três | Você venceu uma partida com três chefes finais. |
| Italian | Tutti e tre | Hai vinto una partita con tre boss finali. |
| German | Alle drei | Du hast eine Partie mit drei Endgegnern gewonnen. |
| Japanese | 三人がかり | 最終決戦の相手が三人の一戦に勝ちました。 |
| Chinese (Simplified) | 三个一起来 | 你赢下了有三个最终对手的一局。 |

### Contra el cansancio — `logro.contra_el_cansancio` · 80 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Contra el cansancio | Ganaste con el Mazo de Cansancio activado. |
| English | Against fatigue | You won with the Fatigue Deck on. |
| Portuguese (Brazil) | Contra o cansaço | Você venceu com o Baralho de Cansaço ativado. |
| Italian | Contro la stanchezza | Hai vinto con il Mazzo della Stanchezza attivo. |
| German | Gegen die Müdigkeit | Du hast mit aktivem Müdigkeitsdeck gewonnen. |
| Japanese | 疲労に抗して | 疲労の山札を入れた状態で勝ちました。 |
| Chinese (Simplified) | 跟疲劳硬扛 | 你在开着疲劳牌堆的情况下赢了。 |

### Alumno aplicado — `logro.alumno_aplicado` · 40 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Alumno aplicado | Cumpliste un encargo de Shifu. |
| English | Model student | You completed one of Shifu's errands. |
| Portuguese (Brazil) | Aluno aplicado | Você cumpriu uma tarefa do Shifu. |
| Italian | Allievo diligente | Hai portato a termine un incarico di Shifu. |
| German | Fleißiger Schüler | Du hast einen Auftrag von Shifu erfüllt. |
| Japanese | 勤勉な弟子 | 師父の言いつけを果たしました。 |
| Chinese (Simplified) | 用功的弟子 | 你完成了师父交代的一件事。 |

### Maratón — `logro.maraton` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Maratón | Jugaste 25 partidas. |
| English | Marathon | You played 25 runs. |
| Portuguese (Brazil) | Maratona | Você jogou 25 partidas. |
| Italian | Maratona | Hai giocato 25 partite. |
| German | Marathon | Du hast 25 Partien gespielt. |
| Japanese | 長丁場 | ２５回遊びました。 |
| Chinese (Simplified) | 马拉松 | 你玩了２５局。 |

### Perseverante — `logro.perseverante` · 60 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Perseverante | Perdiste 10 veces y seguiste jugando. |
| English | Stubborn | You lost 10 times and kept playing. |
| Portuguese (Brazil) | Perseverante | Você perdeu 10 vezes e continuou jogando. |
| Italian | Perseverante | Hai perso 10 volte e hai continuato a giocare. |
| German | Beharrlich | Du hast 10-mal verloren und weitergespielt. |
| Japanese | 粘り強さ | １０回負けても続けました。 |
| Chinese (Simplified) | 不服输 | 你输了１０次还在玩。 |

### Guardián del Templo — `logro.racha7` · 100 puntos

| Idioma | Title | Description |
|---|---|---|
| Spanish | Guardián del Templo | Siete días seguidos defendiendo el templo. |
| English | Guardian of the Temple | Seven days in a row defending the temple. |
| Portuguese (Brazil) | Guardião do Templo | Sete dias seguidos defendendo o templo. |
| Italian | Guardiano del Tempio | Sette giorni di fila a difendere il tempio. |
| German | Wächter des Tempels | Sieben Tage in Folge den Tempel verteidigt. |
| Japanese | 寺院の守り手 | 七日続けて寺を守りました。 |
| Chinese (Simplified) | 寺庙守护者 | 连着七天守住了寺庙。 |

