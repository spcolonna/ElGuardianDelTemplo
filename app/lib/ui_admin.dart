import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'config_store.dart';
import 'ui_balance.dart';
import 'ui_kit.dart';
import 'ui_sim.dart';

/// Panel de administración: Balance y Simulador.
///
/// Sólo se llega por `/#/admin` en web. En mobile la ruta no existe, así que
/// el jugador nunca lo ve y el juego queda limpio.
///
/// Como el admin es web y el juego corre en el teléfono, la configuración
/// viaja por archivo: se exporta el JSON desde acá y se pega en
/// `assets/config.json`. Ver [ConfigStore].
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final hayOverride = ConfigStore.hayOverride(app.prefs.crudo);

    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E24),
        foregroundColor: Colors.white,
        title: const Text('Admin · balance y simulación'),
        bottom: TabBar(
          controller: _tabs,
          labelColor: kOro,
          indicatorColor: kOro,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.tune), text: 'Balance'),
            Tab(icon: Icon(Icons.query_stats), text: 'Simulador'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _exportar(context, app),
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Exportar config.json'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _Aviso(hayOverride: hayOverride, app: app),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [BalanceScreen(), SimScreen()],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportar(BuildContext context, AppState app) async {
    final json = ConfigStore.exportar(app.cfg);
    await Clipboard.setData(ClipboardData(text: json));
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Copiado al portapapeles'),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pegá esto en app/assets/config.json y recompilá. Recién ahí '
                'el teléfono va a jugar con estos valores.',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black26,
                child: SelectableText(
                  json,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }
}

/// Deja claro si lo que se está jugando viene del archivo o de un ajuste
/// local sin guardar. Es el error fácil de cometer con este esquema.
class _Aviso extends StatelessWidget {
  final bool hayOverride;
  final AppState app;
  const _Aviso({required this.hayOverride, required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: hayOverride
          ? kNaranja.withValues(alpha: .18)
          : Colors.white.withValues(alpha: .04),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            hayOverride ? Icons.warning_amber : Icons.check_circle_outline,
            size: 18,
            color: hayOverride ? kNaranja : Colors.white38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hayOverride
                  ? 'Estás jugando con ajustes locales, NO con assets/config.json. '
                        'Exportá y pegá el JSON para que el cambio llegue al teléfono.'
                  : 'Jugando con los valores de assets/config.json.',
              style: const TextStyle(fontSize: 12.5, color: Colors.white70),
            ),
          ),
          if (hayOverride)
            TextButton(
              onPressed: () async {
                await ConfigStore.borrarOverride(app.prefs.crudo);
                await app.restaurarContenido();
              },
              child: const Text('Descartar ajustes locales'),
            ),
        ],
      ),
    );
  }
}
