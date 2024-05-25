//
//  TabScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

enum TabItem: String, CaseIterable, Hashable, Identifiable {
    case home
    case settings
    
    var id: String {
        return self.rawValue
    }
    
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

struct TabScreen {
    @Environment(\.safeAreaInsets) private var insets
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var preferences: UserPreferences
    @State private var selected: TabItem = .home
    @State private var showTabBar = true
  @State private var showWhatIsNew = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
}

extension TabScreen: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            NativeTabView()
            
            if showTabBar {
                CustomBottomBarView()
                    .zIndex(1)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
            }
          
          if showWhatIsNew {
            WhatIsNewScreen {
              withAnimation(.snappy) {
                showWhatIsNew = false
              }
            }
              .zIndex(1)
          }
        }
        .animation(.easeOut(duration: 0.2), value: showTabBar)
        .tint(preferences.accentColor.color)
        .environmentObject(preferences)
        .onAppear {
          withAnimation(.snappy) {
            showWhatIsNew = true
          }
        }
    }
    
    @ViewBuilder
    func NativeTabView() -> some View {
        TabView(selection: $selected) {
            NavigationView {
                HomeScreen(showTabBar: $showTabBar)
                    .afterAppear {
                        showTabBar = true
                    }
                    .navigationBarHidden(true)
            }
            .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
            .tag(TabItem.home)
            
            NavigationView {
                SettingsScreen(showTabBar: $showTabBar)
                    .afterAppear {
                        showTabBar = true
                    }
            }
            .tag(TabItem.settings)
        }
    }
    
    @ViewBuilder
    func CustomBottomBarView() -> some View {
        ZStack{
            HStack{
                ForEach(TabItem.allCases){ tab in
                    Button {
                        HapticKit.selection.generate()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 1.0)) {
                            selected = tab
                        }
                    } label: {
                        CustomTabItem(tab: tab)
                    }
                }
            }
            .padding(6)
        }
        .frame(width: 250, height: 70)
        .background(preferences.accentColor.color)
        .cornerRadius(35)
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    func CustomTabItem(tab: TabItem) -> some View {
        HStack(spacing: 10){
            Spacer()
            tab.icon
                .resizable()
                .renderingMode(.template)
                .foregroundColor(tab == selected ?  preferences.accentColor.color : .white)
                .frame(width: 20, height: 20)
            if tab == selected {
                LocalizedText(tab.title)
                    .font(.qsB(16))
                    .foregroundColor(tab == selected ?  preferences.accentColor.color : .secondary)
            }
            Spacer()
        }
        .frame(width: tab == selected ? 175 : 60, height: 60)
        .background(tab == selected ? .white : preferences.accentColor.color)
        .cornerRadius(30)
    }
}

// Disable swipe back gesture
//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//}

#Preview {
    TabScreen()
        .previewEnvironment()
}
