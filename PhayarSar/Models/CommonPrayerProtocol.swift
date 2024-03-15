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
    let normalSPS = 8.0
    switch speed {
    case .x0_5:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * 0.5)
    case .x0_75:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * 0.75)
    case .x1:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS)
    case .x1_25:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * 1.25)
    case .x1_5:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * 1.5)
    case .x2:
      return calculateReadingTime(paragraph: pronunciation.isEmpty ? content : pronunciation, sylbPerSecond: normalSPS * 2)
    }
  }
}

extension Array where Element: CommonPrayerBodyProtocol {
  func index(of element: some CommonPrayerBodyProtocol) -> Int {
    self.firstIndex(where: { $0.id == element.id }) ?? 0
  }
}

func calculateReadingTime(paragraph: String, sylbPerSecond: Double = 5) -> Double {
  Double(segment(text: paragraph).count) / sylbPerSecond
}

let myConsonant = "\u{1000}-\u{1021}" // "က-အ"
let enChar = "a-zA-Z0-9"
// "ဣဤဥဦဧဩဪဿ၌၍၏၀-၉၊။!-/:-@[-`{-~\s"
let otherChar = "\u{1023}\u{1024}\u{1025}\u{1026}\u{1027}\u{1029}\u{102a}\u{103f}\u{104c}\u{104d}\u{104f}\u{1040}-\u{1049}\u{104a}\u{104b}!-/:-@\\[-`\\{-~\\s"
let ssSymbol = "\u{1039}"
let ngaThat = "\u{1004}\u{103a}"
let aThat = "\u{103a}"
// Regular expression pattern for Myanmar syllable breaking
// *** a consonant not after a subscript symbol AND a consonant is not
// followed by a-That character or a subscript symbol
let BREAK_PATTERN = try! NSRegularExpression(pattern: "((?!" + ssSymbol + ")[" + myConsonant + "](?![" + aThat + ssSymbol + "])" + "|[" + enChar + otherChar + "])", options: .anchorsMatchLines)

func segment(text: String) -> [String] {
  var outArray = text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "။", with: "").replacingOccurrences(of: "၊", with: "").replacingOccurrences(of: "((?!" + ssSymbol + ")[" + myConsonant + "](?![" + aThat + ssSymbol + "])" + "|[" + enChar + otherChar + "])", with: "𝕊$1", options: .regularExpression).components(separatedBy: "𝕊")
  if outArray.count > 0 {
    outArray.removeFirst()
    //out.splice(0, 1);
  }
  return outArray
}
