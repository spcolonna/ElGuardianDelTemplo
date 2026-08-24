import 'package:flutter/material.dart';

import 'app_state.dart';
import 'audio.dart';
import 'l10n.dart';
import 'rutas.dart';
import 'ui_kit.dart';
import 'ui_shell.dart';

/// Ajustes: audio, idioma y el acceso al tutorial.
///
/// Antes esto estaba repartido — los toggles de audio sueltos al pie del
/// patio, el idioma incrustado arriba de la hoja de reglas. Juntarlo deja el
/// patio limpio, como el mock.
class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);

    return PantallaTemplo(
      titulo: t('ajustes.titulo'),
      conVolver: true,
      cuerpo: ListView(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
        children: [
          PlacaTitulo(t('nav.ajustes'), icono: Icons.volume_up),
          const SizedBox(height: 8),
          _Toggle(
            texto: t('ajustes.musica'),
            icono: Icons.music_note,
            valor: app.audio.musicaActiva,
            onTap: () async {
              await app.audio.cambiarMusica(!app.audio.musicaActiva);
              if (mounted) setState(() {});
            },
          ),
          const SizedBox(height: 8),
          _Toggle(
            texto: t('ajustes.efectos'),
            icono: Icons.graphic_eq,
            valor: app.audio.efectosActivos,
            onTap: () async {
              await app.audio.cambiarEfectos(!app.audio.efectosActivos);
              app.audio.sonar(Sfx.toque);
              if (mounted) setState(() {});
            },
          ),

          const SizedBox(height: 20),
          PlacaTitulo(t('ajustes.idioma'), icono: Icons.translate),
          const SizedBox(height: 8),
          _Idiomas(app: app, t: t, onCambio: () => setState(() {})),

          const SizedBox(height: 20),
          PlacaTitulo(t('tutorial.titulo'), icono: Icons.school_outlined),
          const SizedBox(height: 8),
          PanelPapel(
            onTap: () {
              tocarUi(context);
              Navigator.of(context).pushNamed(R.tutorial);
            },
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline, color: kTinta, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t('tutorial.ver'),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: kTinta,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: kTintaSuave),
              ],
            ),
          ),

          const SizedBox(height: 28),
          Text(
            t('ajustes.sobre'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11.5, color: kTintaSuave),
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool valor;
  final VoidCallback onTap;
  const _Toggle({
    required this.texto,
    required this.icono,
    required this.valor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PanelPapel(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icono, color: valor ? kTinta : kTintaSuave, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: kTinta,
              ),
            ),
          ),
          Icon(
            valor ? Icons.toggle_on : Icons.toggle_off,
            size: 36,
            color: valor ? kVerde : kTintaSuave,
          ),
        ],
      ),
    );
  }
}

class _Idiomas extends StatelessWidget {
  final AppState app;
  final TextosUi t;
  final VoidCallback onCambio;
  const _Idiomas({required this.app, required this.t, required this.onCambio});

  @override
  Widget build(BuildContext context) {
    Widget opcion(String? id, String texto) {
      final elegido = app.idiomaElegido == id;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: PanelPapel(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            color: elegido ? kOro.withValues(alpha: .30) : kPapelClaro,
            borde: elegido ? kOroBorde : kMaderaOscura,
            onTap: () {
              tocarUi(context);
              app.cambiarIdioma(id);
              onCambio();
            },
            child: Text(
              texto,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: elegido ? kMaderaOscura : kTintaSuave,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        opcion(null, t('ajustes.idiomaSistema')),
        opcion('es', 'Español'),
        opcion('en', 'English'),
      ],
    );
  }
}
