import 'package:flutter/material.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

import 'l10n.dart';
import 'temas/temas.dart';

/// Las secuencias de cómic del juego. Los paneles viven en el tema activo
/// (`temas/templo.dart`), no acá: esta capa solo sabe reproducirlos.
enum Secuencia { intro, mediodia, ocaso, jefes, victoria, derrota }

/// Reproductor de una secuencia de cómic.
class ComicView extends StatefulWidget {
  final Tema tema;
  final TextosTema textos;
  final TextosUi ui;
  final Secuencia secuencia;
  final String textoFinal;
  final VoidCallback onTerminar;

  const ComicView({
    super.key,
    required this.tema,
    required this.textos,
    required this.ui,
    required this.secuencia,
    required this.onTerminar,
    this.textoFinal = 'Continuar',
  });

  @override
  State<ComicView> createState() => _ComicViewState();
}

class _ComicViewState extends State<ComicView> {
  final _pager = PageController();
  int actual = 0;

  List<PanelArte> get paneles =>
      widget.tema.paneles[widget.secuencia.name] ?? const [];

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  void _ir(int i) {
    if (i < 0 || i >= paneles.length) return;
    _pager.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ultimo = actual == paneles.length - 1;

    return FondoPapel(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 0),
              child: Row(
                children: [
                  // Expanded y no Flexible: el título tiene que ESTIRARSE
                  // hasta ocupar el sobrante, que es lo que empuja al botón
                  // contra el borde derecho. Con Flexible el título toma su
                  // ancho natural y en una pantalla ancha el botón queda
                  // pegado al título, flotando en el medio de la fila.
                  Expanded(
                    child: Text(
                      widget.textos.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: fuenteTitulo,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: kMaderaOscura,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: widget.onTerminar,
                    child: Text(widget.ui('comic.saltar')),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pager,
                itemCount: paneles.length,
                onPageChanged: (i) => setState(() => actual = i),
                itemBuilder: (_, i) => _VistaPanel(
                  panel: paneles[i],
                  texto: widget.textos.paneles[paneles[i].archivo],
                  protagonista: widget.textos.protagonista,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: actual == 0 ? null : () => _ir(actual - 1),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: widget.ui('comic.anterior'),
                  ),
                  const SizedBox(width: 8),
                  // Los puntos son tantos como viñetas: ocho en la intro. Van
                  // en el hueco que sobra y se achican si no entran, en vez de
                  // empujar al botón de Siguiente fuera de la pantalla.
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < paneles.length; i++)
                            GestureDetector(
                              onTap: () => _ir(i),
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i == actual ? kOroBorde : kMadera,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: ultimo
                        ? widget.onTerminar
                        : () => _ir(actual + 1),
                    icon: Icon(ultimo ? Icons.play_arrow : Icons.arrow_forward),
                    label: Text(
                      ultimo ? widget.textoFinal : widget.ui('comic.siguiente'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una viñeta: el dibujo arriba y la conversación abajo.
///
/// Antes el diálogo iba en un bocadillo encima del dibujo. Se veía mal por una
/// razón de fondo: estas ilustraciones no se dibujaron dejando aire para el
/// texto, así que el globo siempre tapaba algo, y las réplicas largas —la nota
/// de Shifu son cuatro renglones— lo volvían una placa opaca sobre la escena.
///
/// Ahora el dibujo se ve entero y lo que se dice va debajo, como un chat: quién
/// habla queda dicho con nombre y color en vez de con una cola que apunta, y el
/// texto puede ser tan largo como haga falta.
///
/// Todo entra escalonado. Antes aparecía de golpe y se sentía una lámina, no
/// una página de cómic.
class _VistaPanel extends StatefulWidget {
  final PanelArte panel;
  final TextoPanel? texto;

  /// Cómo se llama el personaje del jugador: sus réplicas van a la derecha,
  /// como los mensajes propios en un chat.
  final String protagonista;

  const _VistaPanel({
    required this.panel,
    required this.texto,
    required this.protagonista,
  });

  @override
  State<_VistaPanel> createState() => _VistaPanelState();
}

class _VistaPanelState extends State<_VistaPanel>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Recorta un tramo del avance total y lo devuelve entre 0 y 1.
  double _tramo(double a, double b) =>
      ((_c.value - a) / (b - a)).clamp(0.0, 1.0);

  /// Entra desde abajo, como un mensaje que llega.
  Widget _entrando(double avance, Widget hijo) => Opacity(
    opacity: avance,
    child: Transform.translate(
      offset: Offset(0, 16 * (1 - avance)),
      child: hijo,
    ),
  );

  /// Una línea de la charla: burbuja de alguien, o acotación sin dueño.
  Widget _linea(Dicho d, int i) {
    // Acotación es lo que no dice nadie. Un paréntesis CON autor no es
    // acotación: es Mei parpadeando, y sacarle el nombre le saca el chiste.
    if (d.quien.isEmpty) return _Acotacion(texto: d.texto);
    final mio = widget.protagonista.toLowerCase().contains(
      d.quien.toLowerCase(),
    );
    // El nombre se repite sólo cuando cambia de hablante: en un chat, tres
    // mensajes seguidos de la misma persona llevan un solo encabezado.
    final charla = widget.texto?.conversacion ?? const <Dicho>[];
    final seguido = i > 0 && charla[i - 1].quien == d.quien;
    return _Burbuja(
      quien: d.quien,
      texto: d.texto,
      mio: mio,
      encadenada: seguido,
      // Entre paréntesis no habla: hace. Va en itálica para que se lea como
      // una acción y no como algo que dijo en voz alta.
      accion: d.texto.trimLeft().startsWith('('),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.texto;
    final charla = t?.conversacion ?? const <Dicho>[];

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final vineta = Curves.easeOut.transform(_tramo(0, .45));
        final narra = Curves.easeOut.transform(_tramo(.18, .58));

        // Las burbujas entran de a una, escalonadas dentro del último tramo:
        // que aparezcan todas juntas no se lee como una conversación, se lee
        // como un bloque de texto.
        double turno(int i) {
          if (charla.length == 1) return Curves.easeOut.transform(_tramo(.42, .85));
          final paso = .43 / charla.length;
          final desde = .42 + paso * i;
          return Curves.easeOut.transform(_tramo(desde, desde + paso * 1.4));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Opacity(
                    opacity: vineta,
                    child: _MarcoVineta(
                      panel: widget.panel,
                      // Paneo lento: la viñeta entra con un resto de
                      // movimiento en vez de aparecer quieta.
                      acercamiento: 1.05 - .05 * vineta,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if ((t?.narracion ?? '').isNotEmpty)
                    _entrando(narra, _Narracion(texto: t!.narracion)),
                  for (var i = 0; i < charla.length; i++) ...[
                    const SizedBox(height: 8),
                    _entrando(turno(i), _linea(charla[i], i)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// La voz del narrador. No es de nadie, así que no lleva burbuja: va como una
/// línea de sistema, centrada, igual que las del medio de una conversación.
class _Narracion extends StatelessWidget {
  final String texto;
  const _Narracion({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kPapelClaro.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kMadera.withValues(alpha: .45), width: 1.5),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14.5, height: 1.45, color: kTinta),
        ),
      ),
    );
  }
}

/// Una acotación: lo que pasa, no lo que alguien dice.
class _Acotacion extends StatelessWidget {
  final String texto;
  const _Acotacion({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: kMadera.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.35,
            fontStyle: FontStyle.italic,
            color: kTinta,
          ),
        ),
      ),
    );
  }
}

/// Un color estable por personaje, sacado del nombre.
///
/// Que salga del nombre y no de una tabla quiere decir que un personaje nuevo
/// —o un tema nuevo entero— ya tiene su color sin que nadie lo elija.
Color _colorDe(String quien) {
  const paleta = [
    Color(0xFF4F9E63), // verde
    Color(0xFFB2403C), // rojo ocaso
    Color(0xFF7048A8), // violeta
    Color(0xFF3C7BB0), // azul
    Color(0xFFBE8A22), // dorado
    Color(0xFF8A5F33), // madera
  ];
  var h = 7;
  for (final c in quien.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return paleta[h % paleta.length];
}

/// Una réplica, como mensaje de chat.
///
/// Las del protagonista van a la derecha y las de los demás a la izquierda con
/// su inicial adelante: es la convención que ya conoce cualquiera que haya
/// usado un mensajero, y ahorra tener que explicar quién habla.
class _Burbuja extends StatelessWidget {
  final String quien;
  final String texto;
  final bool mio;

  /// Viene pegada a otra del mismo hablante: sin avatar ni nombre repetidos.
  final bool encadenada;

  /// Es algo que el personaje HACE, no algo que dice.
  final bool accion;

  const _Burbuja({
    required this.quien,
    required this.texto,
    required this.mio,
    this.encadenada = false,
    this.accion = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorDe(quien);
    final fondo = mio ? kVerde.withValues(alpha: .38) : kPapelClaro;
    final inicial = quien.isEmpty ? '?' : quien.substring(0, 1).toUpperCase();

    // El ancho máximo se calcula sobre el espacio REAL que hay acá adentro, no
    // sobre el de la pantalla: la viñeta vive dentro de paddings y de un ancho
    // máximo de 760, así que medir la pantalla daba de más y desbordaba.
    return LayoutBuilder(
      builder: (context, cs) {
        const avatar = 30.0;
        const separacion = 8.0;
        final libre = cs.maxWidth - (mio ? 0 : avatar + separacion);
        // El chat no ocupa todo el ancho: el aire del lado de quien NO habla
        // es lo que lo hace leer como conversación y no como párrafos.
        final tope = libre * .88;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: mio
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!mio) ...[
              // Encadenada, el hueco del avatar se deja vacío: alinea las
              // burbujas del mismo hablante sin repetir la cara.
              if (encadenada)
                const SizedBox(width: avatar)
              else
                Container(
                  width: avatar,
                  height: avatar,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: kTinta, width: 1.5),
                  ),
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: kPapelClaro,
                    ),
                  ),
                ),
              const SizedBox(width: separacion),
            ],
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tope),
              child: CustomPaint(
                painter: _PintorBurbuja(fondo: fondo, aLaDerecha: mio),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 9, 14, 11),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (quien.isNotEmpty && !encadenada) ...[
                        Text(
                          quien.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w900,
                            color: mio ? kMaderaOscura : color,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        texto,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.38,
                          fontWeight: accion
                              ? FontWeight.w500
                              : FontWeight.w600,
                          fontStyle: accion
                              ? FontStyle.italic
                              : FontStyle.normal,
                          color: accion ? kTintaSuave : kTinta,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// La burbuja: rectángulo redondeado con la esquina de arriba mordida del lado
/// de quien habla, que es lo que la vuelve un mensaje y no una tarjeta.
class _PintorBurbuja extends CustomPainter {
  final Color fondo;
  final bool aLaDerecha;

  const _PintorBurbuja({required this.fondo, required this.aLaDerecha});

  @override
  void paint(Canvas canvas, Size size) {
    const r = Radius.circular(14);
    const punta = Radius.circular(3);
    final cuerpo = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: aLaDerecha ? r : punta,
      topRight: aLaDerecha ? punta : r,
      bottomLeft: r,
      bottomRight: r,
    );
    final camino = Path()..addRRect(cuerpo);
    canvas.drawShadow(camino, kTinta.withValues(alpha: .45), 4, false);
    canvas.drawPath(camino, Paint()..color = fondo);
    canvas.drawPath(
      camino,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = kTinta,
    );
  }

  @override
  bool shouldRepaint(_PintorBurbuja v) =>
      v.fondo != fondo || v.aLaDerecha != aLaDerecha;
}

class _Placeholder extends StatelessWidget {
  final PanelArte panel;
  const _Placeholder({required this.panel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined, size: 34, color: kMadera),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kPapelClaro,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'assets/comic/${panel.archivo}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: kOroBorde,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            panel.boceto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: kTintaSuave,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Marco de una viñeta.
///
/// La imagen se muestra **entera** (`BoxFit.contain`), nunca recortada ni
/// deformada, así que no hace falta que todas midan lo mismo. El espacio que
/// sobra se rellena con la MISMA imagen ampliada y desenfocada, oscurecida: el
/// relleno combina siempre con esa viñeta en particular, sin tener que elegir
/// un color por escena.
///
/// La caja es más alta en pantallas angostas para que en teléfono el arte se
/// vea grande.
/// La viñeta enmarcada.
///
/// El relleno de los costados ya no es la misma imagen desenfocada con un velo
/// plano: eso se leía como una foto centrada. Ahora es papel con un viñeteado
/// que oscurece los bordes, que es lo que hace que parezca impresa.
class _MarcoVineta extends StatelessWidget {
  final PanelArte panel;
  final double acercamiento;

  const _MarcoVineta({required this.panel, this.acercamiento = 1});

  @override
  Widget build(BuildContext context) {
    final ruta = panel.assetMovil;

    return LayoutBuilder(
      builder: (context, cs) {
        final angosto = cs.maxWidth < 520;
        return AspectRatio(
          aspectRatio: angosto ? 4 / 3 : 16 / 9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: kPapel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kMaderaOscura, width: 2.5),
              boxShadow: sombraPapel(y: 3, desenfoque: 6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Papel, no imagen desenfocada.
                  const ColoredBox(color: kPapel),
                  Opacity(
                    opacity: .28,
                    child: ImagenUi(
                      asset: fondoPapelTextura,
                      fit: BoxFit.cover,
                      respaldo: (_) => const SizedBox.shrink(),
                    ),
                  ),
                  Transform.scale(
                    scale: acercamiento,
                    child: Image.asset(
                      ruta,
                      fit: BoxFit.contain,
                      errorBuilder: (_, e, s) => _Placeholder(panel: panel),
                    ),
                  ),
                  // Viñeteado: oscurece los bordes y hunde la escena.
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: .95,
                          colors: [Color(0x00000000), Color(0x4A2A1F16)],
                          stops: [.62, 1],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
