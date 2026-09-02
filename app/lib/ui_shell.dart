import 'package:flutter/material.dart';

import 'app_state.dart';
import 'audio.dart';
import 'l10n.dart';
import 'ui_common.dart';
import 'ui_kit.dart';
import 'ui_marco.dart';
import 'ui_texturas.dart';

/// El marco del juego: fondo ilustrado, marco de madera, cartel colgante y
/// barra inferior. Es el ÚNICO lugar del código que construye un `Scaffold`
/// —hace falta uno para el ink, los snackbars y el bottom sheet de la
/// bitácora— así que todas las pantallas se ven igual por construcción.
class PantallaTemplo extends StatelessWidget {
  /// Si no es null, se dibuja el cartel colgante con este texto.
  final String? titulo;

  final Widget cuerpo;

  /// La barra de madera del pie. Normalmente una [BarraMadera].
  final Widget? barraInferior;

  /// La acción principal de la pantalla. Va en el botón dorado del marco.
  /// Sin acción propia, ese botón vuelve atrás.
  final String? textoAccion;
  final VoidCallback? onAccion;

  /// Dibuja el disco de volver sobre la banda del marco.
  final bool conVolver;

  final VoidCallback? onVolver;

  /// Con una partida en curso, salir pide confirmación.
  final bool bloquearSalida;

  /// Vela el paisaje detrás del contenido.
  ///
  /// Las pantallas de lista lo necesitan: un título de sección sobre el
  /// dibujo del templo no se lee. El patio no, porque su contenido son un
  /// cuadro y un pergamino que ya traen fondo propio.
  final bool velarContenido;

  const PantallaTemplo({
    super.key,
    required this.cuerpo,
    this.titulo,
    this.barraInferior,
    this.textoAccion,
    this.onAccion,
    this.conVolver = false,
    this.onVolver,
    this.bloquearSalida = false,
    this.velarContenido = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !bloquearSalida,
      onPopInvokedWithResult: (listo, _) async {
        if (listo) return;
        if (await confirmarSalida(context)) {
          if (context.mounted) _salir(context);
        }
      },
      child: Scaffold(
        backgroundColor: kTinta,
        // El Material transparente garantiza el ancestro que necesitan los
        // widgets de Material (Switch, TextButton, IconButton) sin importar
        // qué pantalla se envuelva acá adentro.
        // Todas las pantallas usan el marco ilustrado y el fondo del patio:
        // una pantalla secundaria con otro marco se siente de otra app. Si el
        // asset no está, `MarcoJuego` cae en el dibujo de siempre.
        body: Material(
          type: MaterialType.transparency,
          child: FondoEscena(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Escenario.anchoMaximo,
                  ),
                  child: Builder(
                    builder: (context) {
                      final t = TextosUi.de(AppScope.of(context).idioma);
                      return MarcoJuego(
                        titulo: titulo ?? '',
                        // El botón tallado de la esquina vuelve atrás: es el
                        // único control fijo del marco y no tiene sentido que
                        // quede muerto en las pantallas secundarias.
                        onEsquina: conVolver ? () => _salir(context) : null,
                        // El botón dorado es la acción de la pantalla. Si no
                        // hay ninguna, es la salida.
                        accesos: conVolver
                            ? [
                                AccesoTabla(
                                  texto: t('nav.volver'),
                                  icono: Icons.arrow_back,
                                  onTap: () => _salir(context),
                                ),
                              ]
                            : const [],
                        textoAccion: textoAccion ?? t('nav.volver'),
                        onAccion:
                            onAccion ??
                            (conVolver ? () => _salir(context) : null),
                        respaldo: (context) => _pintado(context),
                        contenido: velarContenido
                            ? DecoratedBox(
                                // .55 dejaba pasar el detalle de la foto por
                                // debajo del texto, así que el contraste
                                // dependía de qué zona del paisaje quedara
                                // atrás. En pantallas de leer, el papel manda.
                                decoration: BoxDecoration(
                                  color: kPapel.withValues(alpha: .78),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: cuerpo,
                              )
                            : cuerpo,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// La versión dibujada, para cuando falta `marco.png`.
  Widget _pintado(BuildContext context) {
    return Escenario(
      child: Stack(
        children: [
          // El contenido va DEBAJO del marco: el marco tiene el centro
          // transparente y taparía los toques si no fuera IgnorePointer.
          Positioned.fill(
            child: Padding(
              padding: marcoPantalla.contenido,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FondoPapel(
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        if (titulo != null) ...[
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CartelColgante(titulo!),
                          ),
                          const SizedBox(height: 8),
                        ] else
                          const SizedBox(height: 6),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: cuerpo,
                          ),
                        ),
                        // La acción principal manda: va sola, a todo el
                        // ancho, arriba de la barra de accesos.
                        if (textoAccion != null && onAccion != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                            child: SizedBox(
                              width: double.infinity,
                              child: BotonMadera(
                                texto: textoAccion!,
                                principal: true,
                                onTap: onAccion,
                              ),
                            ),
                          ),
                        ?barraInferior,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: PiezaNueveCortes(
                pieza: marcoPantalla,
                respaldo: (_) => const _MarcoPintado(),
              ),
            ),
          ),
          if (conVolver)
            Positioned(
              left: 6,
              top: 6,
              child: SafeArea(
                child: BotonVolver(
                  onTap: () async {
                    if (bloquearSalida && !await confirmarSalida(context)) {
                      return;
                    }
                    if (context.mounted) _salir(context);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _salir(BuildContext context) {
    if (onVolver != null) {
      onVolver!();
    } else {
      Navigator.of(context).maybePop();
    }
  }
}

/// El fondo ilustrado del templo, a sangre completa, con un velo de papel
/// encima.
///
/// El velo no es decorativo: el arte del fondo tiene contraste propio y el
/// texto de los paneles se apoya sobre él. Sin bajarlo, la pantalla se vuelve
/// ruidosa apenas el contenido pasa por una zona con detalle.
class FondoEscena extends StatelessWidget {
  final Widget child;

  /// Cuánto papel se pone encima. 0 = el arte tal cual.
  final double velo;

  /// Qué paisaje se ve detrás. Por defecto el del patio.
  final String asset;

  /// Avisa cuando terminó de entrar un paisaje nuevo. La partida lo usa para
  /// cambiar la música recién ahí.
  final VoidCallback? onTransicion;

  /// Qué momento representa este paisaje. Por defecto, el asset mismo.
  ///
  /// Hace falta aparte porque Ocaso y Jefes comparten el mismo JPG: sin esto
  /// el paso a Jefes no cuenta como cambio y la música de los jefes no
  /// arrancaba nunca.
  final String? clave;

  const FondoEscena({
    super.key,
    required this.child,
    this.velo = .30,
    this.asset = fondoPatio,
    this.onTransicion,
    this.clave,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _Paisaje(clave: clave ?? asset, asset: asset, onFin: onTransicion),
        if (velo > 0) ColoredBox(color: kPapel.withValues(alpha: velo)),
        child,
      ],
    );
  }
}

/// El paisaje del fondo, que se desliza cuando cambia.
///
/// El día avanza empujando: el amanecer se va por la izquierda mientras entra
/// el mediodía. Es la única transición del juego que dura más de un segundo, y
/// está bien que dure: es el momento en que el jugador respira entre fases.
///
/// Se hace a mano en vez de con `AnimatedSwitcher` por dos razones. El
/// switcher corre el hijo saliente **en reversa sobre el mismo tween**, así
/// que el paisaje viejo volvería hacia la derecha en lugar de irse hacia la
/// izquierda; y no expone ningún aviso de "terminé", que es justo lo que
/// necesita la música para entrar después y no encima.
class _Paisaje extends StatefulWidget {
  final String asset;
  final String clave;
  final VoidCallback? onFin;

  const _Paisaje({required this.asset, required this.clave, this.onFin});

  @override
  State<_Paisaje> createState() => _PaisajeState();
}

class _PaisajeState extends State<_Paisaje> with SingleTickerProviderStateMixin {
  /// Se crea en `initState` y no como `late final`.
  ///
  /// Diferido, el controller no existía hasta la primera transición, y en una
  /// pantalla que se cierra sin haber cambiado nunca de paisaje el primero en
  /// tocarlo era `dispose()`: ahí `vsync: this` busca un ancestro del árbol
  /// que ya está desactivado y revienta.
  late final AnimationController _ctrl;

  /// El que se está yendo. `null` cuando no hay transición en curso.
  String? _anterior;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: kTransicionPaisaje);
  }

  @override
  void didUpdateWidget(covariant _Paisaje viejo) {
    super.didUpdateWidget(viejo);
    if (viejo.clave == widget.clave) return;
    if (viejo.asset == widget.asset) {
      // Cambió el momento pero no el paisaje (Ocaso → Jefes). No hay nada que
      // deslizar, pero el aviso tiene que salir igual: la música es lo único
      // que marca ese pasaje.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFin?.call();
      });
      return;
    }
    _anterior = viejo.asset;
    _ctrl.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      setState(() => _anterior = null);
      widget.onFin?.call();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _capa(String asset) => ImagenUi(
    asset: asset,
    fit: BoxFit.cover,
    respaldo: (_) => const FondoPapel(child: SizedBox.expand()),
  );

  @override
  Widget build(BuildContext context) {
    final saliendo = _anterior;
    if (saliendo == null) return _capa(widget.asset);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_ctrl.value);
        return Stack(
          fit: StackFit.expand,
          children: [
            FractionalTranslation(
              translation: Offset(-t, 0),
              child: _capa(saliendo),
            ),
            FractionalTranslation(
              translation: Offset(1 - t, 0),
              child: _capa(widget.asset),
            ),
          ],
        );
      },
    );
  }
}

/// Pantalla a sangre completa, sin marco de madera.
///
/// El marco tiene sentido en los menús: los enmarca y les da identidad. En la
/// mesa sólo roba lo único que importa, que es la carta. Acá el papel llega a
/// los cuatro bordes y la pantalla es toda del juego.
class PantallaLibre extends StatelessWidget {
  final Widget cuerpo;
  final bool bloquearSalida;
  final VoidCallback? onSalir;

  /// El paisaje del fondo. Cambia con la fase de la partida.
  final String fondo;

  /// Avisa cuando el paisaje nuevo terminó de entrar.
  final VoidCallback? onTransicion;

  /// Qué momento representa el fondo. Ver `FondoEscena.clave`.
  final String? claveFondo;

  const PantallaLibre({
    super.key,
    required this.cuerpo,
    this.bloquearSalida = false,
    this.onSalir,
    this.fondo = fondoPatio,
    this.onTransicion,
    this.claveFondo,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !bloquearSalida,
      onPopInvokedWithResult: (listo, _) async {
        if (listo) return;
        if (await confirmarSalida(context) && context.mounted) {
          (onSalir ?? Navigator.of(context).pop)();
        }
      },
      child: Scaffold(
        backgroundColor: kPapel,
        body: Material(
          type: MaterialType.transparency,
          // El paisaje se tiene que ver: con el velo al 82% pasaba menos del
          // 20% del dibujo y la mesa parecía vacía. La legibilidad no depende
          // de taparlo — la franja de acciones y los paneles traen su propio
          // fondo opaco, y lo único apoyado sobre el paisaje es la carta, que
          // tiene borde y sombra propios.
          child: FondoEscena(
            asset: fondo,
            velo: .45,
            onTransicion: onTransicion,
            clave: claveFondo,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Escenario.anchoMaximo,
                ),
                child: cuerpo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Diálogo de "¿salir de la partida?". Lo comparten las dos pantallas.
Future<bool> confirmarSalida(BuildContext context) {
  final t = TextosUi.de(AppScope.of(context).idioma);
  return confirmar(
    context,
    titulo: t('ajustes.salir'),
    detalle: t('ajustes.salirSub'),
    textoNo: t('ajustes.cancelar'),
    textoSi: t('ajustes.salirOk'),
  );
}

/// Fondo del patio a sangre completa, con el juego centrado en una caja
/// acotada.
///
/// El letterbox no es estética: es lo que hace viable el marco 9-slice. Sin
/// acotar, el marco tendría que estirarse de 0.46 (iPhone alto) a 1.78 (web
/// apaisada) y la veta se vería deformada. Acotado, el rango real queda entre
/// 0.50 y 0.75, donde el estiramiento es invisible.
class Escenario extends StatelessWidget {
  final Widget child;
  const Escenario({super.key, required this.child});

  /// Más ancho que esto, el juego deja de leerse como juego de teléfono.
  static const anchoMaximo = 560.0;

  /// Por debajo de esto, las esquinas del marco no entran.
  static const anchoMinimo = 320.0;
  static const altoMinimo = 480.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImagenUi(
          asset: fondoPatio,
          fit: BoxFit.cover,
          respaldo: (_) => const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kMadera, kMaderaOscura],
              ),
            ),
          ),
        ),
        // Vela oscura: separa el escenario del juego y hace que el marco
        // recorte contra algo, no contra el dibujo del fondo.
        Positioned.fill(
          child: ColoredBox(color: kTinta.withValues(alpha: .28)),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: anchoMaximo,
              minWidth: anchoMinimo,
              minHeight: altoMinimo,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// El marco dibujado, para cuando todavía no está el PNG.
class _MarcoPintado extends StatelessWidget {
  const _MarcoPintado();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PintorMarco());
  }
}

class _PintorMarco extends CustomPainter {
  static const _banda = 26.0;

  @override
  void paint(Canvas canvas, Size size) {
    final todo = Offset.zero & size;
    final hueco = Rect.fromLTRB(
      _banda,
      _banda,
      size.width - _banda,
      size.height - _banda,
    );
    final marco = Path.combine(
      PathOperation.difference,
      Path()..addRRect(RRect.fromRectXY(todo, 18, 18)),
      Path()..addRRect(RRect.fromRectXY(hueco, 10, 10)),
    );
    canvas.drawPath(marco, Paint()..color = kMadera);
    canvas.drawPath(
      marco,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = kMaderaOscura,
    );
  }

  @override
  bool shouldRepaint(_PintorMarco v) => false;
}

/// Cartel de madera colgado de dos cuerdas: el título de cada pantalla.
class CartelColgante extends StatelessWidget {
  final String texto;
  const CartelColgante(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return PiezaNueveCortes(
      pieza: cartelColgante,
      respaldo: (_) => DecoratedBox(
        decoration: BoxDecoration(
          color: kMadera,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kMaderaOscura, width: 3),
          boxShadow: sombraPapel(y: 3),
        ),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: fuenteTitulo,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: kPapelClaro,
          letterSpacing: 1,
          shadows: [Shadow(color: kMaderaOscura, offset: Offset(0, 1.5))],
        ),
      ),
    );
  }
}

/// Disco de madera tallado con una flecha. Reemplaza al AppBar: no hay ni una
/// barra de Material en todo el juego.
class BotonVolver extends StatelessWidget {
  final VoidCallback onTap;
  const BotonVolver({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BotonPulsable(
      onTap: onTap,
      // El disco dibujado es de 40 pero el área táctil llega a 48: por debajo
      // de 44 pt el toque se vuelve incómodo en teléfono.
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: ImagenUi(
            asset: iconoVolver,
            respaldo: (_) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kMadera,
                shape: BoxShape.circle,
                border: Border.all(color: kMaderaOscura, width: 2.5),
                boxShadow: sombraPapel(),
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: kTinta),
            ),
          ),
        ),
      ),
    );
  }
}

/// Un acceso de la barra inferior: ícono más etiqueta, como el DECK/EQUIP/MAP
/// del mock.
class AccesoMadera {
  final String texto;
  final IconData icono;
  final VoidCallback onTap;
  final bool destacado;
  const AccesoMadera({
    required this.texto,
    required this.icono,
    required this.onTap,
    this.destacado = false,
  });
}

/// La barra de madera del pie: accesos a la izquierda y la acción principal a
/// la derecha.
class BarraMadera extends StatelessWidget {
  final List<AccesoMadera> accesos;
  const BarraMadera({super.key, this.accesos = const []});

  @override
  Widget build(BuildContext context) {
    // 66 es lo que necesitan ícono + etiqueta sin que se corten; el área
    // táctil de cada acceso llega igual a 44 pt de ancho.
    return SizedBox(
      height: 66 + MediaQuery.of(context).padding.bottom * .5,
      child: PiezaNueveCortes(
        pieza: barraInferiorTex,
        respaldo: (_) => DecoratedBox(
          decoration: BoxDecoration(
            color: kMadera,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border(top: BorderSide(color: kMaderaOscura, width: 2.5)),
          ),
        ),
        // Repartida cuando entra, deslizable cuando no.
        //
        // En un teléfono los accesos entran siempre y esto se comporta igual
        // que antes: `spaceEvenly` los reparte a lo ancho. Pero en un iPad en
        // Slide Over la ventana mide 320 pt y la barra se desbordaba 129 px,
        // que en review es un rechazo. La salida NO es achicar los accesos:
        // cada uno tiene 44 pt de área táctil y bajar de ahí rompe la
        // accesibilidad. Se deslizan, que es lo que hace cualquier barra de
        // pestañas cuando le falta lugar.
        child: LayoutBuilder(
          builder: (context, cs) {
            // 68 = los 56 pt de ancho mínimo del acceso más sus 12 de padding.
            final entran = accesos.length * 68 <= cs.maxWidth;
            final fila = Row(
              mainAxisAlignment: entran
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
              mainAxisSize: entran ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final a in accesos) _Acceso(acceso: a)],
            );
            if (entran) return fila;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: fila,
            );
          },
        ),
      ),
    );
  }
}

class _Acceso extends StatelessWidget {
  final AccesoMadera acceso;
  const _Acceso({required this.acceso});

  @override
  Widget build(BuildContext context) {
    return BotonPulsable(
      onTap: acceso.onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 56, minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Crema y oro sobre la madera clara daban 2.3:1 y 1.9:1: el
            // estado "destacado" contrastaba PEOR que el normal, o sea que
            // resaltar volvía la etiqueta más difícil de leer. Ahora la letra
            // es tinta con realce claro —igual que el texto tallado del
            // marco— y el destacado se marca con el disco dorado detrás del
            // ícono, que es contraste de forma y no de color de letra.
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: acceso.destacado ? kOro : Colors.transparent,
                border: acceso.destacado
                    ? Border.all(color: kOroBorde, width: 1.5)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(acceso.icono, size: 21, color: kTinta),
              ),
            ),
            const SizedBox(height: 3),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  acceso.texto.toUpperCase(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                    color: kTinta,
                    shadows: [
                      Shadow(
                        color: Color(0xCCFDF8EC),
                        offset: Offset(0, 1),
                        blurRadius: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toca el efecto de interfaz sin obligar a cada pantalla a acordarse.
void tocarUi(BuildContext context) =>
    AppScope.of(context).audio.sonar(Sfx.toque);
