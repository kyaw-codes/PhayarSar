//
//  PrayerAlignment.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 08/01/2024.
//

import SwiftUI

enum PrayerAlignment: String, CaseIterable, Identifiable, Hashable {
  case left
  case center
  case right
//  case justify
  
  var id: String { self.rawValue }
  
  
  func label() -> LocalizedLabel {
    switch self {
    case .left:
      return LocalizedLabel(.align_left, systemImage: "text.alignleft")
    case .center:
      return LocalizedLabel(.align_center, systemImage: "text.aligncenter")
    case .right:
      return LocalizedLabel(.align_left, systemImage: "text.alignright")
//    case .justify:
//      return LocalizedLabel(.justify, systemImage: "text.justify")
    }
  }
}
