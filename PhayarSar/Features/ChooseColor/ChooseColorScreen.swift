//
//  ChooseColorScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 17/12/2023.
//

import SwiftUI

struct ChooseColorScreen: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 200), spacing: 18), count: 2)) {
                ForEach(AppColor.allCases) { color in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.color)
                        .frame(height: 100)
                        .padding(.top, 9)
                        .overlay(alignment: .bottom) {
                            CustomCornerView(corners: [.bottomLeft, .bottomRight], radius: 12)
                                .fill(.thinMaterial)
                                .frame(height: 32)
                                .overlay {
                                    Text(color.displayName)
                                        .font(.dmSerif(14))
                                }
                        }
                        .overlay(alignment: .topTrailing) {
                            if preferences.accentColor == color {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                    .padding(.trailing, 12)
                            }
                        }
                        .shadow(color: preferences.accentColor == color ? .black.opacity(0.1) : .clear, radius: 10, x: 0, y: 0)
                        .scaleEffect(preferences.accentColor == color ? 1 : 0.95)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.3, bounce: 0.4, blendDuration: 0.7)) {
                                preferences.accentColor = color
                            }
                        }
                }
            }
            .padding([.horizontal, .top])
        }
        .navigationTitle(.choose_accent_color)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ChooseColorScreen()
    }
    .environmentObject(UserPreferences())
}
