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
///   4. Poner `kIdsDePrueba = false`.
///   5. Repetir el App ID en `android/app/src/main/AndroidManifest.xml` y en
///      `ios/Runner/Info.plist`, que son archivos nativos y no leen Dart.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Con esto en `true` la compra se resuelve local y al instante, sin hablar con
/// ninguna tienda, y los anuncios son los de prueba de Google.
///
/// Ponerlo en `false` sin haber creado el producto en las tiendas deja el botón
/// de compra deshabilitado: es lo correcto, pero avisa mal. Cambiarlo recién
/// cuando el producto exista.
const bool kIdsDePrueba = true;

/// App ID de AdMob. Tiene que coincidir con el del manifiesto de Android y el
/// del Info.plist de iOS, o el SDK no arranca.
///
/// Los de prueba son los que documenta Google en
/// developers.google.com/admob/flutter/quick-start
const _appIdPruebaAndroid = 'ca-app-pub-3940256099942544~3347511713';
const _appIdPruebaIos = 'ca-app-pub-3940256099942544~1458002511';

/// Bloque intersticial de prueba.
const _intersticialPruebaAndroid = 'ca-app-pub-3940256099942544/1033173712';
const _intersticialPruebaIos = 'ca-app-pub-3940256099942544/4411468910';

String get appIdAdMob {
  if (kIsWeb) return '';
  return Platform.isIOS ? _appIdPruebaIos : _appIdPruebaAndroid;
}

/// El bloque que se muestra en los tres cambios de fase.
String get intersticialDeFase {
  if (kIsWeb) return '';
  return Platform.isIOS ? _intersticialPruebaIos : _intersticialPruebaAndroid;
}

/// El producto de compra. Uno solo: desbloquea todo y saca la publicidad.
///
/// El mismo string en Play Console y en App Store Connect. Si difieren, hay que
/// partir esto en dos como los IDs de arriba.
const String idProductoCompleto = 'guardian_templo_completo';

/// Lo que se muestra mientras la tienda no diga el precio de verdad. En
/// producción el precio real y su moneda los devuelve la tienda del jugador.
const String precioDeMuestra = '—';
