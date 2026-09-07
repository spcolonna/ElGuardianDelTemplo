/// Los identificadores de AdMob y de las tiendas.
///
/// **Este es el único archivo que hay que tocar el día que se abran las
/// cuentas.** Todo lo demás de `lib/tienda/` está escrito contra estas cinco
/// constantes y no sabe nada de números.
///
/// Hoy están puestos los identificadores de PRUEBA que publica Google: son
/// públicos, funcionan sin registrarse en AdMob y devuelven siempre un anuncio
/// que dice «Test Ad». Sirven para desarrollar el flujo completo; no pagan un
/// centavo y no se pueden publicar así.
///
/// Para pasar a producción:
///
///   1. Crear la app en AdMob y copiar acá su App ID (`ca-app-pub-…~…`).
///   2. Crear un bloque de anuncios **intersticial** y copiar su ID.
///   3. Crear el producto de compra —no consumible / no renovable— con el mismo
///      identificador en Play Console y en App Store Connect.
///   4. Poner `kAnunciosDePrueba` y `kComprasDePrueba` en `false`.
///   5. Repetir el App ID en `android/app/src/main/AndroidManifest.xml` y en
///      `ios/Runner/Info.plist`, que son archivos nativos y no leen Dart.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Con esto en `true` los anuncios son los de prueba de Google: dicen «Test Ad»,
/// no pagan nada y, sobre todo, se pueden tocar sin riesgo.
///
/// **Queda en `true` mientras probemos.** Tocar un anuncio de verdad en la
/// propia app es tráfico inválido para Google y se castiga suspendiendo la
/// cuenta entera, no la app. Se pone en `false` recién para el build que va a
/// la tienda.
const bool kAnunciosDePrueba = true;

/// Con esto en `true` la compra se resuelve local y al instante, sin hablar con
/// ninguna tienda.
///
/// Ponerlo en `false` sin haber creado el producto en las tiendas deja el botón
/// de compra deshabilitado: es lo correcto, pero avisa mal. En TestFlight, con
/// el producto ya dado de alta, `false` compra contra el entorno de prueba de
/// Apple y no cobra un centavo — que es justo lo que queremos probar.
const bool kComprasDePrueba = false;

/// App ID de AdMob. Tiene que coincidir con el del manifiesto de Android y el
/// del Info.plist de iOS, o el SDK no arranca.
///
/// Los de prueba son los que documenta Google en
/// developers.google.com/admob/flutter/quick-start
/// (Los App ID de prueba de Google eran `~3347511713` en Android y
/// `~1458002511` en iOS. Quedan anotados por si alguna vez hay que volver,
/// pero no se usan: el App ID sale del archivo nativo.)

/// Bloque intersticial de prueba.
const _intersticialPruebaAndroid = 'ca-app-pub-3940256099942544/1033173712';
const _intersticialPruebaIos = 'ca-app-pub-3940256099942544/4411468910';

/// Los de verdad, de la cuenta de AdMob del juego.
///
/// Estos tres archivos tienen que decir lo mismo o el SDK no arranca:
/// este archivo, `android/app/src/main/AndroidManifest.xml` y
/// `ios/Runner/Info.plist`.
const _appIdAndroid = 'ca-app-pub-9552343552775183~8413463552';
const _appIdIos = 'ca-app-pub-9552343552775183~4410534166';

const _intersticialAndroid = 'ca-app-pub-9552343552775183/7403529016';
const _intersticialIos = 'ca-app-pub-9552343552775183/8445253146';

/// El App ID de verdad, siempre. El SDK lo lee del archivo nativo al arrancar y
/// no puede depender de un flag de Dart, así que acá tampoco: los de prueba
/// quedan documentados arriba nada más.
///
/// Google permite —y recomienda— usar el App ID real con bloques de prueba: lo
/// que decide si el anuncio es de mentira es el bloque, no la app.
String get appIdAdMob {
  if (kIsWeb) return '';
  return Platform.isIOS ? _appIdIos : _appIdAndroid;
}

/// El bloque que se muestra en los tres cambios de fase.
String get intersticialDeFase {
  if (kIsWeb) return '';
  if (kAnunciosDePrueba) {
    return Platform.isIOS ? _intersticialPruebaIos : _intersticialPruebaAndroid;
  }
  return Platform.isIOS ? _intersticialIos : _intersticialAndroid;
}

/// El producto de compra. Uno solo: desbloquea todo y saca la publicidad.
///
/// El mismo string en Play Console y en App Store Connect. Si difieren, hay que
/// partir esto en dos como los IDs de arriba.
const String idProductoCompleto = 'guardian_templo_completo';

/// Lo que se muestra mientras la tienda no diga el precio de verdad. En
/// producción el precio real y su moneda los devuelve la tienda del jugador.
const String precioDeMuestra = '—';

/// La política de privacidad publicada.
///
/// Apple la pide en la ficha de la App Store, Google la pide en Play Console, y
/// AdMob la exige por política para cualquier app que muestre avisos. Además se
/// enlaza desde Ajustes, que es donde la va a buscar quien quiera leerla.
///
/// El texto vive en `docs/privacidad.html`, versionado en este mismo
/// repositorio. Para que esta URL responda hay que **encender GitHub Pages**
/// en Settings → Pages, sirviendo la rama `main` desde la carpeta `/docs`.
/// Mientras eso no esté hecho, el botón de Ajustes abre un 404.
const String urlPoliticaDePrivacidad =
    'https://spcolonna.github.io/ElGuardianDelTemplo/privacidad.html';
