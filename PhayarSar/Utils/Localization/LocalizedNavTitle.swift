//
//  LocalizedNavTitle.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

private struct LocalizedNavTitleModifier: ViewModifier {
    @EnvironmentObject private var preferences: UserPreferences
    
    var key: LocalizedKey
    var args: [String]
    var defaultValue: String
    
    init(_ key: LocalizedKey, args: [String] = [], default str: String? = nil) {
        self.key = key
        self.args = args
        self.defaultValue = str.orEmpty
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(key.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultValue))
            .font(.dmSerif(14))
    }
}

extension View {
    func navigationTitle(_ key: LocalizedKey, args: [String] = [], default str: String? = nil) -> some View {
        self.modifier(LocalizedNavTitleModifier(key, args: args, default: str))
    }
}
