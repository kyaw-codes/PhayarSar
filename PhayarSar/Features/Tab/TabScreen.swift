//
//  TabScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

enum TabItem: String, CaseIterable, Hashable {
    case home
    case settings
    
    var title: LocalizedKey {
        switch self {
        case .home:
            return .home
        case .settings:
            return .settings
        }
    }
    
    var icon: Image {
        switch self {
        case .home:
            return .init(systemName: "house")
        case .settings:
            return .init(systemName: "gear")
        }
    }
    
    var selectedIcon: Image {
        switch self {
        case .home:
            return .init(systemName: "house.fill")
        case .settings:
            return .init(systemName: "gear")
        }
    }
}

struct TabScreen: View {
    @EnvironmentObject private var preferences: UserPreferences
    @State private var selected: TabItem = .home
    
    var body: some View {
        TabView(selection: $selected) {
            NavigationView {
                HomeScreen()
            }
            .tag(TabItem.home)
            .tabItem {
                Label {
                    LocalizedText(TabItem.home.title)
                } icon: {
                    selected == .home ? TabItem.home.selectedIcon : TabItem.home.icon
                }
            }
            
            NavigationView {
                SettingsScreen()
            }
            .tag(TabItem.settings)
            .tabItem {
                Label {
                    LocalizedText(TabItem.settings.title)
                } icon: {
                    selected == .settings ? TabItem.settings.selectedIcon : TabItem.settings.icon
                }
            }
        }
        .tint(.appGreen)
        .environmentObject(preferences)
    }
}

#Preview {
    TabScreen()
        .environmentObject(UserPreferences())
}
