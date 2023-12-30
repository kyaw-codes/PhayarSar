//
//  SafeAreaInsets.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 30/12/2023.
//

import SwiftUI

#if os(iOS) || os(tvOS)
private extension UIApplication {

    var keyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .filter { $0.isKeyWindow }
            .first
    }
}
#endif

#if canImport(UIKit)
private extension UIEdgeInsets {
    
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
#endif

private struct SafeAreaInsetsKey: EnvironmentKey {
    
    static var defaultValue: EdgeInsets {
        #if os(iOS) || os(tvOS)
        let keyWindow = UIApplication.shared.keyWindow
        return keyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
        #else
        EdgeInsets()
        #endif
    }
}

public extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
