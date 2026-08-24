import '../tema.dart';
import 'arte.dart';
import 'textos_en.dart';
import 'textos_es.dart';

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
  textos: {'es': textosTemploEs, 'en': textosTemploEn},
);
