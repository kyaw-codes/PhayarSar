//
//  AllPrayerPickerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/02/2024.
//

import SwiftUI

struct AllPrayerPickerScreen: View {
  @Binding var prayers: [NatPintVO]
  @State private var internalPrayers: [NatPintVO] = []
  
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var preferences: UserPreferences
  @State private var editMode: EditMode = .active
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(cantotkyo) { prayer in
            ListCell(prayer)
          }
          ForEach(others) { prayer in
            ListCell(prayer)
          }
          ForEach(payeik) { prayer in
            ListCell(prayer)
          }
          
          ListCell(pahtanShort)
          ListCell(pahtanLong)
          
          ForEach(myittarPoe) { prayer in
            ListCell(prayer)
          }
        }
      }
      .onAppear(perform: {
        internalPrayers = prayers
      })
      .environment(\.editMode, .constant(EditMode.active))
      .listStyle(.grouped)
      .navigationTitle("Select prayers")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem {
          Button {
            prayers = internalPrayers
            dismiss()
          } label: {
            Text("Save")
              .font(.qsB(15))
          }
        }
        
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Text("Close")
              .font(.qsSb(15))
          }
        }
      }
      .tint(preferences.accentColor.color)
    }
  }
  
  @ViewBuilder
  private func ListCell(_ prayer: NatPintVO) -> some View {
    VStack(spacing: 0) {
      HStack(spacing: 14) {
        Image(systemName: internalPrayers.contains(prayer) ? "checkmark.circle.fill" : "circle")
          .foregroundColor(internalPrayers.contains(prayer) ? preferences.accentColor.color : Color(uiColor: .tertiaryLabel))
        Text(prayer.title)
          .font(.qsR(18))
        
        Spacer()
      }
      .padding()
      .padding(.vertical, 4)

      Divider()
    }
    .background(internalPrayers.contains(prayer) ? preferences.accentColor.color.opacity(0.2) : .clear)
    .contentShape(Rectangle())
    .onTapGesture {
      HapticKit.selection.generate()
      withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
        if internalPrayers.contains(prayer) {
          internalPrayers.removeAll(where: { $0 == prayer })
        } else {
          internalPrayers.append(prayer)
        }
      }
    }
  }
}

#Preview {
  AllPrayerPickerScreen(prayers: .constant(cantotkyo))
    .previewEnvironment()
}
