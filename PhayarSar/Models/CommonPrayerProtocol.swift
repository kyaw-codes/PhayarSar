//
//  CommonPrayerProtocol.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 06/01/2024.
//

import Foundation

protocol CommonPrayerProtocol: Identifiable {
    associatedtype Body: CommonPrayerBodyProtocol
    
    var id: String { get }
    var title: String { get }
    var about: String { get }
    var body: [Body] { get set }
}

protocol CommonPrayerBodyProtocol: Identifiable {
    var id: String { get }
    var content: String { get }
    var pronunciation: String { get }
    var isBlur: Bool { get set }
}

extension CommonPrayerBodyProtocol {
    func duration(_ speedStr: String) -> Double {
        let speed = ScrollingSpeed(rawValue: speedStr).orElse(.x1)
        let normalSPS = 8.0
        let factor = speedFactor(speed)
        return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * factor)
    }
    
    private func speedFactor(_ speed: ScrollingSpeed) -> Double {
        switch speed {
        case .x0_5: return 0.5
        case .x0_75: return 0.75
        case .x1: return 1.0
        case .x1_25: return 1.25
        case .x1_5: return 1.5
        case .x2: return 2.0
        }
    }
    
    
    private func calculateReadingTime(paragraph: String, sylbPerSecond: Double = 5) -> Double {
        Double(MyammarSyllable.segment(text: paragraph).count) / sylbPerSecond
    }
}

extension Array where Element: CommonPrayerBodyProtocol {
    func index(of element: some CommonPrayerBodyProtocol) -> Int {
        self.firstIndex(where: { $0.id == element.id }) ?? 0
    }
}

