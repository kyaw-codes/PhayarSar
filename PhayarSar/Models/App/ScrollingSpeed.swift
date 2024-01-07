//
//  ScrollingSpeed.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/01/2024.
//

import Foundation

enum ScrollingSpeed: String, CaseIterable, Hashable, Identifiable {
    case x0_5
    case x0_75
    case x1
    case x1_25
    case x1_5
    case x2
    
    var key: LocalizedKey { .init(rawValue: self.rawValue)! }
    
    var id: String { self.rawValue }
}
