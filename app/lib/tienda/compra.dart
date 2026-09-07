import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../preferencias.dart';
import 'ids.dart';

/// La compra única que abre el juego entero.
///
/// Un solo producto, no consumible: desbloquea los seis caminos, el
/// selector de jefes, los dos modos opcionales, y saca la publicidad. No hay
/// monedas, ni suscripción, ni nada que se gaste.
///
/// El estado se guarda en `shared_preferences` para no tener que hablar con la
/// tienda en cada arranque, pero **la preferencia no es la verdad**: se borra al
/// desinstalar. La verdad la tiene la tienda, y por eso `restaurar()` no es un
/// adorno — Google y Apple además exigen que exista ese botón.
class Tienda extends ChangeNotifier {
  final Preferencias prefs;
  Tienda(this.prefs);

  /// El jugador compró el juego. En web siempre `true`: ahí no hay tienda que
  /// cobre ni SDK de anuncios, y es el banco de pruebas del proyecto.
  bool get comprado => kIsWeb || _comprado;
  bool _comprado = false;

  /// La tienda del dispositivo contestó y el producto existe. Con esto en
  /// `false` el botón de comprar no puede hacer nada.
  bool disponible = false;

  /// El precio con la moneda del jugador, tal como lo escribe la tienda.
  String precio = precioDeMuestra;

  /// Una compra está en curso. Sirve para que el botón no se pueda tocar dos
  /// veces y para mostrar la ruedita.
  bool ocupado = false;

  /// Lo último que salió mal, para poder decirlo en pantalla.
  String? error;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  ProductDetails? _producto;

  Future<void> iniciar() async {
    _comprado = prefs.comprado;
    notifyListeners();

    if (kIsWeb) return;

    if (kComprasDePrueba) {
      // Sin cuentas de tienda todavía: se simula un producto para poder
      // recorrer el flujo entero de punta a punta.
      disponible = true;
      precio = 'Gratis (prueba)';
      notifyListeners();
      return;
    }

    try {
      disponible = await InAppPurchase.instance.isAvailable();
      if (!disponible) return notifyListeners();

      _sub = InAppPurchase.instance.purchaseStream.listen(
        _atender,
        onError: (Object e) {
          error = '$e';
          notifyListeners();
        },
      );

      final r = await InAppPurchase.instance.queryProductDetails({
        idProductoCompleto,
      });
      if (r.productDetails.isNotEmpty) {
        _producto = r.productDetails.first;
        precio = _producto!.price;
      } else {
        // El producto no está dado de alta, o todavía no se propagó. Mejor
        // apagar el botón que dejarlo tocar y fallar.
        disponible = false;
      }
    } catch (e) {
      disponible = false;
      error = '$e';
    }
    notifyListeners();
  }

  /// Abre la hoja de pago de la tienda. Devuelve cuando el flujo arrancó, no
  /// cuando terminó: el resultado llega por `purchaseStream` y actualiza esto.
  Future<void> comprar() async {
    if (comprado || ocupado) return;
    ocupado = true;
    error = null;
    notifyListeners();

    if (kComprasDePrueba || kIsWeb) {
      await _conceder();
      ocupado = false;
      notifyListeners();
      return;
    }

    final p = _producto;
    if (p == null) {
      ocupado = false;
      disponible = false;
      notifyListeners();
      return;
    }
    try {
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: p),
      );
    } catch (e) {
      error = '$e';
      ocupado = false;
      notifyListeners();
    }
  }

  /// Recupera la compra de quien reinstaló la app o cambió de teléfono.
  Future<void> restaurar() async {
    if (kIsWeb) return;
    if (kComprasDePrueba) {
      // En modo prueba no hay nada que recuperar, pero el botón tiene que
      // existir igual para poder probar la pantalla.
      ocupado = false;
      notifyListeners();
      return;
    }
    ocupado = true;
    error = null;
    notifyListeners();
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      error = '$e';
    }
    ocupado = false;
    notifyListeners();
  }

  Future<void> _atender(List<PurchaseDetails> compras) async {
    for (final c in compras) {
      if (c.productID != idProductoCompleto) continue;

      switch (c.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _conceder();
        case PurchaseStatus.error:
          error = c.error?.message;
        case PurchaseStatus.canceled:
          error = null;
        case PurchaseStatus.pending:
          continue; // sigue en curso: no se toca `ocupado`
      }

      // Sin esto la tienda reembolsa la compra a los tres días.
      if (c.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(c);
      }
      ocupado = false;
      notifyListeners();
    }
  }

  Future<void> _conceder() async {
    _comprado = true;
    await prefs.marcarComprado(true);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
