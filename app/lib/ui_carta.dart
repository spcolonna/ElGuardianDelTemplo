import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'cartas_rotulo.dart';
import 'mecanica.dart';
import 'models.dart';
import 'tutorial_zonas.dart';
import 'ui_common.dart';
import 'ui_kit.dart';

/// Proporción de una carta de mano o de peligro. Los jefes tienen la suya
/// (ver `ratioCarta`), así que para dibujar una carta concreta hay que
/// preguntarle a ella, no usar esta constante.
const kRatioCarta = kRatioPeligro;

/// Muestra la carta ilustrada, y si todavía no existe cae en el dibujo
/// provisorio de [CartaCombateView].
///
/// La carta física está partida al medio: peligro arriba, técnica abajo
/// impresa a 180°. Por eso, cuando la carta actúa como técnica se muestra
/// Si la carta es una técnica de recompensa se dibuja media vuelta, igual
/// que la girás en la mesa real (ver `cartaRotada`).
class CartaView extends StatelessWidget {
  /// Id de la carta o de la técnica que vive en ella.
  final String id;

  /// Qué dibujar si no hay imagen todavía.
  final CartaCombate? respaldo;

  final double ancho;
  final bool seleccionada;
  final VoidCallback? onTap;

  const CartaView({
    super.key,
    required this.id,
    this.respaldo,
    this.ancho = 96,
    this.seleccionada = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final alto = ancho / ratioCarta(id);
    final base = archivoCarta(id);
    // La rotación la decide la carta, no quien la dibuja.
    final rotada = cartaRotada(id);

    // El original vive en `assets/cartas/$base.jpg` y NO se empaqueta: es el
    // que lee `bin/imprimir.py` para armar el print & play a 300 dpi. Lo que
    // viaja en el binario es la copia WebP de `bin/aligerar.py`.
    Widget imagen = Image.asset(
      'assets/movil/cartas/$base.webp',
      fit: BoxFit.contain,
      // Si la carta todavía no tiene arte —o si alguien se olvidó de correr
      // aligerar.py después de agregarla— se dibuja la carta provisoria y la
      // partida sigue.
      errorBuilder: (_, e, s) => _respaldo(),
    );

    // El texto de la carta NO viene en la imagen: se escribe encima, en el
    // idioma que el jugador esté leyendo. Ver `cartas_rotulo.dart`.
    //
    // El `AspectRatio` no es decorativo: si el padre da restricciones ajustadas
    // de otra proporción, la imagen queda centrada con franjas por el
    // `BoxFit.contain` y el texto, que se ubica sobre la caja entera, se
    // despega de la ilustración. Atando las dos cosas al mismo rectángulo eso
    // no puede pasar, venga el tamaño de donde venga.
    // `foto` aparte y no `imagen` de nuevo: el closure captura la VARIABLE, y
    // reasignarla haría que el rotulado se dibuje a sí mismo para siempre.
    final foto = imagen;
    imagen = Center(
      child: AspectRatio(
        aspectRatio: ratioCarta(id),
        child: LayoutBuilder(
          builder: (context, cons) =>
              _rotulada(context, foto, cons.maxWidth, cons.maxHeight),
        ),
      ),
    );

    if (rotada) {
      imagen = Transform.rotate(angle: math.pi, child: imagen);
    }

    return BotonPulsable(
      onTap: onTap,
      escala: .94,
      child: Container(
        width: ancho,
        height: alto,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: seleccionada
              ? Border.all(color: Colors.amberAccent, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .45),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: imagen,
      ),
    );
  }

  /// La carta con su texto escrito encima, en el idioma activo.
  ///
  /// El orden importa: primero la imagen, después las placas que tapan el
  /// texto horneado, y ÚLTIMO el medallón del divisor recortado de la propia
  /// imagen. El medallón se monta sobre la banda del medio y si no se lo
  /// devuelve queda un semicírculo comido, que es justo lo primero que mira
  /// el ojo porque está en el centro exacto de la carta.
  Widget _rotulada(
    BuildContext context,
    Widget imagen,
    double ancho,
    double alto,
  ) {
    final app = AppScope.of(context);
    // En español el arte YA dice lo que hay que leer: se muestra como salió de
    // imprenta, sin un parche encima. Ver `rotulaEn` en `cartas_rotulo.dart`.
    if (!rotulaEn(app.idioma)) return imagen;
    final placas = rotuloDe(archivoCarta(id), app.textos);
    if (placas.isEmpty) return imagen;
    final divisor = mecPeligros.any((p) => p.id == archivoCarta(id));
    return Stack(
      fit: StackFit.expand,
      children: [
        imagen,
        for (final p in placas) _placa(p, ancho, alto),
        if (divisor)
          Positioned.fill(
            child: ClipPath(clipper: const _Medallon(), child: imagen),
          ),
      ],
    );
  }

  Widget _placa(PlacaRotulo p, double ancho, double alto) {
    // Girada, la placa de abajo ocupa el rectángulo espejado. El margen es el
    // mismo de los dos lados, así que en horizontal no hay nada que espejar.
    final arriba = p.rotada ? 1 - p.abajo : p.arriba;
    final ancePlaca = (p.der - p.izq) * ancho;
    final altoPlaca = (p.abajo - p.arriba) * alto;

    Widget cuerpo = Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              // La del jefe va OPACA. Con un 4% de transparencia todavía se
              // leía el texto viejo por debajo del nuevo: la letra horneada es
              // blanco puro sobre fondo de noche, así que el poco que pasa
              // igual contrasta. Un parche translúcido no tapa nada.
              color: p.oscura
                  ? const Color(0xFF2E2E34)
                  : const Color(0xFFF9F5EB),
              borderRadius: BorderRadius.circular(ancho * .012),
            ),
          ),
        ),
        for (var i = 0; i < p.lineas.length; i++)
          _linea(p, p.lineas[i], i, ancho, alto),
      ],
    );
    if (p.rotada) cuerpo = Transform.rotate(angle: math.pi, child: cuerpo);

    return Positioned(
      left: p.izq * ancho,
      top: arriba * alto,
      width: ancePlaca,
      height: altoPlaca,
      child: cuerpo,
    );
  }

  Widget _linea(
    PlacaRotulo p,
    LineaRotulo l,
    int indice,
    double ancho,
    double alto,
  ) {
    final destacada = indice == 0;
    final color = p.oscura
        ? (destacada ? const Color(0xFFF4EFE5) : const Color(0xFFD8CFBE))
        : (destacada ? const Color(0xFF1A1816) : const Color(0xFF785834));
    final cuerpo = l.cuerpo * alto;
    // Caja generosa alrededor del centro: la que manda es la línea de base
    // que midió el arte, no el alto de la caja.
    final caja = cuerpo * (l.maxLineas + 1.4);
    final pad = ancho * .018;

    return Positioned(
      left: pad,
      right: pad,
      top: (l.y - p.arriba) * alto - caja / 2,
      height: caja,
      child: Align(
        alignment: Alignment(l.alineacion.toDouble(), 0),
        child: _TextoAjustado(
          texto: l.mayusculas ? l.texto.toUpperCase() : l.texto,
          cuerpo: cuerpo,
          maxLineas: l.maxLineas,
          alineacion: l.alineacion < 0
              ? TextAlign.left
              : l.alineacion > 0
              ? TextAlign.right
              : TextAlign.center,
          estilo: TextStyle(
            fontFamily: fuenteCuerpo,
            fontWeight: l.negrita ? FontWeight.bold : FontWeight.normal,
            color: color,
            height: 1.15,
          ),
        ),
      ),
    );
  }

  Widget _respaldo() {
    final c = respaldo;
    if (c == null) return const ColoredBox(color: Color(0xFF1A1A1F));
    return FittedBox(
      fit: BoxFit.contain,
      child: CartaCombateView(carta: c, ancho: 200),
    );
  }
}

/// Convierte una zona normalizada de la carta al rectángulo que ocupa en
/// pantalla. Vive acá y no en `tutorial_zonas.dart` para que ese archivo siga
/// siendo Dart puro.
Rect zonaEnPantalla(ZonaCarta zona, Rect carta) {
  final z = zonasCarta[zona]!;
  return Rect.fromLTRB(
    carta.left + z.izq * carta.width,
    carta.top + z.arriba * carta.height,
    carta.left + z.der * carta.width,
    carta.top + z.abajo * carta.height,
  );
}

/// Muestra una carta en grande sobre un fondo oscuro, hasta que el jugador
/// toque en cualquier lado.
///
/// En la mesa las cartas se ven chicas por necesidad —la del peligro manda—,
/// pero el jugador tiene que poder leer lo que jugó sin abrir la bitácora.
/// La carta abierta, agrandable con dos dedos.
///
/// El zoom NO sobrevive a cerrar la vista, que es lo que uno espera de mirar
/// una carta: el `TransformationController` vive en este `State` y el visor se
/// destruye con el diálogo, así que la próxima apertura arranca en 1x. Si hace
/// falta resetearlo antes —al girar la carta, por ejemplo— se le pasa uno de
/// afuera con [control] y lo maneja quien lo creó.
///
/// Con `minScale: 1` y el `InteractiveViewer` acotado, en 1x el arrastre no
/// mueve nada: recién cuando hay zoom empieza a pasear. Por eso los taps de
/// cerrar y de girar siguen funcionando sin pelearse con el gesto.
class CartaConZoom extends StatefulWidget {
  final Widget child;
  final TransformationController? control;

  /// Si el doble toque vuelve la carta a 1x.
  ///
  /// Se apaga donde el toque simple ya hace algo con la carta —girarla, en la
  /// colección—, porque los dos gestos empiezan igual y el simple gana: el
  /// doble toque terminaría dando dos medias vueltas en vez de reencuadrar.
  /// Ahí el reencuadre lo hace el que gira.
  final bool dobleToqueReencuadra;

  const CartaConZoom({
    super.key,
    required this.child,
    this.control,
    this.dobleToqueReencuadra = true,
  });

  @override
  State<CartaConZoom> createState() => _CartaConZoomState();
}

class _CartaConZoomState extends State<CartaConZoom>
    with SingleTickerProviderStateMixin {
  late final TransformationController _tc =
      widget.control ?? TransformationController();

  // Se crea en `initState` y no con `late final`. Con `late final`, si nadie
  // llega a tocar la carta, el primero en leerlo es el propio `dispose`, y
  // crear un `AnimationController` con el elemento ya desactivado revienta:
  // el mixin va a buscar el `TickerMode` de un ancestro que ya no está.
  late final AnimationController _vuelta;
  Animation<Matrix4>? _animacion;

  @override
  void initState() {
    super.initState();
    _vuelta = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _vuelta.dispose();
    // Sólo se tira el que creó este widget. El de afuera es de otro.
    if (widget.control == null) _tc.dispose();
    super.dispose();
  }

  /// Vuelve a 1x animado. Es lo que hace el doble toque, y es la salida para
  /// el que se perdió adentro de la carta.
  void _reencuadrar() {
    _animacion = Matrix4Tween(
      begin: _tc.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _vuelta, curve: Curves.easeOutCubic));
    _animacion!.addListener(() => _tc.value = _animacion!.value);
    _vuelta.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.dobleToqueReencuadra ? _reencuadrar : null,
      child: InteractiveViewer(
        transformationController: _tc,
        minScale: 1,
        maxScale: 3.5,
        // Sin esto la carta ampliada queda recortada por su propia caja, que
        // es del tamaño de la carta en 1x.
        clipBehavior: Clip.none,
        child: widget.child,
      ),
    );
  }
}

Future<void> mostrarCarta(
  BuildContext context, {
  required String id,
  CartaCombate? respaldo,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'carta',
    barrierColor: const Color(0xFF2A1F16).withValues(alpha: .78),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, _) {
      final ancho = MediaQuery.of(context).size.width * .82;
      final alto = MediaQuery.of(context).size.height * .78;
      return Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: CartaConZoom(
              child: CartaView(
                id: id,
                respaldo: respaldo,
                // La carta no puede pasarse de alto en pantallas bajas.
                ancho: ancho > alto * ratioCarta(id)
                    ? alto * ratioCarta(id)
                    : ancho,
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, _, hijo) {
      final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: .88, end: 1).animate(curva),
          child: hijo,
        ),
      );
    },
  );
}

/// Recorta el medallón redondo del divisor, para volver a ponerlo sobre la
/// placa que le pasó por encima.
///
/// Es el mismo círculo que recorta `bin/rotular.py` para el print & play: si
/// algún día se mueve, se mueve en los dos lados o las cartas impresas y las
/// de pantalla dejan de ser la misma carta.
class _Medallon extends CustomClipper<Path> {
  const _Medallon();

  static const _cx = 0.501;
  static const _cy = 0.498;

  /// El radio es fracción del ANCHO en los dos ejes: el círculo es redondo en
  /// píxeles de la imagen, no en fracciones de una carta que no es cuadrada.
  static const _r = 0.030;

  @override
  Path getClip(Size s) => Path()
    ..addOval(
      Rect.fromCircle(
        center: Offset(_cx * s.width, _cy * s.height),
        radius: _r * s.width,
      ),
    );

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Texto que baja el cuerpo hasta entrar en la caja, en vez de cortarse.
///
/// Hace falta porque el mismo nombre mide distinto en cada idioma: «Fe
/// Renovada» son once caracteres y «Erneuerter Glaube» diecisiete, en la misma
/// banda impresa que no se puede agrandar. Bajar dos puntos de cuerpo se lee;
/// tres puntos suspensivos en el nombre de la carta, no.
///
/// Lo hace un `FittedBox` y no una cuenta propia. Hubo una: medía con
/// `TextPainter`, y para el jefe del Loto Negro —el único nombre que de verdad
/// no entra— daba que entraba, así que no achicaba nada y el nombre salía
/// cortado igual. `BoxFit.scaleDown` mide el texto suelto y lo encoge contra
/// la caja de verdad, que es exactamente el problema.
class _TextoAjustado extends StatelessWidget {
  final String texto;
  final double cuerpo;
  final int maxLineas;
  final TextAlign alineacion;
  final TextStyle estilo;

  const _TextoAjustado({
    required this.texto,
    required this.cuerpo,
    required this.maxLineas,
    required this.alineacion,
    required this.estilo,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        Widget hijo = Text(
          texto,
          textAlign: alineacion,
          maxLines: maxLineas,
          softWrap: maxLineas > 1,
          style: estilo.copyWith(fontSize: cuerpo),
        );
        // Con más de una línea hay que decirle dónde cortar ANTES de encoger,
        // o mide todo en una sola línea larguísima y lo achica a la nada.
        if (maxLineas > 1) {
          hijo = SizedBox(width: cons.maxWidth, child: hijo);
        }
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: hijo,
        );
      },
    );
  }
}
