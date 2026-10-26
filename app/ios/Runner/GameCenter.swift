import Flutter
import GameKit
import UIKit

/// El lado nativo de `lib/game_center.dart`: entrar, reportar logros y la
/// mejor racha, y abrir la pantalla de Game Center. Nada más.
final class GameCenter: NSObject, GKGameCenterControllerDelegate {
  private static var instancia: GameCenter?

  static func registrar(con messenger: FlutterBinaryMessenger) {
    let gc = GameCenter()
    instancia = gc
    let canal = FlutterMethodChannel(name: "guardian/game_center", binaryMessenger: messenger)
    canal.setMethodCallHandler { llamada, result in
      gc.atender(llamada, result: result)
    }
  }

  private func atender(_ llamada: FlutterMethodCall, result: @escaping FlutterResult) {
    switch llamada.method {
    case "autenticar":
      autenticar(result)
    case "logros":
      let ids = llamada.arguments as? [String] ?? []
      let logros = ids.map { id -> GKAchievement in
        let a = GKAchievement(identifier: id)
        a.percentComplete = 100
        // El juego ya celebra cada logro con su propia animación.
        a.showsCompletionBanner = false
        return a
      }
      GKAchievement.report(logros) { _ in result(nil) }
    case "puntaje":
      let args = llamada.arguments as? [String: Any] ?? [:]
      guard let tabla = args["tabla"] as? String, let valor = args["valor"] as? Int else {
        result(nil)
        return
      }
      GKLeaderboard.submitScore(
        valor, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [tabla]
      ) { _ in result(nil) }
    case "mostrar":
      let vc = GKGameCenterViewController(state: .achievements)
      vc.gameCenterDelegate = self
      presentar(vc)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// iOS llama al handler más de una vez (hoja de entrada, entrada, cambio de
  /// cuenta), pero el `result` de Flutter se contesta una sola.
  private func autenticar(_ result: @escaping FlutterResult) {
    var contestado = false
    GKLocalPlayer.local.authenticateHandler = { [weak self] vc, _ in
      if let vc = vc {
        self?.presentar(vc)
        return
      }
      if !contestado {
        contestado = true
        result(GKLocalPlayer.local.isAuthenticated)
      }
    }
  }

  private func presentar(_ vc: UIViewController) {
    let ventana = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    var arriba = ventana?.rootViewController
    while let p = arriba?.presentedViewController { arriba = p }
    arriba?.present(vc, animated: true)
  }

  func gameCenterViewControllerDidFinish(_ vc: GKGameCenterViewController) {
    vc.dismiss(animated: true)
  }
}
