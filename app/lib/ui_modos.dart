import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n.dart';
import 'modos/dificultad.dart';
import 'modos/encargos.dart';
import 'rutas.dart';
import 'ui_kit.dart';
import 'ui_shell.dart';
import 'ui_tienda.dart';

/// Antes de empezar: el camino, los jefes y las reglas opcionales.
///
/// Es la superficie que le faltaba al juego. Los modos Encargos y Cansancio ya
/// existían en el motor, pero sólo se prendían desde `/admin` en web, así que
/// en el teléfono eran inalcanzables.
class ModosScreen extends StatefulWidget {
  const ModosScreen({super.key});

  @override
  State<ModosScreen> createState() => _ModosScreenState();
}

class _ModosScreenState extends State<ModosScreen> {
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = TextosUi.de(app.idioma);
    final o = app.opciones;
    final abierto = app.premium;

    // Un solo gesto para todo lo bloqueado: se toca, se abre la tienda, y si
    // el jugador compra la pantalla se redibuja con todo habilitado.
    Future<void> ofrecer() async {
      if (await abrirTienda(context) && mounted) setState(() {});
    }

    return PantallaTemplo(
      titulo: t('modos.titulo'),
      conVolver: true,
      textoAccion: t('modos.empezar').toUpperCase(),
      onAccion: () {
        // `guardarOpciones` vuelve a apretar las opciones a las de la versión
        // gratis si no compró: los controles bloqueados son la primera puerta,
        // ésta es la que cuenta.
        app.guardarOpciones();
        app.nuevaPartida();
        Navigator.of(context).pushReplacementNamed(R.partida);
      },
      cuerpo: ListView(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
        children: [
          if (!abierto) ...[const BannerCompra(), const SizedBox(height: 16)],
          PlacaTitulo(t('modos.dificultad'), icono: Icons.terrain),
          const SizedBox(height: 8),
          for (final d in Dificultad.values) ...[
            _Camino(
              dificultad: d,
              elegido: o.dificultad == d,
              // El único camino gratis es el primero. Los otros tres se ven
              // enteros, con sus números: hay que mostrar lo que se compra.
              bloqueado: !abierto && d != Dificultad.aprendiz,
              base: app.cfg,
              t: t,
              onTap: () {
                if (!abierto && d != Dificultad.aprendiz) {
                  ofrecer();
                  return;
                }
                tocarUi(context);
                setState(() => o.dificultad = d);
              },
            ),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 8),
          PlacaTitulo(t('modos.jefes'), icono: Icons.local_fire_department),
          const SizedBox(height: 8),
          _SelectorJefes(
            valor: o.jefes,
            automatico: aplicarDificultad(app.cfg, o.dificultad).cantidadJefes,
            textoAuto: t('modos.jefesAuto'),
            // Sin esto el gate se esquiva por la puerta de atrás: Aprendiz con
            // tres jefes es casi todo el desafío, gratis.
            bloqueado: !abierto,
            onElegir: (v) {
              if (!abierto) {
                ofrecer();
                return;
              }
              tocarUi(context);
              setState(() => o.jefes = v);
            },
          ),

          const SizedBox(height: 18),
          PlacaTitulo(t('modos.extras'), icono: Icons.auto_awesome),
          const SizedBox(height: 8),
          _Interruptor(
            titulo: t('modos.encargosT'),
            sub: t('modos.encargosSub'),
            icono: Icons.sticky_note_2_outlined,
            valor: o.encargos,
            bloqueado: !abierto,
            textoBloqueado: t('tienda.bloqueado'),
            // Con el modo prendido se ve la nota REAL de hoy, con su premio:
            // el encargo se sortea por fecha, así que ya está decidido antes
            // de empezar y no hay motivo para ocultarlo.
            detalle: _NotaDeHoy(app: app, t: t),
            onTap: () {
              if (!abierto) {
                ofrecer();
                return;
              }
              tocarUi(context);
              setState(() => o.encargos = !o.encargos);
            },
          ),
          const SizedBox(height: 8),
          _Interruptor(
            titulo: t('modos.cansancioT'),
            sub: t('modos.cansancioSub'),
            icono: Icons.bedtime_outlined,
            valor: o.cansancio,
            bloqueado: !abierto,
            textoBloqueado: t('tienda.bloqueado'),
            onTap: () {
              if (!abierto) {
                ofrecer();
                return;
              }
              tocarUi(context);
              setState(() => o.cansancio = !o.cansancio);
            },
          ),
        ],
      ),
    );
  }
}

/// Un camino a elegir. Muestra el efecto real, no sólo la línea de sabor:
/// esconder los números en un juego de este tipo sería tratar mal al jugador.
class _Camino extends StatelessWidget {
  final Dificultad dificultad;
  final bool elegido;
  final bool bloqueado;
  final dynamic base;
  final TextosUi t;
  final VoidCallback onTap;

  const _Camino({
    required this.dificultad,
    required this.elegido,
    required this.base,
    required this.t,
    required this.onTap,
    this.bloqueado = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = aplicarDificultad(base, dificultad);
    final clave = dificultad.clave;

    return PanelPapel(
      onTap: onTap,
      color: elegido && !bloqueado ? kOro.withValues(alpha: .30) : kPapelClaro,
      borde: bloqueado ? kMadera : (elegido ? kOroBorde : kMaderaOscura),
      child: Row(
        children: [
          if (bloqueado)
            const Candado()
          else
            Icon(
              elegido
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: elegido ? kOroBorde : kTintaSuave,
              size: 22,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('dif.$clave'),
                  style: TextStyle(
                    fontFamily: fuenteTitulo,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: bloqueado ? kTintaSuave : kTinta,
                  ),
                ),
                const SizedBox(height: 2),
                // Bloqueado, la línea de sabor deja lugar al motivo: enterarse
                // de que algo no se puede tocar y no saber por qué es peor que
                // el bloqueo.
                Text(
                  bloqueado ? t('tienda.bloqueado') : t('dif.${clave}Sub'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: bloqueado ? FontWeight.w600 : FontWeight.normal,
                    color: bloqueado ? kMaderaOscura : kTintaSuave,
                  ),
                ),
                const SizedBox(height: 6),
                // Los números se ven igual estando bloqueado: es exactamente
                // lo que se está comprando.
                Opacity(
                  opacity: bloqueado ? .55 : 1,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Pastilla(
                        fmt(t('modos.energia'), {'n': c.energiaInicial}),
                        icono: Icons.bolt,
                        color: kNaranja,
                        compacta: true,
                      ),
                      Pastilla(
                        '${c.cantidadJefes}',
                        icono: Icons.local_fire_department,
                        color: kRojo,
                        compacta: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cuántos jefes finales. Cuatro opciones no entran con etiqueta larga en el
/// ancho de un teléfono: la automática dice sólo "Auto" y el número elegido
/// va grande, que es lo único que hay que comparar.
class _SelectorJefes extends StatelessWidget {
  final int? valor;
  final int automatico;
  final String textoAuto;
  final bool bloqueado;
  final ValueChanged<int?> onElegir;

  const _SelectorJefes({
    required this.valor,
    required this.automatico,
    required this.textoAuto,
    required this.onElegir,
    this.bloqueado = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget opcion(int? v, String grande, String? chico) {
      // Bloqueado, el único que se ve elegido es Auto: es lo que va a jugar.
      final elegido = bloqueado ? v == null : valor == v;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: PanelPapel(
            onTap: () => onElegir(v),
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
            color: elegido && !bloqueado
                ? kOro.withValues(alpha: .30)
                : kPapelClaro,
            borde: bloqueado ? kMadera : (elegido ? kOroBorde : kMaderaOscura),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (bloqueado && v != null) ...[
                  const Candado(),
                  const SizedBox(height: 2),
                ],
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    grande,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: fuenteTitulo,
                      fontSize: 20,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: bloqueado && v != null
                          ? kTintaSuave
                          : (elegido ? kMaderaOscura : kTinta),
                    ),
                  ),
                ),
                if (chico != null) ...[
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      chico,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .3,
                        color: kTintaSuave,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          opcion(null, '$automatico', textoAuto.toUpperCase()),
          opcion(1, '1', null),
          opcion(2, '2', null),
          opcion(3, '3', null),
        ],
      ),
    );
  }
}

class _Interruptor extends StatelessWidget {
  final String titulo;
  final String sub;
  final IconData icono;
  final bool valor;
  final bool bloqueado;

  /// Por qué está bloqueado. Reemplaza a `sub` cuando lo está.
  final String textoBloqueado;

  final VoidCallback onTap;

  /// Lo que el modo hace EN CONCRETO hoy. Va debajo, sangrado, y sólo cuando
  /// está prendido: un modo que se explica en abstracto se prende a ciegas.
  final Widget? detalle;

  const _Interruptor({
    required this.titulo,
    required this.sub,
    required this.icono,
    required this.valor,
    required this.onTap,
    this.bloqueado = false,
    this.textoBloqueado = '',
    this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    final fila = Row(
      children: [
        if (bloqueado)
          const Candado()
        else
          Icon(icono, color: valor ? kVerde : kTintaSuave, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: bloqueado ? kTintaSuave : kTinta,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                bloqueado ? textoBloqueado : sub,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: bloqueado ? FontWeight.w600 : FontWeight.normal,
                  color: bloqueado ? kMaderaOscura : kTintaSuave,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          valor && !bloqueado ? Icons.toggle_on : Icons.toggle_off,
          size: 36,
          color: valor && !bloqueado ? kVerde : kTintaSuave,
        ),
      ],
    );

    if (detalle == null || !valor || bloqueado) {
      return PanelPapel(
        onTap: onTap,
        borde: bloqueado ? kMadera : (valor ? kVerde : kMaderaOscura),
        child: fila,
      );
    }

    return PanelPapel(
      onTap: onTap,
      borde: kVerde,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fila,
          const SizedBox(height: 10),
          const Divider(height: 1, color: kOroBorde),
          const SizedBox(height: 10),
          // Sangrado hasta donde arranca el texto de arriba: se lee como una
          // continuación del modo, no como otra cosa.
          Padding(padding: const EdgeInsets.only(left: 36), child: detalle!),
        ],
      ),
    );
  }
}

/// El encargo que toca hoy, con su condición y su premio.
///
/// Se sortea por fecha —la misma nota todo el día, otra mañana—, así que se
/// puede mostrar antes de empezar sin arruinar nada.
class _NotaDeHoy extends StatelessWidget {
  final AppState app;
  final TextosUi t;
  const _NotaDeHoy({required this.app, required this.t});

  @override
  Widget build(BuildContext context) {
    final e = encargoDelDia(DateTime.now());
    final texto = app.textos.encargos[e.id];
    if (texto == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('modos.encargoHoy').toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
            color: kMaderaOscura,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          texto.titulo,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: kTinta,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          texto.nota,
          style: const TextStyle(
            fontSize: 12,
            height: 1.3,
            fontStyle: FontStyle.italic,
            color: kTinta,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.card_giftcard, size: 14, color: kVerde),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                fmt(t('modos.encargoPremio'), {'r': texto.recompensa}),
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: kVerde,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
