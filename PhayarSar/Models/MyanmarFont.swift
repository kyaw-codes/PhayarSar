//
//  MyanmarFont.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

enum MyanmarFont: String, CaseIterable, Identifiable, Hashable {
    case jasmine
    case msquare
    case yoeyar

    var id: String { self.rawValue }
    
    var key: LocalizedKey {
        switch self {
        case .jasmine:
            return .jasmine
        case .msquare:
            return .msquare
        case .yoeyar:
            return .yoeyar
        }
    }
        
    func font(_ size: CGFloat = 12) -> Font {
        switch self {
        case .jasmine:
            return .jasmine(size)
        case .msquare:
            return .mSquare(size)
        case .yoeyar:
            return .yoeYar(size)
        }
    }
}
