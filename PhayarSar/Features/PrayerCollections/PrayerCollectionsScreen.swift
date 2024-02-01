//
//  PrayerCollectionsScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 30/01/2024.
//

import SwiftUI

struct PrayerCollectionsScreen: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  var title: String
  var systemImage: String
  var prayers: [NatPintVO]
  
  var body: some View {
    ScrollView {
      VStack(spacing: 15) {
        ForEach(prayers) { prayer in
          NavigationLink {
            CommonPrayerScreen(model: prayer)
          } label: {
            HStack(spacing: 6) {
              Image(systemName: systemImage)
                .foregroundColor(.primary)
              
              Text(prayer.title)
                .font(.footnote.bold())
                .foregroundColor(.primary)
                .padding(.vertical, 16)
              
              Spacer()
              
              Image(systemName: "chevron.right")
                .foregroundColor(preferences.accentColor.color)
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 12)
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(.cardBg)
            )
          }
        }
      }
      .padding()
    }
    .navigationTitle(title)
  }
}

#Preview {
  NavigationView {
    PrayerCollectionsScreen(title: "ဘုရားရှိခိုး အမျိုးမျိုး", systemImage: "heart.fill", prayers: cantotkyo)
  }
  .previewEnvironment()
}
