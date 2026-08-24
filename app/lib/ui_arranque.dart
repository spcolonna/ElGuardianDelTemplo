import 'package:flutter/material.dart';

import 'app_state.dart';
import 'audio.dart';
import 'rutas.dart';
import 'ui_common.dart';
import 'ui_game.dart';
import 'ui_shell.dart';
import 'ui_splash.dart';
import 'ui_texturas.dart';
import 'ui_tutorial.dart';

/// La ruta raíz: splash, y después el cómic de apertura y el tutorial, que
/// sólo se ven la primera vez.
///
/// Esto NO es navegación, es estado: por eso vive en una sola ruta en vez de
/// repartirse en tres. Cuando termina, reemplaza la raíz por el patio para que
/// el back del sistema no devuelva al splash.
class ArranqueScreen extends StatefulWidget {
  const ArranqueScreen({super.key});

  @override
  State<ArranqueScreen> createState() => _ArranqueScreenState();
}

class _ArranqueScreenState extends State<ArranqueScreen> {
  bool _splashListo = false;

  @override
  void initState() {
    super.initState();
    // El splash tiene una ventana de espera natural: se aprovecha para meter
    // las texturas en caché y que el patio no aparezca a medio pintar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) precargarTexturas(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    if (!_splashListo || !app.listo) {
      return Scaffold(
        backgroundColor: kFondoSplash,
        body: SplashScreen(
          titulo: app.textos.nombre,
          onTerminar: () => setState(() => _splashListo = true),
        ),
      );
    }

    // El cómic de apertura y el tutorial viven dentro de GameScreen porque
    // comparten su estado de partida riggeada.
    if (!app.introVista || !app.tutorialVisto) {
      return Scaffold(
        body: SafeArea(child: GameScreen(onSalir: () => _alPatio(context))),
      );
    }

    // Ya vio todo: el patio pasa a ser la pantalla base.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _alPatio(context);
    });
    return const Scaffold(backgroundColor: kFondoSplash);
  }

  void _alPatio(BuildContext context) {
    AppScope.of(context).juego = null;
    Navigator.of(context).pushReplacementNamed(R.patio);
  }
}

const kFondoSplash = Color(0xFFF7F1E1);

/// La partida, dentro del shell. Salir vuelve al patio y pide confirmación si
/// hay una partida en curso.
class PartidaScreen extends StatelessWidget {
  const PartidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final enCurso = app.juego != null && !app.juego!.terminado;

    void volver() {
      app.juego = null;
      Navigator.of(context).popUntil(ModalRoute.withName(R.patio));
    }

    // Sin marco y sin cartel: la mesa usa la pantalla entera. El paisaje del
    // fondo sí acompaña a la fase — pero a `faseEscenica`, que va un paso
    // atrás y sólo avanza cuando el cómic del interludio se cerró. Si siguiera
    // a `juego.fase` la transición pasaría tapada por el cómic.
    return PantallaLibre(
      bloquearSalida: enCurso,
      onSalir: volver,
      fondo: fondoDeFase[app.faseEscenica] ?? fondoAlba,
      claveFondo: app.faseEscenica.name,
      // La música entra recién cuando el paisaje nuevo terminó de entrar: las
      // dos cosas juntas son un solo gesto de "cambió el momento del día".
      onTransicion: () => app.audio.ponerPista(
        pistaDeFase[app.faseEscenica] ?? Pista.alba,
      ),
      cuerpo: GameScreen(onSalir: volver),
    );
  }
}

/// El tutorial como ruta propia, para poder verlo desde Ajustes.
class TutorialRuta extends StatelessWidget {
  const TutorialRuta({super.key});

  @override
  Widget build(BuildContext context) {
    return PantallaTemplo(
      conVolver: true,
      cuerpo: TutorialScreen(onTerminar: () => Navigator.of(context).pop()),
    );
  }
}
