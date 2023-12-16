//
//  PhayarSarApp.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

var langDict: [String: [String: String]] = [:]

@main
struct PhayarSarApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject private var preferences = UserPreferences()
}

extension PhayarSarApp {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if preferences.hasAppLangChosen == nil {
                    ChooseLanguageScreen()
                } else {
                    HomeScreen()
                }
            }
            .environmentObject(preferences)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        langDict = Bundle.main.decode([String: [String: String]].self, from: "Language.json")
        
        return true
    }
}
