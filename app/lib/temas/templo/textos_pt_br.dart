import '../../models.dart';
import '../tema.dart';

/// Todo lo que lee el jugador, en portugués de Brasil.
///
/// Es una ADAPTACIÓN, no una traducción literal: el humor no sobrevive palabra
/// por palabra. Las claves son idénticas a `textos_es.dart` — si falta alguna,
/// `bin/check.dart` lo detecta.
///
/// Registro: **você**, informal, brasileño. No es el portugués de Portugal y
/// no se pretende que lo sea: el jugador de Lisboa lo va a entender igual, y
/// el de São Paulo no va a leer un idioma de otro país.
const textosTemploPtBr = TextosTema(
  nombre: 'O Guardião do Templo',
  protagonista: 'O Novato',
  bajada: 'Shifu foi embora por sete dias. Não queime o templo.',
  recurso: 'Energia',
  nombreFase: {
    Fase.alba: 'Amanhecer',
    Fase.mediodia: 'Meio-dia',
    Fase.ocaso: 'Anoitecer',
    Fase.jefes: 'Confronto Final',
  },
  cartas: {
    'puno_torpe': TextoCarta('Soco Desajeitado'),
    'postura_flamenco': TextoCarta(
      'Postura do Flamingo',
      'Não é uma postura Shaolin, mas funciona.',
    ),
    'patada_descuidada': TextoCarta(
      'Chute Descuidado',
      'Você quase caiu de costas.',
    ),
    'respiracion_agitada': TextoCarta(
      'Respiração Ofegante',
      'Você parece um fole furado.',
    ),
    'duda_existencial': TextoCarta(
      'Dúvida Existencial',
      'E se Kung Fu for só ginástica com atitude?',
    ),
    'alba1': TextoCarta('Mosquito do Templo'),
    'garra_inicial': TextoCarta(
      'Garra Inicial',
      'Seu primeiro movimento que parece proposital.',
    ),
    'alba2': TextoCarta('Bandido com Porrete Podre'),
    'puno_bambu': TextoCarta('Soco do Bambu'),
    'alba3': TextoCarta('Bule de Chá Derrubado'),
    'equilibrio': TextoCarta(
      'Equilíbrio',
      'Você aprendeu a não tropeçar no próprio pé.',
    ),
    'alba4': TextoCarta('Soneca Tentadora'),
    'despertar_brusco': TextoCarta(
      'Despertar Brusco',
      'O Mestre jogou um balde de água fria em você.',
    ),
    'alba5': TextoCarta('Gato Guardião do Templo'),
    'rascada_felina': TextoCarta(
      'Arranhão Felino',
      'Você aprendeu com o melhor lutador do templo.',
    ),
    'alba6': TextoCarta('Colega Zombeteiro'),
    'mirada_fija': TextoCarta(
      'Olhar Fixo',
      'Você o assustou com seus olhos de novato faminto.',
    ),
    'alba7': TextoCarta('Pedra no Sapato'),
    'paso_firme': TextoCarta(
      'Passo Firme',
      'Enfim você está usando sapato de treino.',
    ),
    'alba8': TextoCarta('Corda de Pular Arrebentada'),
    'salto_novato': TextoCarta(
      'Salto do Novato',
      'Você bateu com a cabeça nos sinos do templo.',
    ),
    'alba9': TextoCarta('Aranha na Tigela de Arroz'),
    'reflejo': TextoCarta('Reflexo', 'A aranha sobreviveu. Você também.'),
    'alba10': TextoCarta('Vento Frio da Manhã'),
    'resistencia': TextoCarta(
      'Resistência',
      'O frio fortalece o espírito. Você só queria um cobertor.',
    ),
    'med1': TextoCarta('Três Bandidos Famintos'),
    'puno_tigre': TextoCarta(
      'Soco do Tigre',
      'Ruge como um gatinho. Bate como um tigre.',
    ),
    'med2': TextoCarta('Mercenário com Espada de Brinquedo'),
    'ala_grulla': TextoCarta('Asa do Grou', 'Elegância acima de força.'),
    'med3': TextoCarta('Dúvida: "Isso serve pra quê?"'),
    'fe_renovada': TextoCarta(
      'Fé Renovada',
      'Shifu nunca mentiu. Bom, quase nunca.',
    ),
    'med4': TextoCarta('Fúria Incontrolável'),
    'colmillo_serpiente': TextoCarta('Presa de Serpente'),
    'med5': TextoCarta('Soldado do Governador Corrupto'),
    'zancada_leopardo': TextoCarta(
      'Passada do Leopardo',
      'Rápida. Elegante. Confusa para o inimigo.',
    ),
    'med6': TextoCarta('Tentação do Armário'),
    'disciplina': TextoCarta(
      'Disciplina',
      'Os biscoitos do Shifu continuam lá. Intactos. Você é um herói.',
    ),
    'med7': TextoCarta('Falso Mestre de Rua'),
    'escama_dragon': TextoCarta(
      'Escama de Dragão',
      'Você aprendeu o que NÃO se deve fazer. Isso conta.',
    ),
    'med8': TextoCarta('Ponte Pênsil Quebrada'),
    'vuelo_bambu': TextoCarta(
      'Voo do Bambu',
      'Você atravessou o abismo. Com estilo.',
    ),
    'med9': TextoCarta('Colega Traidor'),
    'lealtad': TextoCarta(
      'Lealdade',
      'Você perdoou o traidor. É melhor pessoa do que lutador.',
    ),
    'med10': TextoCarta('Tempestade de Areia Repentina'),
    'resistencia_desierto': TextoCarta(
      'Resistência do Deserto',
      'Areia nos olhos é treino avançado.',
    ),
    'oca1': TextoCarta('Líder dos Bandidos'),
    'rugido_tigre': TextoCarta(
      'Rugido do Tigre',
      'Agora sim ruge como tigre de verdade.',
    ),
    'oca2': TextoCarta('Assassino Silencioso'),
    'vuelo_grulla': TextoCarta(
      'Voo do Grou',
      'Você nem viu vir. Ele também não viu você.',
    ),
    'oca3': TextoCarta('Demônio do Orgulho'),
    'humildad': TextoCarta('Humildade', 'Você desceu do salto. Na porrada.'),
    'oca4': TextoCarta('Demônio da Preguiça'),
    'determinacion': TextoCarta(
      'Determinação',
      'Você levantou às 4 da manhã. Uma vez. Mas conta.',
    ),
    'oca5': TextoCarta('Mestre do Templo Rival'),
    'puno_dragon': TextoCarta(
      'Soco do Dragão',
      'O templo dele tem mais orçamento. Você tem coração.',
    ),
    'oca6': TextoCarta('Exército de Mercenários'),
    'patada_tigre': TextoCarta(
      'Chute do Tigre',
      'Um chute. Muitos mercenários. Matemática simples.',
    ),
    'oca7': TextoCarta('Demônio da Fúria'),
    'serenidad': TextoCarta(
      'Serenidade',
      'Você respirou fundo. O demônio não.',
    ),
    'oca8': TextoCarta('Incêndio na Cozinha do Templo'),
    'agua_sagrada': TextoCarta(
      'Água Sagrada',
      'Você apagou o fogo. Ninguém sabe como começou. Foi o Shifu, né?',
    ),
    'oca9': TextoCarta('Traição do Discípulo Favorito'),
    'perdon': TextoCarta('Perdão', 'Você deu uma segunda chance. E um chute.'),
    'oca10': TextoCarta('Prova do Grão-Mestre (em sonho)'),
    'iluminacion': TextoCarta(
      'Iluminação',
      'Você acordou encharcado. Mas iluminado.',
    ),
    'jefe1': TextoCarta(
      'O Monge Caído',
      'Ex-aluno estrela. Busca vingança... e biscoitos.',
    ),
    'jefe2': TextoCarta(
      'Seu Próprio Reflexo',
      'Tinha a sua cara. E tinha razão em tudo.',
    ),
    'jefe3': TextoCarta(
      'O Senhor dos Mercenários',
      'Paga bem aos seus homens. Cheira mal. Muito mal.',
    ),
    'jefe4': TextoCarta(
      'O Grão-Mestre do Templo do Lótus Negro',
      'O templo dele tem piscina, sauna e rodízio. O seu tem uma pedra.',
    ),
    'jefe5': TextoCarta(
      'O Dragão de Papel',
      'Imponente, cospe fogo. Mas se chover, vira papa.',
    ),

    // Las diez del mazo de Cansancio. Los NÚMEROS siguen en
    // `lib/modos/cansancio.dart`: acá va sólo lo que se traduce.
    'cans_bostezo': TextoCarta(
      'Bocejo',
      'É contagioso. Até o bandido bocejou.',
    ),
    'cans_vista': TextoCarta(
      'Vista Embaçada',
      'São dois bandidos. Ou um. Difícil dizer.',
    ),
    'cans_piernas': TextoCarta(
      'Pernas de Pano',
      'Estão aí embaixo, mas não respondem.',
    ),
    'cans_hombro': TextoCarta(
      'Ombro Dormente',
      'Acordou antes de você e voltou a dormir.',
    ),
    'cans_ampolla': TextoCarta('Bolha', 'Pequenininha. Insuportável.'),
    'cans_nudillo': TextoCarta(
      'Nó do Dedo Rachado',
      'Shifu diria que é caráter. Shifu não está aqui.',
    ),
    'cans_calambre': TextoCarta('Cãibra', 'Bem agora. Bem aí.'),
    'cans_zumbido': TextoCarta(
      'Zumbido no Ouvido',
      'O mosquito do Amanhecer deu a última palavra.',
    ),
    'cans_espalda': TextoCarta(
      'Coluna Velha',
      'Você tem dezesseis anos e as costas do Shifu.',
    ),
    'cans_renunciar': TextoCarta(
      'Vontade de Desistir',
      'A barraca de macarrão da vila também precisa de gente.',
    ),
  },
  paneles: {
    // ------------------------------------------------------------------ intro
    '01_templo_amanecer.png': TextoPanel(
      narracion:
          'No alto da montanha, onde o vento reclama e o chá nunca está quente o bastante, fica o Templo do Lótus Torto.',
      conversacion: [
        Dicho('', '(Cento e oito degraus até o portão.)'),
        Dicho(
          '',
          '(O Novato varre todos eles toda manhã. Toda manhã eles sujam de novo.)',
        ),
      ],
    ),
    '02_shifu_se_va.png': TextoPanel(
      narracion:
          'Nesta manhã, o Grão-Mestre Shifu foi ao Congresso Anual de Mestres de Artes Marciais e Chá de Jasmim.',
      conversacion: [
        Dicho('Shifu', 'Volto em sete dias. Confio em você.'),
        Dicho('Novato', 'Sete dias sozinho?'),
        Dicho('Shifu', 'Sozinho não. Tem a Mei.'),
        Dicho('', '(Mei já tinha ido dormir.)'),
      ],
    ),
    '03_la_nota.png': TextoPanel(
      narracion:
          'Antes de ir deixou um bilhete, escrito com caligrafia impecável.',
      conversacion: [
        Dicho(
          'O bilhete',
          'Querido novato: não queime o templo. Não coma os biscoitos do armário (são meus). Varra o pátio toda manhã.',
        ),
        Dicho('O bilhete', 'E acima de tudo: NÃO DEIXE ENTRAR ESTRANHOS.'),
        Dicho('Novato', 'Fácil.'),
      ],
    ),
    '04_posdata.png': TextoPanel(
      narracion: 'E embaixo, com letra menor, um post-scriptum.',
      conversacion: [
        Dicho(
          'O bilhete',
          'P.S.: Se alguém perguntar pelo "Grande Torneio Ilegal de Artes Marciais", diga que recusamos categoricamente.',
        ),
        Dicho('Novato', 'O quê?'),
        Dicho('Novato', 'Recusamos O QUÊ?'),
      ],
    ),
    '05_llegan_los_problemas.png': TextoPanel(
      narracion:
          'Shifu dobrou a primeira curva da estrada. Doze segundos depois, começaram a subir.',
      conversacion: [
        Dicho('Novato', 'Bom. Isso escalou rápido.'),
        Dicho('', '(No começo eram catorze.)'),
      ],
    ),
    '06_tentaciones.png': TextoPanel(
      narracion: 'E o pior de tudo não vinha de fora.',
      conversacion: [
        Dicho('Novato', 'Um biscoito só ninguém vai notar.'),
        Dicho('Novato', 'Ele nem contou, com certeza.'),
        Dicho('', '(Shifu tinha contado.)'),
      ],
    ),
    '07_entrenamiento.png': TextoPanel(
      narracion:
          'O dia mal começou. Você vai treinar com o que vier e vai transformar cada surra numa técnica nova.',
      conversacion: [
        Dicho('', '(Amanhecer. Meio-dia. Anoitecer.)'),
        Dicho('', '(Três vezes a montanha sobe, e cada vez sobe algo pior.)'),
        Dicho('Novato', 'Eu dou conta.'),
      ],
    ),
    '08_campeones.png': TextoPanel(
      narracion:
          'E quando o sol afundar atrás da montanha, dois Campeões do Torneio vão bater no portão para ficar com o templo.',
      conversacion: [
        Dicho('Novato', 'Será que consigo proteger o templo?'),
        Dicho('Novato', 'E os biscoitos do Shifu?'),
        Dicho('', '(Uma das duas respostas ia ser não.)'),
      ],
    ),

    // --------------------------------------------------------------- mediodía
    '10_fin_alba.png': TextoPanel(
      narracion:
          'Você aguentou o Amanhecer. Dói tudo, mas você segue de pé e o pátio continua sendo seu.',
      conversacion: [
        Dicho('Novato', 'Menos um.'),
        Dicho('', '(O sol mal tinha começado a subir.)'),
      ],
    ),
    '11_mei_juzga.png': TextoPanel(
      narracion:
          'Mei, a gata guardiã, avaliou seu desempenho do telhado. Não ficou impressionada.',
      conversacion: [
        Dicho('Mei', '(silêncio felino demolidor)'),
        Dicho('Novato', 'Eu ganhei, sabia?'),
        Dicho('Mei', '(piscada lenta)'),
        Dicho('Novato', 'Tá bom. Empatei.'),
      ],
    ),
    '12_llega_tao.png': TextoPanel(
      narracion:
          'Ao Meio-dia já não sobem curiosos. Sobem os que cobram para estar aqui.',
      conversacion: [
        Dicho('Tao', 'Nada mal para quem de manhã não sabia fechar o punho.'),
        Dicho('Tao', 'Mas os dessa hora batem diferente, hein.'),
        Dicho('Novato', 'E você é de que lado?'),
        Dicho('Tao', 'Do lado que ganha.'),
      ],
    ),

    // ------------------------------------------------------------------ ocaso
    '20_fin_mediodia.png': TextoPanel(
      narracion:
          'O Meio-dia deixou suas mãos em carne viva, mas o portão nunca se abriu para ninguém que você não quisesse.',
      conversacion: [
        Dicho('Novato', 'Dois.'),
        Dicho('', '(As sombras do pátio já começavam a se esticar.)'),
      ],
    ),
    '21_traicion_tao.png': TextoPanel(
      narracion:
          'Tao foi embora quando o sol começou a baixar. Não se despediu.',
      conversacion: [
        Dicho('Novato', 'Ah. Então era isso.'),
        Dicho('Tao', 'Do lado que ganha, garoto. Eu avisei logo de cara.'),
      ],
    ),
    '22_cae_la_noche.png': TextoPanel(
      narracion:
          'Com o Anoitecer os bandidos param de subir: bandido também tem medo da montanha no escuro. Sobe a outra coisa.',
      conversacion: [
        Dicho('', '(As sombras do pátio deixaram de coincidir com o pátio.)'),
        Dicho('Novato', 'Não tem ninguém ali.'),
        Dicho('Novato', 'Não tem ninguém ali.'),
      ],
    ),

    // ------------------------------------------------------------------ jefes
    '30_fin_ocaso.png': TextoPanel(
      narracion:
          'Você aguentou o Anoitecer inteiro, inclusive os que tinham a sua cara. A montanha ficou em silêncio.',
      conversacion: [
        Dicho('Novato', 'Acabou.'),
        Dicho('', '(Não tinha acabado.)'),
      ],
    ),
    '31_golpean_el_porton.png': TextoPanel(
      narracion: 'Três batidas no portão. Nenhuma pediu licença.',
      conversacion: [
        Dicho('', '(Uma.)'),
        Dicho('', '(Duas.)'),
        Dicho('', '(Três.)'),
        Dicho('Novato', 'Tudo bem. Podem vir.'),
      ],
    ),
    '32_los_campeones.png': TextoPanel(
      narracion:
          'O Grande Torneio Ilegal de Artes Marciais precisa de sede. Vieram buscar a sua.',
      conversacion: [
        Dicho('Os Campeões', 'Disseram que aqui não tinha ninguém.'),
        Dicho('Novato', 'Disseram errado.'),
      ],
    ),

    // --------------------------------------------------------------- victoria
    '40_victoria_campeones.png': TextoPanel(
      narracion:
          'Os dois Campeões foram embora por onde vieram. Um deles mancando.',
      conversacion: [
        Dicho('Novato', 'O templo não está à venda.'),
        Dicho('', '(Mei desceu do telhado pela primeira vez no dia todo.)'),
      ],
    ),
    '41_vuelve_shifu.png': TextoPanel(
      narracion:
          'Cumprido o prazo, Shifu voltou. O mesmo chapéu, a mesma bolsa, a mesma cara.',
      conversacion: [
        Dicho('Shifu', 'O pátio está varrido. O templo está de pé. Bom.'),
        Dicho('Novato', 'Foi tranquilo.'),
        Dicho('Shifu', 'Hum.'),
      ],
    ),
    '42_las_galletas.png': TextoPanel(
      narracion: 'Depois ele abriu o armário.',
      conversacion: [
        Dicho('Shifu', 'Faltam dois.'),
        Dicho('Novato', 'Mei.'),
        Dicho('Mei', '(já não estava no quadro)'),
      ],
    ),

    // ---------------------------------------------------------------- derrota
    '50_derrota_patio.png': TextoPanel(
      narracion: 'Não sobrou nada. Nem Energia, nem técnicas, nem desculpas.',
      conversacion: [Dicho('', '(O portão ficou aberto. Ninguém o fechou.)')],
    ),
    '51_shifu_ve_el_desastre.png': TextoPanel(
      narracion: 'Shifu voltou pontual, como sempre.',
      conversacion: [
        Dicho('Shifu', '...'),
        Dicho('Novato', 'Eu posso explicar.'),
        Dicho('Shifu', '...'),
      ],
    ),
    '52_la_pregunta.png': TextoPanel(
      narracion: 'E então fez a única pergunta que importava.',
      conversacion: [
        Dicho('Shifu', 'E os biscoitos?'),
        Dicho('', '(Essa foi a parte difícil de explicar.)'),
      ],
    ),
  },
  encargos: {
    'sin_meditar': TextoEncargo(
      titulo: 'Nada de meditar',
      nota: 'Meditar é superestimado. Se vire com o baralho que você tem.',
      recompensa: '+2 de Energia inicial amanhã',
    ),
    'terminar_fuerte': TextoEncargo(
      titulo: 'Termine inteiro',
      nota: 'Não me serve um guardião que ganha e fica caído no pátio.',
      recompensa: '+2 de Energia inicial amanhã',
    ),
    'alba_impecable': TextoEncargo(
      titulo: 'O Amanhecer impecável',
      nota: 'Se você perde para um mosquito, não quero nem saber do resto. ',
      recompensa: 'Meditar sai de graça amanhã',
    ),
    'sin_pagar_robos': TextoEncargo(
      titulo: 'Sem gastar demais',
      nota: 'Energia não nasce no bambu. Se vire com o que te toca. ',
      recompensa: '+1 carta grátis em todos os perigos amanhã',
    ),
    'purga_profunda': TextoEncargo(
      titulo: 'Faxina de técnica',
      nota: 'Tire essas dúvidas de cima de você. Todas. Hoje.',
      recompensa: 'Meditar elimina 2 cartas amanhã',
    ),
    'partida_corta': TextoEncargo(
      titulo: 'Rápido e limpo',
      nota:
          'O templo não se defende sozinho, mas você também não tem o dia todo. ',
      recompensa: '+3 de Energia inicial amanhã',
    ),
    'pocas_derrotas': TextoEncargo(
      titulo: 'Perca pouco',
      nota: 'Perder três vezes é aprendizado. Perder oito é outra coisa.',
      recompensa: '+2 de Energia inicial amanhã',
    ),
    'mediodia_limpio': TextoEncargo(
      titulo: 'O Meio-dia sem quedas',
      nota: 'Quem sobe ao meio-dia cobra para vir. Que não receba.',
      recompensa: '+1 carta grátis em todos os perigos amanhã',
    ),
    'jefes_sin_reintento': TextoEncargo(
      titulo: 'Os Campeões de primeira',
      nota: 'Campeão se vence uma vez. Repetir é falta de educação. ',
      recompensa: '+3 de Energia inicial amanhã',
    ),
    'sobrar_energia': TextoEncargo(
      titulo: 'Que sobre',
      nota: 'Quero encontrar o templo de pé e você com vontade de varrer. ',
      recompensa: 'Limite de Energia +5 amanhã',
    ),
    'sin_curarse': TextoEncargo(
      titulo: 'Aguentar sem ajuda',
      nota: 'A água sagrada é para o fogo, não para as suas desculpas.',
      recompensa: '+1 carta grátis em todos os perigos amanhã',
    ),
    'victoria_ajustada': TextoEncargo(
      titulo: 'No limite',
      nota: 'Ganhar com cinco de Energia tem mais mérito. E menos bom senso. ',
      recompensa: '+4 de Energia inicial amanhã',
    ),
  },
  reversos: {
    'Alba': TextoReverso(
      nombre: 'Amanhecer',
      queCartasLleva: 'As 10 cartas perigo/técnica do baralho do Amanhecer',
      descripcion:
          'Lótus entalhado ao centro, sol nascendo baixo no horizonte atrás.',
    ),
    'Mediodía': TextoReverso(
      nombre: 'Meio-dia',
      queCartasLleva: 'As 10 cartas perigo/técnica do baralho do Meio-dia',
      descripcion: 'Mesmo lótus, sol alto e pleno atrás.',
    ),
    'Ocaso': TextoReverso(
      nombre: 'Anoitecer',
      queCartasLleva: 'As 10 cartas perigo/técnica do baralho do Anoitecer',
      descripcion: 'Mesmo lótus, sol afundando atrás, sombras longas.',
    ),
    'Jefes': TextoReverso(
      nombre: 'Campeões',
      queCartasLleva: 'As 5 cartas de Campeão do Torneio',
      descripcion:
          'Lótus negro, moldura mais pesada, sem sol. Deve parecer mais pesado que os outros três.',
    ),
    'Combate': TextoReverso(
      nombre: 'Combate',
      queCartasLleva: 'As 20 técnicas iniciais',
      descripcion:
          'Lótus simples, padrão sóbrio, sem sol. É o baralho que o jogador tem na mão o tempo todo: mantenha discreto.',
    ),
  },
);
