import 'dart:math';

import 'modos/cansancio.dart';
import 'l10n.dart';
import 'models.dart';

enum EstadoJuego {
  esperandoPeligro, // hay que revelar el siguiente peligro
  enCombate, // robando cartas
  postCombate, // combate resuelto, opción de meditar
  victoria,
  derrota,
}

class Entrada {
  final String texto;
  final String tipo; // info | bien | mal | fase
  Entrada(this.texto, [this.tipo = 'info']);
}

class Juego {
  final Config cfg;
  final Contenido contenido;
  final Random rng;

  /// Los textos de la bitácora.
  ///
  /// El motor escribe prosa —es lo que se lee en la bitácora de la partida— y
  /// esa prosa estaba en español dentro del motor, así que un jugador inglés
  /// jugaba en inglés y leía la bitácora en castellano. El default existe para
  /// los tests y las herramientas; la app siempre pasa el idioma que se juega.
  final TextosUi textos;

  final String? _recurso;

  /// Cómo se llama la Energía en este tema y en este idioma.
  String get recurso => _recurso ?? textos('juego.recurso');

  late int energia;
  late List<CartaCombate> mazo;
  late List<CartaCombate> descarte;
  late List<CartaCombate> eliminadas;

  late Map<Fase, List<CartaPeligro>> mazosPeligro;
  late List<CartaJefe> jefes;
  int jefeActual = 0;

  Fase fase = Fase.alba;
  EstadoJuego estado = EstadoJuego.esperandoPeligro;

  CartaPeligro? peligro;
  List<CartaCombate> mesa = [];
  int reduccionAcumulada = 0;
  int energiaSiGanaAcumulada = 0;

  /// Qué carta puso cada parte de `energiaSiGanaAcumulada`, en orden.
  ///
  /// El efecto se promete al robar y se cobra al terminar el combate, y en el
  /// medio pasan diez cosas: sin decir de dónde salió, el ajuste final parece
  /// un número inventado. Se usa sólo para la bitácora.
  final List<(String, int)> causasSiGana = [];
  int gratisRestantes = 0;
  bool ultimoCombateGanado = false;

  int turnos = 0;
  int energiaGastadaEnRobos = 0;
  int energiaGastadaEnMeditar = 0;
  int cartasEliminadas = 0;
  int combatesGanados = 0;
  int combatesPerdidos = 0;

  /// Combates perdidos por fase. Lo consulta el modo Encargos.
  final Map<Fase, int> perdidosPorFase = {};

  /// Energía total ganada por efectos de carta. Lo consulta el modo Encargos.
  int energiaGanadaPorCartas = 0;

  /// Cartas de Cansancio que entraron al mazo (modo Cansancio).
  int cansancioAgregado = 0;

  /// Cuántas veces se rehízo el mazo barajando el descarte.
  ///
  /// Sólo lo mira la interfaz, para avisar del barajado. No entra en ninguna
  /// regla ni en el balance: es un contador de observación.
  int vecesBarajado = 0;

  /// La última carta de Cansancio que entró al descarte.
  ///
  /// Se sortea al azar entre diez, así que sin esto el jugador no tiene forma
  /// de saber CUÁL le tocó hasta que la roba. La interfaz la muestra y la
  /// limpia; el motor sólo la deja anotada.
  CartaCombate? ultimoCansancio;

  /// Cuánta Energía movió DE VERDAD la última carta jugada, ya topada.
  ///
  /// No es lo mismo que `efecto.energiaAlJugar`: con la Energía al máximo una
  /// carta de +3 mueve 0. La interfaz dibujaba el valor nominal y el jugador
  /// veía un "+3" que el marcador no acompañaba. Observación pura.
  int ultimoDeltaEnergia = 0;

  final List<Entrada> log = [];

  /// Si [barajar] es false, el mazo inicial y los peligros salen en el orden
  /// exacto en que están escritos. Lo usa el tutorial para que el guion se
  /// cumpla siempre. En el juego normal es siempre true.
  final bool barajar;

  Juego({
    required this.cfg,
    required this.contenido,
    Random? rng,
    this.barajar = true,
    this.textos = TextosUi.es,
    String? recurso,
  }) : _recurso = recurso,
       rng = rng ?? Random() {
    _iniciar();
  }

  void _iniciar() {
    energia = cfg.energiaInicial;
    mazo = [];
    var i = 0;
    for (final (carta, cant) in contenido.mazoInicial) {
      for (var k = 0; k < cant; k++) {
        mazo.add(carta.copyWith(instancia: i++));
      }
    }
    if (barajar) mazo.shuffle(rng);
    descarte = [];
    eliminadas = [];

    List<CartaPeligro> mezclar(List<CartaPeligro> l) =>
        barajar ? ([...l]..shuffle(rng)) : [...l];

    // Se enfrenta sólo una parte de cada mazo: los que sobran no se ven en
    // esta partida. Menos peligros = menos técnicas ganadas = jefes más duros.
    // El tutorial corre con mazos vacíos: sin esta guarda, clamp(1, 0) explota.
    List<CartaPeligro> recortar(List<CartaPeligro> l) => l.isEmpty
        ? <CartaPeligro>[]
        : mezclar(l).take(cfg.peligrosPorFase.clamp(1, l.length)).toList();

    mazosPeligro = {
      Fase.alba: recortar(contenido.alba),
      Fase.mediodia: recortar(contenido.mediodia),
      Fase.ocaso: recortar(contenido.ocaso),
    };

    final pool = barajar
        ? ([...contenido.jefes]..shuffle(rng))
        : [...contenido.jefes];
    // El tutorial corre sin jefes: sin esta guarda, clamp(1, 0) explota.
    jefes = pool.isEmpty
        ? []
        : pool.take(cfg.cantidadJefes.clamp(1, pool.length)).toList();

    _log(textos('log.arranca'), 'fase');
    revelarPeligro();
  }

  void _log(String t, [String tipo = 'info']) => log.add(Entrada(t, tipo));

  // ---------------------------------------------------------------- consultas

  int get poderPeligroEfectivo =>
      peligro == null ? 0 : max(0, peligro!.poder - reduccionAcumulada);

  int get sumaMesa => mesa.fold(0, (a, c) => a + c.poder);

  int get faltante => max(0, poderPeligroEfectivo - sumaMesa);

  bool get puedeRobarGratis => cfg.robosGratisIlimitados || gratisRestantes > 0;

  bool get hayCartasParaRobar => mazo.isNotEmpty || descarte.isNotEmpty;

  bool get puedeRobar =>
      estado == EstadoJuego.enCombate &&
      hayCartasParaRobar &&
      (puedeRobarGratis || energia >= cfg.costeRoboExtra);

  /// Contra un jefe no se pacta: mientras te quede una carta para robar, la
  /// peleás. El combate sólo se cierra perdido cuando ya no podés robar, y eso
  /// no es rendirse — es que no te dio.
  bool get puedeRendirse =>
      estado == EstadoJuego.enCombate && (fase != Fase.jefes || !puedeRobar);

  bool get puedeMeditar =>
      estado == EstadoJuego.postCombate &&
      descarte.isNotEmpty &&
      energia >= cfg.costeMeditar &&
      (!cfg.meditarSoloAlPerder || !ultimoCombateGanado);

  int get peligrosRestantesFase =>
      fase == Fase.jefes ? 0 : mazosPeligro[fase]!.length;

  CartaJefe? get jefeEnCurso => fase == Fase.jefes && jefeActual < jefes.length
      ? jefes[jefeActual]
      : null;

  // ---------------------------------------------------------------- acciones

  void revelarPeligro() {
    if (estado != EstadoJuego.esperandoPeligro) return;
    turnos++;
    mesa = [];
    reduccionAcumulada = 0;
    energiaSiGanaAcumulada = 0;
    causasSiGana.clear();

    if (fase == Fase.jefes) {
      final j = jefes[jefeActual];
      peligro = j.comoPeligro();
      _log(
        textos.con('log.jefeFinal', {
          'nombre': j.nombre,
          'poder': j.poder,
          'dano': j.dano,
        }),
        'fase',
      );
    } else {
      final m = mazosPeligro[fase]!;
      peligro = m.removeAt(0);
      _log(
        textos.con('log.peligro', {
          'nombre': peligro!.nombre,
          'poder': peligro!.poder,
          'dano': peligro!.dano,
        }),
      );
    }
    gratisRestantes = peligro!.cartasGratis + cfg.cartasGratisExtra;
    estado = EstadoJuego.enCombate;
  }

  /// Roba una carta y aplica sus efectos inmediatos. Devuelve la carta o null.
  CartaCombate? robar({bool esEfecto = false}) {
    if (estado != EstadoJuego.enCombate) return null;
    if (!hayCartasParaRobar) return null;

    if (!esEfecto) {
      if (puedeRobarGratis) {
        if (!cfg.robosGratisIlimitados) gratisRestantes--;
      } else {
        if (energia < cfg.costeRoboExtra) return null;
        energia -= cfg.costeRoboExtra;
        energiaGastadaEnRobos += cfg.costeRoboExtra;
        _log(
          textos.con('log.pagasRobo', {
            'n': cfg.costeRoboExtra,
            'recurso': recurso,
          }),
        );
      }
    }

    final carta = _sacarDelMazo();
    if (carta == null) return null;
    mesa.add(carta);
    _aplicarEfectos(carta);
    return carta;
  }

  CartaCombate? _sacarDelMazo() {
    if (mazo.isEmpty) {
      if (descarte.isEmpty) return null;
      mazo = barajar ? ([...descarte]..shuffle(rng)) : [...descarte];
      descarte = [];
      vecesBarajado++;
      _log(textos('log.barajas'));
      if (_cansancioAlBarajar) _agregarCansancio();
    }
    return mazo.removeAt(0);
  }

  void _aplicarEfectos(CartaCombate c) {
    final e = c.efecto;
    if (e.energiaAlJugar != 0) {
      final antes = energia;
      _cambiarEnergia(e.energiaAlJugar);
      final real = energia - antes;
      ultimoDeltaEnergia = real;
      if (real > 0) energiaGanadaPorCartas += real;
      _log(
        textos.con('log.energia', {
              'carta': c.nombre,
              'n': real > 0 ? '+$real' : '$real',
              'recurso': recurso,
            }) +
            (real != e.energiaAlJugar
                ? ' ${textos.con('log.topado', {'max': cfg.energiaMaxima})}'
                : ''),
        e.energiaAlJugar > 0 ? 'bien' : 'mal',
      );
    }
    if (e.reducePeligro > 0) {
      reduccionAcumulada += e.reducePeligro;
      _log(
        textos.con('log.bajaPeligro', {
          'carta': c.nombre,
          'n': e.reducePeligro,
        }),
      );
    }
    if (e.energiaSiGanas != 0) {
      energiaSiGanaAcumulada += e.energiaSiGanas;
      causasSiGana.add((c.nombre, e.energiaSiGanas));
      _log(
        textos.con('log.siGanas', {
          'carta': c.nombre,
          'n': e.energiaSiGanas > 0
              ? '+${e.energiaSiGanas}'
              : '${e.energiaSiGanas}',
          'recurso': recurso,
        }),
        e.energiaSiGanas > 0 ? 'bien' : 'mal',
      );
    }
    for (var k = 0; k < e.roba; k++) {
      robar(esEfecto: true);
    }
  }

  void _cambiarEnergia(int delta) {
    energia = min(energia + delta, cfg.energiaMaxima);
    // La Energía no baja de 0: se pierde EN EL MOMENTO en que no se puede
    // pagar, no al terminar el combate. Antes se podía llegar a -2 robando,
    // ganar igual, y recién ahí enterarse de que habías perdido.
    if (energia < 0) {
      energia = 0;
      estado = EstadoJuego.derrota;
      _log(textos.con('log.sinEnergia', {'recurso': recurso}), 'mal');
    }
  }

  /// Deja de robar y compara poderes.
  void resolver() {
    if (estado != EstadoJuego.enCombate || peligro == null) return;
    final p = peligro!;
    final gano = sumaMesa >= poderPeligroEfectivo;
    // Plantarse por debajo es rendirse, y contra el jefe eso no existe: la
    // regla vive acá y no en el botón, para que ninguna pantalla la saltee.
    if (!gano && !puedeRendirse) return;
    ultimoCombateGanado = gano;

    if (gano) {
      combatesGanados++;
      if (energiaSiGanaAcumulada != 0) {
        if (energiaSiGanaAcumulada > 0) {
          energiaGanadaPorCartas += energiaSiGanaAcumulada;
        }
        _cambiarEnergia(energiaSiGanaAcumulada);
        // El detalle va entre paréntesis, carta por carta: es la única forma
        // de que el jugador pueda verificar la cuenta en vez de confiar.
        final detalle = causasSiGana
            .map((c) => '${c.$1} ${c.$2 > 0 ? '+' : ''}${c.$2}')
            .join(', ');
        _log(
          textos.con('log.efectosVictoria', {
            'n': energiaSiGanaAcumulada > 0
                ? '+$energiaSiGanaAcumulada'
                : '$energiaSiGanaAcumulada',
            'recurso': recurso,
            'detalle': detalle,
          }),
        );
      }
      if (fase == Fase.jefes) {
        _log(
          textos.con('log.derrotasteJefe', {
            'nombre': p.nombre,
            'suma': sumaMesa,
            'poder': poderPeligroEfectivo,
          }),
          'bien',
        );
        jefeActual++;
      } else {
        descarte.add(p.recompensa.copyWith(instancia: _nuevaInstancia()));
        _log(
          textos.con('log.ganaste', {
            'suma': sumaMesa,
            'poder': poderPeligroEfectivo,
            'tecnica': p.recompensa.nombre,
            'tecnicaPoder': p.recompensa.poder,
          }),
          'bien',
        );
      }
    } else {
      combatesPerdidos++;
      perdidosPorFase[fase] = (perdidosPorFase[fase] ?? 0) + 1;
      _cambiarEnergia(-p.dano);
      _log(
        textos.con('log.perdiste', {
          'suma': sumaMesa,
          'poder': poderPeligroEfectivo,
          'dano': p.dano,
          'recurso': recurso,
        }),
        'mal',
      );
      if (fase != Fase.jefes && !cfg.peligroPerdidoSaleDelJuego) {
        mazosPeligro[fase]!.add(p);
      }
    }

    descarte.addAll(mesa);
    mesa = [];
    // Si el golpe ya terminó la partida, no se vuelve a post-combate.
    if (!terminado) estado = EstadoJuego.postCombate;

    if (energia == 0 && !terminado) {
      _log(textos.con('log.enCero', {'recurso': recurso}), 'mal');
    }
  }

  int _contadorInstancias = 10000;
  int _nuevaInstancia() => _contadorInstancias++;

  /// El mazo de Cansancio de esta partida, barajado una sola vez.
  ///
  /// Es un mazo de verdad y no un sorteo con reposición: se reparte de arriba
  /// y lo que salió no vuelve. Sin barajado queda en orden fijo, para que las
  /// partidas determinísticas de los tests sigan siéndolo.
  late final List<CartaCansancio> _pilaCansancio = barajar
      ? ([...mazoCansancio]..shuffle(rng))
      : [...mazoCansancio];

  /// MODO CANSANCIO: mete una carta de fatiga al azar DENTRO del mazo.
  ///
  /// Va al mazo y no al descarte porque el descarte es lo ya jugado, y meditar
  /// purga de ahí: una carta de Cansancio recién llegada aparecía como
  /// candidata a purgar sin que el jugador la hubiera visto nunca en la mesa.
  /// La fatiga es algo que te vas a encontrar, no algo que ya te pasó.
  ///
  /// Se inserta en una posición al azar en vez de rebarajar el mazo entero:
  /// para el jugador es lo mismo —no sabe cuándo va a salir— y así no se le
  /// revuelve el orden de todo lo que todavía no jugó.
  ///
  /// Sólo se llama con `cfg.modoCansancio` prendido.
  // Los dos disparos se preguntan por lo que NO son, para que `ambos` entre
  // por las dos puertas sin repetir la condición en cada sitio.
  bool get _cansancioAlBarajar =>
      cfg.modoCansancio &&
      cfg.disparoCansancio != DisparoCansancio.finDeFase.index;

  bool get _cansancioAlFinDeFase =>
      cfg.modoCansancio &&
      cfg.disparoCansancio != DisparoCansancio.alRebarajar.index;

  void _agregarCansancio() {
    // Se sortea SIN reposición: cada fatiga es una sola, y verla dos veces
    // rompía la idea de que el cuerpo se te va gastando de a pedazos
    // distintos. Agotadas las diez, el Cansancio deja de sumar.
    if (_pilaCansancio.isEmpty) return;
    final c = _pilaCansancio.removeLast();
    final texto = contenido.cansancio[c.id] ?? (c.id, '');
    final carta = cartaDeCansancio(
      c,
      cfg.poderCansancio,
      _nuevaInstancia(),
      texto.$1,
      texto.$2,
    );
    // Sin barajado el mazo es determinístico y tiene que seguir siéndolo.
    mazo.insert(barajar ? rng.nextInt(mazo.length + 1) : mazo.length, carta);
    cansancioAgregado++;
    ultimoCansancio = carta;
    _log(
      textos.con('log.cansancio', {
        'carta': carta.nombre,
        'poder': carta.poder,
      }),
      'mal',
    );
  }

  void meditar(CartaCombate carta) {
    if (!puedeMeditar) return;
    _cambiarEnergia(-cfg.costeMeditar);
    energiaGastadaEnMeditar += cfg.costeMeditar;
    for (var k = 0; k < cfg.cartasPorMeditacion; k++) {
      if (descarte.isEmpty) break;
      final idx = k == 0
          ? descarte.indexWhere((c) => c.uid == carta.uid)
          : _peorDelDescarte();
      if (idx < 0) break;
      final quitada = descarte.removeAt(idx);
      eliminadas.add(quitada);
      cartasEliminadas++;
      _log(textos.con('log.meditas', {'carta': quitada.nombre}));
    }
  }

  int _peorDelDescarte() {
    var mejorIdx = 0;
    var mejorValor = 999;
    for (var i = 0; i < descarte.length; i++) {
      final v = valorCarta(descarte[i]);
      if (v < mejorValor) {
        mejorValor = v;
        mejorIdx = i;
      }
    }
    return mejorIdx;
  }

  /// Heurística de "qué tan buena" es una carta (para la IA y para ordenar).
  static int valorCarta(CartaCombate c) =>
      c.poder * 2 +
      c.efecto.roba * 2 +
      c.efecto.energiaAlJugar +
      c.efecto.energiaSiGanas +
      c.efecto.reducePeligro * 2;

  /// Termina el paso de meditación, avanza fase/estado y revela el próximo
  /// peligro automáticamente (no hace falta un click extra).
  void continuar() {
    if (estado != EstadoJuego.postCombate) return;

    if (fase == Fase.jefes) {
      if (jefeActual >= jefes.length) {
        estado = EstadoJuego.victoria;
        _log(textos('log.victoria'), 'bien');
        return;
      }
      estado = EstadoJuego.esperandoPeligro;
      revelarPeligro();
      return;
    }

    if (mazosPeligro[fase]!.isEmpty) {
      switch (fase) {
        case Fase.alba:
          fase = Fase.mediodia;
          _log(textos('log.mediodia'), 'fase');
        case Fase.mediodia:
          fase = Fase.ocaso;
          _log(textos('log.ocaso'), 'fase');
        case Fase.ocaso:
          fase = Fase.jefes;
          _log(
            textos.con('log.campeones', {
              'nombres': jefes
                  .map((j) => j.nombre)
                  .join(' ${textos('log.y')} '),
            }),
            'fase',
          );
        case Fase.jefes:
          break;
      }
      if (_cansancioAlFinDeFase) _agregarCansancio();
    }
    estado = EstadoJuego.esperandoPeligro;
    revelarPeligro();
  }

  bool get terminado =>
      estado == EstadoJuego.victoria || estado == EstadoJuego.derrota;
}
