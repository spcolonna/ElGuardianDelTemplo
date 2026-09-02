import 'package:flutter/material.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

import 'app_state.dart';
import 'modos/encargos.dart';
import 'progreso.dart';
import 'temas/temas.dart';
import 'ui_common.dart';

/// Timeline de misiones diarias sobre calendario real.
class ProgresoScreen extends StatelessWidget {
  const ProgresoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.progreso;
    final hoy = DateTime.now();
    p.revisarCadena(hoy);
    final hecho = p.hoyCompletado(hoy);

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      children: [
        const Text(
          'Ganá una partida por día. El día siguiente no se habilita hasta que '
          'cambie la fecha. Si pasa un día entero sin ganar, la cadena se corta '
          'y hay que rehacer los siete.',
          style: TextStyle(color: kTintaSuave, fontSize: 13),
        ),
        const SizedBox(height: 24),

        _Timeline(racha: p.racha, hoyHecho: hecho),
        const SizedBox(height: 24),

        _EstadoDeHoy(hecho: hecho, racha: p.racha),
        const SizedBox(height: 20),

        if (p.logroActivo) const _Insignia(),
        if (p.logroActivo) const SizedBox(height: 20),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Etiqueta(
              'Racha actual ${p.racha}/${Progreso.diasParaLogro}',
              icono: Icons.local_fire_department,
              color: p.racha > 0 ? kMediodia : null,
            ),
            Etiqueta('Mejor racha ${p.mejorRacha}', icono: Icons.trending_up),
            Etiqueta(
              'Semanas completadas ${p.semanasCompletadas}',
              icono: Icons.emoji_events,
              color: kJefe,
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (app.cfg.modoEncargos) _EncargoDeHoy(hoy: hoy, textos: app.textos),

        const Divider(height: 40),
        SwitchListTile(
          dense: true,
          value: p.perderRompeLaRacha,
          onChanged: (v) {
            p.perderRompeLaRacha = v;
            app.guardar();
            app.tocar();
          },
          title: const Text('Perder una partida también corta la racha'),
          subtitle: const Text(
            'Apagado: podés reintentar todas las veces que quieras dentro '
            'del día. Prendido: una derrota te vuelve a cero.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            p.reiniciar();
            app.guardar();
            app.tocar();
          },
          icon: const Icon(Icons.restart_alt, size: 18),
          label: const Text('Reiniciar la racha'),
        ),
        const SizedBox(height: 12),
        const Text(
          'El progreso se guarda en este navegador y usa su reloj: cambiando '
          'la fecha del sistema se saltea la espera. Para una herramienta de '
          'playtesting alcanza; si algún día se publica, esto necesita servidor.',
          style: TextStyle(color: kTintaSuave, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  final int racha;
  final bool hoyHecho;
  const _Timeline({required this.racha, required this.hoyHecho});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cs) {
        // Siete casilleros y seis uniones de 6 pt: el ancho que entra justo
        // es (disponible - 36) / 7. El piso era 26, y ese piso es lo que
        // desbordaba en una ventana de iPad angosta —abajo de 218 pt de
        // disponible, siete casilleros de 26 ya no entran—. Ahora el piso
        // sólo protege de un ancho absurdo; el contenido de cada casillero se
        // achica solo, así que un casillero chico se sigue leyendo.
        final ancho = ((cs.maxWidth - 6 * 6) / 7).clamp(12.0, 72.0);
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < Progreso.diasParaLogro; i++) ...[
              if (i > 0)
                Container(
                  width: 6,
                  height: 3,
                  color: i <= racha
                      ? kMediodia
                      : kMadera.withValues(alpha: .35),
                ),
              _Casillero(
                numero: i + 1,
                ancho: ancho,
                estado: i < racha
                    ? _EstadoDia.hecho
                    : (i == racha && !hoyHecho
                          ? _EstadoDia.disponible
                          : _EstadoDia.bloqueado),
              ),
            ],
          ],
        );
      },
    );
  }
}

enum _EstadoDia { hecho, disponible, bloqueado }

class _Casillero extends StatelessWidget {
  final int numero;
  final double ancho;
  final _EstadoDia estado;
  const _Casillero({
    required this.numero,
    required this.ancho,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icono) = switch (estado) {
      _EstadoDia.hecho => (kMediodia, Icons.check),
      _EstadoDia.disponible => (kAlba, Icons.play_arrow),
      _EstadoDia.bloqueado => (kMadera, Icons.lock_outline),
    };
    return Container(
      width: ancho,
      height: ancho * 1.15,
      decoration: BoxDecoration(
        color: estado == _EstadoDia.hecho
            ? color.withValues(alpha: .22)
            : kPapelClaro,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color,
          width: estado == _EstadoDia.disponible ? 3 : 2,
        ),
        boxShadow: sombraPapel(),
      ),
      // La caja mide `ancho * 1.15` de alto y adentro van un ícono, un espacio
      // y un renglón. Los dos saltos de tamaño —a 40 y a 52 pt— cubren los
      // anchos de teléfono, pero en una ventana de iPad en Slide Over las
      // treinta cajas se reparten 320 pt y quedan tan chicas que el contenido
      // no entra ni en su versión mínima: se desbordaba 8 px por abajo. El
      // `FittedBox` lo resuelve de una vez y para cualquier ancho futuro, sin
      // agregar un tercer umbral que mañana también se quede corto.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: ancho < 40 ? 15 : 20),
            const SizedBox(height: 3),
            Text(
              ancho < 52 ? '$numero' : 'Día $numero',
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: ancho < 40 ? 9.5 : 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoDeHoy extends StatelessWidget {
  final bool hecho;
  final int racha;
  const _EstadoDeHoy({required this.hecho, required this.racha});

  @override
  Widget build(BuildContext context) {
    final color = hecho ? kAlba : kMediodia;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: sombraPapel(),
      ),
      child: Row(
        children: [
          Icon(
            hecho ? Icons.check_circle : Icons.sports_martial_arts,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hecho
                      ? 'El templo aguantó hoy.'
                      : 'El templo todavía no está defendido hoy.',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hecho
                      ? 'Volvé mañana para el día ${racha + 1}.'
                      : 'Ganá una partida para marcar el día ${racha + 1}.',
                  style: const TextStyle(color: kTintaSuave, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kJefe.withValues(alpha: .28), kJefe.withValues(alpha: .06)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kJefe, width: 2),
        boxShadow: sombraPapel(),
      ),
      child: Row(
        children: [
          const IconoJuego(
            asset: insigniaLogro,
            respaldoIcono: Icons.military_tech,
            tamano: 34,
            colorRespaldo: kOroBorde,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guardián del Templo',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Text(
                  'Siete días seguidos. Shifu no se va a enterar, pero vos sí.',
                  style: TextStyle(color: kTintaSuave, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EncargoDeHoy extends StatelessWidget {
  final DateTime hoy;
  final TextosTema textos;
  const _EncargoDeHoy({required this.hoy, required this.textos});

  @override
  Widget build(BuildContext context) {
    final e = textos.encargos[encargoDelDia(hoy).id]!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kOroBorde, width: 2),
        boxShadow: sombraPapel(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sticky_note_2_outlined,
                color: kOroBorde,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Encargo de hoy: ${e.titulo}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${e.nota}"',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recompensa: ${e.recompensa}',
            style: const TextStyle(fontSize: 12.5, color: kAlba),
          ),
        ],
      ),
    );
  }
}
