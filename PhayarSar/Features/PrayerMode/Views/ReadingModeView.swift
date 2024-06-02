//
//  ReadingModeView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import SwiftUI

struct ReadingModeView: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  @State private var textHueRotationDegree = 0.0
  @State private var textOpacity = 1.0
  @State private var paragraphOffsetY = 0.0
  @State private var handRotation = -20.0
  @State private var handOffsetY = 0.0
  @State private var handOffsetX = -10.0
  
  @Binding var selectedMode: PrayingMode
  
  var body: some View {
    VStack {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(uiColor: .secondarySystemBackground))
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(preferences.accentColor.color, style: .init(lineWidth: 1))
          }
        
        VStack(spacing: 12) {
          ForEach(0 ..< 5, id: \.self) { _ in
            VStack(alignment: .leading, spacing: 2) {
              ForEach(0 ..< 4, id: \.self) { id in
                RoundedRectangle(cornerRadius: 3)
                  .fill(
                    LinearGradient(
                      colors: [preferences.accentColor.color.opacity(0.6), preferences.accentColor.color.opacity(textOpacity)],
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing)
                  )
                  .brightness(0.2)
                  .hueRotation(.degrees(textHueRotationDegree))
                  .frame(height: 8)
                  .frame(maxWidth: id == 3 ? 60 : .infinity)
              }
            }
          }
        }
        .offset(y: paragraphOffsetY)
        .padding(.horizontal)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      .overlay(alignment: .bottomTrailing) {
        Image(systemName: "hand.draw.fill")
          .font(.largeTitle)
          .padding(4)
          .background {
            Circle()
              .fill(.regularMaterial)
          }
          .rotationEffect(.degrees(handRotation), anchor: .bottomTrailing)
          .offset(x: handOffsetX, y: handOffsetY)
          .padding([.leading, .bottom])
          .padding(.bottom)
          .padding(.trailing, 8)
        
      }
      
      LocalizedText(.reader_mode)
        .foregroundColor(selectedMode == .reader ? .white : .primary)
        .font(.qsB(15))
        .padding(.top, 2)
        .padding(.bottom, 4)
    }
    .padding(6)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(preferences.accentColor.color)
        .opacity(selectedMode == .reader ? 1 : 0)
    }
    .onAppear {
      withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
        textOpacity = 0.4
        textHueRotationDegree = 10
        
        handRotation = 0
        handOffsetY = -40
        handOffsetX = 0
        
        paragraphOffsetY = -40
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation(.easeOut(duration: 0.3)) {
        selectedMode = .reader
      }
    }
  }
}

#Preview {
  PrayerModeScreen(vm: .init(model: natpint))
    .previewEnvironment()
}
