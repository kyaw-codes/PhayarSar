//
//  Date.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/03/2024.
//

import Foundation

extension Date {
  var startOfWeek: Date {
    let gregorian = Calendar(identifier: .gregorian)
    guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return self }
    return gregorian.date(byAdding: .day, value: 1, to: sunday) ?? self
  }
  
  var endOfWeek: Date {
    let gregorian = Calendar(identifier: .gregorian)
    guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return self }
    return gregorian.date(byAdding: .day, value: 7, to: sunday) ?? self
  }
  
  var startOfMonth: Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
  }
  
  var endOfMonth: Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
  }
}
