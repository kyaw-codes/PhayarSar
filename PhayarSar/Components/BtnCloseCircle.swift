//
//  BtnCloseCircle.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct BtnCloseCircle: View {
    @EnvironmentObject private var preferences: UserPreferences
    @Environment(\.colorScheme) private var colorScheme
    
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(.ultraThinMaterial)
                .background(
                    Circle()
                        .fill(preferences.accentColor.color)
                        .blur(radius: 20)
                        .clipShape(Circle())
                )
                .frame(width: 28)
                .overlay {
                    Image(systemName: "xmark")
                        .font(.caption2.bold())
                        .foregroundColor(preferences.accentColor.color)
                        .background {
                            Image(systemName: "xmark")
                                .font(.caption2.bold())
                                .foregroundColor(preferences.accentColor.color)
                                .blur(radius: colorScheme == .dark ? 2 : 0)
                        }
                }
        }
    }
}
