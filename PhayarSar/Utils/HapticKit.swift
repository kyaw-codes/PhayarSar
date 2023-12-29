//
//  HapticKit.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 29/12/2023.
//

import UIKit

enum HapticFeedbackStyle: Int {
    case light, medium, heavy
    
    case soft, rigid
}

extension HapticFeedbackStyle {
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        return UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
    }
}

enum HapticFeedbackType: Int {
    case success, warning, error
}

extension HapticFeedbackType {
    var value: UINotificationFeedbackGenerator.FeedbackType {
        return UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
    }
}

enum HapticKit {
    case impact(HapticFeedbackStyle)
    case notification(HapticFeedbackType)
    case selection
    
    // trigger
    public func generate() {
        guard UserDefaults.standard.bool(forKey: "isHapticEnable") else { return }
        
        switch self {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style.value)
            generator.prepare()
            generator.impactOccurred()
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type.value)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
