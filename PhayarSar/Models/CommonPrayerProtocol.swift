//
//  CommonPrayerProtocol.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 06/01/2024.
//

import Foundation

protocol CommonPrayerProtocol: Identifiable {
  associatedtype Body: CommonPrayerBodyProtocol
  
  var id: String { get }
  var title: String { get }
  var about: String { get }
  var body: [Body] { get set }
}

protocol CommonPrayerBodyProtocol: Identifiable {
  var id: String { get }
  var content: String { get }
  var pronunciation: String { get }
  var isBlur: Bool { get set }
}

extension CommonPrayerBodyProtocol {
  func duration(_ speedStr: String) -> Double {
    let speed = ScrollingSpeed(rawValue: speedStr).orElse(.x1)
    let normalWPM = 200.0
    switch speed {
    case .x0_5:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM * 0.5)
    case .x0_75:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM * 0.75)
    case .x1:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM)
    case .x1_25:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM * 1.25)
    case .x1_5:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM * 1.5)
    case .x2:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, wordsPerMinute: normalWPM * 2)
    }
  }
}

extension Array where Element: CommonPrayerBodyProtocol {
  func index(of element: some CommonPrayerBodyProtocol) -> Int {
    self.firstIndex(where: { $0.id == element.id }) ?? 0
  }
}

func calculateReadingTime(paragraph: String, wordsPerMinute: Double = 200) -> Double {
  let words = paragraph.components(separatedBy: .whitespacesAndNewlines)
  let numWords = words.count
  
  return Double(numWords) / wordsPerMinute * 60
}
