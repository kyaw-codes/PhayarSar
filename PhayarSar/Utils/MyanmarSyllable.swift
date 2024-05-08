//
//  MyanmarSyllable.swift
//  PhayarSar
//
//  Created by Htain Lin Shwe on 08/05/2024.
//

import Foundation

class MyammarSyllable {
    
    static private let myConsonant = "\u{1000}-\u{1021}" // "က-အ"
    static private let enChar = "a-zA-Z0-9"
    // "ဣဤဥဦဧဩဪဿ၌၍၏၀-၉၊။!-/:-@[-`{-~\s"
    static private let otherChar = "\u{1023}\u{1024}\u{1025}\u{1026}\u{1027}\u{1029}\u{102a}\u{103f}\u{104c}\u{104d}\u{104f}\u{1040}-\u{1049}\u{104a}\u{104b}!-/:-@\\[-`\\{-~\\s"
    static private let ssSymbol = "\u{1039}"
    static private let ngaThat = "\u{1004}\u{103a}"
    static private let aThat = "\u{103a}"


    static func segment(text: String) -> [String] {
      var outArray = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "။", with: "")
            .replacingOccurrences(of: "၊", with: "")
            .replacingOccurrences(of: "((?!" + ssSymbol + ")[" + myConsonant + "](?![" + aThat + ssSymbol + "])" + "|[" + enChar + otherChar + "])", with: "𝕊$1", options: .regularExpression)
            .components(separatedBy: "𝕊")
        
      if outArray.count > 0 {
        outArray.removeFirst()
      }
      return outArray
    }

}
