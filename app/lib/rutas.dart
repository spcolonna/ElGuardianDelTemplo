import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'ui_admin.dart';
import 'ui_ajustes.dart';
import 'ui_arranque.dart';
import 'ui_home.dart';
import 'ui_logros.dart';
import 'ui_modos.dart';
import 'ui_progreso.dart';
import 'ui_reglas.dart';
import 'ui_shell.dart';

/// Rutas nombradas. Son nueve pantallas planas, sin anidación ni deep links
/// reales, así que no hace falta un router declarativo: `onGenerateRoute`
/// alcanza y no pelea con la máquina de estados del arranque (intro/tutorial).
///
/// El beneficio concreto sobre el `Navigator.push` imperativo que había antes:
/// URLs decentes en web, `popUntil` por nombre, y que construir una pantalla
/// deje de ser trabajo del widget de arranque.
abstract final class R {
  static const raiz = '/';
  static const patio = '/patio';
  static const partida = '/partida';
  static const modos = '/modos';
  static const logros = '/logros';
  static const progreso = '/progreso';
  static const reglas = '/reglas';
  static const tutorial = '/tutorial';
  static const ajustes = '/ajustes';

  /// Sólo existe en web: en el teléfono la ruta no resuelve y el jugador
  /// nunca puede llegar al panel de balance.
  static const admin = '/admin';
}

Route<dynamic> generarRuta(RouteSettings ajustes) {
  final nombre = ajustes.name ?? R.raiz;

  if (nombre == R.admin) {
    // En mobile cae al patio, no al admin.
    return _ruta(kIsWeb ? const AdminScreen() : const PatioScreen(), ajustes);
  }

  final pantalla = switch (nombre) {
    R.raiz => const ArranqueScreen(),
    R.patio => const PatioScreen(),
    R.partida => const PartidaScreen(),
    R.modos => const ModosScreen(),
    R.logros => const LogrosScreen(),
    // Progreso y Reglas devuelven su cuerpo scrolleable pelado: el shell les
    // pone el marco, el título y el Scaffold (sin el cual no hay Material y
    // los Switch y los botones de Material explotan).
    R.progreso => const _EnShell(
      clave: 'nav.progreso',
      cuerpo: ProgresoScreen(),
    ),
    R.reglas => const _EnShell(clave: 'nav.reglas', cuerpo: ReglasScreen()),
    R.tutorial => const TutorialRuta(),
    R.ajustes => const AjustesScreen(),
    // Una ruta desconocida (típico en web) vuelve al patio, no al arranque:
    // reproducir el splash por un typo en la URL sería raro.
    _ => const PatioScreen(),
  };

  return _ruta(pantalla, ajustes);
}

/// Envuelve una pantalla vieja —de las que devuelven sólo su contenido— en el
/// marco del juego.
class _EnShell extends StatelessWidget {
  final String clave;
  final Widget cuerpo;
  const _EnShell({required this.clave, required this.cuerpo});

  @override
  Widget build(BuildContext context) {
    final t = TextosUi.de(AppScope.of(context).idioma);
    return PantallaTemplo(titulo: t(clave), conVolver: true, cuerpo: cuerpo);
  }
}

/// Transición suave entre pantallas: fundido con un desplazamiento corto.
Route<T> _ruta<T>(Widget destino, RouteSettings ajustes) => PageRouteBuilder<T>(
  settings: ajustes,
  transitionDuration: const Duration(milliseconds: 320),
  pageBuilder: (_, a, b) => destino,
  transitionsBuilder: (_, anim, sec, hijo) {
    final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curva,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, .035),
          end: Offset.zero,
        ).animate(curva),
        child: hijo,
      ),
    );
  },
);
