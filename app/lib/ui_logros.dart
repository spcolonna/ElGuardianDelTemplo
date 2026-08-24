import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'logros.dart';
import 'ui_kit.dart';
import 'ui_shell.dart';
import 'ui_texturas.dart';

/// Galería de misiones y logros.
///
/// `logros.dart` es Dart puro para que `bin/check.dart` lo valide headless, así
/// que la traducción de clave de ícono a `IconData` vive acá.
const _iconos = <String, IconData>{
  'sol': Icons.wb_sunny,
  'escudo': Icons.shield,
  'meditar': Icons.self_improvement,
  'mazo': Icons.style,
  'rayo': Icons.bolt,
  'corazon': Icons.favorite,
  'moneda': Icons.savings,
  'reloj': Icons.timer,
  'amanecer': Icons.wb_twilight,
  'fuego': Icons.local_fire_department,
  'pesa': Icons.fitness_center,
  'nota': Icons.sticky_note_2,
  'camino': Icons.route,
  'ancla': Icons.anchor,
  'medalla': Icons.military_tech,
};

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  @override
  void initState() {
    super.initState();
    // Recalcular al abrir desbloquea los logros que se agregaron al catálogo
    // después de que el jugador ya cumplió la condición.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppScope.of(context).revisarLogros();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    final estado = app.logros;

    return PantallaTemplo(
      titulo: t('logros.titulo'),
      conVolver: true,
      cuerpo: Column(
        children: [
          PanelPapel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.military_tech, color: kOroBorde, size: 22),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    fmt(t('logros.contador'), {
                      'a': estado.desbloqueados.length,
                      'b': estado.total,
                    }),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kTinta,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 132,
                childAspectRatio: .82,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: catalogoLogros.length,
              itemBuilder: (context, i) {
                final l = catalogoLogros[i];
                return _Insignia(logro: l, tiene: estado.tiene(l.id), t: t);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  final Logro logro;
  final bool tiene;
  final TextosUi t;
  const _Insignia({required this.logro, required this.tiene, required this.t});

  @override
  Widget build(BuildContext context) {
    return PanelPapel(
      padding: const EdgeInsets.all(8),
      color: tiene ? kPapelClaro : kMadera.withValues(alpha: .18),
      borde: tiene ? kOroBorde : kMadera,
      onTap: () => _detalle(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: ImagenUi(
              asset: tiene ? insigniaLogro : insigniaBloqueada,
              respaldo: (_) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tiene
                      ? kOro.withValues(alpha: .35)
                      : kMadera.withValues(alpha: .25),
                  border: Border.all(
                    color: tiene ? kOroBorde : kMadera,
                    width: 2,
                  ),
                ),
                child: Icon(
                  tiene
                      ? (_iconos[logro.icono] ?? Icons.star)
                      : Icons.lock_outline,
                  size: 26,
                  color: tiene ? kMaderaOscura : kTintaSuave,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tiene ? t(logro.claveTitulo) : '???',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              height: 1.15,
              color: tiene ? kTinta : kTintaSuave,
            ),
          ),
        ],
      ),
    );
  }

  /// La descripción se muestra siempre, aunque el logro esté bloqueado: es la
  /// misión, no un secreto. Lo que se oculta es el título, para que la galería
  /// llena se vea como un premio.
  void _detalle(BuildContext context) {
    tocarUi(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: PanelPapel(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tiene
                    ? (_iconos[logro.icono] ?? Icons.star)
                    : Icons.lock_outline,
                size: 44,
                color: tiene ? kOroBorde : kTintaSuave,
              ),
              const SizedBox(height: 12),
              Text(
                tiene ? t(logro.claveTitulo) : t('logros.bloqueado'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: fuenteTitulo,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTinta,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t(logro.claveDesc),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: kTintaSuave,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
