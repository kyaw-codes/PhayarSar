//
//  PageColor.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

enum PageColor: String, CaseIterable, Hashable, Equatable, Decodable, Identifiable {
  var id: String {
    self.rawValue
  }
  
  case classic
  case yellow
  case grey
  case black
  
  var displayName: LocalizedKey {
    switch self {
    case .classic:
      return .page_white
    case .yellow:
      return .page_yellow
    case .grey:
      return .page_yellow
    case .black:
      return .page_black
    }
  }
  
  var color: Color {
    switch self {
    case .classic:
      return .pageWhite
    case .yellow:
      return .pageYellow
    case .grey:
      return .pageGrey
    case .black:
      return .pageBlack
    }
  }
  
  var tintColor: Color {
    switch self {
    case .classic, .yellow:
      return .pageBlack
    case .grey, .black:
      return .white
    }
  }
}
