//
//  AllPrayerPickerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/02/2024.
//

import SwiftUI

struct AllPrayerPickerScreen: View {
  @Binding var prayers: [PhayarSarModel]
  @State private var internalPrayers: [PhayarSarModel] = []
  
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var preferences: UserPreferences
  @State private var editMode: EditMode = .active
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(PhayarSarRepository.getData(type: .cantotkyo)) { prayer in
            ListCell(prayer)
          }
          ForEach(PhayarSarRepository.getData(type: .others)) { prayer in
            ListCell(prayer)
          }
          ForEach(PhayarSarRepository.getData(type: .payeik)) { prayer in
            ListCell(prayer)
          }
          
          ListCell(PhayarSarRepository.getData(type: .pahtanShort)[0])
          ListCell(PhayarSarRepository.getData(type: .pahtanLong)[0])
          
          ForEach(PhayarSarRepository.getData(type: .myittarPoe)) { prayer in
            ListCell(prayer)
          }
        }
      }
      .onAppear(perform: {
        internalPrayers = prayers
      })
      .environment(\.editMode, .constant(EditMode.active))
      .listStyle(.grouped)
      .navigationTitle(.select_prayers)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem {
          Button {
            prayers = internalPrayers
            dismiss()
          } label: {
            LocalizedText(.btn_save)
              .font(.qsB(15))
          }
        }
        
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            LocalizedText(.btn_close)
              .font(.qsSb(15))
          }
        }
      }
      .tint(preferences.accentColor.color)
    }
  }
  
  @ViewBuilder
  private func ListCell(_ prayer: PhayarSarModel) -> some View {
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
  AllPrayerPickerScreen(prayers: .constant(PhayarSarRepository.getData(type: .cantotkyo)))
    .previewEnvironment()
}
