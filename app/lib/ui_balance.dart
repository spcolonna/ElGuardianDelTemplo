import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'modos/cansancio.dart';
import 'models.dart';
import 'ui_common.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  int _version = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cfg = app.cfg;
    final con = app.contenido;

    return ListView(
      key: ValueKey(_version),
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Balance y reglas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: app.exportar()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuración copiada al portapapeles'),
                  ),
                );
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Exportar'),
            ),
            TextButton.icon(
              onPressed: () => _importar(context, app),
              icon: const Icon(Icons.paste, size: 18),
              label: const Text('Importar'),
            ),
            TextButton.icon(
              onPressed: () {
                app.restaurarContenido();
                setState(() => _version++);
              },
              icon: const Icon(Icons.restart_alt, size: 18),
              label: const Text('Restaurar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Los cambios se aplican a la próxima partida y al simulador.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 20),

        _Seccion(
          titulo: 'Parámetros de partida',
          children: [
            _Slider(
              label: 'Energía inicial',
              valor: cfg.energiaInicial.toDouble(),
              min: 5,
              max: 40,
              onChanged: (v) => setState(() {
                cfg.energiaInicial = v.round();
                if (cfg.energiaMaxima < cfg.energiaInicial) {
                  cfg.energiaMaxima = cfg.energiaInicial;
                }
              }),
            ),
            _Slider(
              label: 'Energía máxima (tope al curarse)',
              valor: cfg.energiaMaxima.toDouble(),
              min: 5,
              max: 60,
              onChanged: (v) => setState(() => cfg.energiaMaxima = v.round()),
            ),
            _Slider(
              label: 'Cantidad de jefes finales',
              valor: cfg.cantidadJefes.toDouble(),
              min: 1,
              max: 5,
              onChanged: (v) => setState(() => cfg.cantidadJefes = v.round()),
            ),
            _Slider(
              label: 'Coste de robo extra (Energía)',
              valor: cfg.costeRoboExtra.toDouble(),
              min: 1,
              max: 4,
              onChanged: (v) => setState(() => cfg.costeRoboExtra = v.round()),
            ),
            _Slider(
              label: 'Coste de meditar (Energía)',
              valor: cfg.costeMeditar.toDouble(),
              min: 1,
              max: 4,
              onChanged: (v) => setState(() => cfg.costeMeditar = v.round()),
            ),
            _Slider(
              label: 'Cartas eliminadas por meditación',
              valor: cfg.cartasPorMeditacion.toDouble(),
              min: 1,
              max: 3,
              onChanged: (v) =>
                  setState(() => cfg.cartasPorMeditacion = v.round()),
            ),
            SwitchListTile(
              dense: true,
              value: cfg.robosGratisIlimitados,
              onChanged: (v) => setState(() => cfg.robosGratisIlimitados = v),
              title: const Text(
                'Robos gratis ilimitados (regla literal del doc)',
              ),
              subtitle: const Text(
                'Con esto activado nunca perdés un combate: sirve sólo para comparar.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SwitchListTile(
              dense: true,
              value: cfg.meditarSoloAlPerder,
              onChanged: (v) => setState(() => cfg.meditarSoloAlPerder = v),
              title: const Text('Meditar sólo después de perder'),
            ),
            SwitchListTile(
              dense: true,
              value: cfg.peligroPerdidoSaleDelJuego,
              onChanged: (v) =>
                  setState(() => cfg.peligroPerdidoSaleDelJuego = v),
              title: const Text('El peligro perdido sale del juego'),
              subtitle: const Text(
                'Si se apaga, vuelve al fondo del mazo.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),

        _Seccion(
          titulo: 'Modos alternativos',
          color: kJefe,
          children: [
            const Text(
              'Apagados no cambian nada del juego base. Cada uno es un modo '
              'aparte, no una regla nueva.',
              style: TextStyle(color: Colors.white54, fontSize: 12.5),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              dense: true,
              value: cfg.modoEncargos,
              onChanged: (v) => setState(() => cfg.modoEncargos = v),
              title: const Text('Encargos de Shifu'),
              subtitle: const Text(
                'Cada día real trae una nota con una condición extra. '
                'Cumplirla da un beneficio para el día siguiente.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SwitchListTile(
              dense: true,
              value: cfg.modoCansancio,
              onChanged: (v) => setState(() => cfg.modoCansancio = v),
              title: const Text('Mazo de Cansancio'),
              subtitle: const Text(
                'Entra una carta de fatiga a tu mazo cada tanto, como las '
                'cartas de envejecimiento de Friday.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            if (cfg.modoCansancio) ...[
              _Slider(
                label: 'Poder de las cartas de Cansancio',
                valor: cfg.poderCansancio.toDouble(),
                min: -2,
                max: 0,
                onChanged: (v) =>
                    setState(() => cfg.poderCansancio = v.round()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 260,
                      child: Text(
                        'Cuándo entra una carta',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: cfg.disparoCansancio,
                        items: [
                          for (final d in DisparoCansancio.values)
                            DropdownMenuItem(
                              value: d.index,
                              child: Text(
                                d.nombre,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                        ],
                        onChanged: (v) =>
                            setState(() => cfg.disparoCansancio = v ?? 0),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Medido con el simulador: con Energía 20 el modo baja las '
                'victorias de 14% a ~5%. Es un modo duro — conviene subir la '
                'Energía inicial a 25 (queda en ~32%).',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ],
        ),

        _Seccion(
          titulo: 'Mazo inicial de combate',
          children: [
            for (var i = 0; i < con.mazoInicial.length; i++)
              _FilaCombate(
                carta: con.mazoInicial[i].$1,
                cantidad: con.mazoInicial[i].$2,
                onCantidad: (v) => setState(
                  () => con.mazoInicial[i] = (con.mazoInicial[i].$1, v),
                ),
                onCarta: (c) => setState(
                  () => con.mazoInicial[i] = (c, con.mazoInicial[i].$2),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Total ${con.mazoInicial.fold<int>(0, (a, e) => a + e.$2)} cartas · '
                'poder promedio ${_promedio(con.mazoInicial).toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),

        for (final fase in [Fase.alba, Fase.mediodia, Fase.ocaso])
          _Seccion(
            titulo: 'Mazo del ${fase.nombre}',
            color: colorFase(fase),
            children: [
              for (var i = 0; i < con.peligrosDe(fase).length; i++)
                _FilaPeligro(
                  peligro: con.peligrosDe(fase)[i],
                  onCambio: (p) => setState(() => con.peligrosDe(fase)[i] = p),
                ),
            ],
          ),

        _Seccion(
          titulo: 'Jefes finales',
          color: kJefe,
          children: [
            for (var i = 0; i < con.jefes.length; i++)
              _FilaJefe(
                jefe: con.jefes[i],
                onCambio: (j) => setState(() => con.jefes[i] = j),
              ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  double _promedio(List<(CartaCombate, int)> mazo) {
    final total = mazo.fold<int>(0, (a, e) => a + e.$2);
    if (total == 0) return 0;
    final suma = mazo.fold<int>(0, (a, e) => a + e.$1.poder * e.$2);
    return suma / total;
  }

  Future<void> _importar(BuildContext context, AppState app) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pegá el JSON de configuración'),
        content: SizedBox(
          width: 500,
          child: TextField(
            controller: ctrl,
            maxLines: 12,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Importar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final err = app.importar(ctrl.text);
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      } else {
        setState(() => _version++);
      }
    }
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  final Color? color;
  const _Seccion({required this.titulo, required this.children, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border.all(
          color: (color ?? Colors.white24).withValues(alpha: .35),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.white,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: children,
        ),
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  final String label;
  final double valor, min, max;
  final ValueChanged<double> onChanged;
  const _Slider({
    required this.label,
    required this.valor,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 260,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: valor.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            label: '${valor.round()}',
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 34,
          child: Text(
            '${valor.round()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _Num extends StatelessWidget {
  final String label;
  final int valor;
  final ValueChanged<int> onChanged;
  final double ancho;
  const _Num({
    required this.label,
    required this.valor,
    required this.onChanged,
    this.ancho = 62,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      child: TextFormField(
        initialValue: '$valor',
        style: const TextStyle(fontSize: 13),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 11),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          border: const OutlineInputBorder(),
        ),
        onChanged: (t) {
          final v = int.tryParse(t);
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _FilaCombate extends StatelessWidget {
  final CartaCombate carta;
  final int cantidad;
  final ValueChanged<int> onCantidad;
  final ValueChanged<CartaCombate> onCarta;
  const _FilaCombate({
    required this.carta,
    required this.cantidad,
    required this.onCantidad,
    required this.onCarta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 190,
            child: Text(carta.nombre, style: const TextStyle(fontSize: 13)),
          ),
          _Num(label: 'x', valor: cantidad, onChanged: onCantidad, ancho: 54),
          const SizedBox(width: 8),
          _Num(
            label: 'poder',
            valor: carta.poder,
            onChanged: (v) => onCarta(carta.copyWith(poder: v)),
          ),
          const SizedBox(width: 8),
          _Num(
            label: 'roba',
            valor: carta.efecto.roba,
            onChanged: (v) =>
                onCarta(carta.copyWith(efecto: carta.efecto.copyWith(roba: v))),
          ),
          const SizedBox(width: 8),
          _Num(
            label: '⚡ jugar',
            valor: carta.efecto.energiaAlJugar,
            onChanged: (v) => onCarta(
              carta.copyWith(efecto: carta.efecto.copyWith(energiaAlJugar: v)),
            ),
          ),
          const SizedBox(width: 8),
          _Num(
            label: '⚡ ganar',
            valor: carta.efecto.energiaSiGanas,
            onChanged: (v) => onCarta(
              carta.copyWith(efecto: carta.efecto.copyWith(energiaSiGanas: v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaPeligro extends StatelessWidget {
  final CartaPeligro peligro;
  final ValueChanged<CartaPeligro> onCambio;
  const _FilaPeligro({required this.peligro, required this.onCambio});

  @override
  Widget build(BuildContext context) {
    final r = peligro.recompensa;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 210,
            child: Text(peligro.nombre, style: const TextStyle(fontSize: 13)),
          ),
          _Num(
            label: 'poder',
            valor: peligro.poder,
            onChanged: (v) => onCambio(peligro.copyWith(poder: v)),
          ),
          _Num(
            label: 'daño',
            valor: peligro.dano,
            onChanged: (v) => onCambio(peligro.copyWith(dano: v)),
          ),
          _Num(
            label: 'gratis',
            valor: peligro.cartasGratis,
            onChanged: (v) => onCambio(peligro.copyWith(cartasGratis: v)),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: Text(
              '→ ${r.nombre}',
              style: const TextStyle(fontSize: 12, color: kCombate),
            ),
          ),
          _Num(
            label: 'poder rec.',
            valor: r.poder,
            ancho: 74,
            onChanged: (v) =>
                onCambio(peligro.copyWith(recompensa: r.copyWith(poder: v))),
          ),
        ],
      ),
    );
  }
}

class _FilaJefe extends StatelessWidget {
  final CartaJefe jefe;
  final ValueChanged<CartaJefe> onCambio;
  const _FilaJefe({required this.jefe, required this.onCambio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: Text(jefe.nombre, style: const TextStyle(fontSize: 13)),
          ),
          _Num(
            label: 'poder',
            valor: jefe.poder,
            onChanged: (v) => onCambio(jefe.copyWith(poder: v)),
          ),
          const SizedBox(width: 8),
          _Num(
            label: 'daño',
            valor: jefe.dano,
            onChanged: (v) => onCambio(jefe.copyWith(dano: v)),
          ),
          const SizedBox(width: 8),
          _Num(
            label: 'gratis',
            valor: jefe.cartasGratis,
            onChanged: (v) => onCambio(jefe.copyWith(cartasGratis: v)),
          ),
        ],
      ),
    );
  }
}
