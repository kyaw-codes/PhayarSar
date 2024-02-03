//
//  DaysOfWeek.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import Foundation

enum DaysOfWeek: String, Hashable, Equatable, CaseIterable {
  case everyday
  case sun
  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  
  var key: LocalizedKey {
    .init(rawValue: self.rawValue)!
  }
}
