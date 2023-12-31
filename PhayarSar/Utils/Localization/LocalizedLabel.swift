//
//  LocalizedLabel.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct LocalizedLabel: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    var key: LocalizedKey
    var defaultValue: String
    var args: [String]
    var systemImage: String
    var color: Color?
    
    init(_ titleKey: LocalizedKey, args: [String] = [], default text: String = "", systemImage: String, color: Color? = nil) {
        self.key = titleKey
        self.args = args
        self.defaultValue = text
        self.systemImage = systemImage
        self.color = color
    }
    
    var body: some View {
        if let color {
            Label(
                title: { LocalizedText(key, args: args, default: defaultValue).foregroundColor(color) },
                icon: { Image(systemName: systemImage).foregroundColor(color) }
            )
        } else {
            Label(key.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultValue), systemImage: systemImage)
        }
    }
}
