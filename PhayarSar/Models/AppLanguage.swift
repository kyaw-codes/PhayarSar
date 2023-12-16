//
//  AppLanguage.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

enum AppLanguage: String, Equatable, CaseIterable, Decodable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case Eng
    case Mm
    
    var title: String {
        switch self {
        case .Eng:
            return "English"
        case .Mm:
            return "Myanmar"
        }
    }
    
    var desc: String {
        switch self {
        case .Eng:
            return "(English)"
        case .Mm:
            return "(Burmese)"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .Eng:
            return .eng
        case .Mm:
            return .mm
        }
    }
}
