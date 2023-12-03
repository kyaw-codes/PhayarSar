//
//  PhayarSarApp.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

@main
struct PhayarSarApp: App {
    @AppStorage(Defaults.isFirstLaunch.rawValue) var isFirstLaunch = false
    @State private var showingOnboard = false
}

extension PhayarSarApp {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    defer { isFirstLaunch = true }
                    if !isFirstLaunch {
                        showingOnboard = true
                    }
                }
                .sheet(isPresented: $showingOnboard, content: {
                    OnboardingScreen()
                })
        }
    }
}
