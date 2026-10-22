import 'package:flutter/material.dart';
import 'ui_kit.dart';
import 'ui_texturas.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'modos/encargos.dart';
import 'progreso.dart';
import 'temas/temas.dart';
import 'ui_common.dart';
import 'ui_sellos.dart';

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
    final dias = p.diasEnSemana(hoy);
    final t = TextosUi.de(app.idioma);

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      children: [
        Text(
          t('progreso.explicacion'),
          style: const TextStyle(color: kTintaSuave, fontSize: 13),
        ),
        const SizedBox(height: 24),

        // La semana en curso de la cadena viva: la segunda arranca el día 8.
        if (p.racha > 0) ...[
          Text(
            t.con('progreso.semanaN', {
              'n': hecho && dias == Progreso.diasParaLogro
                  ? p.semanasSeguidas
                  : p.semanasSeguidas + 1,
            }),
            style: TextStyle(
              fontFamily: fuenteTitulo,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kMaderaOscura,
            ),
          ),
          const SizedBox(height: 8),
        ],
        _Timeline(racha: dias, hoyHecho: hecho),
        const SizedBox(height: 24),

        _EstadoDeHoy(hecho: hecho, racha: dias % Progreso.diasParaLogro),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Etiqueta(
              t.con('progreso.rachaDias', {'n': p.racha}),
              icono: Icons.local_fire_department,
              color: p.racha > 0 ? kMediodia : null,
            ),
            Etiqueta(
              t.con('progreso.mejorRacha', {'n': p.mejorRacha}),
              icono: Icons.trending_up,
            ),
            Etiqueta(
              t.con('progreso.semanas', {'n': p.semanasCompletadas}),
              icono: Icons.emoji_events,
              color: kJefe,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _PremioDeLaSemana(app: app, t: t),
        const SizedBox(height: 20),

        _Titulo(p: p, t: t),
        const SizedBox(height: 28),

        PlacaTitulo(t('progreso.sellos'), icono: Icons.verified),
        const SizedBox(height: 6),
        Text(
          t('progreso.sellosSub'),
          style: const TextStyle(color: kTintaSuave, fontSize: 12.5),
        ),
        const SizedBox(height: 14),
        GrillaSellos(
          ganados: p.sellos,
          nombre: (i) => i < p.sellos
              ? t('sello.${idsSellos[i]}')
              : t.con('progreso.selloSemana', {'n': i + 1}),
        ),
        const SizedBox(height: 24),

        if (app.opciones.encargos) _EncargoDeHoy(hoy: hoy, textos: app.textos),

        const Divider(height: 40),
        SwitchListTile(
          dense: true,
          value: p.perderRompeLaRacha,
          onChanged: (v) {
            p.perderRompeLaRacha = v;
            app.guardar();
            app.tocar();
          },
          title: Text(t('progreso.perderCorta')),
          subtitle: Text(
            t('progreso.perderCortaSub'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            p.reiniciar();
            app.guardar();
            app.tocar();
          },
          icon: const Icon(Icons.restart_alt, size: 18),
          label: Text(t('progreso.reiniciar')),
        ),
        const SizedBox(height: 12),
        Text(
          t('progreso.aviso'),
          style: const TextStyle(color: kTintaSuave, fontSize: 11.5),
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
              ancho < 52
                  ? '$numero'
                  : TextosUi.de(
                      AppScope.of(context).idioma,
                    ).con('progreso.dia', {'n': numero}),
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
    final t = TextosUi.de(AppScope.of(context).idioma);
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
                  t(hecho ? 'progreso.hecho' : 'progreso.pendiente'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  t.con(hecho ? 'progreso.volveManana' : 'progreso.ganaHoy', {
                    'n': racha + 1,
                  }),
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

/// El título que da la cadena viva, y cuánto falta para el siguiente.
class _Titulo extends StatelessWidget {
  final Progreso p;
  final TextosUi t;
  const _Titulo({required this.p, required this.t});

  @override
  Widget build(BuildContext context) {
    final nivel = p.nivelTitulo;
    final faltan = p.semanasParaSubir;
    final siguiente = faltan == null ? null : t('titulo.${nivel + 1}');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Opaco: sobre el paisaje, un velo violeta dejaba el texto gris
        // ilegible.
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(kJefe.withValues(alpha: .20), kPapelClaro),
            kPapelClaro,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kJefe, width: 2),
        boxShadow: sombraPapel(),
      ),
      child: Row(
        children: [
          IconoJuego(
            asset: insigniaLogro,
            respaldoIcono: Icons.military_tech,
            tamano: nivel == 0 ? 28 : 36,
            colorRespaldo: kOroBorde,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('progreso.tuTitulo'),
                  style: const TextStyle(color: kTinta, fontSize: 12),
                ),
                Text(
                  t('titulo.$nivel'),
                  style: TextStyle(
                    fontFamily: fuenteTitulo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTinta,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  siguiente == null
                      ? t('progreso.tituloMaximo')
                      : t.con('progreso.proximoTitulo', {
                          't': siguiente,
                          'n': Progreso.semanasPorTitulo[nivel + 1],
                        }),
                  style: const TextStyle(color: kTinta, fontSize: 12.5),
                ),
                if (p.mejorNivelTitulo > nivel) ...[
                  const SizedBox(height: 3),
                  Text(
                    t.con('progreso.mejorTitulo', {
                      't': t('titulo.${p.mejorNivelTitulo}'),
                    }),
                    style: const TextStyle(color: kTinta, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Qué se gana al cerrar la semana, dicho antes de ganarlo: es lo que hace
/// que el día cinco valga la pena.
class _PremioDeLaSemana extends StatelessWidget {
  final AppState app;
  final TextosUi t;
  const _PremioDeLaSemana({required this.app, required this.t});

  @override
  Widget build(BuildContext context) {
    final p = app.progreso;
    final hasta = p.temploAbiertoHasta;
    final abierto = app.temploAbierto && hasta != null;
    final texto = abierto
        ? textoTiempoAbierto(t, hasta.difference(DateTime.now()))
        : t.con(
            app.comprado ? 'progreso.premioComprado' : 'progreso.premioGratis',
            {'n': AppState.energiaDeBendicion, 'r': app.textos.recurso},
          );
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: abierto ? kOro.withValues(alpha: .22) : kPapelClaro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kOroBorde, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            abierto ? Icons.lock_open : Icons.card_giftcard,
            color: kOroBorde,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(abierto ? 'templo.abierto' : 'progreso.premioTitulo'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kTinta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  texto,
                  style: const TextStyle(fontSize: 12.5, color: kTinta),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// «Quedan 5 h 20 min con todo abierto.» Lo usan Progreso y la tienda.
String textoTiempoAbierto(TextosUi t, Duration queda) {
  final h = queda.inHours;
  final m = queda.inMinutes % 60;
  return h > 0
      ? t.con('templo.quedan', {'h': h, 'm': m})
      : t.con('templo.quedanMin', {'m': m < 1 ? 1 : m});
}

class _EncargoDeHoy extends StatelessWidget {
  final DateTime hoy;
  final TextosTema textos;
  const _EncargoDeHoy({required this.hoy, required this.textos});

  @override
  Widget build(BuildContext context) {
    final t = TextosUi.de(AppScope.of(context).idioma);
    final encargo = encargoDelDia(hoy);
    final e = textos.encargos[encargo.id]!;
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
                t.con('progreso.encargoHoy', {'t': e.titulo}),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            condicionDe(encargo, e),
            style: const TextStyle(fontSize: 14, height: 1.35),
          ),
          const SizedBox(height: 6),
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
            t.con('progreso.recompensa', {'r': e.recompensa}),
            style: const TextStyle(fontSize: 12.5, color: kAlba),
          ),
        ],
      ),
    );
  }
}
