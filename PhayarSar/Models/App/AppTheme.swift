//
//  AppTheme.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 28/05/2024.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
  var id: String {
    self.rawValue
  }
  
  case light
  case dark
  case system
  
  var colorScheme: ColorScheme? {
    switch self {
    case .light:
      return .light
    case .dark:
      return .dark
    case .system:
        return nil
    }
  }
}
