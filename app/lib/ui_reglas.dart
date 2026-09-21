import 'package:flutter/material.dart';
import 'ui_kit.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'models.dart';
import 'reglas_texto.dart';
import 'rutas.dart';
import 'ui_common.dart';
import 'ui_shell.dart';

/// Hoja de reglas viva: se regenera con los valores actuales de Balance.
class ReglasScreen extends StatelessWidget {
  const ReglasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final c = app.cfg;
    final t = TextosUi.de(app.idioma);

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      children: [
        Text(
          t('reglas.ui.bajada'),
          style: const TextStyle(color: kTinta, fontSize: 13),
        ),
        const SizedBox(height: 14),
        // La colección entra por acá y no por el patio: la tabla del marco da
        // para tres accesos y ya están los tres. Además es el lugar donde el
        // jugador viene a entender el juego, y mirar las cartas es eso.
        // De borde a borde y en dorado, como el de comprar en la tienda: es
        // la única acción de esta pantalla y tiene que leerse como tal. El
        // `width` va explícito aunque el `ListView` ya lo estire, para que no
        // dependa de quién sea el padre el día que esto se mueva de lugar.
        SizedBox(
          width: double.infinity,
          child: BotonMadera(
            texto: t('nav.contenido'),
            icono: Icons.style,
            principal: true,
            onTap: () {
              tocarUi(context);
              Navigator.of(context).pushNamed(R.coleccion);
            },
          ),
        ),
        const SizedBox(height: 20),
        // La prosa la genera `reglas_texto.dart`, que es Dart puro y también
        // alimenta el reglamento impreso. Duplicarla acá sería garantizar que
        // la app y el papel digan cosas distintas al primer rebalanceo.
        for (final b in reglasDe(c, app.contenido, t))
          _bloque(b.titulo, b.lineas),
        const SizedBox(height: 12),
        _tabla(context, app, t),
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

  Widget _tabla(BuildContext context, AppState app, TextosUi t) {
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
                  t.con('reglas.ui.mazoDe', {'fase': app.textos.fase(fase)}),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorTexto(colorFase(fase)),
                  ),
                ),
                const SizedBox(height: 6),
                for (final p in app.contenido.peligrosDe(fase))
                  Text(
                    t.con('reglas.ui.peligro', {
                          'nombre': p.nombre,
                          'poder': p.poder,
                          'dano': p.dano,
                          'gratis': p.cartasGratis,
                          'tecnica': p.recompensa.nombre,
                          'tecnicaPoder': p.recompensa.poder,
                        }) +
                        (p.recompensa.efecto.vacio
                            ? ''
                            : ', '
                                  '${p.recompensa.efecto.textoCon(t, app.textos.recurso)}'),
                    style: const TextStyle(fontSize: 12.5, height: 1.5),
                  ),
              ],
            ),
          ),
        Text(
          t('reglas.ui.jefes'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorTexto(kJefe),
          ),
        ),
        const SizedBox(height: 6),
        for (final j in app.contenido.jefes)
          Text(
            t.con('reglas.ui.jefe', {
              'nombre': j.nombre,
              'poder': j.poder,
              'dano': j.dano,
              'gratis': j.cartasGratis,
            }),
            style: const TextStyle(fontSize: 12.5, height: 1.5),
          ),
      ],
    );
  }
}
