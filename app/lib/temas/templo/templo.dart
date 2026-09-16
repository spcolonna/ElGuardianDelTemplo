import '../tema.dart';
import 'arte.dart';
import 'textos_en.dart';
import 'textos_de.dart';
import 'textos_es.dart';
import 'textos_it.dart';
import 'textos_ja.dart';
import 'textos_pt_br.dart';
import 'textos_zh_hans.dart';

/// Tema original: templo shaolin.
///
/// Para una expansión estética, copiá esta carpeta entera, cambiá los textos y
/// los sujetos de arte, y registrá el tema nuevo en `temas.dart`. No toques ni
/// un número: el balance vive en `mecanica.dart`.
const temaTemplo = Tema(
  id: 'templo',
  colorFase: coloresTemplo,
  colorCombate: 0xFF6FA8DC,
  sujetosArte: sujetosTemplo,
  sufijoEstilo: sufijoEstiloTemplo,
  sufijoReverso: sufijoReversoTemplo,
  paneles: panelesTemplo,
  reversos: reversosTemplo,
  // Un mapa por idioma de `lib/idiomas.dart`. Si acá falta uno que la
  // lista declara, `textosDe()` lo tapa con español y el juego arranca
  // como si estuviera traducido: por eso lo chequea `bin/check.dart`.
  textos: {
    'es': textosTemploEs,
    'en': textosTemploEn,
    'pt-BR': textosTemploPtBr,
    'it': textosTemploIt,
    'de': textosTemploDe,
    'ja': textosTemploJa,
    'zh-Hans': textosTemploZhHans,
  },
);
