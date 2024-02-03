//
//  WorshipPlanConfigStep.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import Foundation

enum WorshipPlanConfigStep: String, Hashable, Equatable, CaseIterable {
  case selectDay
  case selectTime
  case selectTagColor
  case setReminder
  
  var key: LocalizedKey {
    .init(rawValue: self.rawValue)!
  }
}
