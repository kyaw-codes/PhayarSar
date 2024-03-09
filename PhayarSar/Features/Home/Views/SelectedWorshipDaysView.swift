//
//  SelectedWorshipDaysView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 09/03/2024.
//

import SwiftUI

struct SelectedWorshipDaysView: View {
  @EnvironmentObject private var preferences: UserPreferences
  let selectedDaysEnum: [DaysOfWeek]
  var fontSize: CGFloat = 8
  
  var body: some View {
    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 20), spacing: 8), count: 7)) {
      ForEach([DaysOfWeek.sun, .mon, .tue, .wed, .thu, .fri, .sat].map(\.shortStr), id: \.self) { name in
        Circle()
          .stroke(preferences.accentColor.color, lineWidth: 1)
          .background {
            if selectedDaysEnum.map(\.shortStr).contains(name) {
              Circle()
                .fill(preferences.accentColor.color)
            }
          }
          .overlay {
            LocalizedText(name)
              .font(.qsB(fontSize))
              .foregroundColor(selectedDaysEnum.map(\.shortStr).contains(name) ? .white : preferences.accentColor.color)
          }
      }
    }
  }
}

#Preview {
  SelectedWorshipDaysView(selectedDaysEnum: [.mon, .wed, .fri, .sat])
    .previewEnvironment()
    .padding()
}
