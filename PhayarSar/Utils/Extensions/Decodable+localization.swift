//
//  Decodable+localization.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 21/05/2024.
//

import Foundation

extension Decodable {
  
  func localized(en: KeyPath<Self, String>, mm: KeyPath<Self, String>) -> String {
    if UserDefaults.standard.string(forKey: "appLang") == AppLanguage.Eng.rawValue {
      return self[keyPath: en]
    } else {
      return self[keyPath: mm]
    }
  }
}
