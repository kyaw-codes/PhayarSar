//
//  SettingsScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI
import AlertToast

struct SettingsScreen: View {
  @Binding var showTabBar: Bool
  @EnvironmentObject private var preferences: UserPreferences
  @State private var showResetSuccessfulToast = false
  
  var body: some View {
    List {
      Section {
        HStack(spacing: 14) {
          Image(.logo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 58)
            .clipShape(RoundedRectangle(cornerRadius: 12))
          
          VStack(alignment: .leading, spacing: 5) {
            Text("PhayarSar")
              .font(.dmSerif(20))
            
            Text("V1.0.0")
              .font(.qsB(14))
              .foregroundColor(preferences.accentColor.color)
          }
        }
      }

      Section {
        ChooseLang()
        AppAccentColor()
        EnableHaptic()
      }
      
      Section {
        ResetPrayersThemeData()
      } footer: {
        LocalizedText(.reset_prayers_theme_desc)
          .font(.qsR(14))
      }
    }
    .navigationTitle(.settings)
    .navigationBarTitleDisplayMode(.inline)
    .toast(isPresenting: $showResetSuccessfulToast) {
      AlertToast(
        displayMode: .alert,
        type: .systemImage("checkmark.circle.fill", .white),
        title: LocalizedKey.prayers_theme_data_reset_successfully.localize(preferences.appLang),
        style: .style(backgroundColor: .green, titleColor: .white, subTitleColor: .white, titleFont: .qsSb(16), subTitleFont: nil)
      )
    }
  }
  
  @ViewBuilder
  private func ChooseLang() -> some View {
    NavigationLink {
      ChooseLanguageScreen(isStandalone: true)
        .onAppear {
          showTabBar = false
        }
    } label: {
      HStack {
        LocalizedText(.app_language)
          .font(.qsSb(16))
        Spacer()
        Text(preferences.appLang.title)
          .font(.qsB(16))
          .foregroundColor(preferences.accentColor.color)
        
      }
    }
  }
  
  @ViewBuilder
  private func AppAccentColor() -> some View {
    NavigationLink {
      ChooseColorScreen()
        .onAppear {
          showTabBar = false
        }
    } label: {
      HStack {
        LocalizedText(.app_accent_color)
          .font(.qsSb(16))
        Spacer()
        Circle()
          .fill(preferences.accentColor.color)
          .frame(width: 28)
          .overlay {
            Circle()
              .stroke(Color.white, lineWidth: 3)
              .frame(width: 20)
          }
        
      }
    }
  }
  
  @ViewBuilder
  private func EnableHaptic() -> some View {
    Toggle(isOn: $preferences.isHapticEnable, label: {
      LocalizedText(.haptic_on, default: "Haptic on")
        .font(.qsSb(16))
    })
    .tint(preferences.accentColor.color)
  }
  
  @ViewBuilder
  private func ResetPrayersThemeData() -> some View {
    LocalizedButton(.reset_prayers_theme) {
      do {
        try CoreDataStack.shared.deleteAll(PrayerConfiguration.self)
        HapticKit.selection.generate()
        showResetSuccessfulToast.toggle()
      } catch {
        print("Failed to delete all PrayerConfiguration: \(error.localizedDescription)")
      }
    }
    .font(.qsSb(16))
    .tint(.pink)
  }
}

#Preview {
  NavigationView {
    SettingsScreen(showTabBar: .constant(true))
  }
  .environmentObject(UserPreferences())
}
