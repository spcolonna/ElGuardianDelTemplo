import 'package:flutter/material.dart';
import 'ui_kit.dart';

import 'app_state.dart';
import 'models.dart';
import 'reglas_texto.dart';
import 'ui_common.dart';

/// Hoja de reglas viva: se regenera con los valores actuales de Balance.
class ReglasScreen extends StatelessWidget {
  const ReglasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final c = app.cfg;

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      children: [
        const Text(
          'Refleja los valores que tengas en Balance.',
          style: TextStyle(color: kTinta, fontSize: 13),
        ),
        const SizedBox(height: 20),
        // La prosa la genera `reglas_texto.dart`, que es Dart puro y también
        // alimenta el reglamento impreso. Duplicarla acá sería garantizar que
        // la app y el papel digan cosas distintas al primer rebalanceo.
        for (final b in reglasDe(c, app.contenido)) _bloque(b.titulo, b.lineas),
        const SizedBox(height: 12),
        _tabla(context, app),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _bloque(String titulo, List<String> lineas) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            // Estos títulos eran dorado claro sobre papel claro: contra el
            // fondo daban menos de 2:1 y prácticamente no se leían. La madera
            // oscura mantiene el aire cálido y sí contrasta.
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kMaderaOscura,
            ),
          ),
          const SizedBox(height: 6),
          for (final l in lineas)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $l',
                style: const TextStyle(fontSize: 13.5, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabla(BuildContext context, AppState app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final fase in [Fase.alba, Fase.mediodia, Fase.ocaso])
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mazo del ${fase.nombre}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorTexto(colorFase(fase)),
                  ),
                ),
                const SizedBox(height: 6),
                for (final p in app.contenido.peligrosDe(fase))
                  Text(
                    '${p.nombre} — Poder ${p.poder}, Daño ${p.dano}, '
                    'gratis ${p.cartasGratis} → ${p.recompensa.nombre} (${p.recompensa.poder})'
                    '${p.recompensa.efecto.vacio ? '' : ', ${p.recompensa.efecto.texto}'}',
                    style: const TextStyle(fontSize: 12.5, height: 1.5),
                  ),
              ],
            ),
          ),
        Text(
          'Jefes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorTexto(kJefe),
          ),
        ),
        const SizedBox(height: 6),
        for (final j in app.contenido.jefes)
          Text(
            '${j.nombre} — Poder ${j.poder}, Daño ${j.dano}, gratis ${j.cartasGratis}',
            style: const TextStyle(fontSize: 12.5, height: 1.5),
          ),
      ],
    );
  }
}
