import 'package:flutter/material.dart';
import 'ui_kit.dart';

import 'app_state.dart';
import 'bot.dart';
import 'models.dart';
import 'ui_common.dart';

class SimScreen extends StatefulWidget {
  const SimScreen({super.key});

  @override
  State<SimScreen> createState() => _SimScreenState();
}

class _SimScreenState extends State<SimScreen> {
  int partidas = 500;
  bool corriendo = false;
  ResumenSim? resumen;
  List<(String, ResumenSim)> comparativa = [];

  Future<void> _correr(AppState app) async {
    setState(() => corriendo = true);
    await Future.delayed(const Duration(milliseconds: 30));
    final r = simularLote(
      cfg: app.cfg.clone(),
      contenido: app.contenido,
      partidas: partidas,
    );
    setState(() {
      resumen = r;
      corriendo = false;
    });
  }

  Future<void> _barridoEnergia(AppState app) async {
    setState(() => corriendo = true);
    await Future.delayed(const Duration(milliseconds: 30));
    final res = <(String, ResumenSim)>[];
    for (final e in [12, 15, 18, 20, 22, 25, 30]) {
      final c = app.cfg.clone()
        ..energiaInicial = e
        ..energiaMaxima = e > app.cfg.energiaMaxima ? e : app.cfg.energiaMaxima;
      res.add((
        'Energía inicial $e',
        simularLote(cfg: c, contenido: app.contenido, partidas: partidas),
      ));
    }
    setState(() {
      comparativa = res;
      corriendo = false;
    });
  }

  Future<void> _barridoJefes(AppState app) async {
    setState(() => corriendo = true);
    await Future.delayed(const Duration(milliseconds: 30));
    final res = <(String, ResumenSim)>[];
    for (final n in [1, 2, 3]) {
      final c = app.cfg.clone()..cantidadJefes = n;
      res.add((
        '$n jefe(s) final(es)',
        simularLote(cfg: c, contenido: app.contenido, partidas: partidas),
      ));
    }
    setState(() {
      comparativa = res;
      corriendo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Simulador',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Un bot juega N partidas con la configuración actual: roba gratis siempre, '
          'paga sólo si el robo cuesta menos que el daño, medita cuando le sobra Energía '
          'y se juega la vida contra los jefes. Sirve para ver si la dificultad cierra.',
          style: TextStyle(color: kTintaSuave, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('Partidas: '),
            Expanded(
              child: Slider(
                value: partidas.toDouble(),
                min: 100,
                max: 5000,
                divisions: 49,
                label: '$partidas',
                onChanged: (v) => setState(() => partidas = v.round()),
              ),
            ),
            SizedBox(width: 60, child: Text('$partidas')),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: corriendo ? null : () => _correr(app),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Simular configuración actual'),
            ),
            OutlinedButton.icon(
              onPressed: corriendo ? null : () => _barridoEnergia(app),
              icon: const Icon(Icons.bolt),
              label: const Text('Barrido de Energía inicial'),
            ),
            OutlinedButton.icon(
              onPressed: corriendo ? null : () => _barridoJefes(app),
              icon: const Icon(Icons.local_fire_department),
              label: const Text('Barrido de cantidad de jefes'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (corriendo) const LinearProgressIndicator(),
        if (resumen != null && !corriendo) _resumenView(resumen!),
        if (comparativa.isNotEmpty && !corriendo) ...[
          const SizedBox(height: 12),
          for (final (nombre, r) in comparativa) _filaComparativa(nombre, r),
          const SizedBox(height: 16),
          const Text(
            'Zona sana para un solitario tipo Friday: 25–45% de victorias.',
            style: TextStyle(color: kTintaSuave, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _resumenView(ResumenSim r) {
    final wr = r.winRate;
    final juicio = wr < .10
        ? 'Demasiado difícil: el bot casi nunca gana.'
        : wr < .25
        ? 'Difícil. Puede estar bien para jugadores expertos.'
        : wr > .65
        ? 'Demasiado fácil: falta tensión.'
        : wr > .45
        ? 'Accesible. Buen punto de entrada.'
        : 'Zona ideal para un solitario de este tipo.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: kMadera),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${(wr * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: wr < .2 ? kOcaso : (wr > .6 ? kMediodia : kAlba),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r.victorias} victorias en ${r.partidas} partidas'),
                    Text(
                      juicio,
                      style: const TextStyle(color: kTintaSuave, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Etiqueta('Turnos prom. ${r.turnosPromedio.toStringAsFixed(1)}'),
              Etiqueta(
                'Energía final prom. ${r.energiaPromedioFinal.toStringAsFixed(1)}',
              ),
              Etiqueta(
                'Cartas eliminadas prom. ${r.cartasEliminadasProm.toStringAsFixed(1)}',
              ),
              Etiqueta(
                'Jefes derrotados prom. ${r.jefesPromedio.toStringAsFixed(2)}',
                color: kJefe,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '¿Dónde muere el jugador?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          for (final f in [Fase.alba, Fase.mediodia, Fase.ocaso, Fase.jefes])
            _barra(
              f.nombre,
              r.muertesPorFase[f.nombre] ?? 0,
              r.partidas,
              colorFase(f),
            ),
        ],
      ),
    );
  }

  Widget _barra(String label, int valor, int total, Color color) {
    final pct = total == 0 ? 0.0 : valor / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 10,
                backgroundColor: kMadera.withValues(alpha: .28),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '  $valor (${(pct * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaComparativa(String nombre, ResumenSim r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 200, child: Text(nombre)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: r.winRate,
                minHeight: 14,
                backgroundColor: kMadera.withValues(alpha: .28),
                valueColor: AlwaysStoppedAnimation(
                  r.winRate < .2
                      ? kOcaso
                      : (r.winRate > .6 ? kMediodia : kAlba),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              '  ${(r.winRate * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
