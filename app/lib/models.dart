// Modelos de datos de "El Guardián del Templo".
// Todo es mutable/copiable para poder ajustar valores desde la pantalla de balance.

enum Fase { alba, mediodia, ocaso, jefes }

extension FaseX on Fase {
  String get nombre => switch (this) {
    Fase.alba => 'Alba',
    Fase.mediodia => 'Mediodía',
    Fase.ocaso => 'Ocaso',
    Fase.jefes => 'Enfrentamiento Final',
  };
}

/// Efectos de una carta de combate.
class Efecto {
  /// Cartas que roba al jugarse.
  final int roba;

  /// Energía inmediata al jugarse (negativa = coste).
  final int energiaAlJugar;

  /// Energía si ganás el combate (Ala de Grulla, Patada Descuidada = -1).
  final int energiaSiGanas;

  /// Reduce el poder del peligro antes de resolver.
  final int reducePeligro;

  const Efecto({
    this.roba = 0,
    this.energiaAlJugar = 0,
    this.energiaSiGanas = 0,
    this.reducePeligro = 0,
  });

  bool get vacio =>
      roba == 0 &&
      energiaAlJugar == 0 &&
      energiaSiGanas == 0 &&
      reducePeligro == 0;

  Efecto copyWith({
    int? roba,
    int? energiaAlJugar,
    int? energiaSiGanas,
    int? reducePeligro,
  }) => Efecto(
    roba: roba ?? this.roba,
    energiaAlJugar: energiaAlJugar ?? this.energiaAlJugar,
    energiaSiGanas: energiaSiGanas ?? this.energiaSiGanas,
    reducePeligro: reducePeligro ?? this.reducePeligro,
  );

  String get texto {
    final p = <String>[];
    if (roba > 0) p.add('Roba $roba');
    if (energiaAlJugar != 0) {
      p.add('${energiaAlJugar > 0 ? '+' : ''}$energiaAlJugar Energía');
    }
    if (energiaSiGanas != 0) {
      p.add('${energiaSiGanas > 0 ? '+' : ''}$energiaSiGanas Energía si ganás');
    }
    if (reducePeligro > 0) p.add('-$reducePeligro al peligro');
    return p.join(' · ');
  }

  Map<String, dynamic> toJson() => {
    'roba': roba,
    'energiaAlJugar': energiaAlJugar,
    'energiaSiGanas': energiaSiGanas,
    'reducePeligro': reducePeligro,
  };

  factory Efecto.fromJson(Map<String, dynamic> j) => Efecto(
    roba: j['roba'] ?? 0,
    energiaAlJugar: j['energiaAlJugar'] ?? 0,
    energiaSiGanas: j['energiaSiGanas'] ?? 0,
    reducePeligro: j['reducePeligro'] ?? 0,
  );
}

class CartaCombate {
  final String id;
  final String nombre;
  final int poder;
  final Efecto efecto;
  final String sabor;

  /// Sólo para identificar copias distintas en mesa.
  final int instancia;

  const CartaCombate({
    required this.id,
    required this.nombre,
    required this.poder,
    this.efecto = const Efecto(),
    this.sabor = '',
    this.instancia = 0,
  });

  CartaCombate copyWith({
    String? nombre,
    int? poder,
    Efecto? efecto,
    String? sabor,
    int? instancia,
  }) => CartaCombate(
    id: id,
    nombre: nombre ?? this.nombre,
    poder: poder ?? this.poder,
    efecto: efecto ?? this.efecto,
    sabor: sabor ?? this.sabor,
    instancia: instancia ?? this.instancia,
  );

  String get uid => '$id#$instancia';

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'poder': poder,
    'efecto': efecto.toJson(),
    'sabor': sabor,
  };

  factory CartaCombate.fromJson(Map<String, dynamic> j) => CartaCombate(
    id: j['id'],
    nombre: j['nombre'],
    poder: j['poder'],
    efecto: Efecto.fromJson(Map<String, dynamic>.from(j['efecto'] ?? {})),
    sabor: j['sabor'] ?? '',
  );
}

class CartaPeligro {
  final String id;
  final String nombre;
  final Fase fase;
  final int poder;
  final int dano;

  /// Cartas gratis antes de tener que pagar Energía (regla estilo Friday).
  final int cartasGratis;

  /// Recompensa: carta de combate que ganás si vencés.
  final CartaCombate recompensa;

  const CartaPeligro({
    required this.id,
    required this.nombre,
    required this.fase,
    required this.poder,
    required this.dano,
    required this.cartasGratis,
    required this.recompensa,
  });

  CartaPeligro copyWith({
    String? nombre,
    int? poder,
    int? dano,
    int? cartasGratis,
    CartaCombate? recompensa,
  }) => CartaPeligro(
    id: id,
    nombre: nombre ?? this.nombre,
    fase: fase,
    poder: poder ?? this.poder,
    dano: dano ?? this.dano,
    cartasGratis: cartasGratis ?? this.cartasGratis,
    recompensa: recompensa ?? this.recompensa,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'fase': fase.index,
    'poder': poder,
    'dano': dano,
    'cartasGratis': cartasGratis,
    'recompensa': recompensa.toJson(),
  };

  factory CartaPeligro.fromJson(Map<String, dynamic> j) => CartaPeligro(
    id: j['id'],
    nombre: j['nombre'],
    fase: Fase.values[j['fase']],
    poder: j['poder'],
    dano: j['dano'],
    cartasGratis: j['cartasGratis'] ?? 1,
    recompensa: CartaCombate.fromJson(
      Map<String, dynamic>.from(j['recompensa']),
    ),
  );
}

class CartaJefe {
  final String id;
  final String nombre;
  final int poder;
  final int dano;
  final int cartasGratis;
  final String lore;

  const CartaJefe({
    required this.id,
    required this.nombre,
    required this.poder,
    required this.dano,
    required this.cartasGratis,
    this.lore = '',
  });

  CartaJefe copyWith({
    String? nombre,
    int? poder,
    int? dano,
    int? cartasGratis,
  }) => CartaJefe(
    id: id,
    nombre: nombre ?? this.nombre,
    poder: poder ?? this.poder,
    dano: dano ?? this.dano,
    cartasGratis: cartasGratis ?? this.cartasGratis,
    lore: lore,
  );

  /// Un jefe se resuelve igual que un peligro: lo convertimos para reusar la lógica.
  CartaPeligro comoPeligro() => CartaPeligro(
    id: id,
    nombre: nombre,
    fase: Fase.jefes,
    poder: poder,
    dano: dano,
    cartasGratis: cartasGratis,
    recompensa: CartaCombate(id: 'nada', nombre: '—', poder: 0),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'poder': poder,
    'dano': dano,
    'cartasGratis': cartasGratis,
    'lore': lore,
  };

  factory CartaJefe.fromJson(Map<String, dynamic> j) => CartaJefe(
    id: j['id'],
    nombre: j['nombre'],
    poder: j['poder'],
    dano: j['dano'],
    cartasGratis: j['cartasGratis'] ?? 4,
    lore: j['lore'] ?? '',
  );
}

/// Parámetros de partida ajustables para playtesting.
class Config {
  int energiaInicial;
  int energiaMaxima;
  int cantidadJefes;

  /// Cuántos peligros de cada mazo se enfrentan.
  ///
  /// Es la palanca de dificultad que NO toca ningún número de carta: cada
  /// peligro vencido regala una técnica, así que enfrentar menos significa
  /// llegar a los jefes con un mazo más flaco. Ataca el efecto bola de nieve
  /// en vez de la aritmética.
  int peligrosPorFase;

  /// Si true: robar es gratis e ilimitado (regla literal del documento).
  bool robosGratisIlimitados;

  /// Coste en energía de cada carta extra.
  int costeRoboExtra;

  /// Coste en energía de meditar (eliminar 1 carta del descarte).
  int costeMeditar;

  /// Cuántas cartas se pueden eliminar por meditación.
  int cartasPorMeditacion;

  /// Meditar sólo tras perder (regla del doc) o también tras ganar.
  bool meditarSoloAlPerder;

  /// Al perder, ¿la carta de peligro sale del juego? (regla del doc)
  bool peligroPerdidoSaleDelJuego;

  /// Cartas gratis extra en TODOS los peligros. Lo usan los beneficios del
  /// modo Encargos; en el juego base siempre es 0.
  int cartasGratisExtra;

  // ------------------------------------------------------------------ modos
  /// MODO CANSANCIO: entra una carta de fatiga al mazo cada tanto.
  bool modoCansancio;

  /// Poder base de las cartas de Cansancio (0, -1 o -2).
  int poderCansancio;

  /// 0 = al terminar cada fase · 1 = cada vez que barajás el descarte.
  int disparoCansancio;

  /// MODO ENCARGOS: cada día trae una condición extra de Shifu.
  bool modoEncargos;

  Config({
    this.energiaInicial = 23,
    this.energiaMaxima = 23,
    this.cantidadJefes = 2,
    this.peligrosPorFase = 10,
    this.robosGratisIlimitados = false,
    this.costeRoboExtra = 1,
    this.costeMeditar = 1,
    this.cartasPorMeditacion = 1,
    this.meditarSoloAlPerder = true,
    this.peligroPerdidoSaleDelJuego = true,
    this.cartasGratisExtra = 0,
    this.modoCansancio = false,
    this.poderCansancio = 0,
    this.disparoCansancio = 0,
    this.modoEncargos = false,
  });

  Config clone() => Config(
    energiaInicial: energiaInicial,
    energiaMaxima: energiaMaxima,
    cantidadJefes: cantidadJefes,
    peligrosPorFase: peligrosPorFase,
    robosGratisIlimitados: robosGratisIlimitados,
    costeRoboExtra: costeRoboExtra,
    costeMeditar: costeMeditar,
    cartasPorMeditacion: cartasPorMeditacion,
    meditarSoloAlPerder: meditarSoloAlPerder,
    peligroPerdidoSaleDelJuego: peligroPerdidoSaleDelJuego,
    cartasGratisExtra: cartasGratisExtra,
    modoCansancio: modoCansancio,
    poderCansancio: poderCansancio,
    disparoCansancio: disparoCansancio,
    modoEncargos: modoEncargos,
  );

  Map<String, dynamic> toJson() => {
    'energiaInicial': energiaInicial,
    'energiaMaxima': energiaMaxima,
    'cantidadJefes': cantidadJefes,
    'peligrosPorFase': peligrosPorFase,
    'robosGratisIlimitados': robosGratisIlimitados,
    'costeRoboExtra': costeRoboExtra,
    'costeMeditar': costeMeditar,
    'cartasPorMeditacion': cartasPorMeditacion,
    'meditarSoloAlPerder': meditarSoloAlPerder,
    'peligroPerdidoSaleDelJuego': peligroPerdidoSaleDelJuego,
    'cartasGratisExtra': cartasGratisExtra,
    'modoCansancio': modoCansancio,
    'poderCansancio': poderCansancio,
    'disparoCansancio': disparoCansancio,
    'modoEncargos': modoEncargos,
  };

  factory Config.fromJson(Map<String, dynamic> j) => Config(
    energiaInicial: j['energiaInicial'] ?? 23,
    energiaMaxima: j['energiaMaxima'] ?? 23,
    cantidadJefes: j['cantidadJefes'] ?? 2,
    peligrosPorFase: j['peligrosPorFase'] ?? 10,
    robosGratisIlimitados: j['robosGratisIlimitados'] ?? false,
    costeRoboExtra: j['costeRoboExtra'] ?? 1,
    costeMeditar: j['costeMeditar'] ?? 1,
    cartasPorMeditacion: j['cartasPorMeditacion'] ?? 1,
    meditarSoloAlPerder: j['meditarSoloAlPerder'] ?? true,
    peligroPerdidoSaleDelJuego: j['peligroPerdidoSaleDelJuego'] ?? true,
    cartasGratisExtra: j['cartasGratisExtra'] ?? 0,
    modoCansancio: j['modoCansancio'] ?? false,
    poderCansancio: j['poderCansancio'] ?? 0,
    disparoCansancio: j['disparoCansancio'] ?? 0,
    modoEncargos: j['modoEncargos'] ?? false,
  );
}

/// Contenido completo del juego (editable en la pantalla de balance).
class Contenido {
  /// Mazo inicial: (carta, cantidad)
  List<(CartaCombate, int)> mazoInicial;
  List<CartaPeligro> alba;
  List<CartaPeligro> mediodia;
  List<CartaPeligro> ocaso;
  List<CartaJefe> jefes;

  Contenido({
    required this.mazoInicial,
    required this.alba,
    required this.mediodia,
    required this.ocaso,
    required this.jefes,
  });

  List<CartaPeligro> peligrosDe(Fase f) => switch (f) {
    Fase.alba => alba,
    Fase.mediodia => mediodia,
    Fase.ocaso => ocaso,
    Fase.jefes => const [],
  };

  Map<String, dynamic> toJson() => {
    'mazoInicial': mazoInicial
        .map((e) => {'carta': e.$1.toJson(), 'cantidad': e.$2})
        .toList(),
    'alba': alba.map((e) => e.toJson()).toList(),
    'mediodia': mediodia.map((e) => e.toJson()).toList(),
    'ocaso': ocaso.map((e) => e.toJson()).toList(),
    'jefes': jefes.map((e) => e.toJson()).toList(),
  };

  factory Contenido.fromJson(Map<String, dynamic> j) => Contenido(
    mazoInicial: (j['mazoInicial'] as List)
        .map(
          (e) => (
            CartaCombate.fromJson(Map<String, dynamic>.from(e['carta'])),
            e['cantidad'] as int,
          ),
        )
        .toList(),
    alba: (j['alba'] as List)
        .map((e) => CartaPeligro.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    mediodia: (j['mediodia'] as List)
        .map((e) => CartaPeligro.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    ocaso: (j['ocaso'] as List)
        .map((e) => CartaPeligro.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    jefes: (j['jefes'] as List)
        .map((e) => CartaJefe.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );
}
