import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// El permiso para mostrar avisos, que hay que pedir antes de mostrarlos.
///
/// Son dos permisos distintos, de dos dueños distintos, y el orden entre ellos
/// importa:
///
///  1. **UMP** (User Messaging Platform), que es de Google y cumple el RGPD.
///     Sólo aparece donde hace falta —Europa, el Reino Unido, Suiza—; en el
///     resto del mundo `canRequestAds` da `true` sin mostrarle nada a nadie.
///     El mensaje se redacta en la consola de AdMob, no acá.
///  2. **ATT** (App Tracking Transparency), que es de Apple y sólo existe en
///     iOS. Es el cartel de «permitir que la app te siga».
///
/// Google pide expresamente que ATT vaya **después** de UMP, porque el
/// formulario europeo explica para qué se pide y el cartel de Apple, que no
/// explica nada, se entiende mejor con esa explicación recién leída.
///
/// La regla del archivo es la misma que la de [Anuncios]: **nada de esto puede
/// dejar al jugador esperando.** Si el SDK falla, si no hay red, si el
/// formulario no baja, se sigue sin avisos personalizados y el juego arranca
/// igual. Perder un aviso es barato; una pantalla negra en el primer arranque
/// no.
class Consentimiento {
  bool _resuelto = false;
  bool _puedePedirAvisos = false;

  /// Si el jugador tiene derecho a un botón de «Opciones de privacidad».
  ///
  /// Es requisito de AdMob: quien pudo decir que sí tiene que poder cambiar de
  /// opinión. Fuera de Europa da `false` y el botón no se dibuja, porque un
  /// botón que abre un formulario vacío es peor que no tenerlo.
  bool _hayOpciones = false;
  bool get hayOpciones => _hayOpciones;

  /// Cuánto se espera al formulario antes de arrancar sin él.
  ///
  /// Generoso, porque acá el jugador está mirando la pantalla de arranque y no
  /// una partida a medias, pero acotado: con el avión puesto, esto no puede
  /// dejar el juego colgado para siempre.
  static const _paciencia = Duration(seconds: 8);

  /// Resuelve los dos permisos y devuelve si se pueden pedir avisos.
  ///
  /// Idempotente: la segunda llamada devuelve lo mismo sin volver a preguntar.
  Future<bool> resolver() async {
    if (_resuelto) return _puedePedirAvisos;
    _resuelto = true;

    try {
      await _pedirUmp().timeout(_paciencia);
    } catch (_) {
      // Sin UMP no se sirven avisos personalizados, y eso es lo correcto:
      // ante la duda, se asume que no hay consentimiento.
    }

    try {
      _puedePedirAvisos = await ConsentInformation.instance.canRequestAds();
      _hayOpciones =
          await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      _puedePedirAvisos = false;
      _hayOpciones = false;
    }

    // ATT recién ahora, y sólo en iOS. Sin el permiso de Apple igual se
    // muestran avisos: lo que se pierde es el identificador, o sea que dejan
    // de tener que ver con quien mira. Por eso no condiciona el retorno.
    await _pedirAtt();

    return _puedePedirAvisos;
  }

  Future<void> _pedirUmp() async {
    final listo = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(
        // El juego no está dirigido a menores: la clasificación de contenido
        // es una cosa y el público objetivo es otra. Ver el README.
        tagForUnderAgeOfConsent: false,
      ),
      () async {
        // `loadAndShowConsentFormIfRequired` decide sola si hace falta
        // mostrar algo. Fuera de Europa vuelve al instante sin dibujar nada.
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {
          if (!listo.isCompleted) listo.complete();
        });
      },
      (_) {
        if (!listo.isCompleted) listo.complete();
      },
    );

    return listo.future;
  }

  Future<void> _pedirAtt() async {
    if (kIsWeb || !Platform.isIOS) return;
    try {
      final estado = await AppTrackingTransparency.trackingAuthorizationStatus;
      // Se pregunta una sola vez en la vida de la instalación. Si ya contestó
      // —que sí, que no, o si el dispositivo lo tiene restringido— volver a
      // pedirlo no muestra nada y sólo gasta tiempo de arranque.
      if (estado == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // En un simulador viejo o si el permiso no está disponible, seguir.
    }
  }

  /// Reabre el formulario para que el jugador cambie lo que eligió.
  ///
  /// Lo llama el botón de Ajustes. No devuelve nada porque no hay nada que
  /// hacer con el resultado: el SDK ya guardó la decisión nueva y el próximo
  /// aviso la respeta.
  Future<void> abrirOpciones() async {
    final cerrado = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((_) {
        if (!cerrado.isCompleted) cerrado.complete();
      });
      await cerrado.future.timeout(const Duration(seconds: 30), onTimeout: () {});
    } catch (_) {
      // Que el botón no explote nunca.
    }
  }

  /// Sólo para desarrollo: borra lo elegido para volver a ver el formulario.
  ///
  /// No lo llama nadie en producción. Está acá porque probar el primer
  /// arranque de otra manera obliga a desinstalar la app cada vez.
  @visibleForTesting
  Future<void> olvidar() async {
    await ConsentInformation.instance.reset();
    _resuelto = false;
    _puedePedirAvisos = false;
    _hayOpciones = false;
  }
}
