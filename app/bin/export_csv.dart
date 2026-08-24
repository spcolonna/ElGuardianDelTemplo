// Genera un CSV por cada tipo de carta a imprimir: `dart run bin/export_csv.dart`
//
// Cada fila es UNA carta y cada columna un atributo que va impreso o que hace
// falta para producirla. La carta se lee con NÚMERO + ÍCONO: la explicación de
// qué significa cada número va en la carta de referencia del manual, no en cada
// carta. Por eso acá no hay textos de reglas.
import 'dart:io';

import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/mecanica.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/temas/temas.dart';

// --------------------------------------------------------------- constantes
// Tres medidas distintas, y por eso van en columnas separadas y explícitas:
//  · cartaPx    → la carta entera con sangrado, 69 x 94 mm @300 dpi
//  · generarPx  → a qué tamaño pedirle la ilustración al generador
//  · finalPx    → a qué tamaño se coloca esa ilustración dentro de la carta
const cartaPx = '815x1110';
const generarPx = '1024x1024';
const finalPx = '265x265'; // 22,4 mm @300 dpi — medido sobre el mockup
const finalPxJefe = '430x430'; // el jefe no tiene mitad de técnica
const reversoPx = '815x1110'; // el reverso ocupa la carta entera

String hex(int argb) =>
    '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

// ------------------------------------------------------------------ helpers
String q(Object? v) {
  final s = '$v';
  return s.contains(',') || s.contains('"') || s.contains('\n')
      ? '"${s.replaceAll('"', '""')}"'
      : s;
}

String fila(List<Object?> c) => c.map(q).join(',');

/// Efecto en la forma corta que va impresa: número + ícono.
String efecto(Efecto e) {
  final p = <String>[];
  if (e.roba > 0) p.add('+${e.roba} 🃏');
  if (e.energiaAlJugar != 0) {
    p.add('${e.energiaAlJugar > 0 ? '+' : '−'}${e.energiaAlJugar.abs()} ⚡');
  }
  if (e.energiaSiGanas != 0) {
    p.add(
      '${e.energiaSiGanas > 0 ? '+' : '−'}${e.energiaSiGanas.abs()} ⚡ '
      'si ganás',
    );
  }
  if (e.reducePeligro > 0) p.add('−${e.reducePeligro} 👊 al peligro');
  return p.isEmpty ? '—' : p.join(' · ');
}

void main(List<String> args) {
  final idTema = args
      .firstWhere((a) => a.startsWith('--tema='), orElse: () => '--tema=templo')
      .substring(7);
  final idioma = args
      .firstWhere((a) => a.startsWith('--idioma='), orElse: () => '--idioma=es')
      .substring(9);
  final tema = temaPorId(idTema);
  final t = tema.textosDe(idioma);
  final c = contenidoDe(tema, idioma);
  String prompt(String id) => tema.promptDe(id);

  // Cada tema e idioma escribe en su propia carpeta.
  final dir = Directory('../csv/${tema.id}/$idioma')
    ..createSync(recursive: true);

  for (final viejo in [
    'cartas_mecanica.csv',
    'cartas_tema.csv',
    'config.csv',
  ]) {
    final f = File('${dir.path}/$viejo');
    if (f.existsSync()) f.deleteSync();
  }

  // =================================================== 1. TÉCNICAS INICIALES
  final ini = <String>[
    fila([
      'copias_a_imprimir',
      'archivo',
      'nombre',
      'poder',
      'efecto',
      'texto_sabor',
      'arte_prompt',
      'arte_generar_px',
      'arte_final_px',
      'carta_px',
    ]),
  ];
  for (final (carta, copias) in c.mazoInicial) {
    ini.add(
      fila([
        copias,
        'cartas/${archivoCarta(carta.id)}.jpg',
        carta.nombre,
        carta.poder,
        efecto(carta.efecto),
        carta.sabor,
        prompt(carta.id),
        generarPx,
        finalPx,
        cartaPx,
      ]),
    );
  }
  File(
    '${dir.path}/cartas_iniciales.csv',
  ).writeAsStringSync('${ini.join('\n')}\n');

  // =============================================== 2. CARTAS PELIGRO/TÉCNICA
  final pt = <String>[
    fila([
      'mazo',
      'archivo',
      'color_banda_hex',
      'peligro_nombre',
      'peligro_poder',
      'peligro_dano',
      'peligro_cartas_gratis',
      'peligro_arte_prompt',
      'tecnica_nombre',
      'tecnica_poder',
      'tecnica_efecto',
      'tecnica_texto_sabor',
      'tecnica_arte_prompt',
      'arte_generar_px',
      'arte_final_px',
      'carta_px',
    ]),
  ];
  for (final fase in [Fase.alba, Fase.mediodia, Fase.ocaso]) {
    for (final p in c.peligrosDe(fase)) {
      final r = p.recompensa;
      pt.add(
        fila([
          t.nombreFase[fase],
          'cartas/${p.id}.jpg',
          hex(tema.colorFase[fase]!),
          p.nombre,
          p.poder,
          p.dano,
          p.cartasGratis,
          prompt(p.id),
          r.nombre,
          r.poder,
          efecto(r.efecto),
          r.sabor,
          prompt(r.id),
          generarPx,
          finalPx,
          cartaPx,
        ]),
      );
    }
  }
  File(
    '${dir.path}/cartas_peligro_tecnica.csv',
  ).writeAsStringSync('${pt.join('\n')}\n');

  // ============================================================== 3. JEFES
  final jf = <String>[
    fila([
      'archivo',
      'nombre',
      'poder',
      'dano',
      'cartas_gratis',
      'texto_lore',
      'arte_prompt',
      'arte_generar_px',
      'arte_final_px',
      'carta_px',
    ]),
  ];
  for (final j in c.jefes) {
    jf.add(
      fila([
        'cartas/${j.id}.jpg',
        j.nombre,
        j.poder,
        j.dano,
        j.cartasGratis,
        j.lore,
        prompt(j.id),
        generarPx,
        finalPxJefe,
        cartaPx,
      ]),
    );
  }
  File('${dir.path}/cartas_jefes.csv').writeAsStringSync('${jf.join('\n')}\n');

  // =========================================================== 4. REVERSOS
  // El reverso ocupa la carta entera: generar y final son el tamaño de la carta.
  final rev = <String>[
    fila([
      'mazo',
      'archivo',
      'que_cartas_lleva',
      'color_fondo_hex',
      'descripcion',
      'arte_prompt',
      'arte_generar_px',
      'arte_final_px',
      'carta_px',
    ]),
    for (final r in tema.reversos)
      fila([
        t.reversos[r.mazo]?.nombre ?? r.mazo,
        'cartas/reverso_${r.mazo.toLowerCase().replaceAll('í', 'i')}.jpg',
        t.reversos[r.mazo]?.queCartasLleva ?? '',
        r.colorFondoHex,
        t.reversos[r.mazo]?.descripcion ?? '',
        r.prompt,
        reversoPx,
        reversoPx,
        cartaPx,
      ]),
  ];
  File(
    '${dir.path}/reverso_cartas.csv',
  ).writeAsStringSync('${rev.join('\n')}\n');

  // ------------------------------------------------------------------ aviso
  final faltantes = <String>[];
  for (final (carta, _) in c.mazoInicial) {
    if (!tema.sujetosArte.containsKey(carta.id)) faltantes.add(carta.id);
  }
  for (final fase in [Fase.alba, Fase.mediodia, Fase.ocaso]) {
    for (final p in c.peligrosDe(fase)) {
      if (!tema.sujetosArte.containsKey(p.id)) faltantes.add(p.id);
      if (!tema.sujetosArte.containsKey(p.recompensa.id))
        faltantes.add(p.recompensa.id);
    }
  }
  for (final j in c.jefes) {
    if (!tema.sujetosArte.containsKey(j.id)) faltantes.add(j.id);
  }

  stdout.writeln('Tema: ${t.nombre} · idioma: $idioma');
  stdout.writeln('Escritos en csv/${tema.id}/$idioma/:');
  stdout.writeln(
    '  cartas_iniciales.csv        ${ini.length - 1} filas × '
    '${ini.first.split(',').length} columnas',
  );
  stdout.writeln(
    '  cartas_peligro_tecnica.csv  ${pt.length - 1} filas × '
    '${pt.first.split(',').length} columnas',
  );
  stdout.writeln(
    '  cartas_jefes.csv            ${jf.length - 1} filas × '
    '${jf.first.split(',').length} columnas',
  );
  stdout.writeln(
    '  reverso_cartas.csv          ${rev.length - 1} filas × '
    '${rev.first.split(',').length} columnas',
  );
  stdout.writeln(
    faltantes.isEmpty
        ? 'Prompts de arte: completos.'
        : 'FALTAN PROMPTS: ${faltantes.join(", ")}',
  );
}
