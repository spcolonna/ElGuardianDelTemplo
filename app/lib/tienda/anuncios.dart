import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models.dart';
import 'compra.dart';
import 'consentimiento.dart';
import 'ids.dart';

/// La publicidad de pantalla completa entre fases del día.
///
/// Son exactamente tres por partida —alba→mediodía, mediodía→ocaso,
/// ocaso→jefes— y salen en el corte de capítulo, después del cómic del
/// interludio, cuando el jugador ya tocó «seguir». Ni en victoria ni en
/// derrota: el final de una partida no es lugar para un anuncio.
///
/// Regla de oro de este archivo: **el juego nunca se queda esperando.** Si no
/// hay anuncio cargado, si el SDK falla, si el jugador compró, si estamos en
/// web o si tarda demasiado, `mostrarEnFase` vuelve enseguida y la partida
/// sigue. Un anuncio que no aparece es plata perdida; una partida colgada es un
/// jugador perdido.
class Anuncios {
  final Tienda tienda;

  /// El permiso para mostrar avisos. Vive acá y no adentro porque Ajustes lo
  /// necesita para dibujar el botón de opciones de privacidad.
  final consentimiento = Consentimiento();

  Anuncios(this.tienda);

  /// Cuánto se espera a que un anuncio pedido termine de bajar antes de seguir
  /// sin él. Es el tiempo que el jugador está mirando una pantalla quieta.
  static const _paciencia = Duration(seconds: 4);

  InterstitialAd? _cargado;
  bool _cargando = false;
  bool _iniciado = false;

  /// Se completa cuando la carga en curso termina, bien o mal.
  Completer<void>? _espera;

  bool get _apagado => kIsWeb || tienda.comprado;

  Future<void> iniciar() async {
    if (_apagado || _iniciado) return;
    _iniciado = true;
    try {
      // Primero el permiso, después el SDK, y recién después el primer
      // anuncio. En este orden y no en otro: pedir un anuncio antes de saber
      // si se puede es exactamente lo que castiga la política de AdMob en
      // Europa. Si el jugador dice que no, `canRequestAds` da false y este
      // método se va sin cargar nada.
      final permitido = await consentimiento.resolver();
      if (!permitido) {
        _iniciado = false;
        return;
      }

      // El juego no está dirigido a menores —eso está decidido y explicado en
      // el README— pero sí lo puede jugar alguien de nueve años, así que los
      // avisos se limitan a contenido apto. Cuesta cero y saca de encima el
      // riesgo de que a un chico le aparezca un aviso de casino.
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          maxAdContentRating: MaxAdContentRating.pg,
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
        ),
      );

      await MobileAds.instance.initialize();
      precargar();
    } catch (_) {
      // Sin SDK no hay publicidad, y el juego funciona igual.
      _iniciado = false;
    }
  }

  /// Pide el próximo anuncio con tiempo. Se llama al arrancar la partida y
  /// después de mostrar cada uno.
  void precargar() {
    if (_apagado || _cargando || _cargado != null) return;
    _cargando = true;
    _espera = Completer<void>();

    InterstitialAd.load(
      adUnitId: intersticialDeFase,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _cargado = ad;
          _cargando = false;
          _terminarEspera();
        },
        onAdFailedToLoad: (_) {
          _cargado = null;
          _cargando = false;
          _terminarEspera();
        },
      ),
    );
  }

  void _terminarEspera() {
    if (_espera != null && !_espera!.isCompleted) _espera!.complete();
    _espera = null;
  }

  /// Muestra el anuncio del cambio de fase y **vuelve cuando la pantalla ya es
  /// del juego otra vez**. Quien la llama puede seguir sin más cuidados.
  ///
  /// La fase se recibe para no mostrar nada al entrar al alba, que no es una
  /// transición sino el arranque.
  Future<void> mostrarEnFase(Fase fase) async {
    if (_apagado || fase == Fase.alba) return;

    // Si justo se estaba bajando, se le da un rato; si no llega, se sigue.
    if (_cargado == null && _cargando && _espera != null) {
      await _espera!.future.timeout(_paciencia, onTimeout: () {});
    }

    final ad = _cargado;
    if (ad == null) {
      precargar(); // que el próximo corte lo tenga listo
      return;
    }
    _cargado = null;

    final cerrado = Completer<void>();
    void seguir() {
      if (!cerrado.isCompleted) cerrado.complete();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        precargar();
        seguir();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        precargar();
        seguir();
      },
    );

    try {
      await ad.show();
    } catch (_) {
      ad.dispose();
      precargar();
      seguir();
    }

    // Red de seguridad: si el SDK no llama a ningún callback, el juego sigue
    // igual. Es generoso a propósito —un anuncio dura hasta 30 s— y sólo actúa
    // cuando algo se rompió.
    await cerrado.future.timeout(const Duration(seconds: 45), onTimeout: () {});
  }

  void soltar() {
    _cargado?.dispose();
    _cargado = null;
    _terminarEspera();
  }
}
