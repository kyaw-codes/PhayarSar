//
//  AboutPrayerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct AboutPrayerScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var preferences: UserPreferences
    
    let title: String
    let about: String
    
    var body: some View {
        ScrollView {
            Text(about)
                .font(.title2)
                .padding()
                .navigationTitle(.about_x, args: [title])
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        BtnCloseCircle { dismiss() }
                    }
                }
        }
        .tint(preferences.accentColor.color)
    }
}

#Preview {
    NavigationView {
        AboutPrayerScreen(title: natPint.title, about: natPint.about)
    }
    .previewEnvironment()
}
