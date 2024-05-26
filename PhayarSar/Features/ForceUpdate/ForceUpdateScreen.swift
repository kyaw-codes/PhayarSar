//
//  ForceUpdateScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 26/05/2024.
//

import SwiftUI

struct ForceUpdateScreen: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  var body: some View {
    VStack(spacing: 30) {
      Image(.rocketLaunch)
      
      VStack(spacing: 12) {
        LocalizedText(.update_require)
          .font(preferences.appLang == .Mm ? .qsB(30) : .dmSerif(30))
        
        LocalizedText(.update_require_desc)
          .lineSpacing(preferences.appLang == .Mm ? 4 : 0)
          .font(.qsSb(16))
          .padding(.top, preferences.appLang == .Mm ? 15 : 0)
      }
      .multilineTextAlignment(.center)
    }
    .padding(.horizontal, 20)
    .frame(maxHeight: .infinity)
    .safeAreaInset(edge: .bottom) {
      Button {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6475991817") {
          UIApplication.shared.open(url)
        }
      } label: {
        LocalizedText(.update_now)
          .font(.qsSb(17))
          .padding(12)
          .frame(maxWidth: .infinity)
          .background(Capsule().fill(preferences.accentColor.color))
          .padding()
          .foregroundStyle(.white)
      }
    }
  }
}

#Preview {
  ForceUpdateScreen()
    .previewEnvironment()
}
