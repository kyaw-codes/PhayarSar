//
//  LocalizedPicker.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 28/05/2024.
//

import SwiftUI

struct LocalizedPicker<Model: Hashable, Content: View>: View {
  
  let titleKey: LocalizedKey
  let defaultValue: String
  let args: [String]
  @Binding var selection: Model
  let content: () -> Content
  
  init(
    _ titleKey: LocalizedKey,
    defaultValue: String = "",
    args: [String] = [],
    selection: Binding<Model>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.titleKey = titleKey
    self.defaultValue = defaultValue
    self.args = args
    self._selection = selection
    self.content = content
  }
  
  @EnvironmentObject private var preferences: UserPreferences
  
  var body: some View {
    Picker(selection: $selection, content: content) {
      LocalizedText(titleKey, args: args, default: defaultValue)
        .font(.qsSb(16))
    }
    .tint(.primary)
  }
}
