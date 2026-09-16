/// Los idiomas del juego, en un solo lugar.
///
/// Antes la lista vivía repartida en cinco: la constante de `TextosUi`, el mapa
/// literal de `templo.dart`, los campos `textoEs`/`textoEn` de `PasoTutorial`,
/// un ternario `idioma == 'en'` y tres botones cableados en Ajustes. Con dos
/// idiomas eso se sostiene; con siete, cada uno de esos lugares es un hueco que
/// el `??` de `textosDe()` tapa con español sin que nadie se entere. Ahora todo
/// deriva de [idiomasSoportados] y `bin/check.dart` falla si algo se desvía.
///
/// Dart puro a propósito, sin `package:flutter`: `bin/check.dart` lo importa,
/// igual que hace con `tutorial_zonas.dart`.
library;

/// Un idioma que el juego habla.
class Idioma {
  /// Lo que se guarda en preferencias y lo que indexa los mapas de texto.
  /// Lleva la variante cuando importa: `pt-BR`, `zh-Hans`.
  final String codigo;

  /// Cómo se llama el idioma EN ese idioma. Un japonés busca 日本語 en la
  /// lista, no «Japonés», así que este campo nunca se traduce.
  final String nombreNativo;

  /// La lengua sola, para comparar contra el locale del sistema.
  final String lengua;

  /// La escritura, cuando la lengua tiene más de una. Sólo el chino, por ahora.
  final String? escritura;

  /// Si necesita la fuente CJK en vez de las latinas del juego.
  /// Patrick Hand SC y Atkinson Hyperlegible no tienen ni un kana.
  final bool cjk;

  const Idioma(
    this.codigo,
    this.nombreNativo,
    this.lengua, {
    this.escritura,
    this.cjk = false,
  });
}

/// La lista. Agregar un idioma es agregar una línea acá y que check te diga
/// todo lo que falta.
const idiomasSoportados = <Idioma>[
  Idioma('es', 'Español', 'es'),
  Idioma('en', 'English', 'en'),
  Idioma('pt-BR', 'Português (BR)', 'pt'),
  Idioma('it', 'Italiano', 'it'),
  Idioma('de', 'Deutsch', 'de'),
  Idioma('ja', '日本語', 'ja', cjk: true),
  Idioma('zh-Hans', '简体中文', 'zh', escritura: 'Hans', cjk: true),
];

/// Los códigos, en el mismo orden.
List<String> get codigosIdioma => [for (final i in idiomasSoportados) i.codigo];

/// El idioma que ve alguien cuyo teléfono está en algo que no hablamos.
///
/// No es [Tema.idiomaPorDefecto], que es otra cosa: aquél es el idioma del que
/// se copian los DATOS cuando falta una traducción, y ese sigue siendo el
/// español porque es el original. Éste es qué le mostramos a un coreano.
const idiomaDeReserva = 'en';

/// Una preferencia de idioma del sistema, ya desarmada.
typedef PrefIdioma = ({String lengua, String? escritura, String? region});

/// Traduce las preferencias del sistema al idioma que hablamos.
///
/// Recibe la lista entera y en orden, no sólo la primera: alguien con el
/// teléfono en [turco, italiano, inglés] tiene que recibir italiano, no la
/// reserva. Se queda con la primera preferencia que sepamos contestar.
String resolverIdioma(List<PrefIdioma> preferencias) {
  for (final p in preferencias) {
    final r = _unaPreferencia(p);
    if (r != null) return r;
  }
  return idiomaDeReserva;
}

String? _unaPreferencia(PrefIdioma p) {
  final mismaLengua = [
    for (final i in idiomasSoportados)
      if (i.lengua == p.lengua) i,
  ];
  if (mismaLengua.isEmpty) return null;

  // Si la lengua se escribe de más de una forma y el sistema nos dice cuál,
  // respetarla: `zh-Hant` no es `zh-Hans`.
  for (final i in mismaLengua) {
    if (i.escritura != null && i.escritura == p.escritura) return i.codigo;
  }

  // Si no, la primera que tengamos de esa lengua, y la región no importa.
  // `de-AT`, `es-MX` y `en-GB` caen en su idioma; `pt-PT` cae en el brasileño,
  // que es el único portugués que mandamos y que un portugués prefiere antes
  // que el inglés; `zh-Hant` cae en simplificado, que alguien de Taipéi lee
  // bastante mejor que inglés.
  return mismaLengua.first.codigo;
}
