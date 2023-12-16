//
//  UserDefaults.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import Foundation

extension UserDefaults {
    
    func set(_ value: Any?, forKey key: Defaults) {
        self.set(value, forKey: key.rawValue)
    }
    
    func string(forKey key: Defaults) -> String? {
        string(forKey: key.rawValue)
    }
    
    func bool(forKey key: Defaults) -> Bool {
        bool(forKey: key.rawValue)
    }
}
