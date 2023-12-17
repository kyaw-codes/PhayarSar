//
//  AppBtnFilled.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

struct AppBtnFilled: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    var action: () -> Void
    var title: LocalizedKey
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(preferences.accentColor.color)
                    .frame(height: 60)
                
                LocalizedText(title)
                    .foregroundColor(.white)
                    .font(.qsB(18))
            }
                
        }
    }
}
