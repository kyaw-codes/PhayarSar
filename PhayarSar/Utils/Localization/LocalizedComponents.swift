//
//  LocalizedComponents.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

struct LocalizedComponents: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    var body: some View {
        VStack {
            LocalizedText(.welcome_to_phayarsar)
                .multilineTextAlignment(.center)
                .font(.dmSerif(32))
            Button {
                withAnimation(.none) {
                    preferences.appLang = preferences.appLang == .Eng ? .Mm : .Eng
                }
            } label: {
                LocalizedText(.next)
            }
        }
    }
}

#Preview {
    NavigationView {
        LocalizedComponents()
            .navigationTitle(.choose_a_language)
            .navigationBarTitleDisplayMode(.inline)
    }
    .environmentObject(UserPreferences())
}
