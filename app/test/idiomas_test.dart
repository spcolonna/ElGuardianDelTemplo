// Qué idioma le toca a cada teléfono.
//
// Es la única forma de probar esto sin tener siete teléfonos configurados en
// siete idiomas, y es donde estaban los cuatro errores que tenía la versión
// anterior: usaba `locale` en vez de `locales`, tiraba el script, tiraba la
// región, y mandaba a español a cualquiera que no entendiera.
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/idiomas.dart';

PrefIdioma p(String lengua, {String? escritura, String? region}) =>
    (lengua: lengua, escritura: escritura, region: region);

void main() {
  test('la lista de idiomas no tiene códigos repetidos', () {
    expect(codigosIdioma.toSet().length, codigosIdioma.length);
  });

  test('el idioma de reserva es uno que hablamos', () {
    expect(codigosIdioma, contains(idiomaDeReserva));
  });

  test('la región no cambia el idioma', () {
    for (final r in ['ES', 'MX', 'AR', 'UY', null]) {
      expect(resolverIdioma([p('es', region: r)]), 'es');
    }
    for (final r in ['US', 'GB', 'AU', null]) {
      expect(resolverIdioma([p('en', region: r)]), 'en');
    }
  });

  test('un idioma que no hablamos cae en la reserva, no en español', () {
    for (final l in ['ko', 'ru', 'tr', 'fr', 'ar']) {
      expect(resolverIdioma([p(l)]), idiomaDeReserva);
    }
  });

  test('sin preferencias, la reserva', () {
    expect(resolverIdioma([]), idiomaDeReserva);
  });

  test('se respeta el ORDEN de las preferencias del sistema', () {
    // Alguien con el teléfono en [turco, inglés, español] tiene que recibir
    // inglés: es su segunda opción, no la última que miremos.
    expect(resolverIdioma([p('tr'), p('en'), p('es')]), 'en');
    expect(resolverIdioma([p('tr'), p('es'), p('en')]), 'es');
    // Y si ninguna la hablamos, la reserva y no la primera.
    expect(resolverIdioma([p('ko'), p('ru')]), idiomaDeReserva);
  });

  test('toda lengua de la lista se resuelve a sí misma', () {
    for (final i in idiomasSoportados) {
      expect(
        resolverIdioma([p(i.lengua, escritura: i.escritura)]),
        i.codigo,
        reason: 'la lengua de ${i.codigo} no vuelve a ${i.codigo}',
      );
    }
  });

  // Los casos que sólo aparecen cuando el código lleva variante. Hoy no
  // tenemos ni pt-BR ni zh-Hans; el test se salta solo y empieza a correr el
  // día que entren, que es justo cuando hace falta.
  test('el portugués de Portugal recibe el brasileño', () {
    if (!codigosIdioma.contains('pt-BR')) return;
    expect(resolverIdioma([p('pt', region: 'PT')]), 'pt-BR');
    expect(resolverIdioma([p('pt', region: 'BR')]), 'pt-BR');
    expect(resolverIdioma([p('pt')]), 'pt-BR');
  });

  test('el chino tradicional recibe simplificado antes que inglés', () {
    if (!codigosIdioma.contains('zh-Hans')) return;
    expect(
      resolverIdioma([p('zh', escritura: 'Hant', region: 'TW')]),
      'zh-Hans',
    );
    expect(
      resolverIdioma([p('zh', escritura: 'Hans', region: 'CN')]),
      'zh-Hans',
    );
    expect(resolverIdioma([p('zh', region: 'SG')]), 'zh-Hans');
    expect(resolverIdioma([p('zh')]), 'zh-Hans');
  });

  test('si algún día hay dos escrituras, gana la que pide el sistema', () {
    final conEscritura = idiomasSoportados.where((i) => i.escritura != null);
    for (final i in conEscritura) {
      final hermanos = idiomasSoportados.where((h) => h.lengua == i.lengua);
      if (hermanos.length < 2) continue;
      expect(resolverIdioma([p(i.lengua, escritura: i.escritura)]), i.codigo);
    }
  });
}
