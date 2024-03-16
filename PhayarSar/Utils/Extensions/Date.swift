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
    let calendar = Calendar.current
    // Get the year and month components of the given date
    let year = calendar.component(.year, from: self)
    let month = calendar.component(.month, from: self)
    
    // Create date components for the first day of the month
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = 1
    
    // Get the start of the month by creating a date from the date components
    return calendar.date(from: dateComponents) ?? .init()
  }
  
  var endOfMonth: Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
  }
}
