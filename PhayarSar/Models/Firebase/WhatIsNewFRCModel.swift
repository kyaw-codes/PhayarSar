//
//  WhatIsNewFRCModel.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 20/05/2024.
//

import Foundation

struct WhatIsNewFRCModel: Decodable, Identifiable, Hashable {
  var id: String {
    titleEn
  }
  
  var titleEn: String
  var titleMm: String
  var bodyEn: String
  var bodyMm: String
  var image_url: String
  
  var localizedTitle: String {
    localized(en: \.titleEn, mm: \.titleMm)
  }
  
  var localizedBody: String {
    localized(en: \.bodyEn, mm: \.bodyMm)
  }
  
  static let empty: Self = .init(titleEn: "", titleMm: "", bodyEn: "", bodyMm: "", image_url: "")
}
