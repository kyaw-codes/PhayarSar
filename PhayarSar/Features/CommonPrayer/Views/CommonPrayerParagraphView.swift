//
//  CommonPrayerParagraphView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

struct CommonPrayerParagraphView<Model: CommonPrayerProtocol>: View  {
  @EnvironmentObject private var preferences: UserPreferences
  
  @Binding var refreshId: String
  @Binding var prayer: Model.Body
  @Binding var index: Int
  @Binding var scrollToId: String?
  @Binding var config: PrayerConfiguration
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(prayer.content)
        .tracking(config.letterSpacing)
        .lineSpacing(config.lineSpacing)
        .frame(maxWidth: .infinity, 
               alignment: PrayerAlignment(rawValue: config.textAlignment).orElse(.left).alignment)

      if config.showPronunciation {
        Text("(\(prayer.pronunciation))")
          .font(MyanmarFont(rawValue: config.font).orElse(.msquare).font(CGFloat(config.textSize) * 0.9))
          .tracking(config.letterSpacing)
          .lineSpacing(config.lineSpacing)
          .opacity(0.5)
          .frame(maxWidth: .infinity, 
                 alignment: PrayerAlignment(rawValue: config.textAlignment).orElse(.left).alignment)
      }
    }
    .font(MyanmarFont(rawValue: config.font).orElse(.msquare).font(CGFloat(config.textSize)))
    .multilineTextAlignment(PrayerAlignment(rawValue: config.textAlignment).orElse(.left).textAlignment)
    .padding([.top, .bottom], 10)
    .blur(radius: calculateBlurRadius())
    .opacity(config.mode == PrayingMode.player.rawValue ? 0.5 : 1)
    .contentShape(Rectangle())
    .id(refreshId)
    .onTapGesture {
      scrollToId = prayer.id
    }
  }
  
  private func calculateBlurRadius() -> CGFloat {
    guard config.mode != PrayingMode.reader.rawValue else {
      return 0
    }
    return prayer.isBlur ? 2.5 : 0
  }
}

#Preview {
  CommonPrayerParagraphView<NatPintVO>(
    refreshId: .constant(""),
    prayer: .constant(natPint.body[0]),
    index: .constant(0),
    scrollToId: .constant(nil),
    config: .constant(PrayerConfiguration.preview())
  )
  .previewEnvironment()
}
