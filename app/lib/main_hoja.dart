// Hoja de contacto de las 50 cartas, para mirar el rotulado de un vistazo.
// Herramienta de desarrollo: `flutter run -t lib/main_hoja.dart`.
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'idiomas.dart';
import 'mecanica.dart';
import 'modos/cansancio.dart';
import 'ui_carta.dart';

void main() => runApp(const _Hoja());

class _Hoja extends StatefulWidget {
  const _Hoja();
  @override
  State<_Hoja> createState() => _HojaState();
}

class _HojaState extends State<_Hoja> {
  final estado = AppState();
  var i = 0;
  var cols = 3;

  @override
  Widget build(BuildContext context) {
    final ids = <String>[
      for (final p in mecPeligros) p.id,
      for (final c in mazoCansancio) c.id,
      for (final (id, _) in mecMazoInicial) id,
      for (final j in mecJefes) j.id,
    ];
    estado.idiomaElegido = codigosIdioma[i % codigosIdioma.length];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppScope(
        state: estado,
        child: Scaffold(
          backgroundColor: const Color(0xFF241C14),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                heroTag: 'c',
                onPressed: () => setState(() => cols = cols == 3 ? 1 : 3),
                label: Text('$cols'),
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                heroTag: 'i',
                onPressed: () => setState(() => i++),
                label: Text(estado.idiomaElegido!),
              ),
            ],
          ),
          body: SafeArea(
            child: GridView.count(
              crossAxisCount: cols,
              childAspectRatio: .62,
              padding: const EdgeInsets.all(6),
              children: [
                for (final id in ids)
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: CartaView(id: id, ancho: cols == 1 ? 380 : 130),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
