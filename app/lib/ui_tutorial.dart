import 'dart:math';

import 'package:flutter/material.dart';
import 'ui_kit.dart';

import 'app_state.dart';
import 'engine.dart';
import 'l10n.dart';
import 'tutorial.dart';

import 'ui_carta.dart';
import 'ui_common.dart';

/// El aire que el botón de Saltar suma alrededor de su texto: el padding del
/// `TextButton` más el hueco que lo separa del contador. Se usa para saber si
/// el título entra sin tener que medirlo después de dibujarlo.
const _kBotonSaltarAire = 44.0;

/// Cuánto mide ese texto en una sola línea.
double _anchoDe(String texto, TextStyle estilo) {
  final tp = TextPainter(
    text: TextSpan(text: texto, style: estilo),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
  final ancho = tp.width;
  tp.dispose();
  return ancho;
}

/// Tutorial: una partida real con mazo trucado y un overlay que explica.
///
/// Usa el mismo `Juego` que el juego de verdad (`barajar: false`), así que lo
/// que el jugador aprende acá es exactamente lo que le va a pasar después.
///
/// Los pasos que hablan de la carta oscurecen la pantalla y dejan un recorte
/// sobre la región exacta de la imagen (ver `tutorial_zonas.dart`).
class TutorialScreen extends StatefulWidget {
  final VoidCallback onTerminar;
  const TutorialScreen({super.key, required this.onTerminar});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  Juego? _j;
  Juego get j => _j!;
  int paso = 0;
  bool accionHecha = false;

  final _claveCarta = GlobalKey();
  final _clavePila = GlobalKey();
  Rect? _rectCarta;

  /// Una llave por cosa que el guion puede señalar, para poder traerla a la
  /// vista. `carta` no está acá: ya tiene `_claveCarta`, que se usa además
  /// para recortar el velo.
  final _clavesFoco = {
    for (final f in [
      FocoTutorial.energia,
      FocoTutorial.botones,
      FocoTutorial.mesa,
      FocoTutorial.descarte,
    ])
      f: GlobalKey(),
  };

  /// La mesa scrollea y el globo de texto de abajo tapa una parte. Sin esto el
  /// tutorial dice «tocá tal botón» sobre un botón que está fuera de pantalla,
  /// y el jugador tiene que adivinar que hay que scrollear.
  final _scroll = ScrollController();

  /// El paso del último intento de enfoque, y cuántos van.
  ///
  /// El tope es lo que evita pelearle al dedo del jugador: si scrollea a otro
  /// lado, el tutorial no se lo devuelve para siempre. Dos alcanzan porque el
  /// caso real que necesita un segundo intento es uno solo y es el primero:
  /// se trae el botón a la vista mientras la imagen de la carta todavía no
  /// cargó, y cuando carga la carta crece y lo empuja para abajo otra vez.
  int? _pasoEnfocado;
  int _intentosDeFoco = 0;

  /// El latido del resalte. Uno solo para toda la pantalla: lo comparten el
  /// marco de los botones y el del velo recortado.
  late final AnimationController _pulso;

  @override
  void initState() {
    super.initState();
    _pulso = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    // El agujero del velo se calcula en `build`, y el scroll que pide
    // `_enfocar` lo maneja el `Scrollable` con su propio estado: no pasa por
    //acá. Sin este listener el recuadro queda dibujado donde estaba la carta
    // ANTES de moverse, que es lo que se veía en el paso 2.
    _scroll.addListener(_remedirCuandoAsiente);
  }

  @override
  void dispose() {
    _scroll.removeListener(_remedirCuandoAsiente);
    _pulso.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Vuelve a medir la carta en el frame siguiente al que el scroll movió.
  ///
  /// Después y no en el acto: el listener corre mientras la posición se
  /// actualiza, y ahí `localToGlobal` devolvería una transformación que
  /// todavía no se pintó.
  void _remedirCuandoAsiente() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _medirCarta();
    });
  }

  /// Trae a la vista lo que el paso está señalando.
  ///
  /// Se hace después del layout, porque antes el objetivo puede no existir
  /// todavía: la mesa y el descarte son condicionales y aparecen recién cuando
  /// la partida llega a ese punto. Sin contexto no hay nada que traer, y no
  /// pasa nada: el paso siguiente lo intenta de nuevo.
  void _enfocar(FocoTutorial foco) {
    if (_pasoEnfocado != paso) {
      _pasoEnfocado = paso;
      _intentosDeFoco = 0;
    }
    if (_intentosDeFoco >= 2) return;

    final clave = foco == FocoTutorial.carta ? _claveCarta : _clavesFoco[foco];
    final ctx = clave?.currentContext;
    if (ctx == null) return;

    // Mientras algo se esté moviendo no se pide nada: volver a pedirlo en cada
    // frame reiniciaría la animación y el scroll no llegaría nunca.
    if (_scroll.hasClients && _scroll.position.isScrollingNotifier.value) {
      return;
    }
    if (_seVe(ctx)) return;

    _intentosDeFoco++;
    Scrollable.ensureVisible(
      ctx,
      // Alto a propósito: el objetivo queda en el tercio de arriba, que es la
      // parte que el globo de texto del tutorial no tapa.
      alignment: .3,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  // La partida se arma acá y no en initState porque necesita leer AppScope
  // (el tema y el idioma), y un InheritedWidget todavía no está disponible
  // durante initState. La guarda evita rearmarla en cada cambio de
  // dependencias, que reiniciaría el tutorial a mitad de camino.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Esto va ANTES de la salida temprana: el latido hay que sincronizarlo
    // cada vez, la partida se arma una sola vez.
    //
    // Quien pidió menos movimiento en el sistema no quiere un latido eterno:
    // se le deja el resalte encendido y quieto.
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulso.stop();
      _pulso.value = 1;
    } else if (!_pulso.isAnimating) {
      _pulso.repeat(reverse: true);
    }
    if (_j != null) return;
    final app = AppScope.of(context);
    _j = Juego(
      cfg: configTutorial(),
      contenido: contenidoTutorial(app.tema, app.idioma),
      rng: Random(1),
      barajar: false,
      textos: TextosUi.de(app.idioma),
      recurso: app.textos.recurso,
    );
  }

  PasoTutorial get actual => guionTutorial[paso];
  bool get ultimo => paso == guionTutorial.length - 1;
  bool get puedeAvanzar => actual.accion == AccionTutorial.leer || accionHecha;

  /// Mide dónde quedó la carta para poder recortar el velo encima.
  void _medirCarta() {
    final cajaCarta =
        _claveCarta.currentContext?.findRenderObject() as RenderBox?;
    final cajaPila =
        _clavePila.currentContext?.findRenderObject() as RenderBox?;
    if (cajaCarta == null || cajaPila == null) return;

    final origen = cajaPila.globalToLocal(cajaCarta.localToGlobal(Offset.zero));
    final r = origen & cajaCarta.size;
    if (_rectCarta != r) setState(() => _rectCarta = r);
  }

  /// ¿El objetivo entra entero en la parte visible de la mesa?
  ///
  /// La cuenta es la misma que la del velo: se lo pasa a coordenadas de la
  /// pila, que es exactamente el pedazo de pantalla que la mesa ocupa.
  bool _seVe(BuildContext ctx) {
    final caja = ctx.findRenderObject() as RenderBox?;
    final pila = _clavePila.currentContext?.findRenderObject() as RenderBox?;
    if (caja == null || pila == null) return false;
    final r = pila.globalToLocal(caja.localToGlobal(Offset.zero)) & caja.size;
    return r.top >= 0 && r.bottom <= pila.size.height;
  }

  void _avanzar() {
    if (ultimo) {
      widget.onTerminar();
      return;
    }
    setState(() {
      paso++;
      accionHecha = false;
    });
  }

  void _hacer(AccionTutorial a, VoidCallback efecto) {
    if (actual.accion != a) return;
    setState(() {
      efecto();
      accionHecha = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    final foco = actual.foco;

    // Después de cada layout se recalcula por si cambió el tamaño de pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _medirCarta();
      _enfocar(foco);
    });

    final hueco =
        (foco == FocoTutorial.carta &&
            actual.zona != null &&
            _rectCarta != null)
        ? zonaEnPantalla(actual.zona!, _rectCarta!)
        : null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
          child: LayoutBuilder(
            builder: (context, cs) {
              const estiloTitulo = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              );
              const estiloContador = TextStyle(
                color: kTintaSuave,
                fontSize: 13,
              );
              final contador = '${paso + 1}/${guionTutorial.length}';

              // El título se muestra entero o no se muestra.
              //
              // Antes se recortaba con puntos suspensivos, y en alemán a 320 px
              // «So wird gespielt» quedaba en dos letras: eso no es un título,
              // es ruido. Lo que el jugador necesita sí o sí es en qué paso va
              // y cómo salir, y esos dos nunca ceden.
              final libre =
                  cs.maxWidth -
                  _anchoDe(contador, estiloContador) -
                  _anchoDe(
                    t('tutorial.saltar'),
                    const TextStyle(fontSize: 14),
                  ) -
                  _kBotonSaltarAire;
              final entra =
                  _anchoDe(t('tutorial.titulo'), estiloTitulo) <= libre;

              return Row(
                children: [
                  // El Spacer del caso angosto hace el mismo trabajo que el
                  // Expanded: empuja al botón contra el borde derecho.
                  if (entra)
                    Expanded(
                      child: Text(
                        t('tutorial.titulo'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: estiloTitulo,
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 12),
                  Text(contador, style: estiloContador),
                  // Sin flex: el botón va pegado a la derecha, como en el cómic.
                  TextButton(
                    onPressed: widget.onTerminar,
                    child: Text(t('tutorial.saltar'), maxLines: 1),
                  ),
                ],
              );
            },
          ),
        ),

        // ----------------------------------------------------------- la mesa
        Expanded(
          child: Stack(
            key: _clavePila,
            children: [
              SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _Resalte(
                        key: _clavesFoco[FocoTutorial.energia],
                        activo: foco == FocoTutorial.energia,
                        pulso: _pulso,
                        child: Etiqueta(
                          '${app.textos.recurso} '
                          '${j.energia}/${j.cfg.energiaMaxima}',
                          icono: Icons.bolt,
                          color: kAlba,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (j.peligro != null)
                      LayoutBuilder(
                        builder: (context, cs) => Center(
                          child: CartaView(
                            key: _claveCarta,
                            id: j.peligro!.id,
                            ancho: cs.maxWidth.clamp(0.0, 300.0),
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),
                    _estado(t),
                    const SizedBox(height: 14),
                    _Resalte(
                      key: _clavesFoco[FocoTutorial.botones],
                      activo: foco == FocoTutorial.botones,
                      pulso: _pulso,
                      child: _botones(t),
                    ),
                    if (j.mesa.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _Resalte(
                        key: _clavesFoco[FocoTutorial.mesa],
                        activo: foco == FocoTutorial.mesa,
                        pulso: _pulso,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fmt(t('juego.enMesa'), {
                                'n': j.mesa.length,
                                's': j.sumaMesa,
                              }),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kTintaSuave,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final c in j.mesa)
                                  CartaView(id: c.id, respaldo: c, ancho: 76),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (actual.accion == AccionTutorial.meditar &&
                        j.estado == EstadoJuego.postCombate) ...[
                      const SizedBox(height: 18),
                      _Resalte(
                        key: _clavesFoco[FocoTutorial.descarte],
                        activo: foco == FocoTutorial.descarte,
                        pulso: _pulso,
                        child: _descarte(t),
                      ),
                    ],
                  ],
                ),
              ),

              // Velo con recorte: sólo cuando el paso habla de la carta.
              if (foco == FocoTutorial.carta)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _pulso,
                      builder: (context, _) => CustomPaint(
                        painter: VeloRecortado(
                          hueco: hueco,
                          pulso: Curves.easeInOut.transform(_pulso.value),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ----------------------------------------------------------- el globo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: kPapelClaro,
            border: Border(
              top: BorderSide(color: kOroBorde.withValues(alpha: .4)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school_outlined, size: 18, color: kOroBorde),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      actual.texto(t),
                      style: const TextStyle(fontSize: 14.5, height: 1.45),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (!puedeAvanzar)
                    // El aviso comparte renglón con un botón que también es
                    // traducible: en 320 px no entran los dos enteros.
                    Flexible(
                      child: Text(
                        t('tutorial.tuTurno'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kOroBorde,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: puedeAvanzar ? _avanzar : null,
                    icon: Icon(ultimo ? Icons.play_arrow : Icons.arrow_forward),
                    label: Text(
                      ultimo ? t('tutorial.terminar') : t('tutorial.siguiente'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// La suma y la barra: estado de la partida, no está en la imagen.
  Widget _estado(TextosUi t) {
    final objetivo = j.poderPeligroEfectivo;
    final progreso = objetivo == 0
        ? 1.0
        : (j.sumaMesa / objetivo).clamp(0.0, 1.0);
    final gana = j.sumaMesa >= objetivo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progreso,
            minHeight: 12,
            backgroundColor: kMadera.withValues(alpha: .28),
            valueColor: AlwaysStoppedAnimation(gana ? kVerde : kAlba),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          gana
              ? fmt(t('juego.tuSumaGana'), {'s': j.sumaMesa, 'o': objetivo})
              : fmt(t('juego.tuSumaFalta'), {'s': j.sumaMesa, 'f': j.faltante}),
          style: TextStyle(fontSize: 13, color: gana ? kAlba : kTintaSuave),
        ),
      ],
    );
  }

  Widget _botones(TextosUi t) {
    final esperaRobar = actual.accion == AccionTutorial.robar && !accionHecha;
    final esperaResolver =
        actual.accion == AccionTutorial.resolver && !accionHecha;
    final esperaContinuar =
        actual.accion == AccionTutorial.continuar && !accionHecha;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (j.estado == EstadoJuego.enCombate) ...[
          FilledButton.icon(
            onPressed: esperaRobar
                ? () => _hacer(AccionTutorial.robar, () {
                    if (actual.robarTodas) {
                      while (j.puedeRobarGratis) {
                        j.robar();
                      }
                    } else {
                      j.robar();
                    }
                  })
                : null,
            icon: const Icon(Icons.add_card),
            label: Text(t('juego.robarGratis')),
          ),
          OutlinedButton.icon(
            onPressed: esperaResolver
                ? () => _hacer(AccionTutorial.resolver, () => j.resolver())
                : null,
            icon: const Icon(Icons.gavel),
            label: Text(
              j.sumaMesa >= j.poderPeligroEfectivo
                  ? fmt(t('juego.resolverGanas'), {
                      'carta': j.peligro!.recompensa.nombre,
                    })
                  : fmt(t('juego.rendirse'), {'n': j.peligro!.dano}),
            ),
          ),
        ],
        if (j.estado == EstadoJuego.postCombate &&
            actual.accion != AccionTutorial.meditar)
          FilledButton.icon(
            onPressed: esperaContinuar
                ? () => _hacer(AccionTutorial.continuar, () => j.continuar())
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: Text(t('juego.continuarPeligro')),
          ),
      ],
    );
  }

  Widget _descarte(TextosUi t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kOroBorde.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fmt(t('meditar.titulo'), {
              'coste': j.cfg.costeMeditar,
              'n': j.cfg.cartasPorMeditacion,
            }),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in j.descarte)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CartaView(
                      id: c.id,
                      respaldo: c,
                      ancho: 84,
                      // Sólo la carta que el guion pide es tocable.
                      seleccionada: c.id == 'duda_existencial',
                      onTap: c.id == 'duda_existencial' && !accionHecha
                          ? () => _hacer(
                              AccionTutorial.meditar,
                              () => j.meditar(c),
                            )
                          : null,
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

/// Oscurece todo menos un rectángulo, que queda enmarcado en ámbar.
class VeloRecortado extends CustomPainter {
  final Rect? hueco;

  /// 0 a 1, el mismo latido que el resalte de los botones. Sólo engrosa el
  /// marco: el velo no se toca, que si parpadeara marearía.
  final double pulso;
  const VeloRecortado({required this.hueco, required this.pulso});

  @override
  void paint(Canvas canvas, Size size) {
    final velo = Paint()..color = Colors.black.withValues(alpha: .70);
    final todo = Offset.zero & size;

    if (hueco == null) {
      canvas.drawRect(todo, velo);
      return;
    }

    final marco = RRect.fromRectAndRadius(
      hueco!.inflate(8),
      const Radius.circular(12),
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(todo),
        Path()..addRRect(marco),
      ),
      velo,
    );

    canvas.drawRRect(
      marco,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 + 2.5 * pulso
        ..color = kOroBorde.withValues(alpha: .70 + .30 * pulso),
    );
  }

  @override
  bool shouldRepaint(VeloRecortado v) => v.hueco != hueco || v.pulso != pulso;
}

/// Marco que resalta un widget (los pasos que hablan de botones, no de la
/// carta). Convive con el spotlight.
class _Resalte extends StatelessWidget {
  final bool activo;
  final Animation<double> pulso;
  final Widget child;
  const _Resalte({
    super.key,
    required this.activo,
    required this.pulso,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulso,
      builder: (context, hijo) {
        final v = Curves.easeInOut.transform(pulso.value);
        // Late el HALO y la escala, nunca el grosor del borde: el borde de un
        // `Container` suma tamaño, así que animarlo relayoutearía el contenido
        // sesenta veces por segundo y el botón de adentro bailaría.
        return Transform.scale(
          scale: activo ? 1 + .02 * v : 1,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: activo
                    ? kOroBorde.withValues(alpha: .65 + .35 * v)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: activo
                  ? [
                      BoxShadow(
                        color: kOroBorde.withValues(alpha: .16 + .24 * v),
                        blurRadius: 12 + 16 * v,
                      ),
                    ]
                  : null,
            ),
            child: hijo,
          ),
        );
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: activo ? 1 : 0.55,
        child: child,
      ),
    );
  }
}
