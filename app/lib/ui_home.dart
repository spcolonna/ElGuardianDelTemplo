import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'progreso.dart';
import 'rutas.dart';
import 'ui_common.dart';
import 'ui_kit.dart';
import 'ui_marco.dart';
import 'ui_texturas.dart';
import 'ui_shell.dart';

/// El Patio del Templo: la pantalla de inicio.
///
/// Sigue la estructura del mock: el personaje en su marco con la placa de
/// nombre, paneles de estado debajo, el botón de acción dominando la pantalla,
/// y los accesos secundarios en la barra de madera del pie.
class PatioScreen extends StatelessWidget {
  const PatioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    final p = app.progreso;
    final hecho = p.hoyCompletado(DateTime.now());

    // Al volver de una partida la música sigue en la pista de la fase.
    app.audio.pistaDeMenu();

    // El marco ilustrado manda: el título va en el cartel colgante, los tres
    // accesos en la tabla del pie, y JUGAR en el botón dorado. La tabla da
    // para tres y ni uno más, así que Ajustes se fue al botón de la esquina.
    return Scaffold(
      backgroundColor: kPapel,
      body: Material(
        type: MaterialType.transparency,
        child: FondoEscena(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: MarcoJuego(
                  titulo: app.textos.nombre,
                  // El marco ya dibuja un monje ahí: es la ficha del jugador.
                  onEsquina: () => _ir(context, R.progreso),
                  textoAccion: t('patio.jugar').toUpperCase(),
                  onAccion: () {
                    app.audio.arrancarMusica();
                    _ir(context, R.modos);
                  },
                  accesos: [
                    AccesoTabla(
                      texto: t('nav.logros'),
                      icono: Icons.military_tech,
                      destacado: app.logros.desbloqueados.isNotEmpty,
                      onTap: () => _ir(context, R.logros),
                    ),
                    AccesoTabla(
                      texto: t('nav.reglas'),
                      icono: Icons.menu_book,
                      onTap: () => _ir(context, R.reglas),
                    ),
                    AccesoTabla(
                      texto: t('nav.ajustes'),
                      icono: Icons.settings,
                      onTap: () => _ir(context, R.ajustes),
                    ),
                  ],
                  // Mientras el marco no esté en el build, el patio se ve con
                  // el shell de siempre: la app nunca queda esperando arte.
                  respaldo: (context) =>
                      _patioSinMarco(context, app, t, p, hecho),
                  contenido: _contenido(context, app, t, p, hecho),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// El interior del marco: el personaje en su cuadro y el pergamino con los
  /// dos datos que importan.
  Widget _contenido(
    BuildContext context,
    AppState app,
    TextosUi t,
    Progreso p,
    bool hecho,
  ) {
    return LayoutBuilder(
      builder: (context, cs) {
        // El pergamino es apaisado (1.44) y manda su alto desde el ancho
        // disponible; lo que sobra se lo lleva el personaje.
        final anchoPergamino = cs.maxWidth;
        final altoPergamino =
            anchoPergamino / (Huecos.pergaminoFuente.aspectRatio);
        // El personaje ya no se estira: ocupa lo suyo y el bloque entero
        // queda centrado en el hueco del marco.
        final altoPersonaje = (cs.maxHeight - altoPergamino - 8).clamp(
          120.0,
          math.min(cs.maxHeight * .46, 290.0).toDouble(),
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Center(
                child: SizedBox(
                  height: altoPersonaje,
                  child: MarcoConHueco(
                    asset: marcoPersonaje,
                    fuente: Huecos.marcoPersonajeFuente,
                    hueco: Huecos.marcoPersonajeHueco,
                    respaldo: (_) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: kMadera.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kMaderaOscura, width: 3),
                      ),
                    ),
                    // El Novato es más angosto que el hueco y se apoya en el
                    // piso del cuadro, como si estuviera parado adentro.
                    child: ImagenUi(
                      asset: personaje,
                      fit: BoxFit.contain,
                      respaldo: (_) => const Center(
                        child: Icon(
                          Icons.self_improvement,
                          size: 72,
                          color: kMaderaOscura,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            MarcoConHueco(
              asset: pergamino,
              fuente: Huecos.pergaminoFuente,
              hueco: Huecos.pergaminoHueco,
              respaldo: (_) => DecoratedBox(
                decoration: BoxDecoration(
                  color: kPapelClaro,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kMaderaOscura, width: 2),
                ),
              ),
              child: _DatosPergamino(app: app, t: t, progreso: p, hecho: hecho),
            ),
          ],
        );
      },
    );
  }

  /// Respaldo dibujado, para cuando falta `marco.png`.
  Widget _patioSinMarco(
    BuildContext context,
    AppState app,
    TextosUi t,
    Progreso p,
    bool hecho,
  ) {
    return PantallaTemplo(
      titulo: app.textos.nombre,
      // El patio no vela: su contenido es un cuadro y un pergamino con fondo
      // propio, y el paisaje detrás es medio punto de la pantalla.
      velarContenido: false,
      textoAccion: t('patio.jugar').toUpperCase(),
      onAccion: () {
        app.audio.arrancarMusica();
        _ir(context, R.modos);
      },
      barraInferior: BarraMadera(
        accesos: [
          AccesoMadera(
            texto: t('nav.logros'),
            icono: Icons.military_tech,
            destacado: app.logros.desbloqueados.isNotEmpty,
            onTap: () => _ir(context, R.logros),
          ),
          AccesoMadera(
            texto: t('nav.progreso'),
            icono: Icons.calendar_month,
            onTap: () => _ir(context, R.progreso),
          ),
          AccesoMadera(
            texto: t('nav.reglas'),
            icono: Icons.menu_book,
            onTap: () => _ir(context, R.reglas),
          ),
          AccesoMadera(
            texto: t('nav.ajustes'),
            icono: Icons.settings,
            onTap: () => _ir(context, R.ajustes),
          ),
        ],
      ),
      cuerpo: _contenido(context, app, t, p, hecho),
    );
  }

  void _ir(BuildContext context, String ruta) {
    tocarUi(context);
    Navigator.of(context).pushNamed(ruta);
  }
}

/// Los siete días de la semana en chico. La usan el patio y la pantalla de
/// progreso, así que vive acá y no privada.
class Semaforo extends StatelessWidget {
  final int racha;
  final bool hoyHecho;
  final double tamano;
  const Semaforo({
    super.key,
    required this.racha,
    required this.hoyHecho,
    this.tamano = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < Progreso.diasParaLogro; i++)
          Container(
            width: tamano,
            height: tamano,
            margin: EdgeInsets.symmetric(horizontal: tamano * .18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < racha
                  ? kNaranja
                  : (i == racha && !hoyHecho
                        ? kOro.withValues(alpha: .55)
                        : kMadera.withValues(alpha: .30)),
              border: Border.all(color: kMaderaOscura, width: 1),
            ),
          ),
      ],
    );
  }
}

/// Lo que entra en el pergamino.
///
/// El hueco útil de `paper.png` es apenas el 52% del ancho y el 49% del alto
/// del asset —los rollos y el marco se comen el resto—, así que en pantalla
/// son unos 185x120 pt. Ahí no entran dos paneles con texto descriptivo: dos
/// columnas con el número grande sí, y es lo que el jugador mira igual.
class _DatosPergamino extends StatelessWidget {
  final AppState app;
  final TextosUi t;
  final Progreso progreso;
  final bool hecho;

  const _DatosPergamino({
    required this.app,
    required this.t,
    required this.progreso,
    required this.hecho,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _Dato(
            icono: progreso.logroActivo
                ? Icons.emoji_events
                : Icons.local_fire_department,
            color: progreso.logroActivo ? kOroBorde : kNaranja,
            valor: '${progreso.racha}/${Progreso.diasParaLogro}',
            etiqueta: t('nav.progreso'),
            onTap: () {
              tocarUi(context);
              Navigator.of(context).pushNamed(R.progreso);
            },
            pie: Semaforo(racha: progreso.racha, hoyHecho: hecho, tamano: 6),
          ),
        ),
        Container(
          width: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: kMaderaOscura.withValues(alpha: .28),
        ),
        Expanded(
          child: _Dato(
            icono: Icons.military_tech,
            color: kJefe,
            valor: '${app.logros.desbloqueados.length}/${app.logros.total}',
            etiqueta: t('nav.logros'),
            onTap: () {
              tocarUi(context);
              Navigator.of(context).pushNamed(R.logros);
            },
          ),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String valor;
  final String etiqueta;
  final VoidCallback onTap;
  final Widget? pie;

  const _Dato({
    required this.icono,
    required this.color,
    required this.valor,
    required this.etiqueta,
    required this.onTap,
    this.pie,
  });

  @override
  Widget build(BuildContext context) {
    return BotonPulsable(
      onTap: onTap,
      escala: .93,
      resalte: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 20, color: color),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valor,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: fuenteTitulo,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTinta,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                etiqueta.toUpperCase(),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4,
                  color: kMaderaOscura,
                ),
              ),
            ),
            // Las dos columnas reservan el mismo alto acá abajo, tenga o no
            // contenido: si no, la que trae el semáforo empuja sus números
            // fuera de línea con los de la otra.
            const SizedBox(height: 4),
            SizedBox(height: 10, child: Center(child: pie ?? const SizedBox())),
          ],
        ),
      ),
    );
  }
}
