//
//  LaunchScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 20/05/2024.
//

import SwiftUI

struct LaunchScreen: View {
  @EnvironmentObject private var preferences: UserPreferences
  @State private var showLoading = false
  
  var body: some View {
    VStack(spacing: 0) {
      Image(.logo)
        .resizable()
        .frame(width: 90, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaleEffect(showLoading ? 1 : 0.8, anchor: .top)
      
      Text("PhayarSar")
        .multilineTextAlignment(.center)
        .font(.dmSerif(30))
        .scaleEffect(showLoading ? 0.8 : 1, anchor: .bottom)
      
      if showLoading {
        ProgressView()
          .scaleEffect(1.4)
          .tint(preferences.accentColor.color)
          .transition(.offset(y: 20))
          .padding(.top, 20)
      }
    }
    .padding(.horizontal, 40)
    .onAppear {
      withAnimation(.snappy.delay(0.2)) {
        showLoading.toggle()
      }
    }
  }
}

#Preview {
  LaunchScreen()
    .previewEnvironment()
}
