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
  
  var shortStr: LocalizedKey {
    switch self {
    case .everyday:
      return .about_x
    case .sun:
      return .su
    case .mon:
      return .mo
    case .tue:
      return .tu
    case .wed:
      return .we
    case .thu:
      return .th
    case .fri:
      return .fr
    case .sat:
      return .sa
    }
  }
  
  var weekday: Int {
    switch self {
    case .everyday:
      return -1
    case .sun:
      return 1
    case .mon:
      return 2
    case .tue:
      return 3
    case .wed:
      return 4
    case .thu:
      return 5
    case .fri:
      return 6
    case .sat:
      return 7
    }
  }
  
  var key: LocalizedKey {
    .init(rawValue: self.rawValue)!
  }
  
  func shortName(appLang: AppLanguage) -> String {
    switch self {
    case .everyday:
      return ""
    case .sun:
      return appLang == .Eng ? "SUN" : "နွေ"
    case .mon:
      return appLang == .Eng ? "MON" : "လာ"
    case .tue:
      return appLang == .Eng ? "TUE" : "ဂါ"
    case .wed:
      return appLang == .Eng ? "WED" : "ဟူး"
    case .thu:
      return appLang == .Eng ? "THU" : "ကြာ"
    case .fri:
      return appLang == .Eng ? "FRI" : "သော"
    case .sat:
      return appLang == .Eng ? "SAT" : "နေ"
    }
  }
}
