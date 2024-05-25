//
//  ShimmeringEffect.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 25/05/2024.
//

import SwiftUI

extension View {
  @ViewBuilder
  func shimmering() -> some View {
    self.modifier(ShimmeringEffectModifier())
  }
}

struct ShimmeringEffectModifier: ViewModifier {
  @State private var startAnimation = false
  private var screenWidth: CGFloat { UIScreen.main.bounds.width }

  func body(content: Content) -> some View {
    content
      .overlay {
        LinearGradient(
          colors: [
            .clear,
            .white.opacity(0.8),
            .clear
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .offset(x: startAnimation ? screenWidth * 0.5 : -screenWidth * 0.5)
      }
      .mask {
        content
      }
      .onAppear {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
          startAnimation.toggle()
        }
      }
  }
}
