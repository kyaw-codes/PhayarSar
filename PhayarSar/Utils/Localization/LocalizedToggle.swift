//
//  LocalizedToggle.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

struct LocalizedToggle: View {
    @EnvironmentObject var preferences: UserPreferences
    let titleKey: LocalizedKey
    let defaultTitle: String
    let args: [String]
    let systemImage: String
    let isOn: Binding<Bool>
    
    init(_ titleKey: LocalizedKey, defaultTitle title: String = "", args: [String] = [], systemImage: String = "", isOn: Binding<Bool>) {
        self.titleKey = titleKey
        self.args = args
        self.defaultTitle = title
        self.systemImage = systemImage
        self.isOn = isOn
    }

    var body: some View {
        Toggle(titleKey.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultTitle), systemImage: systemImage, isOn: isOn)
    }
}
