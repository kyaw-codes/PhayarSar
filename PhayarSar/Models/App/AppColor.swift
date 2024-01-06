//
//  AppColor.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 17/12/2023.
//

import SwiftUI

enum AppColor: String, CaseIterable, Hashable, Equatable, Decodable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case pineGreen
    case oliveGreen
    case dodgerBlue
    case neonBlue
    case midnightBlue
    case brightPink
    case aerospaceOrange
    case rust
    case bole
    case darkPurple
    case ultraViolet
    case ebony
    case charcol
    
    var displayName: String {
        switch self {
        case .pineGreen:
            return "Pine Green"
        case .oliveGreen:
            return "Olive Green"
        case .dodgerBlue:
            return "Dodger Blue"
        case .midnightBlue:
            return "Midnight Blue"
        case .neonBlue:
            return "Neon Blue"
        case .rust:
            return "Rust"
        case .brightPink:
            return "Bright Pink"
        case .aerospaceOrange:
            return "Orange"
        case .bole:
            return "Bole"
        case .darkPurple:
            return "Dark Purple"
        case .ultraViolet:
            return "Ultra Violet"
        case .ebony:
            return "Ebony"
        case .charcol:
            return "Charcol"
        }
    }
    
    var color: Color {
        switch self {
        case .pineGreen:
            return .appGreen
        case .oliveGreen:
            return .oliveGreen
        case .dodgerBlue:
            return .dodgerBlue
        case .midnightBlue:
            return .midnightBlue
        case .neonBlue:
            return .neonBlue
        case .rust:
            return .rust
        case .brightPink:
            return .brightPink
        case .aerospaceOrange:
            return .aerospaceOrange
        case .bole:
            return .bole
        case .darkPurple:
            return .darkPurple
        case .ultraViolet:
            return .ultraViolet
        case .ebony:
            return .ebony
        case .charcol:
            return .charcol
        }
    }
}
