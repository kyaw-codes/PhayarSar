//
//  PrayerModeScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import SwiftUI

struct PrayerModeScreen: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  var body: some View {
    VStack(alignment: .leading) {
      LocalizedText(.mode)
        .font(.dmSerif(24))
            
      HStack(alignment: .top, spacing: 20) {
        ReadingModeView()
          .frame(height: 240)
        
        
        PlayerModeView()
          .frame(height: 240)
      }
      .multilineTextAlignment(.center)
      .padding(.top, 8)
      
      Spacer(minLength: 20)
    }
    .padding()
  }
}

#Preview {
  PrayerModeScreen()
    .previewEnvironment()
}
