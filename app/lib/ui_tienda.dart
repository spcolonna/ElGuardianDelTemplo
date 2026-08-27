import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'ui_kit.dart';
import 'ui_shell.dart';

/// El banner y la hoja de compra del templo completo.
///
/// Está armado con las piezas del juego —`PanelPapel`, `BotonMadera`,
/// `Pastilla`— a propósito: un banner de tienda con estética de tienda se lee
/// como algo pegado encima, y este juego tiene una sola voz visual.

/// Lo que se abre al comprar. Se dice tres veces —en el banner, en la hoja y
/// en el candado— y siempre igual.
List<Widget> _promesas(TextosUi t) => [
  Pastilla(
    t('tienda.caminos'),
    icono: Icons.terrain,
    color: kMaderaOscura,
    compacta: true,
  ),
  Pastilla(
    t('tienda.sinAvisos'),
    icono: Icons.block,
    color: kRojo,
    compacta: true,
  ),
  Pastilla(
    t('tienda.extras'),
    icono: Icons.auto_awesome,
    color: kVerde,
    compacta: true,
  ),
  Pastilla(
    t('tienda.jefesLibres'),
    icono: Icons.local_fire_department,
    color: kNaranja,
    compacta: true,
  ),
];

/// El banner de compra. Va arriba de la pantalla de modos, sólo si no compró.
class BannerCompra extends StatelessWidget {
  const BannerCompra({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    if (app.premium) return const SizedBox.shrink();

    return PanelPapel(
      onTap: () => abrirTienda(context),
      color: kOro.withValues(alpha: .18),
      borde: kOroBorde,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_open, color: kMaderaOscura, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t('tienda.titulo'),
                  style: const TextStyle(
                    fontFamily: fuenteTitulo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kMaderaOscura,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: kMaderaOscura),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t('tienda.gancho'),
            style: const TextStyle(fontSize: 12.5, height: 1.3, color: kTinta),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: _promesas(t)),
        ],
      ),
    );
  }
}

/// El candado que reemplaza al control bloqueado. Chico, y siempre el mismo:
/// el jugador tiene que aprender de una sola vez qué significa.
class Candado extends StatelessWidget {
  const Candado({super.key});

  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.lock, size: 20, color: kMaderaOscura);
}

/// La hoja de compra. Devuelve `true` si el jugador quedó con el juego abierto.
Future<bool> abrirTienda(BuildContext context) async {
  tocarUi(context);
  final app = AppScope.of(context);
  if (app.premium) return true;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: kPapelClaro,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (hoja) => _HojaTienda(app: app),
  );
  return app.premium;
}

class _HojaTienda extends StatefulWidget {
  final AppState app;
  const _HojaTienda({required this.app});

  @override
  State<_HojaTienda> createState() => _HojaTiendaState();
}

class _HojaTiendaState extends State<_HojaTienda> {
  @override
  void initState() {
    super.initState();
    widget.app.tienda.addListener(_refrescar);
  }

  @override
  void dispose() {
    widget.app.tienda.removeListener(_refrescar);
    super.dispose();
  }

  void _refrescar() {
    if (!mounted) return;
    setState(() {});
    // Comprado: la hoja ya no tiene nada que ofrecer.
    if (widget.app.premium) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final t = TextosUi.de(app.idioma);
    final tienda = app.tienda;

    final puedeComprar = tienda.disponible && !tienda.ocupado;
    final texto = tienda.precio == '—'
        ? t('tienda.comprar')
        : fmt(t('tienda.comprarPrecio'), {'precio': tienda.precio});

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('tienda.titulo'),
              style: const TextStyle(
                fontFamily: fuenteTitulo,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kMaderaOscura,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t('tienda.gancho'),
              style: const TextStyle(fontSize: 14, height: 1.35, color: kTinta),
            ),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: _promesas(t)),
            const SizedBox(height: 20),

            if (!tienda.disponible) ...[
              Text(
                t('tienda.noDisponible'),
                style: const TextStyle(fontSize: 12.5, color: kRojo),
              ),
              const SizedBox(height: 10),
            ],

            SizedBox(
              width: double.infinity,
              child: BotonMadera(
                texto: tienda.ocupado ? t('tienda.pensando') : texto,
                icono: Icons.lock_open,
                principal: true,
                onTap: puedeComprar ? () => tienda.comprar() : null,
              ),
            ),
            const SizedBox(height: 10),

            // Obligatorio, no decorativo: las preferencias no sobreviven a una
            // desinstalación, así que sin esto quien reinstala pierde lo que
            // pagó. Las dos tiendas además lo exigen para aprobar la app.
            Center(
              child: TextButton(
                onPressed: tienda.ocupado ? null : () => tienda.restaurar(),
                child: Text(
                  t('tienda.restaurar'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kTintaSuave,
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
