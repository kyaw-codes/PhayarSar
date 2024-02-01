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
  
  private let coreDataStack = CoreDataStack.shared
  
  init() {
    let appear = UINavigationBarAppearance()
    
    let atters: [NSAttributedString.Key: Any] = [
      .font: UIFont(name: "DMSerifDisplay-Regular", size: 18)!
    ]
    
    appear.largeTitleTextAttributes = atters
    appear.titleTextAttributes = atters
    UINavigationBar.appearance().standardAppearance = appear
    UINavigationBar.appearance().compactAppearance = appear
    UINavigationBar.appearance().scrollEdgeAppearance = appear
  }
}

extension PhayarSarApp {
  
  var body: some Scene {
    WindowGroup {
      Group {
        if preferences.hasAppLangChosen == nil {
          ChooseLanguageScreen()
        } else {
          TabScreen()
        }
      }
      .environmentObject(preferences)
      .environment(\.managedObjectContext, coreDataStack.viewContext)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    langDict = Bundle.main.decode([String: [String: String]].self, from: "Language.json")
    
    return true
  }
}
