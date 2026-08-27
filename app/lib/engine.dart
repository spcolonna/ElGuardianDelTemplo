import 'dart:math';

import 'modos/cansancio.dart';
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
  }) : rng = rng ?? Random() {
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

    _log('El Maestro Shifu se fue. Empieza el Alba.', 'fase');
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
        'JEFE FINAL: ${j.nombre} (Poder ${j.poder}, Daño ${j.dano})',
        'fase',
      );
    } else {
      final m = mazosPeligro[fase]!;
      peligro = m.removeAt(0);
      _log(
        'Peligro: ${peligro!.nombre} (Poder ${peligro!.poder}, '
        'Daño ${peligro!.dano})',
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
        _log('Pagás ${cfg.costeRoboExtra} de Energía por una carta extra.');
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
      _log('Barajás el descarte para rehacer el mazo.');
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
        '${c.nombre}: ${real > 0 ? '+' : ''}$real Energía'
        '${real != e.energiaAlJugar ? ' (topado en ${cfg.energiaMaxima})' : ''}.',
        e.energiaAlJugar > 0 ? 'bien' : 'mal',
      );
    }
    if (e.reducePeligro > 0) {
      reduccionAcumulada += e.reducePeligro;
      _log('${c.nombre}: el peligro baja ${e.reducePeligro} de Poder.');
    }
    if (e.energiaSiGanas != 0) {
      energiaSiGanaAcumulada += e.energiaSiGanas;
      causasSiGana.add((c.nombre, e.energiaSiGanas));
      _log(
        '${c.nombre}: si ganás este combate, '
        '${e.energiaSiGanas > 0 ? '+' : ''}${e.energiaSiGanas} Energía.',
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
      _log('Te quedaste sin Energía. El templo cae.', 'mal');
    }
  }

  /// Deja de robar y compara poderes.
  void resolver() {
    if (estado != EstadoJuego.enCombate || peligro == null) return;
    final p = peligro!;
    final gano = sumaMesa >= poderPeligroEfectivo;
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
          'Efectos de victoria: ${energiaSiGanaAcumulada > 0 ? '+' : ''}'
          '$energiaSiGanaAcumulada Energía ($detalle).',
        );
      }
      if (fase == Fase.jefes) {
        _log(
          '¡Derrotaste a ${p.nombre}! ($sumaMesa vs $poderPeligroEfectivo)',
          'bien',
        );
        jefeActual++;
      } else {
        descarte.add(p.recompensa.copyWith(instancia: _nuevaInstancia()));
        _log(
          '¡Ganaste! ($sumaMesa vs $poderPeligroEfectivo) '
              'Ganás ${p.recompensa.nombre} (${p.recompensa.poder}).',
          'bien',
        );
      }
    } else {
      combatesPerdidos++;
      perdidosPorFase[fase] = (perdidosPorFase[fase] ?? 0) + 1;
      _cambiarEnergia(-p.dano);
      _log(
        'Perdiste ($sumaMesa vs $poderPeligroEfectivo). '
            '-${p.dano} de Energía.',
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
      _log(
        'Quedaste en 0 de Energía: seguís en pie, pero el próximo gasto '
            'te tumba.',
        'mal',
      );
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
    final carta = cartaDeCansancio(c, cfg.poderCansancio, _nuevaInstancia());
    // Sin barajado el mazo es determinístico y tiene que seguir siéndolo.
    mazo.insert(barajar ? rng.nextInt(mazo.length + 1) : mazo.length, carta);
    cansancioAgregado++;
    ultimoCansancio = carta;
    _log(
      'El cansancio se acumula: ${carta.nombre} (${carta.poder}) '
          'entra a tu mazo.',
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
      _log('Meditás: eliminás ${quitada.nombre} del juego.');
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
        _log(
          '¡Protegiste el templo! Shifu nunca se va a enterar de lo de las galletas.',
          'bien',
        );
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
          _log('Cae el Mediodía. Las cosas se ponen serias.', 'fase');
        case Fase.mediodia:
          fase = Fase.ocaso;
          _log('Cae el Ocaso. El verdadero peligro llega.', 'fase');
        case Fase.ocaso:
          fase = Fase.jefes;
          _log(
            'Los Campeones del Torneo llegan al templo: '
                '${jefes.map((j) => j.nombre).join(' y ')}.',
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
