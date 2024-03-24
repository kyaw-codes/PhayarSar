//
//  CommonPrayerParagraphView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

struct CommonPrayerParagraphView<Model: CommonPrayerProtocol>: View  {
  @EnvironmentObject private var preferences: UserPreferences
  
  @Binding var prayer: Model.Body
  @ObservedObject var vm: CommonPrayerVM<Model>
  
  var body: some View {
    LazyVStack(alignment: .leading, spacing: 10) {
      Text(prayer.content)
        .tracking(vm.config.letterSpacing)
        .lineSpacing(vm.config.lineSpacing)
        .frame(maxWidth: .infinity,
               alignment: PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).alignment)

      if vm.config.showPronunciation && !prayer.pronunciation.isEmpty {
        Text("(\(prayer.pronunciation))")
          .font(MyanmarFont(rawValue: vm.config.font).orElse(.msquare).font(CGFloat(vm.config.textSize) * 0.9))
          .tracking(vm.config.letterSpacing)
          .lineSpacing(vm.config.lineSpacing)
          .opacity(0.5)
          .frame(maxWidth: .infinity, 
                 alignment: PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).alignment)
      }
    }
    .font(MyanmarFont(rawValue: vm.config.font).orElse(.msquare).font(CGFloat(vm.config.textSize)))
    .multilineTextAlignment(PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).textAlignment)
    .padding([.top, .bottom], 10)
    .blur(radius: calculateBlurRadius())
    .opacity(calculateOpacity())
    .contentShape(Rectangle())
    .onTapGesture(perform: scrollToCertainParagraph)
  }
  
  private func calculateBlurRadius() -> CGFloat {
    guard vm.config.mode != PrayingMode.reader.rawValue, vm.config.spotlightTextEnable else {
      return 0
    }
    return prayer.isBlur ? 2.5 : 0
  }
  
  private func calculateOpacity() -> Double {
    if vm.config.mode == PrayingMode.player.rawValue && vm.config.spotlightTextEnable {
      return prayer.isBlur ? 0.5 : 1
    } else {
      return 1
    }
  }
  
  private func scrollToCertainParagraph() {
    if vm.config.mode == PrayingMode.player.rawValue && vm.config.tapToScrollEnable {
      vm.scrollToId = prayer.id
    }
  }
}

#Preview {
  CommonPrayerParagraphView<PhayarSarModel>(
    prayer: .constant(natPint.body[0]),
    vm: .init(model: natPint)
  )
  .previewEnvironment()
}
