import 'dart:math';

import 'package:flutter/material.dart';
import 'ui_kit.dart';

import 'app_state.dart';
import 'engine.dart';
import 'l10n.dart';
import 'tutorial.dart';

import 'ui_carta.dart';
import 'ui_common.dart';

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

class _TutorialScreenState extends State<TutorialScreen> {
  Juego? _j;
  Juego get j => _j!;
  int paso = 0;
  bool accionHecha = false;

  final _claveCarta = GlobalKey();
  final _clavePila = GlobalKey();
  Rect? _rectCarta;

  // La partida se arma acá y no en initState porque necesita leer AppScope
  // (el tema y el idioma), y un InheritedWidget todavía no está disponible
  // durante initState. La guarda evita rearmarla en cada cambio de
  // dependencias, que reiniciaría el tutorial a mitad de camino.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_j != null) return;
    final app = AppScope.of(context);
    _j = Juego(
      cfg: configTutorial(),
      contenido: contenidoTutorial(app.tema, app.idioma),
      rng: Random(1),
      barajar: false,
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _medirCarta());

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
          child: Row(
            children: [
              // El que cede es el título: el Expanded lo estira contra el
              // resto del renglón, de paso empujando al botón contra el borde
              // derecho, y si no entra se corta él en vez de desbordar.
              Expanded(
                child: Text(
                  t('tutorial.titulo'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${paso + 1}/${guionTutorial.length}',
                style: const TextStyle(color: kTintaSuave, fontSize: 13),
              ),
              // Sin flex: el botón va pegado a la derecha, como en el cómic.
              TextButton(
                onPressed: widget.onTerminar,
                child: Text(t('tutorial.saltar'), maxLines: 1),
              ),
            ],
          ),
        ),

        // ----------------------------------------------------------- la mesa
        Expanded(
          child: Stack(
            key: _clavePila,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _Resalte(
                        activo: foco == FocoTutorial.energia,
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
                      activo: foco == FocoTutorial.botones,
                      child: _botones(t),
                    ),
                    if (j.mesa.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _Resalte(
                        activo: foco == FocoTutorial.mesa,
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
                        activo: foco == FocoTutorial.descarte,
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
                    child: CustomPaint(painter: _Spotlight(hueco: hueco)),
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
                      actual.texto(app.idioma),
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
class _Spotlight extends CustomPainter {
  final Rect? hueco;
  const _Spotlight({required this.hueco});

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
        ..strokeWidth = 3
        ..color = kOroBorde,
    );
  }

  @override
  bool shouldRepaint(_Spotlight v) => v.hueco != hueco;
}

/// Marco que resalta un widget (los pasos que hablan de botones, no de la
/// carta). Convive con el spotlight.
class _Resalte extends StatelessWidget {
  final bool activo;
  final Widget child;
  const _Resalte({required this.activo, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: activo ? kOroBorde : Colors.transparent,
          width: 2,
        ),
        boxShadow: activo
            ? [
                BoxShadow(
                  color: kOroBorde.withValues(alpha: .25),
                  blurRadius: 18,
                ),
              ]
            : null,
      ),
      child: Opacity(opacity: activo ? 1 : 0.55, child: child),
    );
  }
}
