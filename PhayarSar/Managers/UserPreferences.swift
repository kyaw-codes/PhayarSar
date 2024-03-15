//
//  UserPreferences.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

@MainActor
class UserPreferences: ObservableObject {
  @AppStorage("isFirstLaunch") var isFirstLaunch: Bool?
  @AppStorage("hasAppLangChosen") var hasAppLangChosen: Bool?
  @AppStorage("appLang") var appLang: AppLanguage = .Eng
  @AppStorage("accentColor") var accentColor: AppColor = .pineGreen
  @AppStorage("isHapticEnable") var isHapticEnable: Bool = false
  @AppStorage("areRemindersEnabled") var areRemindersEnabled: Bool = true
}
