//
//  PlayerModeView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import SwiftUI

struct PlayerModeView: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  @State private var currentIndex = 0
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State private var playPauseBtn = "pause.fill"
  
  var body: some View {
    VStack {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(uiColor: .secondarySystemBackground))
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(preferences.accentColor.color, style: .init(lineWidth: 1))
          }
        
        ScrollViewReader { proxy in
          ScrollView {
            VStack(spacing: 12) {
              ForEach(0 ..< 5, id: \.self) { index in
                VStack(alignment: .leading, spacing: 2) {
                  ForEach(0 ..< 4, id: \.self) { id in
                    RoundedRectangle(cornerRadius: 3)
                      .fill(
                        LinearGradient(
                          colors: [preferences.accentColor.color.opacity(0.6), preferences.accentColor.color.opacity(1)],
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
                      )
                      .brightness(0.2)
                      .frame(height: currentIndex == index ? 8 : 5)
                      .padding(.top, currentIndex == index ? 0 : 3)
                      .frame(maxWidth: id == 3 ? 60 : .infinity)
                  }
                }
                .id(index)
                .blur(radius: currentIndex == index ? 0 : 3)
              }
            }
            .padding(.bottom, 120)
          }
          .allowsHitTesting(false)
          .onReceive(timer, perform: { _ in
            withAnimation(.easeIn(duration: 0.3)) {
              currentIndex = currentIndex + 1 == 5 ? 0 : currentIndex + 1
              proxy.scrollTo(currentIndex, anchor: .top)
              playPauseBtn = currentIndex == 0 ? "play.fill" : "pause.fill"
            }
          })
        }
        .padding(.horizontal)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      .overlay(alignment: .bottomTrailing) {
        Capsule()
          .fill(preferences.accentColor.color)
          .frame(width: 40, height: 24)
          .overlay {
            Image(systemName: playPauseBtn)
              .font(.caption2)
              .foregroundColor(.white)
          }
          .padding(.trailing, 8)
          .padding(.bottom, 12)
      }
      
      LocalizedText(.player_mode)
        .foregroundColor(.primary)
        .font(.qsB(15))
        .padding(.top, 2)
        .padding(.bottom, 4)
    }
    .padding(6)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(preferences.accentColor.color)
        .opacity(0)
    }
  }
}

#Preview {
  PrayerModeScreen()
    .previewEnvironment()
}
