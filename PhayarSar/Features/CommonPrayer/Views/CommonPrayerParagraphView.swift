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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(prayer.content)
            Text("(\(prayer.pronunciation))")
                .font(.jasmine(25))
                .opacity(0.5)
        }
        .foregroundColor(.init(uiColor: prayer.isBlur ? .secondaryLabel : .label))
        .font(.jasmine( prayer.isBlur ? 25 : 30))
        .multilineTextAlignment(.leading)
        .padding([.top, .bottom], 10)
        .blur(radius: prayer.isBlur ? 2.5 : 0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .id(refreshId)
    }
}

#Preview {
    CommonPrayerParagraphView<NatPintVO>(
        refreshId: .constant(""),
        prayer: .constant(natPint.body[0]), 
        index: .constant(0)
    )
    .previewEnvironment()
}
