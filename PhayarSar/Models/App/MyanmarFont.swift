//
//  MyanmarFont.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

enum MyanmarFont: String, CaseIterable, Identifiable, Hashable {
  case msquare
  case panlong
  case yoeyar
  
  var id: String { self.rawValue }
  
  var key: LocalizedKey {
    switch self {
    case .panlong:
      return .panglong
    case .msquare:
      return .msquare
    case .yoeyar:
      return .yoeyar
    }
  }
  
  func font(_ size: CGFloat = 12) -> Font {
    switch self {
    case .panlong:
      return .panlong(size)
    case .msquare:
      return .mSquare(size)
    case .yoeyar:
      return .yoeYar(size)
    }
  }
}
