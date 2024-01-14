//
//  ModeSelectedView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import SwiftUI

struct ModeSelectedView: View {
  @EnvironmentObject private var preferences: UserPreferences
  
  var body: some View {
    HStack(spacing: 2) {
      Image(systemName: "checkmark.circle.fill")
        .font(.callout)
      
      LocalizedText(.selected)
        .font(.qsSb(12))
    }
    .foregroundColor(.white)
  }
}

#Preview {
  ModeSelectedView()
    .previewEnvironment()
    .preferredColorScheme(.dark)
}
