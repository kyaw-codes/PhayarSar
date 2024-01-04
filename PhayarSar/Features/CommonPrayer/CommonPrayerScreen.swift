//
//  CommonPrayerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI
import SwiftUIBackports

struct CommonPrayerScreen<Model> where Model: CommonPrayerProtocol {
    @State private var showPronounciation = true
    @EnvironmentObject var preferences: UserPreferences
    @State private var showAboutScreen = false
    @State private var showThemesScreen = false
    
    // Dependencies
    var model: Model
}

extension CommonPrayerScreen: View {
    var body: some View {
        ScrollView {
        }
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                PrayerMenu()
            }
        }
        .tint(preferences.accentColor.color)
        .sheet(isPresented: $showAboutScreen) {
            NavigationView {
                AboutPrayerScreen(title: model.title, about: model.about)
            }
        }
        .sheet(isPresented: $showThemesScreen) {
            NavigationView {
                ThemesAndSettingsScreen()
                    .ignoresSafeArea()
            }
            .backport.presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder private func PrayerMenu() -> some View {
        Menu {
            Button {
                showThemesScreen.toggle()
            } label: {
                LocalizedLabel(.themes_and_settings, default: "Themes & Settings", systemImage: "textformat.size")
            }
            Button {
                showAboutScreen.toggle()
            } label: {
                LocalizedLabel(.about_x, args: [model.title], systemImage: "info.circle.fill")
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
        }
    }
}

#Preview {
    NavigationView {
        CommonPrayerScreen(model: natPint)
    }
    .previewEnvironment()
}
