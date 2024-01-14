//
//  PrayerModeScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 14/01/2024.
//

import SwiftUI

struct PrayerModeScreen {
  @ObservedObject private var vm: CommonPrayerVM
  @EnvironmentObject private var preferences: UserPreferences
  
  @State private var selectedMode = PrayingMode.reader
  
  init(vm: CommonPrayerVM) {
    self._vm = .init(wrappedValue: vm)
  }
}

extension PrayerModeScreen: View {
  var body: some View {
    VStack(alignment: .leading) {
      LocalizedText(.mode)
        .font(.dmSerif(24))
            
      HStack(alignment: .top, spacing: 20) {
        ReadingModeView(selectedMode: $selectedMode)
          .frame(height: 240)
        
        PlayerModeView(selectedMode: $selectedMode)
          .frame(height: 240)
      }
      .multilineTextAlignment(.center)
      .padding(.top, 8)
      
      Spacer(minLength: 20)
    }
    .padding()
    .onChange(of: selectedMode) { mode in
      HapticKit.selection.generate()
      vm.config.mode = selectedMode.rawValue
    }
    .onAppear {
      selectedMode = .init(rawValue: vm.config.mode).orElse(.reader)
    }
    .onDisappear {
      vm.save()
    }
  }
}

#Preview {
  PrayerModeScreen(vm: CommonPrayerVM(prayerId: "NatPint"))
    .previewEnvironment()
}
