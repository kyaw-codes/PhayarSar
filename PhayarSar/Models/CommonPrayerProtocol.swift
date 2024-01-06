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
    var duration: TimeInterval {
        return Double(pronunciation.count - 2) * 0.1
    }
}

extension Array where Element: CommonPrayerBodyProtocol {
    func index(of element: some CommonPrayerBodyProtocol) -> Int {
        self.firstIndex(where: { $0.id == element.id }) ?? 0
    }
}
