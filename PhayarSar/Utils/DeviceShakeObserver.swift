//
//  DeviceShakeObserver.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 19/05/2024.
//

import SwiftUI

// The notification we'll send when a shake gesture happens.
extension UIDevice {
  static let deviceDidShakeNotification = Notification.Name(rawValue: "com.kyaw.PhayarSar.deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
  }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      .onAppear()
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
        action()
      }
  }
}

// A View extension to make the modifier easier to use.
extension View {
  func onShake(perform action: @escaping () -> Void) -> some View {
    self.modifier(DeviceShakeViewModifier(action: action))
  }
}
