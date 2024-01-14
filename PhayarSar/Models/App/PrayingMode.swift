//
//  PrayingMode.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import Foundation

enum PrayingMode: String, CaseIterable, Hashable, Identifiable {
  case reader
  case player
  
  var id: String {
    self.rawValue
  }
}
