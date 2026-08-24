import 'tema.dart';
import 'templo/templo.dart';

export 'tema.dart';
export 'templo/templo.dart';

/// Todos los temas disponibles. Para agregar una expansión estética:
/// copiá `templo.dart`, cambiá los textos y sumalo a esta lista.
const temasDisponibles = <Tema>[temaTemplo];

Tema temaPorId(String id) =>
    temasDisponibles.firstWhere((t) => t.id == id, orElse: () => temaTemplo);
