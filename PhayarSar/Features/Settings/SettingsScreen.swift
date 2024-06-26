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
  @Binding var showWhatIsNew: Bool
  @EnvironmentObject private var frcManager: RemoteConfigManager
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var worshipPlanRepo: WorshipPlanRepository
  @State private var showResetSuccessfulToast = false
  @State private var showDisableReminderSuccessfulToast = false
  @State private var showLanguageSelector = false
  
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
            
            Text("V\(appVersion)")
              .font(.qsB(14))
              .foregroundColor(preferences.accentColor.color)
          }
        }
      }

      Section {
        ChooseLang()
        AppAccentColor()
        EnableHaptic()
        EnableShakeToReport()
        ThemeSelector()
      }
      
      WhatIsNewSection()
      
      if isCurrentVersionLower(minimumVersion: frcManager.latestAppVersion) {
        NewVersionAvailableSection()
      }
      
      HelpSection()
      
      Section {
        NavigationLink {
          SwiftPackagesScreen()
            .onAppear {
              showTabBar = false
            }
        } label: {
          HStack {
            Image(systemName: "swift")
              .foregroundColor(.white)
              .font(.caption)
              .padding(5)
              .background(
                RoundedRectangle(cornerRadius: 4)
                  .fill(.gray)
              )
            LocalizedText(.licenses)
              .font(.qsSb(16))
              .foregroundColor(.primary)
          }
          .foregroundColor(.primary)
        }
        
        NavigationLink {
          ReferencedWebsitesScreen()
            .onAppear {
              showTabBar = false
            }
        } label: {
          HStack {
            Image(systemName: "globe")
              .foregroundColor(.white)
              .font(.caption)
              .padding(5)
              .background(
                RoundedRectangle(cornerRadius: 4)
                  .fill(.brown)
              )
            LocalizedText(.websites_referenced_for_prayers)
              .font(.qsSb(16))
              .foregroundColor(.primary)
          }
          .foregroundColor(.primary)
        }
      }
      
      Section {
        ResetPrayersThemeData()
      } footer: {
        LocalizedText(.reset_prayers_theme_desc)
          .font(.qsR(14))
      }
      
      Group {
        Section {
          DisableAllRemainder()
        } footer: {
          LocalizedText(.disable_worship_reminders_desc)
            .font(.qsR(14))
            .padding(.bottom, 100)
        }
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
    .toast(isPresenting: $showDisableReminderSuccessfulToast) {
      AlertToast(
        displayMode: .alert,
        type: .systemImage("checkmark.circle.fill", .white),
        title: LocalizedKey.disable_worship_reminders_success.localize(preferences.appLang),
        style: .style(backgroundColor: .green, titleColor: .white, subTitleColor: .white, titleFont: .qsSb(16), subTitleFont: nil)
      )
    }
    .sheet(isPresented: $showLanguageSelector) {
      if #available(iOS 16, *) {
        NavigationView {
          ChooseLanguageScreen(isStandalone: true)
        }
        .presentationDetents([.fraction(0.4)])
      } else {
        NavigationView {
          ChooseLanguageScreen(isStandalone: true)
        }
        .backport.presentationDetents([.medium])
      }
    }
  }
  
  @ViewBuilder
  func WhatIsNewSection() -> some View {
    Section {
      Button {
        withAnimation(.snappy) {
          showWhatIsNew = true
        }
      } label: {
        HStack {
          Image(systemName: "warninglight.fill")
            .foregroundColor(.white)
            .font(.caption)
            .padding(5)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(.purple)
            )
          LocalizedText(.whats_new_in_v_x, args: ["\(appVersion)"])
            .font(.qsSb(16))
            .foregroundColor(.primary)
        }
        .foregroundColor(.primary)
      }
    }
  }
  
  @ViewBuilder
  func NewVersionAvailableSection() -> some View {
    Section {
      Button(action: openPhayarsarOnAppStore) {
        HStack {
          Image(systemName: "bolt.fill")
            .foregroundColor(.white)
            .font(.caption)
            .padding(5)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(colors: [.pink, .orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
          
          LocalizedText(.version_x_is_available, args: ["\(frcManager.latestAppVersion)"])
            .font(.qsSb(16))
          
          Spacer()
          
          Image(systemName: "arrow.up.right")
            .foregroundColor(.secondary)
        }
      }
      .tint(.primary)
    } footer: {
      LocalizedText(.version_x_is_available_desc)
        .font(.qsR(14))
    }
  }
  
  @ViewBuilder
  func HelpSection() -> some View {
    Section {
      Button(action: openPhayarsarOnAppStore) {
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.white)
            .font(.caption)
            .padding(5)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(.yellow)
            )
          LocalizedText(.rate_app)
            .font(.qsSb(16))
            .foregroundColor(.primary)
          
          Spacer()
          
          Image(systemName: "arrow.up.right")
            .foregroundColor(.secondary)
        }
        .foregroundColor(.primary)
      }
      
      if #available(iOS 16, *) {
        ShareLink(item: URL(string: "https://apps.apple.com/us/app/phayarsar/id6475991817")!) {
          HStack {
            Image(systemName: "square.and.arrow.up.fill")
              .foregroundColor(.white)
              .font(.caption)
              .padding(5)
              .background(
                RoundedRectangle(cornerRadius: 4)
                  .fill(.blue)
              )
            LocalizedText(.tell_friends)
              .font(.qsSb(16))
              .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "arrow.up.right")
              .foregroundColor(.secondary)
          }
          .foregroundColor(.primary)
        }
      }
      
      Button(action: sendFeedback) {
        HStack {
          Image(systemName: "paperplane.fill")
            .foregroundColor(.white)
            .font(.caption)
            .padding(5)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(.pink)
            )
          LocalizedText(.send_feedback)
            .font(.qsSb(16))
          
          Spacer()
          
          Image(systemName: "arrow.up.right")
            .foregroundColor(.secondary)
        }
        .foregroundColor(.primary)
      }
    }
  }
  
  private func sendFeedback() {
    let mailtoString = "mailto:kyaw.codes@gmail.com?subject=PhayarSar App feedback".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let mailToUrl = URL(string: mailtoString!)!
    
    if UIApplication.shared.canOpenURL(mailToUrl) {
      UIApplication.shared.open(mailToUrl, options: [:])
    }
  }

  @ViewBuilder
  private func ChooseLang() -> some View {
    Button {
      showLanguageSelector.toggle()
    } label: {
      HStack {
        LocalizedText(.app_language)
          .font(.qsSb(16))
        Spacer()
        Text(preferences.appLang.title)
          .font(.qsB(16))
          .foregroundColor(preferences.accentColor.color)
        Image(systemName: "chevron.right")
          .foregroundStyle(Color(uiColor: .systemGray2))
      }
    }
    .tint(.primary)
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
  private func EnableShakeToReport() -> some View {
    Toggle(isOn: $preferences.enableShakeToReport, label: {
      LocalizedText(.enable_shake_to_report)
        .font(.qsSb(16))
    })
    .tint(preferences.accentColor.color)
  }
  
  @ViewBuilder
  private func ThemeSelector() -> some View {
    LocalizedPicker(.app_theme, selection: $preferences.appTheme) {
      ForEach(AppTheme.allCases) {
        LocalizedText(.init(rawValue: $0.rawValue) ?? .system)
          .tag($0)
      }
    }
    .font(.qsSb(16))
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
  
  @ViewBuilder
  private func DisableAllRemainder() -> some View {
    LocalizedButton(.disable_worship_reminders) {
      worshipPlanRepo.disableAllReminders()
      showDisableReminderSuccessfulToast.toggle()
    }
    .font(.qsSb(16))
    .tint(.pink)
  }
}

#Preview {
  NavigationView {
    SettingsScreen(showTabBar: .constant(true), showWhatIsNew: .constant(false))
  }
  .previewEnvironment()
}
