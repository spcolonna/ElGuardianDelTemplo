import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui_texturas.dart';

/// Paleta y piezas de interfaz del juego, sacadas del mock: papel crema,
/// marcos de madera, tinta marrón y botones dorados.
///
/// La profundidad NO es sombra difusa de Material: es contorno de tinta más
/// una sombra corta y dura, como un sticker sobre papel. Está encapsulada acá
/// para no repetir decoraciones pantalla por pantalla.
///
/// Las piezas se dibujan con texturas 9-slice (ver `ui_texturas.dart`) y caen
/// al dibujo hecho con `BoxDecoration` si el asset todavía no existe. Por eso
/// ninguna firma pública de este archivo cambió al pasar al arte nuevo: las
/// pantallas que ya usaban estos widgets heredaron el look sin tocarse.

/// Familias tipográficas. Van sueltas para poder usarlas en `TextStyle`
/// puntuales sin depender del `Theme`.
const fuenteTitulo = 'Titulo';
const fuenteCuerpo = 'Cuerpo';

// ------------------------------------------------------------------ paleta
const kPapel = Color(0xFFF7F1E1); // fondo
const kPapelClaro = Color(0xFFFDF8EC); // paneles
const kMadera = Color(0xFFC4915A);
const kMaderaOscura = Color(0xFF8A5F33);
const kTinta = Color(0xFF4A3728);
const kTintaSuave = Color(0xFF8A7862);
const kOro = Color(0xFFF2C14E);
const kOroBorde = Color(0xFFC99A2E);
const kRojo = Color(0xFFD2554D);
const kNaranja = Color(0xFFE8863C);
const kTurquesa = Color(0xFF6FC5D0);
const kVerde = Color(0xFFA8C489);

/// Sombra corta y dura: el sello visual de toda la interfaz.
List<BoxShadow> sombraPapel({double y = 2, double desenfoque = 0}) => [
  BoxShadow(
    color: kMaderaOscura.withValues(alpha: .35),
    offset: Offset(0, y),
    blurRadius: desenfoque,
  ),
];

// ----------------------------------------------------------------- widgets

/// Panel de papel con contorno de tinta. La base de casi todo.
class PanelPapel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color? borde;
  final double radio;
  final VoidCallback? onTap;

  const PanelPapel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = kPapelClaro,
    this.borde,
    this.radio = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final panel = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radio),
        border: Border.all(color: borde ?? kMaderaOscura, width: 2),
        boxShadow: sombraPapel(),
      ),
      child: child,
    );
    if (onTap == null) return panel;
    return BotonPulsable(onTap: onTap, child: panel);
  }
}

/// Da feedback físico a cualquier cosa tocable: hunde la pieza, vibra y suena.
///
/// Antes cada `onTap` de cada pantalla llamaba a mano a `audio.sonar(toque)` y
/// la mitad se olvidaba. Acá queda en un solo lugar y lo heredan todos los
/// botones del juego.
class BotonPulsable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double escala;

  /// Si no es null, al apretar se enciende un resalte con este radio.
  ///
  /// Hace falta cuando el botón está DIBUJADO en un asset y no se puede
  /// teñir: sin esto, hundir la pieza un 4% es un cambio tan sutil que el
  /// jugador no llega a registrar que tocó algo.
  final BorderRadius? resalte;

  const BotonPulsable({
    super.key,
    required this.child,
    this.onTap,
    this.escala = .96,
    this.resalte,
  });

  @override
  State<BotonPulsable> createState() => _BotonPulsableState();
}

class _BotonPulsableState extends State<BotonPulsable> {
  bool _hundido = false;

  void _marcar(bool v) {
    if (widget.onTap == null || _hundido == v) return;
    setState(() => _hundido = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Sin acción NO se absorbe el toque: si no, un botón deshabitado
      // anidado adentro de otro tocable se come el gesto. Es lo que pasaba
      // con las cartas sin arte —las de fatiga entre ellas—, que se dibujan
      // con `CartaCombateView` y ésa se envuelve acá sin onTap: no se podían
      // ni agrandar ni eliminar.
      behavior: widget.onTap == null
          ? HitTestBehavior.deferToChild
          : HitTestBehavior.opaque,
      onTapDown: (_) => _marcar(true),
      onTapCancel: () => _marcar(false),
      onTapUp: (_) => _marcar(false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _hundido ? widget.escala : 1,
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        child: widget.resalte == null
            ? widget.child
            : Stack(
                children: [
                  widget.child,
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _hundido ? 1 : 0,
                        duration: const Duration(milliseconds: 90),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: kMaderaOscura.withValues(alpha: .20),
                            borderRadius: widget.resalte,
                          ),
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

/// Cartel de madera colgado, para títulos.
class CartelMadera extends StatelessWidget {
  final String texto;
  final double tamano;
  const CartelMadera(this.texto, {super.key, this.tamano = 20});

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
        style: TextStyle(
          fontFamily: fuenteTitulo,
          fontSize: tamano + 4,
          fontWeight: FontWeight.bold,
          color: kPapelClaro,
          letterSpacing: 1.1,
          shadows: [
            Shadow(
              color: kMaderaOscura.withValues(alpha: .8),
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón de madera o dorado. [principal] lo hace grande y dorado.
class BotonMadera extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final VoidCallback? onTap;
  final bool principal;

  /// Alto fijo del botón. Se puede pisar cuando el lugar aprieta.
  final double? alto;

  const BotonMadera({
    super.key,
    required this.texto,
    this.icono,
    this.onTap,
    this.principal = false,
    this.alto,
  });

  @override
  Widget build(BuildContext context) {
    final habilitado = onTap != null;
    final fondo = principal ? kOro : kPapelClaro;
    final borde = principal ? kOroBorde : kMaderaOscura;
    final h = alto ?? (principal ? 58.0 : 50.0);
    // La letra crece con el botón: así dos botones de distinta jerarquía uno
    // al lado del otro se ven de la misma familia.
    //
    // El factor es .30 y no .36 porque con los botones de la mesa más altos
    // el texto llegaba al tope de 22 pt y se comía la placa. La proporción
    // importa más que el número: la palabra tiene que flotar en la madera,
    // no apoyarse en los dos biseles.
    final cuerpo = (h * .30).clamp(13.0, 20.0);

    return Opacity(
      opacity: habilitado ? 1 : .5,
      child: RepaintBoundary(
        child: BotonPulsable(
          onTap: onTap,
          child: SizedBox(
            height: h,
            child: PiezaNueveCortes(
              pieza: principal ? botonDoradoTex : botonMaderaTex,
              aplicarPadding: false,
              respaldo: (_) => DecoratedBox(
                decoration: BoxDecoration(
                  color: fondo,
                  borderRadius: BorderRadius.circular(principal ? 16 : 12),
                  border: Border.all(color: borde, width: principal ? 3 : 2),
                  boxShadow: sombraPapel(y: principal ? 4 : 2),
                ),
              ),
              // El padding va acá adentro, junto con el recorte: el contenido
              // NO puede pintar fuera de la placa. Antes, cuando el texto no
              // entraba, se dibujaba por encima de la madera y quedaba flotando
              // sobre el fondo.
              child: ClipRect(
                child: Padding(
                  padding: principal
                      ? botonDoradoTex.contenido
                      : botonMaderaTex.contenido,
                  child: Center(
                    // FittedBox necesita ancho acotado para achicar, y dentro de
                    // un Row con mainAxisSize.min no lo tiene. Con el Center y
                    // el alto fijo, lo tiene siempre.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icono != null) ...[
                            Icon(icono, size: cuerpo * 1.1, color: kTinta),
                            const SizedBox(width: 9),
                          ],
                          Text(
                            texto,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: principal ? fuenteTitulo : null,
                              fontSize: cuerpo,
                              fontWeight: FontWeight.bold,
                              color: kTinta,
                              letterSpacing: principal ? 1.1 : 0.3,
                              // La tinta sobre la veta de la madera se
                              // desdibuja donde el arte se oscurece. El realce
                              // claro la despega, igual que el texto tallado
                              // del marco.
                              shadows: const [
                                Shadow(
                                  color: Color(0xB3FDF8EC),
                                  offset: Offset(0, 1),
                                  blurRadius: 1.5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Plaquita chica de acceso secundario, como el DECK / EQUIP / MAP del mock.
class PlacaMadera extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onTap;
  const PlacaMadera({
    super.key,
    required this.texto,
    required this.icono,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BotonPulsable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kMadera.withValues(alpha: .30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kMaderaOscura, width: 2),
          boxShadow: sombraPapel(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 22, color: kTinta),
            const SizedBox(height: 4),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: kTinta,
                letterSpacing: .6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Píldora de estado (energía, fase, mazo…), con ícono y color propio.
class Pastilla extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final Color color;
  final bool compacta;

  const Pastilla(
    this.texto, {
    super.key,
    this.icono,
    this.color = kTinta,
    this.compacta = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compacta ? 9 : 12,
        vertical: compacta ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .75), width: 2),
        boxShadow: sombraPapel(y: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: compacta ? 14 : 16, color: color),
            const SizedBox(width: 5),
          ],
          // Flexible + ellipsis porque la pastilla vive en filas sin espacio
          // de sobra: la de la fase crece con el texto ('Enfrentamiento
          // Final') y sin acotarla desbordaba la barra de la mesa. Con
          // mainAxisSize.min el Flexible no estira nada, sólo pone el techo.
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kTinta,
                fontSize: compacta ? 12 : 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fondo de papel: gradiente suave con la textura real encima si existe.
class FondoPapel extends StatelessWidget {
  final Widget child;
  const FondoPapel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.35),
                radius: 1.1,
                colors: [Color(0xFFFDF8EC), kPapel],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: .35,
            child: ImagenUi(
              asset: fondoPapelTextura,
              fit: BoxFit.cover,
              respaldo: (_) => const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

/// El personaje en su marco de madera, con la placa de nombre debajo.
///
/// Es la pieza central del patio, la que hace que la pantalla se lea como un
/// juego y no como una lista de opciones.
class MarcoRetrato extends StatelessWidget {
  final String? nombre;
  final double ancho;

  /// Ruta de la ilustración. Si falta, se dibuja un monje simple.
  final String asset;

  const MarcoRetrato({
    super.key,
    this.nombre,
    this.ancho = 176,
    this.asset = retratoNovato,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: ancho,
          height: ancho * (900 / 768),
          child: PiezaNueveCortes(
            pieza: marcoRetratoTex,
            respaldo: (_) => DecoratedBox(
              decoration: BoxDecoration(
                color: kMadera.withValues(alpha: .28),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kMaderaOscura, width: 4),
                boxShadow: sombraPapel(y: 4),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImagenUi(
                asset: asset,
                fit: BoxFit.cover,
                respaldo: (_) => const Center(
                  child: Icon(
                    Icons.self_improvement,
                    size: 84,
                    color: kMaderaOscura,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (nombre != null)
          Transform.translate(
            offset: const Offset(0, -12),
            child: PlacaNombre(nombre!),
          ),
      ],
    );
  }
}

/// Placa de madera clara con el nombre tallado.
class PlacaNombre extends StatelessWidget {
  final String texto;
  const PlacaNombre(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return PiezaNueveCortes(
      pieza: placaNombreTex,
      respaldo: (_) => DecoratedBox(
        decoration: BoxDecoration(
          color: kPapelClaro,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kMaderaOscura, width: 2),
          boxShadow: sombraPapel(),
        ),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: fuenteTitulo,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: kMaderaOscura,
          letterSpacing: .5,
        ),
      ),
    );
  }
}

/// Título de sección dentro de una pantalla. Distinto del cartel colgante,
/// que titula la pantalla entera.
class PlacaTitulo extends StatelessWidget {
  final String texto;
  final IconData? icono;
  const PlacaTitulo(this.texto, {super.key, this.icono});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icono != null) ...[
          Icon(icono, size: 18, color: kMaderaOscura),
          const SizedBox(width: 8),
        ],
        // El título es traducible y la fuente de titular es ancha: sin acotar,
        // un título largo empujaba la línea fuera de la pantalla.
        Flexible(
          child: Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: fuenteTitulo,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: kMaderaOscura,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // La línea cede antes que el título, pero nunca desaparece del todo.
        const Expanded(
          child: Divider(color: kMadera, thickness: 1.5),
        ),
      ],
    );
  }
}

/// Una pieza de iconografía del juego, con un ícono de Material como respaldo.
///
/// El trofeo y la calavera de Material funcionan, pero son de cualquier app.
/// Esto deja que el arte propio los reemplace en cuanto exista, sin que la
/// pantalla dependa de que exista.
class IconoJuego extends StatelessWidget {
  final String asset;
  final IconData respaldoIcono;
  final double tamano;
  final Color? colorRespaldo;

  const IconoJuego({
    super.key,
    required this.asset,
    required this.respaldoIcono,
    this.tamano = 64,
    this.colorRespaldo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamano,
      height: tamano,
      child: ImagenUi(
        asset: asset,
        fit: BoxFit.contain,
        respaldo: (_) => Icon(
          respaldoIcono,
          size: tamano,
          color: colorRespaldo ?? kMaderaOscura,
        ),
      ),
    );
  }
}

/// Diálogo de confirmación con los botones del juego.
///
/// Los `TextButton` del `AlertDialog` quedan planos al lado de una interfaz de
/// madera: acá las dos salidas son botones de verdad, y la peligrosa es la
/// dorada para que se vea cuál es la que hace algo irreversible.
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  String? detalle,
  required String textoSi,
  required String textoNo,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (d) => AlertDialog(
      title: Text(titulo),
      content: detalle == null ? null : Text(detalle),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: BotonMadera(
                texto: textoNo,
                alto: 54,
                onTap: () => Navigator.pop(d, false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BotonMadera(
                texto: textoSi,
                principal: true,
                alto: 54,
                onTap: () => Navigator.pop(d, true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return r ?? false;
}
