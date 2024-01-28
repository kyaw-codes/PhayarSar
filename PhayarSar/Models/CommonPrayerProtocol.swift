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
    let normal = Double(pronunciation.count - 2) * 0.1
    switch speed {
    case .x0_5:
      return normal / 0.5
    case .x0_75:
      return normal / 0.75
    case .x1:
      return normal
    case .x1_25:
      return normal / 1.25
    case .x1_5:
      return normal / 1.5
    case .x2:
      return normal / 2
    }
  }
}

extension Array where Element: CommonPrayerBodyProtocol {
  func index(of element: some CommonPrayerBodyProtocol) -> Int {
    self.firstIndex(where: { $0.id == element.id }) ?? 0
  }
}
