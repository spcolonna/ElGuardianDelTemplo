import '../models.dart';

/// Contrato de un tema.
///
/// Un tema tiene dos mitades bien separadas:
///
/// - **Arte** (esta clase): identidad, paleta, sujetos de ilustración y
///   archivos de viñeta. No depende del idioma. Los prompts van SIEMPRE en
///   inglés porque son para el generador de imágenes, no para el jugador.
/// - **Textos** ([TextosTema]): todo lo que lee el jugador, uno por idioma.
///
/// Un tema NO contiene ni un solo número de balance: eso vive en
/// `mecanica.dart` y se comparte entre todos los temas. Cambiar de tema o de
/// idioma no puede mover la dificultad.
///
/// Todo en Dart puro (los colores van como int ARGB, no como `Color`) para que
/// los scripts headless puedan importarlo sin arrastrar Flutter.
class Tema {
  /// Identificador corto: se usa para la carpeta de CSV y de assets.
  final String id;

  /// Color de cada fase en ARGB (0xFFRRGGBB).
  final Map<Fase, int> colorFase;

  /// Color de las cartas de combate, en ARGB.
  final int colorCombate;

  /// Sujeto de la ilustración de cada carta, en inglés, por id de carta.
  final Map<String, String> sujetosArte;

  /// Se pega al final de cada prompt de carta. Cambiarlo cambia las 70.
  final String sufijoEstilo;

  /// Se pega al final de cada prompt de reverso.
  final String sufijoReverso;

  /// Viñetas por secuencia (`intro`, `mediodia`, `ocaso`, `jefes`,
  /// `victoria`, `derrota`). Solo el archivo y el boceto para quien ilustra.
  final Map<String, List<PanelArte>> paneles;

  /// Un reverso por mazo.
  final List<ReversoArte> reversos;

  /// Textos por código de idioma: `es`, `en`.
  final Map<String, TextosTema> textos;

  const Tema({
    required this.id,
    required this.colorFase,
    required this.colorCombate,
    required this.sujetosArte,
    required this.sufijoEstilo,
    required this.sufijoReverso,
    required this.paneles,
    required this.reversos,
    required this.textos,
  });

  /// Idioma que se usa si el pedido no existe.
  static const idiomaPorDefecto = 'es';

  TextosTema textosDe(String idioma) =>
      textos[idioma] ?? textos[idiomaPorDefecto]!;

  String nombreDe(String id, String idioma) =>
      textosDe(idioma).cartas[id]?.nombre ?? id;

  String saborDe(String id, String idioma) =>
      textosDe(idioma).cartas[id]?.sabor ?? '';

  String promptDe(String id) =>
      '${sujetosArte[id] ?? 'FALTA SUJETO PARA $id'}, $sufijoEstilo';

  /// Idiomas para los que hay textos.
  Iterable<String> get idiomas => textos.keys;
}

/// Todo lo que lee el jugador, en un idioma.
class TextosTema {
  final String nombre;
  final String bajada;

  /// Cómo se llama el personaje que juega el jugador. Va en la placa del
  /// retrato, en el patio.
  final String protagonista;

  /// Cómo se llama el recurso que en el Templo es "Energía".
  final String recurso;

  final Map<Fase, String> nombreFase;

  /// Nombre y sabor de las 70 cartas, por id.
  final Map<String, TextoCarta> cartas;

  /// Narración y diálogo de cada viñeta, indexado por nombre de archivo.
  /// Usar el archivo como clave hace que falte un texto sea detectable.
  final Map<String, TextoPanel> paneles;

  /// Textos de los encargos, por id de encargo.
  final Map<String, TextoEncargo> encargos;

  /// Textos de los reversos, por nombre de mazo.
  final Map<String, TextoReverso> reversos;

  const TextosTema({
    required this.nombre,
    required this.bajada,
    this.protagonista = 'El Novato',
    required this.recurso,
    required this.nombreFase,
    required this.cartas,
    required this.paneles,
    required this.encargos,
    required this.reversos,
  });
}

class TextoCarta {
  final String nombre;
  final String sabor;
  const TextoCarta(this.nombre, [this.sabor = '']);
}

/// La mitad de una viñeta que no se traduce: qué archivo es y qué se dibuja.
class PanelArte {
  final String archivo;
  final String boceto;

  /// Dónde está la cabeza de quien habla, en coordenadas 0..1 sobre la
  /// viñeta.
  ///
  /// Hoy la interfaz NO lo usa: el diálogo pasó a ir debajo del dibujo, como
  /// una conversación, así que ya no hay bocadillo al que ponerle cola. Se
  /// conserva porque sigue siendo información útil para quien ilustra —dice
  /// dónde está cada personaje en cada escena— y porque devolver los globos
  /// sería volver a leer esto y nada más.
  ///
  /// Van como dos doubles y no como `Offset` porque este archivo lo importan
  /// los scripts de `bin/`, que corren en Dart puro y no tienen `dart:ui`.
  final double? anclaX;
  final double? anclaY;

  const PanelArte({
    required this.archivo,
    required this.boceto,
    this.anclaX,
    this.anclaY,
  });

  bool get tieneAncla => anclaX != null && anclaY != null;

  /// La ruta del asset que viaja adentro del binario.
  ///
  /// [archivo] es el nombre del ORIGINAL (`01_templo_amanecer.png`) y además
  /// la clave con la que [TextosTema.paneles] busca el diálogo, así que no se
  /// puede tocar. Pero el original no se empaqueta: pesa entre 2 y 3 MB y son
  /// veintitrés. Lo que viaja es la copia WebP que escribe `bin/aligerar.py`
  /// en `assets/movil/comic/`, que pesa una décima parte.
  String get assetMovil {
    final punto = archivo.lastIndexOf('.');
    final base = punto == -1 ? archivo : archivo.substring(0, punto);
    return 'assets/movil/comic/$base.webp';
  }
}

/// Una línea suelta de la conversación de una viñeta.
///
/// [quien] vacío o un texto entre paréntesis se dibujan como acotación, sin
/// burbuja ni autor: no todo lo que se dice en una viñeta lo dice alguien.
class Dicho {
  final String quien;
  final String texto;
  const Dicho(this.quien, this.texto);
}

/// La mitad de una viñeta que sí se traduce.
///
/// La conversación es una LISTA y no un diálogo único: con una sola línea por
/// imagen el cómic se leía como un pie de foto, y son las respuestas —el ida y
/// vuelta— las que le dan a los personajes algo parecido a una voz.
class TextoPanel {
  final String narracion;
  final List<Dicho> conversacion;
  const TextoPanel({required this.narracion, this.conversacion = const []});
}

class TextoEncargo {
  final String titulo;
  final String nota;
  final String recompensa;
  const TextoEncargo({
    required this.titulo,
    required this.nota,
    required this.recompensa,
  });
}

/// La mitad del reverso que no se traduce.
class ReversoArte {
  final String mazo;
  final String colorFondoHex;
  final String prompt;
  const ReversoArte({
    required this.mazo,
    required this.colorFondoHex,
    required this.prompt,
  });
}

class TextoReverso {
  /// Nombre visible del mazo. La clave del mapa es el id estable.
  final String nombre;
  final String queCartasLleva;
  final String descripcion;
  const TextoReverso({
    required this.nombre,
    required this.queCartasLleva,
    required this.descripcion,
  });
}
