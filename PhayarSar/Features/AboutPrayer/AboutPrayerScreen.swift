//
//  AboutPrayerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct AboutPrayerScreen: View {
    @Environment(\.colorScheme) private var colorScheme
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
                        Button {
                            dismiss()
                        } label: {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .background(
                                    Circle()
                                        .fill(preferences.accentColor.color)
                                        .blur(radius: 20)
                                        .clipShape(Circle())
                                )
                                .frame(width: 28)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .font(.caption2.bold())
                                        .foregroundColor(preferences.accentColor.color)
                                        .background {
                                            Image(systemName: "xmark")
                                                .font(.caption2.bold())
                                                .foregroundColor(preferences.accentColor.color)
                                                .blur(radius: colorScheme == .dark ? 2 : 0)
                                        }
                                }
                        }
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
