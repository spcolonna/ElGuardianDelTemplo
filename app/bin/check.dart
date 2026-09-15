// Chequeos del motor: `dart run bin/check.dart`
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:guardian_templo/cartas_rotulo.dart';
import 'package:guardian_templo/data.dart';
import 'package:guardian_templo/mecanica.dart';
import 'package:guardian_templo/engine.dart';
import 'package:guardian_templo/idiomas.dart';
import 'package:guardian_templo/modos/cansancio.dart';
import 'package:guardian_templo/modos/encargos.dart';
import 'package:guardian_templo/models.dart';
import 'package:guardian_templo/l10n.dart';
import 'package:guardian_templo/logros.dart';
import 'package:guardian_templo/modos/dificultad.dart';
import 'package:guardian_templo/progreso.dart';
import 'package:guardian_templo/temas/temas.dart';
import 'package:guardian_templo/tutorial.dart';

void main() {
  final con = contenidoPorDefecto();

  // 1) Auto-revelado: tras crear la partida y tras cada continuar(),
  //    nunca queda en esperandoPeligro.
  var quedoEsperando = 0;
  final fasesVistas = <String>[];
  final j = Juego(
    cfg: Config(energiaInicial: 200, energiaMaxima: 200),
    contenido: con,
    rng: Random(7),
  );
  if (j.estado == EstadoJuego.esperandoPeligro) quedoEsperando++;
  var faseAnterior = j.fase;
  fasesVistas.add(j.fase.nombre);

  var pasos = 0;
  while (!j.terminado && pasos++ < 500) {
    while (j.estado == EstadoJuego.enCombate &&
        j.sumaMesa < j.poderPeligroEfectivo &&
        j.puedeRobar) {
      j.robar();
    }
    j.resolver();
    j.continuar();
    if (j.estado == EstadoJuego.esperandoPeligro) quedoEsperando++;
    if (j.fase != faseAnterior) {
      faseAnterior = j.fase;
      fasesVistas.add(j.fase.nombre);
    }
  }

  print(
    '1) Veces que quedó en "esperandoPeligro": $quedoEsperando  '
    '(esperado 0)',
  );
  print('2) Secuencia de fases: ${fasesVistas.join(" -> ")}');
  print('   Resultado: ${j.estado}');

  // 3) Llegar a 0 exacto no mata; el siguiente golpe sí.
  final k = Juego(
    cfg: Config(energiaInicial: 20, energiaMaxima: 20),
    contenido: con,
    rng: Random(3),
  );
  k.energia = k.peligro!.dano; // justo lo que hace falta para quedar en 0
  k.resolver();
  print(
    '3) Se rinde con la energía justa -> queda en ${k.energia}, '
    'estado ${k.estado}  (esperado 0 y NO derrota)',
  );
  k.continuar();
  print(
    '   ¿Puede seguir jugando? ${!k.terminado} · '
    '¿puede pagar un robo? ${k.puedeRobar && !k.puedeRobarGratis}',
  );
  while (k.puedeRobarGratis) {
    k.robar();
  }
  k.resolver();
  print('   Tras el siguiente golpe: energía ${k.energia}, estado ${k.estado}');

  // 4) Con 0 de energía no puede pagar robos ni meditar.
  final m = Juego(
    cfg: Config(energiaInicial: 0, energiaMaxima: 20),
    contenido: con,
    rng: Random(1),
  );
  while (m.puedeRobarGratis && m.puedeRobar) {
    m.robar();
  }
  print(
    '4) Con 0 de Energía y sin cartas gratis, ¿puede robar pagando? '
    '${m.puedeRobar}  (esperado false)',
  );

  // 5) Racha diaria: se completa ganando, se corta si pasa un día sin ganar.
  final d1 = DateTime(2026, 3, 1);
  final p = Progreso();
  for (var i = 0; i < 7; i++) {
    p.registrarVictoria(d1.add(Duration(days: i)));
  }
  print(
    '5) 7 días seguidos -> racha ${p.racha}, logro ${p.logroActivo}  '
    '(esperado 7 y true)',
  );

  // ganar dos veces el mismo día no suma
  final antes = p.racha;
  p.registrarVictoria(d1.add(const Duration(days: 6)));
  print(
    '   Segunda victoria el mismo día: racha $antes -> ${p.racha}  '
    '(no debe cambiar)',
  );

  // saltearse un día corta la cadena y quita el logro
  p.revisarCadena(d1.add(const Duration(days: 9)));
  print(
    '   Tras saltear un día: racha ${p.racha}, logro ${p.logroActivo}  '
    '(esperado 0 y false)',
  );
  print('   Mejor racha conservada: ${p.mejorRacha}  (esperado 7)');

  // 6) El encargo del día es determinístico.
  final e1 = encargoDelDia(DateTime(2026, 5, 4));
  final e2 = encargoDelDia(DateTime(2026, 5, 4));
  final e3 = encargoDelDia(DateTime(2026, 5, 5));
  print(
    '6) Encargo determinístico por fecha: ${e1.id == e2.id}  '
    '(esperado true) · cambia al día siguiente: ${e1.id != e3.id}',
  );

  // 7) Modo Cansancio: entra una carta por fase y son basura.
  final cc = Config(energiaInicial: 200, energiaMaxima: 200)
    ..modoCansancio = true
    ..poderCansancio = -1
    ..disparoCansancio = DisparoCansancio.finDeFase.index;
  final jc = Juego(cfg: cc, contenido: con, rng: Random(11));
  var pasos2 = 0;
  while (!jc.terminado && pasos2++ < 500) {
    while (jc.estado == EstadoJuego.enCombate &&
        jc.sumaMesa < jc.poderPeligroEfectivo &&
        jc.puedeRobar) {
      jc.robar();
    }
    jc.resolver();
    jc.continuar();
  }
  final basura = [
    ...jc.mazo,
    ...jc.descarte,
    ...jc.eliminadas,
  ].where((c) => c.id.startsWith('cans_')).toList();
  print(
    '7) Cansancio agregado: ${jc.cansancioAgregado}  (esperado 3, una por '
    'fase) · cartas en juego: ${basura.length}',
  );
  print('   Poderes de esas cartas: ${basura.map((c) => c.poder).toSet()}');

  // 8) Con el modo apagado no entra ninguna.
  final js = Juego(
    cfg: Config(energiaInicial: 200, energiaMaxima: 200),
    contenido: con,
    rng: Random(11),
  );
  var pasos3 = 0;
  while (!js.terminado && pasos3++ < 500) {
    while (js.estado == EstadoJuego.enCombate &&
        js.sumaMesa < js.poderPeligroEfectivo &&
        js.puedeRobar) {
      js.robar();
    }
    js.resolver();
    js.continuar();
  }
  print(
    '8) Con el modo apagado, cansancio agregado: ${js.cansancioAgregado}  '
    '(esperado 0)',
  );

  // 9) Cobertura de traducción: ningún idioma puede tener huecos.
  //
  // Esto es lo que impide que agregar un idioma sea agregarlo a medias. El
  // `??` de `textosDe()` y el de `TextosUi.call()` son buenos fallbacks en
  // runtime y pésimos avisos: tapan la falta con español y con la clave
  // pelada, así que un idioma incompleto se ve como un idioma terminado.
  var huecos = 0;

  // 9a) Una sola lista de idiomas. `lib/idiomas.dart` es la fuente de verdad;
  //     si alguien agrega uno ahí y se olvida de `templo.dart` o de los mapas
  //     de UI, el juego arranca igual y muestra español.
  final esperados = codigosIdioma.toSet();
  final enUi = TextosUi.idiomas.toSet();
  if (!_mismos(enUi, esperados)) {
    print('   TextosUi habla $enUi y la lista dice $esperados');
    huecos++;
  }
  for (final tema in temasDisponibles) {
    final suyos = tema.idiomas.toSet();
    if (!_mismos(suyos, esperados)) {
      print('   El tema "${tema.id}" habla $suyos y la lista dice $esperados');
      huecos++;
    }
  }

  // 9b) Claves huérfanas: una que existe en otro idioma y no en español es la
  //     traducción de algo que se borró, y se arrastra para siempre.
  for (final idioma in TextosUi.idiomas) {
    for (final k in TextosUi.mapaDe(idioma).keys) {
      if (!TextosUi.mapaDe('es').containsKey(k)) {
        print('   SOBRA texto de UI "$k" en $idioma (no está en es)');
        huecos++;
      }
    }
  }

  // 9c) Los `{placeholders}` tienen que ser los mismos en todos los idiomas.
  //     Una traducción que se come un `{carta}` no rompe nada: escribe la
  //     llave cruda en pantalla y nadie la ve hasta que la ve un jugador.
  for (final idioma in TextosUi.idiomas) {
    for (final k in TextosUi.claves) {
      final base = _huecosDe(TextosUi.mapaDe('es')[k]!);
      final otro = _huecosDe(TextosUi.mapaDe(idioma)[k] ?? '');
      if (!_mismos(base, otro)) {
        print('   "$k" en $idioma usa $otro y el original $base');
        huecos++;
      }
    }
  }
  for (final tema in temasDisponibles) {
    final base = tema.textosDe('es');
    for (final idioma in tema.idiomas) {
      final t = tema.textosDe(idioma);
      for (final id in base.cartas.keys) {
        if (!t.cartas.containsKey(id)) {
          print('   FALTA carta "$id" en $idioma');
          huecos++;
        }
      }
      for (final sec in tema.paneles.entries) {
        for (final p in sec.value) {
          final panel = t.paneles[p.archivo];
          if (panel == null) {
            print('   FALTA viñeta "${p.archivo}" en $idioma');
            huecos++;
            continue;
          }
          // La conversación tiene que tener los mismos turnos en todos los
          // idiomas: una traducción a la que le falta la respuesta deja el
          // chiste sin remate, y eso no lo agarra un chequeo de claves.
          final n = base.paneles[p.archivo]!.conversacion.length;
          if (panel.conversacion.length != n) {
            print(
              '   "${p.archivo}" en $idioma tiene '
              '${panel.conversacion.length} líneas y el original $n',
            );
            huecos++;
          }
        }
      }
      for (final id in base.encargos.keys) {
        if (!t.encargos.containsKey(id)) {
          print('   FALTA encargo "$id" en $idioma');
          huecos++;
        }
      }
      for (final m in base.reversos.keys) {
        if (!t.reversos.containsKey(m)) {
          print('   FALTA reverso "$m" en $idioma');
          huecos++;
        }
      }
    }
  }
  for (final idioma in TextosUi.idiomas) {
    for (final k in TextosUi.claves) {
      if (!TextosUi.mapaDe(idioma).containsKey(k)) {
        print('   FALTA texto de UI "$k" en $idioma');
        huecos++;
      }
    }
  }
  print('9) Huecos de traducción: $huecos  (esperado 0)');

  // 10) El tutorial es determinista y cumple el guion.
  final jt = Juego(
    cfg: configTutorial(),
    contenido: contenidoTutorial(temaTemplo, 'es'),
    rng: Random(1),
    barajar: false,
  );
  final p1 = jt.peligro!.id;
  jt.robar();
  jt.robar();
  final gana1 = jt.sumaMesa >= jt.poderPeligroEfectivo;
  jt.resolver();
  jt.continuar();
  final p2 = jt.peligro!.id;
  while (jt.puedeRobarGratis) {
    jt.robar();
  }
  final pierde2 = jt.sumaMesa < jt.poderPeligroEfectivo;
  jt.resolver();
  final hayDuda = jt.descarte.any((c) => c.id == 'duda_existencial');
  print(
    '10) Tutorial: peligro1=$p1 gana=$gana1 · peligro2=$p2 '
    'pierde=$pierde2 · puedeMeditar=${jt.puedeMeditar} · '
    'la Duda está en el descarte=$hayDuda',
  );
  print('    (esperado alba1/true, alba8/true, true, true)');

  // 11) Todas las cartas ilustradas tienen que medir lo mismo.
  final dir = Directory('assets/cartas');
  if (dir.existsSync()) {
    final imgs = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.png'))
        .toList();
    var distintas = 0;
    var disfrazadas = 0;
    for (final f in imgs) {
      // Los jefes son apaisados a propósito: 1620x1024. El resto, vertical.
      final nombre = f.uri.pathSegments.last;
      final esJefe = mecJefes.any((j) => nombre.startsWith(j.id));
      final (ew, eh) = esJefe ? (1620, 1024) : (1024, 1620);
      final bytes = f.readAsBytesSync();
      final (w, h) = _medida(bytes);
      if (w != ew || h != eh) {
        print('   $nombre: $w x $h  (esperado $ew x $eh)');
        distintas++;
      }
      // Flutter decodifica por contenido, así que un PNG llamado .jpg se ve
      // igual de bien — y pesa diez veces más. El nombre miente en silencio.
      final esPng = bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50;
      final dicePng = nombre.endsWith('.png');
      if (esPng != dicePng) {
        print(
          '   $nombre se llama ${dicePng ? 'PNG' : 'JPG'} pero por dentro es '
          '${esPng ? 'PNG' : 'JPEG'}',
        );
        disfrazadas++;
      }
    }
    print(
      '11) Cartas ilustradas: ${imgs.length} · con medida distinta: '
      '$distintas · con formato disfrazado: $disfrazadas  (esperado 0 y 0)',
    );
  } else {
    print('11) No hay assets/cartas todavía.');
  }

  // 12) El archivo que levanta el juego tiene que reproducir el balance
  // simulado. Si se desincroniza, el teléfono juega otro juego.
  final fCfg = File('assets/config.json');
  if (!fCfg.existsSync()) {
    print('12) FALTA assets/config.json');
  } else {
    final leido = Config.fromJson(
      jsonDecode(fCfg.readAsStringSync()) as Map<String, dynamic>,
    );
    final igual = jsonEncode(leido.toJson()) == jsonEncode(Config().toJson());
    print(
      '12) assets/config.json parsea e iguala al Config() por defecto: '
      '$igual  (esperado true)',
    );
  }

  // 13) El preset Guardián tiene que ser la IDENTIDAD sobre Config(): es lo
  // que garantiza que el juego por defecto sea el mismo que mide bin/sim.dart.
  final identidad =
      jsonEncode(aplicarDificultad(Config(), Dificultad.guardian).toJson()) ==
      jsonEncode(Config().toJson());
  print(
    '13) El preset Guardián es la identidad sobre Config(): '
    '$identidad  (esperado true)',
  );
  for (final d in Dificultad.values) {
    final c = aplicarDificultad(Config(), d);
    print(
      '    ${d.name.padRight(17)} energía ${c.energiaInicial}, '
      'peligros ${c.peligrosPorFase}, jefes ${c.cantidadJefes}, '
      'robo ${c.costeRoboExtra}'
      // El disparo por nombre y no por índice: «cansancio 0» se leía como
      // apagado cuando en realidad es `finDeFase`.
      '${c.modoCansancio ? ', cansancio '
                '${DisparoCansancio.values[c.disparoCansancio].name}' : ''}',
    );
  }

  // 14) Las medidas del arte de interfaz son contrato: si una regeneración
  // llega con un píxel de más, el centerSlice queda corrido y se ve raro sin
  // que nada falle. Esto lo detecta antes de que llegue al teléfono.
  if (!Directory('assets/ui').existsSync()) {
    print('14) Todavía no hay assets/ui (se usan los respaldos pintados).');
  } else {
    var malas = 0, faltan = 0;
    for (final e in piezasEsperadas.entries) {
      final f = File('assets/ui/${e.key}');
      if (!f.existsSync()) {
        faltan++;
        continue;
      }
      final (w, h) = _medida(f.readAsBytesSync());
      if (w != e.value.$1 || h != e.value.$2) {
        print(
          '    ${e.key}: $w x $h  (esperado ${e.value.$1} x ${e.value.$2})',
        );
        malas++;
      }
    }
    print(
      '14) Arte de interfaz: ${piezasEsperadas.length - faltan} de '
      '${piezasEsperadas.length} presentes · con medida distinta: $malas  '
      '(esperado 0)',
    );
  }

  // 15) El catálogo de logros: ids únicos, textos en los dos idiomas, y
  // ninguna condición que explote sin partida (la galería las evalúa así).
  final ids = catalogoLogros.map((l) => l.id).toSet();
  var sinTexto = 0;
  for (final l in catalogoLogros) {
    for (final idioma in TextosUi.idiomas) {
      final m = TextosUi.mapaDe(idioma);
      if (!m.containsKey(l.claveTitulo) || !m.containsKey(l.claveDesc)) {
        print('    falta texto de ${l.id} en $idioma');
        sinTexto++;
      }
    }
  }
  var explotan = 0;
  for (final l in catalogoLogros) {
    try {
      l.condicion(null, Progreso(), LogrosEstado());
    } catch (e) {
      print('    ${l.id} explota sin partida: $e');
      explotan++;
    }
  }
  print(
    '15) Logros: ${catalogoLogros.length} · ids únicos: '
    '${ids.length == catalogoLogros.length} · sin texto: $sinTexto · '
    'explotan sin partida: $explotan  (esperado true, 0, 0)',
  );

  // 16) Cobertura del arte: qué cartas del juego todavía no tienen imagen.
  //
  // `pubspec.yaml` declara `assets/cartas/` sin recursión, así que una carta
  // dentro de una subcarpeta NO entra al build y en el teléfono sale la carta
  // dibujada sin que nada falle. Esto lo hace visible.
  final contenido = contenidoDe(temaTemplo, 'es');
  final delJuego = <String>{};
  for (final (carta, _) in contenido.mazoInicial) {
    delJuego.add(carta.id);
  }
  for (final f in [contenido.alba, contenido.mediodia, contenido.ocaso]) {
    for (final p in f) {
      delJuego.add(p.id);
      delJuego.add(p.recompensa.id);
    }
  }
  for (final j in contenido.jefes) {
    delJuego.add(j.id);
  }
  // El modo Cansancio está apagado por defecto, pero sus diez cartas se
  // imprimen y se dibujan igual: si les falta el arte hay que enterarse acá.
  for (final c in mazoCansancio) {
    delJuego.add(c.id);
  }
  final sinArte = <String>[];
  for (final id in delJuego) {
    final base = archivoCarta(id);
    if (!File('assets/cartas/$base.jpg').existsSync() &&
        !File('assets/cartas/$base.png').existsSync()) {
      sinArte.add(base);
    }
  }
  sinArte.sort();
  print(
    '16) Cartas con arte: ${delJuego.length - sinArte.length} de '
    '${delJuego.length}${sinArte.isEmpty ? '' : ' · faltan: ${sinArte.join(', ')}'}',
  );

  // 17) Sólo las técnicas de recompensa se dibujan giradas: son la mitad de
  // abajo de la carta del peligro. Las iniciales tienen carta propia, y
  // girarlas fue un bug que estuvo a la vista sin que nada fallara.
  var giroMal = 0;
  for (final p in mecPeligros) {
    if (!cartaRotada(p.recompensa)) {
      print('    ${p.recompensa} debería girar y no gira');
      giroMal++;
    }
    if (cartaRotada(p.id)) {
      print('    ${p.id} es un peligro y no debería girar');
      giroMal++;
    }
  }
  for (final (id, _) in mecMazoInicial) {
    if (cartaRotada(id)) {
      print('    $id es del mazo inicial y no debería girar');
      giroMal++;
    }
  }
  for (final j in mecJefes) {
    if (cartaRotada(j.id)) {
      print('    ${j.id} es un jefe y no debería girar');
      giroMal++;
    }
  }
  print(
    '17) Giro de carta: ${mecPeligros.length} recompensas giran, '
    'peligros/jefes/iniciales no · errores: $giroMal  (esperado 0)',
  );

  // 18) Las viñetas del cómic existen EN DISCO y son PNG de verdad.
  //
  // El chequeo 9 sólo mira que el panel esté traducido, así que un archivo
  // faltante o corrupto no lo agarraba. Y no rompen la app: el errorBuilder
  // de ui_intro.dart dibuja el placeholder con el boceto y la partida sigue,
  // o sea que un panel roto puede pasar meses sin que nadie lo note. Ya pasó:
  // cuatro descargas vencidas quedaron guardadas como .png de 45 bytes con un
  // JSON de error adentro.
  var vinetasMal = 0;
  var vinetas = 0;
  for (final tema in temasDisponibles) {
    for (final sec in tema.paneles.entries) {
      for (final panel in sec.value) {
        vinetas++;
        final f = File('assets/comic/${panel.archivo}');
        if (!f.existsSync()) {
          print('    FALTA assets/comic/${panel.archivo}');
          vinetasMal++;
          continue;
        }
        // Se acepta PNG o JPEG sin mirar la extensión, porque Flutter
        // decodifica por contenido: hoy `01_templo_amanecer.png` es en
        // realidad un JPEG y se ve perfecto. Lo que se busca acá no es el
        // formato correcto, es que el archivo sea una imagen y no otra cosa.
        final b = f.readAsBytesSync();
        final esPng =
            b.length > 8 &&
            b[0] == 0x89 &&
            b[1] == 0x50 &&
            b[2] == 0x4E &&
            b[3] == 0x47;
        final esJpeg = b.length > 4 && b[0] == 0xFF && b[1] == 0xD8;
        if (!esPng && !esJpeg) {
          print(
            '    ROTA assets/comic/${panel.archivo} '
            '(${b.length} bytes, no es una imagen)',
          );
          vinetasMal++;
          continue;
        }
        // Y que además esté COMPLETA. Una descarga cortada a la mitad tiene
        // el encabezado bien y no se ve igual; el final es lo que falta.
        final cerrada = esPng
            ? (b[b.length - 8] == 0x49 && // IEND
                  b[b.length - 7] == 0x45 &&
                  b[b.length - 6] == 0x4E &&
                  b[b.length - 5] == 0x44)
            : (b[b.length - 2] == 0xFF && b[b.length - 1] == 0xD9);
        if (!cerrada) {
          print(
            '    CORTADA assets/comic/${panel.archivo} (${b.length} bytes)',
          );
          vinetasMal++;
        }
      }
    }
  }
  print(
    '18) Viñetas del cómic: ${vinetas - vinetasMal} de $vinetas '
    'presentes y legibles  (esperado 0 errores)',
  );

  // 20) Nada de español fuera de la capa de textos.
  //
  // Este es el chequeo que hace que agregar un idioma sea agregar un idioma y
  // no descubrir, tres pantallas adentro, que las reglas o la bitácora siguen
  // en castellano. Pasó: `reglas_texto.dart` tenía 724 palabras de prosa y un
  // jugador inglés las leía en español desde que existe el inglés.
  //
  // Mira SÓLO literales de string, no comentarios: los comentarios de este
  // repositorio están en español a propósito y así se quedan.
  //
  // Y es un detector parcial, hay que decirlo: encuentra el español acentuado
  // y se le escapa «Peligro», «Tienda» o «Combate». Sirve igual porque la
  // prosa larga casi siempre lleva una tilde; lo que de verdad cierra el
  // agujero es traducir a un quinto idioma y jugar.
  final permitidos = <String, String>{
    'lib/l10n/': 'es la capa de textos',
    'lib/temas/': 'son los textos del tema',
    'lib/ui_balance.dart': 'herramienta interna de playtesting',
    'lib/ui_sim.dart': 'herramienta interna de playtesting',
    'lib/ui_admin.dart': 'herramienta interna de playtesting',
    'lib/models.dart': 'los nombres INTERNOS de fase, para logs y Balance',
    'lib/modos/cansancio.dart': 'las etiquetas internas del disparo',
    'lib/idiomas.dart': 'los nombres de los idiomas van en su propio idioma',
  };
  final acentos = RegExp('[áéíóúÁÉÍÓÚñÑ¿¡üÜ]');
  var castellano = 0;
  for (final f in Directory(
    'lib',
  ).listSync(recursive: true).whereType<File>()) {
    final ruta = f.path;
    if (!ruta.endsWith('.dart')) continue;
    if (permitidos.keys.any(ruta.contains)) continue;
    var n = 0;
    for (final linea in f.readAsLinesSync()) {
      n++;
      final limpia = linea.trimLeft();
      if (limpia.startsWith('//')) continue;
      for (final m in RegExp(r"'((?:[^'\\\n]|\\.)*)'").allMatches(linea)) {
        final s = m[1]!;
        if (!acentos.hasMatch(s)) continue;
        print('   $ruta:$n español suelto: "$s"');
        castellano++;
      }
    }
  }
  print('20) Español fuera de la capa de textos: $castellano  (esperado 0)');

  // 21) Ningún literal partido se pega sin espacio.
  //
  // Dart concatena literales adyacentes sin agregar nada en el medio, así que
  // una prosa larga partida en varias líneas para entrar en 80 columnas queda
  // a merced de dónde cayó el corte. Si la línea termina en palabra y la
  // siguiente empieza en palabra, el jugador lee «si bajade cero».
  //
  // No es hipotético: al mover el guion del tutorial de `tutorial.dart` a las
  // claves se perdieron 34 espacios, en inglés Y en español, y ningún test lo
  // vio porque el string existe, tiene la clave correcta y mide lo esperado.
  // Sólo se ve leyendo, y para eso hay que saber el idioma.
  // El literal puede tener la OTRA comilla adentro —«ganar una carta» va
  // entre comillas dobles dentro de un literal simple— así que no alcanza con
  // prohibir las dos: hay que prohibir sólo la que abrió. Con la versión
  // anterior, esos literales no matcheaban y se salteaban en silencio, que es
  // justo donde estaban dos de los seis pegados que quedaban.
  final finDeLiteral = RegExp(r"""(['"])((?:\\.|(?!\1)[^\\])*)\1\s*$""");
  final iniDeLiteral = RegExp(r"""^(['"])((?:\\.|(?!\1)[^\\])*)\1""");
  // Resuelve los escapes para que un literal terminado en `\n` no cuente como
  // terminado en la letra ene.
  String real(String s) {
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (s[i] == r'\' && i + 1 < s.length) {
        b.write(const {'n': '\n', 't': '\t'}[s[i + 1]] ?? s[i + 1]);
        i++;
      } else {
        b.write(s[i]);
      }
    }
    return b.toString();
  }

  var pegados = 0;
  for (final f in Directory(
    'lib',
  ).listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.dart')) continue;
    final lineas = f.readAsLinesSync();
    for (var i = 0; i < lineas.length - 1; i++) {
      final a = lineas[i].trimRight();
      final b = lineas[i + 1].trim();
      if (a.endsWith(',') || a.endsWith(';')) continue;
      final ma = finDeLiteral.firstMatch(a);
      final mb = iniDeLiteral.firstMatch(b);
      if (ma == null || mb == null) continue;
      final fin = real(ma[2]!);
      final ini = real(mb[2]!);
      if (fin.isEmpty || ini.isEmpty) continue;
      // No alcanza con letra contra letra. «...a ese número.» pegado a «En
      // este caso, dos.» da «número.En», que es igual de ilegible y encima
      // más difícil de ver leyendo, porque el punto disimula. Así que cierra
      // también con puntuación: después de un punto, una coma o dos puntos,
      // una letra sin espacio es siempre un error.
      final cierra = RegExp(r'[\w.,;:!?»)]');
      final abre = RegExp(r'[\w¿¡«]');
      if (cierra.hasMatch(fin[fin.length - 1]) && abre.hasMatch(ini[0])) {
        print(
          '   ${f.path}:${i + 1} se pegan: "...${fin.substring(fin.length - 12 < 0 ? 0 : fin.length - 12)}" + "${ini.substring(0, ini.length < 12 ? ini.length : 12)}..."',
        );
        pegados++;
      }
    }
  }
  print(
    '21) Literales partidos que se pegan sin espacio: $pegados  (esperado 0)',
  );

  // 22) Ninguna carta se queda sin rótulo.
  //
  // El texto de las cartas ya no viaja en el JPG: se dibuja encima, en el
  // idioma del jugador (ver `lib/cartas_rotulo.dart`). El modo de falla es
  // mudo —la carta se ve perfecta, con el nombre viejo horneado en español—
  // así que no hay manera de notarlo salvo mirando las cincuenta, en los siete
  // idiomas, una por una. Esto lo hace en un milisegundo.
  //
  // Se recorren los IDS DE JUEGO y no los archivos porque son más: las 30
  // técnicas de recompensa comparten carta con su peligro, y si alguna dejara
  // de encontrar su placa se vería como un peligro sin nombre.
  var sinRotulo = 0;
  final idsDeCarta = <String>{
    for (final p in mecPeligros) ...[p.id, p.recompensa],
    for (final j in mecJefes) j.id,
    for (final c in mazoCansancio) c.id,
    for (final (id, _) in mecMazoInicial) id,
  };
  for (final idioma in codigosIdioma) {
    final textos = temaTemplo.textosDe(idioma);
    for (final id in idsDeCarta) {
      final placas = rotuloDe(archivoCarta(id), textos);
      final vacia =
          placas.isEmpty ||
          placas.any((p) => p.lineas.any((l) => l.texto.trim().isEmpty));
      if (vacia) {
        print('   $idioma/$id: ${archivoCarta(id)} sin rótulo');
        sinRotulo++;
      }
    }
  }
  print('22) Cartas sin rótulo en algún idioma: $sinRotulo  (esperado 0)');

  // 19) La copia liviana está al día.
  //
  // Lo que se empaqueta no es el arte de `assets/{comic,cartas,ui}` sino la
  // conversión a WebP que escribe `bin/aligerar.py` en `assets/movil/`. El
  // riesgo es silencioso en las dos direcciones: agregar una carta y olvidarse
  // de correr el script deja una carta sin imagen en el teléfono aunque el
  // archivo esté en el repositorio, y retocar un original sin reconvertir deja
  // la versión vieja viajando en el binario. Ninguna de las dos rompe nada
  // — la app dibuja el respaldo o la imagen anterior— así que puede pasar
  // meses sin que nadie lo note, igual que pasó con las viñetas del 18.
  var sinCopia = 0, vencidas = 0, copias = 0;
  for (final familia in ['comic', 'cartas', 'ui']) {
    final dir = Directory('assets/$familia');
    if (!dir.existsSync()) continue;
    for (final f in dir.listSync().whereType<File>()) {
      final nombre = f.uri.pathSegments.last;
      final ext = nombre.contains('.')
          ? nombre.substring(nombre.lastIndexOf('.')).toLowerCase()
          : '';
      if (!['.png', '.jpg', '.jpeg'].contains(ext)) continue;
      copias++;
      final base = nombre.substring(0, nombre.lastIndexOf('.'));
      final webp = File('assets/movil/$familia/$base.webp');
      if (!webp.existsSync()) {
        print('    FALTA assets/movil/$familia/$base.webp');
        sinCopia++;
      } else if (webp.statSync().modified.isBefore(f.statSync().modified)) {
        print(
          '    VIEJA assets/movil/$familia/$base.webp '
          '(el original es más nuevo)',
        );
        vencidas++;
      }
    }
  }
  print(
    '19) Copia para el teléfono: $copias originales · sin convertir: '
    '$sinCopia · desactualizadas: $vencidas  (esperado 0 y 0)',
  );
  if (sinCopia > 0 || vencidas > 0) {
    print('    Se arregla con: python3 bin/aligerar.py');
  }
}

/// Lee ancho y alto del encabezado, sin decodificar la imagen entera.
/// Sirve para PNG y para JPEG.
(int?, int?) _medida(List<int> b) {
  if (b.length > 24 && b[0] == 0x89 && b[1] == 0x50) {
    return (
      (b[16] << 24) | (b[17] << 16) | (b[18] << 8) | b[19],
      (b[20] << 24) | (b[21] << 16) | (b[22] << 8) | b[23],
    );
  }
  for (var i = 2; i + 9 < b.length; i++) {
    if (b[i] == 0xFF && (b[i + 1] == 0xC0 || b[i + 1] == 0xC2)) {
      return ((b[i + 7] << 8) | b[i + 8], (b[i + 5] << 8) | b[i + 6]);
    }
  }
  return (null, null);
}

/// Medidas que el arte de interfaz tiene que respetar. Es el mismo contrato
/// que declara `lib/ui_texturas.dart` y que documenta ASSETS_UI.md.
const piezasEsperadas = <String, (int, int)>{
  'marco.png': (1024, 1536),
  'home.png': (670, 1132),
  'character.png': (349, 937),
  'paper.png': (926, 643),
  'marco_pantalla.png': (1200, 1800),
  'cartel_colgante.png': (1024, 384),
  'panel_papel.png': (600, 600),
  'boton_madera.png': (600, 240),
  'boton_dorado.png': (600, 234),
  'placa_nombre.png': (512, 160),
  'marco_retrato.png': (768, 900),
  'barra_inferior.png': (1200, 300),
  'background_home.jpg': (1376, 768),
  'fondo_alba.jpg': (472, 768),
  'fondo_mediodia.jpg': (455, 768),
  'fondo_ocaso.jpg': (426, 768),
  'fondo_papel.jpg': (1024, 1024),
  'logo.jpeg': (1024, 1024),
  'victoria.png': (512, 512),
  'derrota.png': (512, 512),
  'boton_volver.png': (192, 192),
  'insignia_logro.png': (512, 512),
  'insignia_bloqueada.png': (512, 512),
};

/// Dos conjuntos con exactamente lo mismo adentro.
bool _mismos(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

/// Los `{placeholders}` que usa un texto.
Set<String> _huecosDe(String texto) =>
    RegExp(r'\{(\w+)\}').allMatches(texto).map((m) => m[1]!).toSet();
