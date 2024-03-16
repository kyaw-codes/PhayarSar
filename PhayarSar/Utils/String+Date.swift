//
//  String+Date.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/03/2024.
//

import Foundation

enum DateFormat: String {
  case hmm_a = "h:mm a"
  case ddMMyyyy = "dd / MM / yyyy"
  case MMM = "MMM"
  case EEddMMMyyyy = "EE, dd MMM yyyy"
  case EE = "EE"
}

extension Locale {
    static let enUS = Locale(identifier: "en_US_POSIX")
}

extension String {
  func removeWhitespaces() -> String {
      return components(separatedBy: .whitespaces).joined()
  }
  
  func toDate(format: DateFormat, useBaseLang: Bool = false) -> Date? {
    let dateFormatter = DateFormatter()
    
    if useBaseLang {
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    dateFormatter.dateFormat = format.rawValue
    
    return dateFormatter.date(from: self)
  }
}

extension Date {
  func toStringWith(_ format: DateFormat, _ locale: Locale = .current, _ calendarIdentifier: Calendar.Identifier = .gregorian, setGMT0: Bool = false, removeMeridiem: Bool = false, removeSpaces: Bool = false) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.enUS
    dateFormatter.calendar = Calendar(identifier: calendarIdentifier)
    dateFormatter.dateFormat = format.rawValue
    if setGMT0 { dateFormatter.timeZone = TimeZone(secondsFromGMT:0) }
    var strDate = dateFormatter.string(from: self)
    
    if removeSpaces {
      strDate = strDate.removeWhitespaces()
    }
    
    if removeMeridiem {
      strDate = strDate.replacingOccurrences(of: "AM", with: "")
      strDate = strDate.replacingOccurrences(of: "PM", with: "")
    }
    
    return strDate
  }
}
