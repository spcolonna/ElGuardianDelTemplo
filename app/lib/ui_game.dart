import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

import 'app_state.dart';
import 'audio.dart';
import 'l10n.dart';
import 'engine.dart';
import 'modos/encargos.dart';
import 'mecanica.dart';
import 'models.dart';
import 'ui_carta.dart';
import 'ui_fogonazo.dart';
import 'ui_common.dart';
import 'temas/temas.dart';
import 'ui_celebracion.dart';
import 'ui_intro.dart';
import 'ui_tutorial.dart';

class GameScreen extends StatefulWidget {
  /// Vuelve a la Home al terminar la partida o al abandonarla.
  final VoidCallback onSalir;
  const GameScreen({super.key, required this.onSalir});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// La celebración se muestra una vez por partida, no en cada rebuild.
  bool _celebracionVista = false;

  final _logCtrl = ScrollController();

  /// Cómic que se está mostrando encima de la mesa (interludio o final).
  Secuencia? _comic;

  /// Hay un aviso de pantalla completa arriba de todo. Mientras dure, la
  /// partida no avanza sola: el jugador no la está viendo.
  bool _adEnPantalla = false;
  Fase _faseVista = Fase.alba;
  bool _finalMostrado = false;

  /// El cómic de apertura ya se vio en ESTA partida.
  bool _introMostrada = false;

  /// Cuántos barajados ya se avisaron. El motor sólo lleva la cuenta; decidir
  /// si hay que mostrar el cartel es de acá.
  int _barajadasVistas = 0;

  /// Aviso de "se rebarajó el mazo" en pantalla ahora mismo.
  bool _avisoBaraja = false;

  /// Carta de Cansancio que se está revelando, y el uid de la última ya
  /// mostrada para no repetirla en cada rebuild.
  CartaCombate? _cansancioRevelado;
  String? _cansancioVisto;

  /// Carta de Cansancio que entró mientras el cómic tapaba la mesa.
  ///
  /// El Cansancio se agrega en el mismo `continuar()` que cambia de fase, o
  /// sea exactamente cuando se abre el interludio: revelarla ahí es revelarla
  /// detrás de una pantalla completa, y sus 4,2 s se consumen sin que nadie
  /// la vea. Queda esperando acá hasta que el cómic cierre.
  CartaCombate? _cansancioPendiente;

  Timer? _avisoTimer;

  /// La música de la partida ya arrancó. Los cambios de pista posteriores los
  /// dispara la transición de paisaje, no esto.
  bool _pistaArrancada = false;

  static const _porFase = {
    Fase.mediodia: Secuencia.mediodia,
    Fase.ocaso: Secuencia.ocaso,
    Fase.jefes: Secuencia.jefes,
  };

  /// El menú de la partida. Todo lo que no se mira en cada turno vive acá:
  /// el estado del mazo, la bitácora, reiniciar y salir.
  void _abrirMenu(BuildContext context, AppState app, Juego j, TextosUi t) {
    app.audio.sonar(Sfx.toque);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kPapelClaro,
      showDragHandle: true,
      builder: (hoja) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // El estado del mazo es informativo: acá hay lugar para las
              // etiquetas que en la barra no entraban.
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Pastilla(
                    fmt(t('juego.mazo'), {'n': j.mazo.length}),
                    icono: Icons.style,
                  ),
                  Pastilla(
                    fmt(t('juego.descarte'), {'n': j.descarte.length}),
                    icono: Icons.layers,
                  ),
                  Pastilla(
                    fmt(t('juego.eliminadas'), {'n': j.eliminadas.length}),
                    icono: Icons.delete_outline,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _OpcionMenu(
                icono: Icons.receipt_long,
                texto: '${t('nav.bitacora')} (${j.log.length})',
                onTap: () {
                  Navigator.pop(hoja);
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: kPapelClaro,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (_) => FractionallySizedBox(
                      heightFactor: .7,
                      child: _Log(juego: j, ctrl: _logCtrl, ui: t),
                    ),
                  );
                },
              ),
              _OpcionMenu(
                icono: Icons.refresh,
                texto: t('juego.nueva'),
                onTap: () {
                  Navigator.pop(hoja);
                  app.nuevaPartida();
                  _reiniciarSeguimiento();
                  setState(() {});
                },
              ),
              _OpcionMenu(
                icono: Icons.home_outlined,
                texto: t('nav.inicio'),
                onTap: () {
                  Navigator.pop(hoja);
                  widget.onSalir();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cuánto dura el fogonazo antes de que la partida siga sola. Tiene que ser
  /// un pelo más que la animación de `ui_fogonazo.dart`.
  static const _esperaAuto = Duration(milliseconds: 1250);

  /// Cuánto se queda la carta de Cansancio a la vista.
  ///
  /// Bastante más que `_esperaAuto` a propósito: ahí el jugador ya sabe qué
  /// pasó y sólo espera, mientras que acá tiene que LEER una carta que nunca
  /// vio, y que se sorteó entre diez.
  static const _esperaCansancio = Duration(milliseconds: 4200);

  Timer? _auto;

  /// Programa el avance automático si el post-combate no tiene nada que
  /// decidir. Con meditación disponible manda el jugador.
  void _programarAuto(Juego? j) {
    _auto?.cancel();
    _auto = null;
    if (j == null || j.estado != EstadoJuego.postCombate) return;
    if (j.puedeMeditar) return;
    if (_adEnPantalla) return;
    _auto = Timer(_esperaAuto, () {
      if (!mounted) return;
      final actual = AppScope.of(context).juego;
      // Entre medio el jugador pudo tocar Continuar o salir de la partida.
      if (actual == null || actual.estado != EstadoJuego.postCombate) return;
      actual.continuar();
      _refrescar();
    });
  }

  void _reiniciarSeguimiento() {
    _faseVista = Fase.alba;
    _finalMostrado = false;
    _comic = null;
    _celebracionVista = false;
    _introMostrada = false;
    _barajadasVistas = 0;
    _avisoBaraja = false;
    _cansancioRevelado = null;
    _cansancioVisto = null;
    _cansancioPendiente = null;
    _adEnPantalla = false;
    _avisoTimer?.cancel();
    _avisoTimer = null;
    _pistaArrancada = false;
  }

  /// Mira los dos contadores del motor y dispara los avisos que correspondan.
  ///
  /// El barajado y el Cansancio son las dos cosas que pasan SOLAS, sin que el
  /// jugador toque nada: si no se avisan, el mazo cambia a sus espaldas.
  void _revisarAvisos(Juego j) {
    final nuevoCansancio =
        j.ultimoCansancio != null && j.ultimoCansancio!.uid != _cansancioVisto;

    if (nuevoCansancio) {
      _cansancioVisto = j.ultimoCansancio!.uid;
      // El Cansancio manda: si además se rebarajó, el cartel de barajado
      // quedaría tapado por la carta.
      _avisoBaraja = false;
      _barajadasVistas = j.vecesBarajado;
      // Con el cómic abierto no hay mesa que mirar: espera su turno.
      if (_comic != null) {
        _cansancioPendiente = j.ultimoCansancio;
      } else {
        _revelarCansancio(j.ultimoCansancio!);
      }
      return;
    }

    if (j.vecesBarajado > _barajadasVistas) {
      _barajadasVistas = j.vecesBarajado;
      _avisoBaraja = true;
      _avisoTimer?.cancel();
      _avisoTimer = Timer(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _avisoBaraja = false);
      });
    }
  }

  /// Pone la carta de Cansancio a la vista y programa su salida.
  void _revelarCansancio(CartaCombate c) {
    _cansancioPendiente = null;
    _cansancioRevelado = c;
    _avisoTimer?.cancel();
    _avisoTimer = Timer(_esperaCansancio, () {
      if (mounted) setState(() => _cansancioRevelado = null);
    });
  }

  /// Detecta cambios de fase y el final de la partida para lanzar el cómic.
  ///
  /// Acá NO se cambia ni el paisaje ni la música. Las dos cosas cuelgan de
  /// `app.faseEscenica`, que avanza recién cuando el cómic del interludio se
  /// cierra: si se movieran acá, la transición correría tapada por el cómic y
  /// el jugador volvería a la mesa con todo ya cambiado.
  void _revisarHistoria(Juego j) {
    final app = AppScope.of(context);
    // El arranque es el único cambio de pista que no viene de una transición:
    // no hay paisaje anterior del que salir.
    if (!_pistaArrancada) {
      _pistaArrancada = true;
      app.audio.ponerPista(pistaDeFase[app.faseEscenica] ?? Pista.alba);
    }
    if (j.terminado) {
      if (!_finalMostrado) {
        _finalMostrado = true;
        app.registrarResultado(j);
        _comic = j.estado == EstadoJuego.victoria
            ? Secuencia.victoria
            : Secuencia.derrota;
      }
      return;
    }
    if (j.fase != _faseVista) {
      _faseVista = j.fase;
      _comic = _porFase[j.fase];
    }
  }

  @override
  void dispose() {
    _auto?.cancel();
    _avisoTimer?.cancel();
    _logCtrl.dispose();
    super.dispose();
  }

  void _refrescar() {
    final j = AppScope.of(context).juego;
    if (j != null) {
      // La historia va PRIMERO: es la que decide si hay un cómic abierto, y
      // los avisos necesitan saberlo para no dibujarse detrás de él.
      _revisarHistoria(j);
      _revisarAvisos(j);
    }
    _programarAuto(j);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logCtrl.hasClients) {
        _logCtrl.animateTo(
          _logCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    final j = app.juego;

    // El cómic de apertura abre CADA partida, no sólo la primera: es la
    // premisa del juego y dura diez segundos. El botón Saltar lo corta entero.
    if (!_introMostrada) {
      return ComicView(
        tema: app.tema,
        textos: app.textos,
        ui: t,
        secuencia: Secuencia.intro,
        textoFinal: t('juego.empezar'),
        onTerminar: () {
          app.marcarIntroVista();
          setState(() => _introMostrada = true);
          if (app.juego == null) app.nuevaPartida();
        },
      );
    }

    if (app.introVista && !app.tutorialVisto) {
      return TutorialScreen(
        onTerminar: () async {
          await app.marcarTutorialVisto();
          if (context.mounted) setState(() {});
        },
      );
    }

    if (j == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(kPapel, BlendMode.multiply),
                child: ImagenUi(
                  asset: logo,
                  fit: BoxFit.contain,
                  respaldo: (_) => const Icon(
                    Icons.sports_martial_arts,
                    size: 88,
                    color: kMaderaOscura,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              app.textos.nombre,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(app.textos.bajada, style: const TextStyle(color: kTintaSuave)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _reiniciarSeguimiento();
                app.nuevaPartida();
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(t('juego.empezar')),
            ),
          ],
        ),
      );
    }

    // Interludio o final: tapa la mesa hasta que el jugador siga.
    if (_comic != null) {
      return ComicView(
        tema: app.tema,
        textos: app.textos,
        ui: t,
        secuencia: _comic!,
        textoFinal: switch (_comic!) {
          Secuencia.victoria || Secuencia.derrota => t('comic.verResumen'),
          Secuencia.jefes => t('comic.enfrentar'),
          _ => t('comic.seguir'),
        },
        onTerminar: () async {
          // La publicidad de los cambios de fase va acá: después del cómic del
          // interludio y antes de devolver la mesa. Es el corte de capítulo, y
          // el jugador acaba de tocar «seguir» por su cuenta.
          //
          // Todo lo que sigue queda detrás del `await` a propósito: el
          // deslizamiento del paisaje y la carta de Cansancio que esperaba
          // tienen que pasar con la mesa a la vista, no tapadas por el aviso.
          // `mostrarEnFase` no muestra nada y vuelve enseguida si el jugador
          // compró el juego, si no hay aviso cargado o si el SDK falla.
          _auto?.cancel();
          if (!app.premium) {
            setState(() => _adEnPantalla = true);
            await app.anuncios.mostrarEnFase(j.fase);
            if (!mounted) return;
            _adEnPantalla = false;
          }

          setState(() => _comic = null);
          // Acá arranca el deslizamiento del paisaje, ya con la mesa a la
          // vista, y al terminar `onTransicion` cambia la música.
          final transiciona = app.faseEscenica != j.fase;
          if (transiciona) {
            app.faseEscenica = j.fase;
            app.tocar();
          }
          // El Cansancio que entró con el cambio de fase se muestra recién
          // ahora, y detrás del paisaje: dos cosas moviéndose a la vez no se
          // leen, y la carta es justamente lo que hay que leer.
          final pendiente = _cansancioPendiente;
          if (pendiente != null) {
            _avisoTimer?.cancel();
            _avisoTimer = Timer(
              transiciona ? kTransicionPaisaje : Duration.zero,
              () {
                if (mounted) setState(() => _revelarCansancio(pendiente));
              },
            );
          }
        },
      );
    }

    return Builder(
      builder: (context) {
        // La mesa se queda con TODO el alto que sobra: es lo único que el
        // jugador necesita mirar. Todo lo demás vive en el menú.
        final pantalla = Column(
          children: [
            _Barra(
              juego: j,
              tema: app.tema,
              textos: app.textos,
              t: t,
              onMenu: () => _abrirMenu(context, app, j, t),
            ),
            Expanded(
              child: _Mesa(juego: j, app: app, onCambio: _refrescar),
            ),
          ],
        );

        // Los dos avisos van SOBRE la mesa y no la bloquean: el barajado y el
        // Cansancio pasan solos, sin que el jugador toque nada, y hasta ahora
        // sólo quedaban anotados en la bitácora.
        final conAvisos = Stack(
          children: [
            pantalla,
            if (_avisoBaraja)
              _AvisoMesa(
                icono: Icons.shuffle,
                color: kMaderaOscura,
                titulo: t('juego.barajando'),
                detalle: t('juego.barajandoSub'),
              ),
            if (_cansancioRevelado != null)
              _RevelacionCansancio(
                carta: _cansancioRevelado!,
                t: t,
                duracion: _esperaCansancio,
              ),
          ],
        );

        // Semana completada: la celebración tapa todo una sola vez.
        // Las celebraciones son una COLA, no un if: al ganar la última
        // partida de la semana pueden dispararse la de racha y varios logros
        // a la vez, y encimarlas se vería como un parpadeo.
        if (app.semanaCompletadaReciente && !_celebracionVista) {
          return Stack(
            children: [
              conAvisos,
              CelebracionLogro(
                titulo: t('progreso.logroTitulo'),
                subtitulo: t('progreso.logroSub'),
                textoBoton: t('comic.seguir'),
                onCerrar: () => setState(() => _celebracionVista = true),
              ),
            ],
          );
        }
        if (app.colaCelebracion.isNotEmpty) {
          final l = app.colaCelebracion.first;
          return Stack(
            children: [
              conAvisos,
              CelebracionLogro(
                titulo: t(l.claveTitulo),
                subtitulo: t(l.claveDesc),
                textoBoton: t('comic.seguir'),
                onCerrar: () => setState(() => app.colaCelebracion.removeAt(0)),
              ),
            ],
          );
        }
        return conAvisos;
      },
    );
  }
}

/// Cartel corto que baja sobre la mesa, avisa algo que pasó solo, y se va.
///
/// No bloquea: se puede seguir jugando mientras está en pantalla. Lo que
/// avisa es informativo, no una decisión.
class _AvisoMesa extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String detalle;

  const _AvisoMesa({
    required this.icono,
    required this.color,
    required this.titulo,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            builder: (_, v, hijo) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, -26 * (1 - v)),
                child: hijo,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 54),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: kPapelClaro,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color, width: 2),
                boxShadow: sombraPapel(y: 4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icono, size: 22, color: color),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontFamily: fuenteTitulo,
                          fontSize: 17,
                          color: kTinta,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        detalle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: kTintaSuave,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// La carta de Cansancio que acaba de entrar, mostrada de verdad.
///
/// Se sortea al azar entre diez, así que un cartel de texto no alcanza: el
/// jugador tiene que VER cuál le tocó, porque de eso depende cuánto le va a
/// molestar cuando la robe. La carta entra girando desde el costado y se
/// desvanece sola.
class _RevelacionCansancio extends StatelessWidget {
  final CartaCombate carta;
  final TextosUi t;
  final Duration duracion;

  const _RevelacionCansancio({
    required this.carta,
    required this.t,
    required this.duracion,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(carta.uid),
          tween: Tween(begin: 0, end: 1),
          duration: duracion,
          builder: (_, v, hijo) {
            // Entra rápido y se va rápido: casi todo el tiempo es de lectura.
            final entrada = Curves.easeOutBack.transform(
              (v / .09).clamp(0.0, 1.0),
            );
            final salida = ((v - .88) / .12).clamp(0.0, 1.0);
            return Opacity(
              opacity: (entrada * (1 - salida)).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, -34 * salida),
                child: Transform.rotate(
                  angle: (1 - entrada) * .35,
                  child: Transform.scale(scale: .6 + .4 * entrada, child: hijo),
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kRojo,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: sombraPapel(y: 3),
                ),
                child: Text(
                  t('juego.cansancioEntra').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .6,
                    color: kPapelClaro,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CartaView(id: carta.id, respaldo: carta, ancho: 168),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kPapelClaro,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kMaderaOscura, width: 1.5),
                ),
                child: Text(
                  t('juego.cansancioSub'),
                  style: const TextStyle(fontSize: 11.5, color: kTinta),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// La barra de la partida: los tres datos que cambian tu decisión en el turno,
/// y un único botón de menú.
///
/// Antes eran seis píldoras que había que deslizar. Mazo, descarte y
/// eliminadas se miran una vez cada tanto, no en cada turno: viven en el menú.
class _Barra extends StatefulWidget {
  final Juego juego;
  final Tema tema;
  final TextosTema textos;
  final TextosUi t;
  final VoidCallback onMenu;

  const _Barra({
    required this.juego,
    required this.tema,
    required this.textos,
    required this.t,
    required this.onMenu,
  });

  @override
  State<_Barra> createState() => _BarraState();
}

class _BarraState extends State<_Barra> {
  /// Cuánto cambió la Energía en el último movimiento, para mostrarlo.
  int? _delta;
  int _energiaVista = 0;
  int _serie = 0;

  @override
  void initState() {
    super.initState();
    _energiaVista = widget.juego.energia;
  }

  @override
  void didUpdateWidget(_Barra viejo) {
    super.didUpdateWidget(viejo);
    final ahora = widget.juego.energia;
    if (ahora != _energiaVista) {
      // La Energía es lo único que puede terminar la partida: cada cambio
      // tiene que verse, no deducirse comparando un número contra el que
      // había antes.
      //
      // Salvo cuando la carta que acaba de caer ya lo está diciendo con su
      // propia burbuja: dos globos con el mismo "-1" a la vez se leen como si
      // te lo hubieran cobrado dos veces. Ahí la barra sólo cambia el número.
      final cambio = ahora - _energiaVista;
      setState(() {
        _delta = _loDiceLaCarta(cambio) ? null : cambio;
        _energiaVista = ahora;
        _serie++;
      });
    }
  }

  /// ¿La chispa sobre la última carta de la mesa ya explica este cambio?
  ///
  /// El coste del robo pagado y el daño del peligro no tienen carta que los
  /// explique, así que ésos siguen saliendo en la barra.
  bool _loDiceLaCarta(int cambio) {
    final mesa = widget.juego.mesa;
    if (mesa.isEmpty || cambio == 0) return false;
    if (mesa.last.efecto.energiaAlJugar == 0) return false;
    return widget.juego.ultimoDeltaEnergia == cambio;
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.juego;
    final energiaColor = j.energia <= 5
        ? kRojo
        : (j.energia <= 10 ? kNaranja : kAlba);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 4),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Pastilla(
                  '${j.energia}',
                  icono: Icons.bolt,
                  color: energiaColor,
                ),
                if (_delta != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: IgnorePointer(
                      child: _Delta(key: ValueKey(_serie), delta: _delta!),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            // La única flexible de la fila: es la que crece con el texto. En
            // Jefes pasa de 'Ocaso' a 'Enfrentamiento Final' justo cuando la
            // pastilla de al lado también se ensancha, y la barra desbordaba.
            Flexible(
              child: Pastilla(
                widget.textos.nombreFase[j.fase] ?? j.fase.nombre,
                icono: Icons.wb_twilight,
                color: colorFaseDe(widget.tema, j.fase),
                compacta: true,
              ),
            ),
            const SizedBox(width: 8),
            if (j.fase == Fase.jefes)
              Pastilla(
                '${j.jefeActual + 1}/${j.jefes.length}',
                icono: Icons.local_fire_department,
                color: kJefe,
                compacta: true,
              )
            else
              Pastilla(
                '${j.peligrosRestantesFase}',
                icono: Icons.warning_amber,
                compacta: true,
              ),
            const SizedBox(width: 8),
            // Cuántas cartas quedan antes de rebarajar. Es el dato que decide
            // si conviene pagar un robo ahora o esperar a que el mazo se
            // renueve: hasta ahora estaba enterrado en el menú.
            Pastilla(
              '${j.mazo.length}',
              icono: Icons.style,
              compacta: true,
              color: j.mazo.isEmpty ? kNaranja : kTinta,
            ),
            const Spacer(),
            BotonPulsable(
              onTap: widget.onMenu,
              escala: .90,
              resalte: BorderRadius.circular(10),
              child: const SizedBox(
                width: 46,
                height: 44,
                child: Icon(Icons.menu, size: 24, color: kTinta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// El número que sube y se desvanece cuando cambia la Energía.
///
/// Se dispara por cambio de key, así que cada movimiento arranca su propia
/// animación sin que nadie tenga que apagarla.
class _Delta extends StatefulWidget {
  final int delta;
  const _Delta({super.key, required this.delta});

  @override
  State<_Delta> createState() => _DeltaState();
}

class _DeltaState extends State<_Delta> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sube = widget.delta > 0;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Opacity(
          opacity: (1 - t * t).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -26 * Curves.easeOut.transform(t)),
            child: Center(
              child: Text(
                '${sube ? '+' : ''}${widget.delta}',
                style: TextStyle(
                  fontFamily: fuenteTitulo,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: sube ? kAlba : kRojo,
                  shadows: [
                    Shadow(color: kPapel, blurRadius: 4),
                    Shadow(color: kPapel, blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Una línea del menú de partida.
class _OpcionMenu extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  const _OpcionMenu({
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BotonPulsable(
      onTap: onTap,
      escala: .97,
      resalte: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Icon(icono, size: 21, color: kTinta),
            const SizedBox(width: 14),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: kTinta,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mesa extends StatelessWidget {
  final Juego juego;
  final AppState app;
  final VoidCallback onCambio;
  const _Mesa({required this.juego, required this.app, required this.onCambio});

  @override
  Widget build(BuildContext context) {
    final j = juego;
    final t = TextosUi.de(app.idioma);

    if (j.terminado) {
      final gano = j.estado == EstadoJuego.victoria;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconoJuego(
                asset: gano ? iconoVictoria : iconoDerrota,
                respaldoIcono: gano
                    ? Icons.emoji_events
                    : Icons.sentiment_very_dissatisfied,
                tamano: 84,
                colorRespaldo: gano ? kOroBorde : kOcaso,
              ),
              const SizedBox(height: 12),
              Text(
                gano ? t('juego.ganaste') : t('juego.perdiste'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                gano
                    ? t('juego.finGano')
                    : fmt(t('juego.finPerdio'), {
                        'fase': j.fase.nombre,
                        'n': j.energia,
                      }),
                style: const TextStyle(color: kTintaSuave),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  Etiqueta(fmt(t('juego.turnos'), {'n': j.turnos})),
                  Etiqueta(
                    fmt(t('juego.resGanados'), {'n': j.combatesGanados}),
                    color: kAlba,
                  ),
                  Etiqueta(
                    fmt(t('juego.resPerdidos'), {'n': j.combatesPerdidos}),
                    color: kOcaso,
                  ),
                  Etiqueta(
                    fmt(t('juego.resEliminadas'), {'n': j.cartasEliminadas}),
                  ),
                  Etiqueta(
                    fmt(t('juego.resEnergiaRobos'), {
                      'n': j.energiaGastadaEnRobos,
                    }),
                  ),
                  if (j.cansancioAgregado > 0)
                    Etiqueta(
                      fmt(t('juego.resCansancio'), {'n': j.cansancioAgregado}),
                      color: kOcaso,
                    ),
                ],
              ),
              if (app.encargoActivo != null) ...[
                const SizedBox(height: 18),
                _ResultadoEncargo(
                  encargo: app.encargoActivo!,
                  textos: app.textos,
                  juego: j,
                  ui: t,
                ),
              ],
              if (gano) ...[
                const SizedBox(height: 18),
                Etiqueta(
                  app.semanaCompletadaReciente
                      ? t('juego.semanaCompleta')
                      : fmt(t('juego.diaMarcado'), {
                          'a': app.progreso.racha,
                          'b': 7,
                        }),
                  icono: app.semanaCompletadaReciente
                      ? Icons.emoji_events
                      : Icons.local_fire_department,
                  color: app.semanaCompletadaReciente ? kJefe : kMediodia,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Tres zonas fijas, sin scroll en el camino principal: la carta manda y
    // ocupa todo lo que sobra, la franja de combate resume en tres líneas, y
    // las acciones quedan siempre al alcance del pulgar.
    return Column(
      children: [
        _FranjaEncargo(app: app, t: t),
        Expanded(child: _zonaCarta(context, j)),
        _franjaInferior(context, j),
      ],
    );
  }

  /// La carta del peligro, lo más grande que entre, y debajo lo que jugaste.
  Widget _zonaCarta(BuildContext context, Juego j) {
    final t = TextosUi.de(app.idioma);
    final p = j.peligro;
    final color = colorFase(j.fase);
    final hayMesa = j.mesa.isNotEmpty;

    if (p == null || j.estado == EstadoJuego.esperandoPeligro) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.style, color: color.withValues(alpha: .55), size: 64),
              const SizedBox(height: 18),
              Text(
                j.fase == Fase.jefes
                    ? fmt(t('juego.teEspera'), {
                        'n': j.jefeEnCurso?.nombre ?? '—',
                      })
                    : fmt(t('juego.sinPeligro'), {'fase': j.fase.nombre}),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, cs) {
        // Lo que queda para la carta después de reservar la tira de cartas
        // jugadas. Manda el alto: una carta recortada no sirve de nada.
        // Un jefe es apaisado: lo limita el ancho, no el alto. Se lo deja
        // crecer todo lo que pueda —es el momento más importante de la
        // partida— y el alto que sobra se lo lleva la pila, que en un
        // enfrentamiento final tiene muchas más cartas que en un turno normal.
        final ratio = ratioCarta(p.id);
        var ancho = math.min(cs.maxWidth - 16, ratio > 1 ? 560.0 : 360.0);
        var alto = ancho / ratio;
        final minTira = hayMesa ? 150.0 : 0.0;
        if (alto + minTira + 12 > cs.maxHeight) {
          alto = cs.maxHeight - minTira - 12;
          ancho = alto * ratio;
        }
        final altoTira = hayMesa ? cs.maxHeight - alto - 12 : 0.0;

        return Column(
          children: [
            Expanded(
              child: Center(
                // La carta nueva entra con un fundido y una escala corta: es
                // lo que hace que revelar un peligro se sienta como dar vuelta
                // una carta y no como refrescar una pantalla.
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  // Las dos cartas se superponen en el mismo lugar: sin esto
                  // el switcher las acomoda una al lado de la otra a mitad de
                  // la transición y la carta salta.
                  layoutBuilder: (actual, previas) => Stack(
                    alignment: Alignment.center,
                    children: [...previas, ?actual],
                  ),
                  transitionBuilder: (hijo, anim) => AnimatedBuilder(
                    animation: anim,
                    builder: (_, _) {
                      // Giro sobre el eje vertical: la que sale se va de
                      // canto, la que entra llega de canto. Es literalmente
                      // el gesto de dar vuelta la carta sobre la mesa.
                      final v = anim.value;
                      final e = 0.94 + 0.06 * v;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0012)
                          ..rotateY((1 - v) * math.pi / 2)
                          ..scaleByDouble(e, e, 1, 1),
                        child: Opacity(
                          opacity: v.clamp(0.0, 1.0),
                          child: RepaintBoundary(child: hijo),
                        ),
                      );
                    },
                  ),
                  child: SizedBox(
                    key: ValueKey(p.id),
                    width: ancho,
                    height: alto,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CartaView(
                            id: p.id,
                            ancho: ancho,
                            onTap: () => mostrarCarta(context, id: p.id),
                          ),
                        ),
                        // Resuelto el combate, la carta se enciende del color
                        // del resultado y quedan las partículas.
                        if (j.estado == EstadoJuego.postCombate) ...[
                          Positioned.fill(
                            child: HaloCarta(gano: j.ultimoCombateGanado),
                          ),
                          Positioned.fill(
                            child: Fogonazo(
                              // La key cambia con cada combate resuelto, y por
                              // eso la animación corre una sola vez.
                              key: ValueKey(
                                j.combatesGanados + j.combatesPerdidos,
                              ),
                              gano: j.ultimoCombateGanado,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (hayMesa)
              SizedBox(
                height: altoTira,
                child: Stack(
                  children: [
                    Positioned.fill(child: _PilaMesa(juego: j)),
                    // La suma va acá y no en una franja: es el dato que mirás
                    // junto a las cartas, no aparte de ellas.
                    Positioned(left: 10, top: 6, child: _Insignia(juego: j)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  /// Franja de combate más acciones. Es la única parte fija de abajo.
  Widget _franjaInferior(BuildContext context, Juego j) {
    final enMeditacion = j.estado == EstadoJuego.postCombate;

    // El SafeArea NO envuelve al panel: envuelve a su CONTENIDO. Así el
    // hueco del indicador de inicio queda transparente y el paisaje sigue
    // hasta el borde de la pantalla, en vez de cortarse contra un bloque de
    // papel opaco que ocupaba media pulgada de nada.
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Velado, no opaco: el paisaje sigue viéndose DETRÁS de los botones,
        // que traen su propia placa de madera y se leen igual.
        //
        // En meditación sube casi a opaco porque ahí abajo hay una lista de
        // cartas con nombres y números, y eso sí necesita fondo.
        color: kPapelClaro.withValues(alpha: enMeditacion ? .93 : .52),
        border: const Border(
          top: BorderSide(color: kMaderaOscura, width: 2),
          bottom: BorderSide(color: kMaderaOscura, width: 2),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (enMeditacion)
              ConstrainedBox(
                // La meditación puede ser larga: se le da un techo y adentro
                // scrollea, en vez de empujar las acciones fuera de pantalla.
                constraints: const BoxConstraints(maxHeight: 250),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: j.puedeMeditar
                      ? _meditacion(context, j)
                      : _sinMeditacion(j),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: _acciones(context, j),
            ),
          ],
        ),
      ),
    );
  }

  /// Los botones del turno. Dicen sólo el verbo: las consecuencias están
  /// impresas en la carta que el jugador tiene delante.
  Widget _acciones(BuildContext context, Juego j) {
    final t = TextosUi.de(app.idioma);

    // Más altos que el default de `BotonMadera`: son los botones que se
    // aprietan cien veces por partida y con el pulgar. La letra escala sola
    // desde el alto, así que crecen sin que haya que tocar nada más.
    Widget boton(
      String texto,
      IconData icono,
      VoidCallback? onTap, {
      bool principal = false,
    }) => Expanded(
      child: BotonMadera(
        texto: texto,
        icono: icono,
        principal: principal,
        alto: principal ? 68 : 62,
        onTap: onTap,
      ),
    );

    switch (j.estado) {
      case EstadoJuego.esperandoPeligro:
        return Row(
          children: [
            boton(
              j.fase == Fase.jefes
                  ? t('juego.enfrentarJefe')
                  : t('juego.revelar'),
              Icons.visibility,
              () {
                app.audio.sonar(Sfx.dia);
                j.revelarPeligro();
                onCambio();
              },
              principal: true,
            ),
          ],
        );

      case EstadoJuego.enCombate:
        final gana = j.sumaMesa >= j.poderPeligroEfectivo;
        return Row(
          children: [
            boton(
              j.puedeRobarGratis
                  ? t('juego.robarGratis')
                  : fmt(t('juego.robarPago'), {'n': j.cfg.costeRoboExtra}),
              Icons.add_card,
              // Alcanzado el poder del peligro no se roba más: no hay nada
              // que ganar y sí Energía que perder. Es lo mismo que hace el
              // bot que mide el balance, así que los números no se mueven.
              (j.puedeRobar && !gana)
                  ? () {
                      app.audio.sonar(Sfx.robar);
                      j.robar();
                      onCambio();
                    }
                  : null,
            ),
            const SizedBox(width: 10),
            boton(
              gana ? t('juego.resolverGanas') : t('juego.rendirse'),
              gana ? Icons.emoji_events : Icons.flag,
              () async {
                // Rendirse cuesta Energía y no tiene vuelta atrás, y el botón
                // vive donde el pulgar ya estaba apretando «Robar»: un toque
                // de más y perdías el combate sin haberlo decidido. Se
                // confirma. Resolver ganando no pregunta nada: es la jugada
                // que el jugador vino a hacer y no hay nada que lamentar.
                if (!gana) {
                  final ok = await _confirmarRendirse(context, j);
                  if (!ok) return;
                  // El diálogo pudo haber sobrevivido a la partida.
                  if (!context.mounted) return;
                }
                // El sonido se elige antes de resolver: después el peligro ya
                // no está.
                app.audio.sonar(gana ? Sfx.ganar : Sfx.perder);
                j.resolver();
                onCambio();
              },
              principal: gana,
            ),
          ],
        );

      case EstadoJuego.postCombate:
        // Sin nada que decidir, la partida sigue sola cuando termina la
        // animación: pedir "Continuar" para nada es un toque de peaje.
        if (!j.puedeMeditar) {
          return _EsperaAuto(
            key: ValueKey(j.combatesGanados + j.combatesPerdidos),
            gano: j.ultimoCombateGanado,
          );
        }
        return Row(
          children: [
            boton(t('juego.continuarPeligro'), Icons.arrow_forward, () {
              j.continuar();
              onCambio();
            }, principal: true),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  /// Explica por qué no se puede meditar ahora (si no, el panel desaparece sin motivo).
  Widget _sinMeditacion(Juego j) {
    final t = TextosUi.de(app.idioma);
    final motivo = j.cfg.meditarSoloAlPerder && j.ultimoCombateGanado
        ? t('medita.motivoGano')
        : j.descarte.isEmpty
        ? t('medita.motivoVacio')
        : fmt(t('medita.motivoEnergia'), {'n': j.cfg.costeMeditar});

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMadera.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.self_improvement, color: kTintaSuave, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fmt(t('medita.noAhora'), {'motivo': motivo}),
              style: const TextStyle(fontSize: 12.5, color: kTintaSuave),
            ),
          ),
        ],
      ),
    );
  }

  /// Meditar saca la carta del juego para siempre. Un toque perdido sobre la
  /// carta equivocada no tiene vuelta atrás, así que se confirma.
  Future<bool> _confirmarEliminar(BuildContext context, CartaCombate c) async {
    final t = TextosUi.de(app.idioma);
    return confirmar(
      context,
      titulo: fmt(t('medita.confirmar'), {'carta': c.nombre}),
      detalle: t('medita.confirmarSub'),
      textoNo: t('ajustes.cancelar'),
      textoSi: t('medita.eliminar'),
    );
  }

  /// Rendirse es la única jugada del combate que resta Energía sin devolver
  /// nada, y el botón comparte fila con el de robar. Se confirma diciendo el
  /// número exacto que se va a perder, que es el dato que hace dudar.
  Future<bool> _confirmarRendirse(BuildContext context, Juego j) async {
    final t = TextosUi.de(app.idioma);
    final dano = j.peligro?.dano ?? 0;
    return confirmar(
      context,
      titulo: t('juego.rendirseConfirmar'),
      detalle: fmt(t('juego.rendirseConfirmarSub'), {'n': dano}),
      textoNo: t('juego.rendirseSeguir'),
      textoSi: t('juego.rendirse'),
    );
  }

  Widget _meditacion(BuildContext context, Juego j) {
    final t = TextosUi.de(app.idioma);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kOroBorde.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.self_improvement, color: kOroBorde, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fmt(t('medita.explica'), {
                    'coste': j.cfg.costeMeditar,
                    'cartas': j.cfg.cartasPorMeditacion,
                    'n': j.descarte.length,
                  }),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in j.descarte)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CartaView(
                      id: c.id,
                      respaldo: c,
                      ancho: 104,
                      // Eliminar es para siempre: se pregunta antes.
                      onTap: () async {
                        if (!await _confirmarEliminar(context, c)) return;
                        app.audio.sonar(Sfx.meditar);
                        j.meditar(c);
                        onCambio();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Log extends StatelessWidget {
  final Juego juego;
  final ScrollController ctrl;
  final TextosUi ui;
  const _Log({required this.juego, required this.ctrl, required this.ui});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Text(
            ui('juego.diario'),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: ctrl,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: juego.log.length,
            itemBuilder: (_, i) {
              final e = juego.log[i];
              final color = switch (e.tipo) {
                'bien' => kAlba,
                'mal' => kRojo,
                'fase' => kMaderaOscura,
                _ => kTintaSuave,
              };
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  e.texto,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: color,
                    fontWeight: e.tipo == 'fase'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Si el encargo del día se cumplió, en la pantalla de resumen.
class _ResultadoEncargo extends StatelessWidget {
  final Encargo encargo;
  final TextosTema textos;
  final Juego juego;
  final TextosUi ui;
  const _ResultadoEncargo({
    required this.encargo,
    required this.textos,
    required this.juego,
    required this.ui,
  });

  @override
  Widget build(BuildContext context) {
    final t = textos.encargos[encargo.id]!;
    final ok = encargo.cumplido(juego);
    final color = ok ? kAlba : kOcaso;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.cancel,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                fmt(ui('encargo.titulo'), {'t': t.titulo}),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            ok
                ? fmt(ui('encargo.cumplido'), {'r': t.recompensa})
                : ui('encargo.fallado'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: kTintaSuave),
          ),
        ],
      ),
    );
  }
}

/// Las cartas que jugaste, apiladas en abanico.
///
/// Antes era una tira de miniaturas de 38 px donde no se distinguía nada. Las
/// cartas que jugás pesan casi tanto como el peligro que enfrentás: se ven
/// grandes, superpuestas y un poco desprolijas, como quedan en una mesa real.
class _PilaMesa extends StatelessWidget {
  final Juego juego;
  const _PilaMesa({required this.juego});

  /// Desorden estable: derivado del uid de la carta, no del azar. Si fuera
  /// aleatorio, la pila entera se reacomodaría en cada rebuild.
  static double _sesgo(String uid, int sal) {
    var h = sal;
    for (final c in uid.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return (h % 1000) / 1000 * 2 - 1; // -1 .. 1
  }

  @override
  Widget build(BuildContext context) {
    final cartas = juego.mesa;
    if (cartas.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, cs) {
        // Con un jefe en pantalla la banda es mucho más alta: las cartas
        // aprovechan ese espacio en vez de quedar chicas en el medio.
        final anchoCarta = ((cs.maxHeight - 14) * kRatioCarta).clamp(
          58.0,
          124.0,
        );
        final altoCarta = anchoCarta / kRatioCarta;
        final disponible = cs.maxWidth - 24;

        // El paso se achica para que entren todas, hasta superponerlas casi
        // del todo: es preferible ver un borde de cada una que perder alguna.
        final paso = cartas.length < 2
            ? 0.0
            : math.min(
                anchoCarta * .58,
                (disponible - anchoCarta) / (cartas.length - 1),
              );
        final anchoTotal = anchoCarta + paso * (cartas.length - 1);
        final izquierda = (cs.maxWidth - anchoTotal) / 2;
        final arriba = (cs.maxHeight - altoCarta) / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (i, c) in cartas.indexed)
              Positioned(
                left: izquierda + paso * i,
                top: arriba + _sesgo(c.uid, 7) * 7,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(c.uid),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  builder: (_, v, hijo) => Opacity(
                    opacity: v.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 22 * (1 - v)),
                      child: Transform.rotate(
                        angle: _sesgo(c.uid, 13) * .09 * v,
                        // La carta pinta imagen, borde y sombra: sin esto
                        // Impeller se queja en cada frame de la entrada.
                        child: RepaintBoundary(child: hijo),
                      ),
                    ),
                  ),
                  child: CartaView(
                    id: c.id,
                    respaldo: c,
                    ancho: anchoCarta,
                    onTap: () => mostrarCarta(context, id: c.id, respaldo: c),
                  ),
                ),
              ),
            // El efecto de Energía se aplica EN EL MOMENTO en que la carta
            // cae, pero el número sube allá arriba en la barra y se pasaba
            // por alto. El aviso sale de la carta que lo causó.
            //
            // Sólo la última: es la que acaba de entrar. `energiaSiGanas` no
            // va acá a propósito, porque todavía no pasó nada.
            //
            // El número es el que la carta movió DE VERDAD, no el que dice su
            // efecto: con la Energía al tope una carta de +3 mueve 0, y la
            // burbuja decía +3 mientras el marcador no se inmutaba.
            if (cartas.last.efecto.energiaAlJugar != 0 &&
                juego.ultimoDeltaEnergia != 0)
              Positioned(
                left: izquierda + paso * (cartas.length - 1),
                top: arriba,
                width: anchoCarta,
                child: IgnorePointer(
                  child: _ChispaEnergia(
                    key: ValueKey(cartas.last.uid),
                    delta: juego.ultimoDeltaEnergia,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// El encargo del día en dos renglones finitos, arriba de todo. El panel
/// grande que había antes empujaba la carta media pantalla para abajo.
///
/// Lleva el premio y no sólo el título: "Nada de meditar" dice qué hacer pero
/// no por qué conviene, y sin el para qué el modo entero parece decorativo.
/// Arriba, si corresponde, la línea que avisa que el encargo de la partida
/// anterior ya se cobró: era el único eslabón de la cadena que no se veía
/// nunca, y sin él el beneficio llegaba sin que nadie se enterara.
class _FranjaEncargo extends StatelessWidget {
  final AppState app;
  final TextosUi t;
  const _FranjaEncargo({required this.app, required this.t});

  @override
  Widget build(BuildContext context) {
    final e = app.encargoActivo;
    if (e == null) return const SizedBox.shrink();
    final texto = app.textos.encargos[e.id];
    if (texto == null) return const SizedBox.shrink();
    final cobrado = app.beneficioAplicado;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cobrado != null)
          Container(
            width: double.infinity,
            color: kVerde.withValues(alpha: .22),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard, size: 14, color: kVerde),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fmt(t('encargo.beneficio'), {'b': cobrado}),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: kVerde,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          width: double.infinity,
          color: kOro.withValues(alpha: .22),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 15,
                  color: kOroBorde,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texto.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kMaderaOscura,
                      ),
                    ),
                    Text(
                      fmt(t('modos.encargoPremio'), {'r': texto.recompensa}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: kMaderaOscura,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tu suma contra el poder del peligro, pegada a la pila.
///
/// Reemplaza a la franja de resumen entera: el daño y las cartas gratis
/// totales ya están impresos en la carta del peligro, y repetirlos abajo era
/// contarle al jugador algo que tiene delante de los ojos.
class _Insignia extends StatelessWidget {
  final Juego juego;
  const _Insignia({required this.juego});

  @override
  Widget build(BuildContext context) {
    final objetivo = juego.poderPeligroEfectivo;
    final gana = juego.sumaMesa >= objetivo;
    final color = gana ? kAlba : kMaderaOscura;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPapelClaro,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
            boxShadow: sombraPapel(y: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${juego.sumaMesa}',
                style: TextStyle(
                  fontFamily: fuenteTitulo,
                  fontSize: gana ? 26 : 22,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              // Con la suma alcanzada el objetivo deja de importar.
              if (!gana)
                Text(
                  'de $objetivo',
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.2,
                    color: kTintaSuave,
                  ),
                ),
            ],
          ),
        ),
        // Lo único que la carta no puede saber: cuántos robos gratis quedan.
        if (!juego.cfg.robosGratisIlimitados &&
            juego.estado == EstadoJuego.enCombate &&
            juego.gratisRestantes > 0) ...[
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Pastilla(
              '${juego.gratisRestantes}',
              icono: Icons.card_giftcard,
              compacta: true,
            ),
          ),
        ],
      ],
    );
  }
}

/// Ocupa el lugar de las acciones mientras la partida avanza sola.
///
/// Sin esto la franja de abajo se vacía por un segundo y la pantalla salta.
/// La barra además explica por qué nadie tiene que tocar nada.
class _EsperaAuto extends StatelessWidget {
  final bool gano;
  const _EsperaAuto({super.key, required this.gano});

  @override
  Widget build(BuildContext context) {
    final color = gano ? kAlba : kOcaso;
    return SizedBox(
      height: 52,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1250),
          curve: Curves.easeInOut,
          builder: (_, v, _) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: kMadera.withValues(alpha: .28),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// El "+2" que sale de la carta recién jugada y sube.
///
/// Hermano de `_Delta`, que hace lo mismo en la barra de Energía. Los dos
/// juntos no son redundancia: uno dice CUÁNTO tenés ahora y el otro POR QUÉ.
class _ChispaEnergia extends StatelessWidget {
  final int delta;
  const _ChispaEnergia({super.key, required this.delta});

  @override
  Widget build(BuildContext context) {
    final sube = delta > 0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      builder: (_, v, hijo) {
        final entrada = Curves.easeOutBack.transform((v / .25).clamp(0.0, 1.0));
        final salida = ((v - .6) / .4).clamp(0.0, 1.0);
        return Opacity(
          opacity: (entrada * (1 - salida)).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -14 - 30 * salida),
            child: Transform.scale(scale: .7 + .3 * entrada, child: hijo),
          ),
        );
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: sube ? kAlba : kRojo,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPapelClaro, width: 2),
            boxShadow: sombraPapel(y: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, size: 14, color: kPapelClaro),
              const SizedBox(width: 2),
              Text(
                '${sube ? '+' : ''}$delta',
                style: const TextStyle(
                  fontFamily: fuenteTitulo,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: kPapelClaro,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
