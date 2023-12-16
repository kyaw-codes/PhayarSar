//
//  LocalizedText.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

struct LocalizedText: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    var key: LocalizedKey
    var args: [String]
    var defaultValue: String
    
    init(_ key: LocalizedKey, args: [String] = [], default str: String? = nil) {
        self.key = key
        self.args = args
        self.defaultValue = str.orEmpty
    }
    
    var body: some View {
        Text(key.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultValue))
    }
}
