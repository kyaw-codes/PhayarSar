//
//  CommonPrayerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct CommonPrayerScreen<Model>: View where Model: CommonPrayerProtocol {
    @State private var showPronounciation = true
    @EnvironmentObject var preferences: UserPreferences
    @State private var showAboutScreen = false
    
    var model: Model
    
    var body: some View {
        ScrollView {
        }
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Menu {
                    Button {
                        
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
        .tint(preferences.accentColor.color)
        .sheet(isPresented: $showAboutScreen, content: {
            NavigationView {
                AboutPrayerScreen(title: model.title, about: model.about)
            }
        })
    }
}

#Preview {
    NavigationView {
        CommonPrayerScreen(model: natPint)
    }
    .previewEnvironment()
}
