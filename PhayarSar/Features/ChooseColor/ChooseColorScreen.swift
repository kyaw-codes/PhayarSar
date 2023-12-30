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
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 0), count: 3)) {
                ForEach(AppColor.allCases) { color in
                    ColorSampleView(color)
                }
            }
            .padding([.horizontal, .top])
        }
        .navigationTitle(.choose_accent_color)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func ColorSampleView(_ appColor: AppColor) -> some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(appColor.color)
                .frame(width: 90, height: 167)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(preferences.accentColor == appColor ? Color.white : .clear, lineWidth: 6)
                        .shadow(color: preferences.accentColor == appColor ? .black.opacity(0.8) : .clear, radius: 20, x: 0.0, y: -4)
                }
                .overlay {
                    VStack(spacing: 8) {
                        Circle()
                            .fill(appColor.color)
                            .brightness(0.15)
                            .frame(width: 30)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(appColor.color)
                            .brightness(0.15)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(appColor.color)
                            .brightness(-0.1)
                            .frame(height: 56)
                            .padding(.top, 4)
                            .overlay {
                                VStack(spacing: 8) {
                                    ForEach(0 ..< 3, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(appColor.color)
                                        .brightness(0.15)
                                        .frame(height: 5)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                    }
                    .padding(14)
                    .padding(.bottom, 5)
                }
                .scaleEffect(preferences.accentColor == appColor ? 1 : 0.96, anchor: .center)
            
            Text(appColor.displayName)
                .font(.qsB(13))
                .background {
                    if preferences.accentColor == appColor {
                        Text(appColor.displayName)
                            .font(.qsB(13))
                            .blur(radius: 10)
                    }
                }
                .foregroundColor(appColor.color)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(.thickMaterial)
                }
                .background {
                    if preferences.accentColor == appColor {
                        Capsule()
                            .fill(appColor.color)
                            .blur(radius: 2.5)
                    }
                }
                .scaleEffect(preferences.accentColor == appColor ? 1 : 0.9, anchor: .center)
                .padding(.bottom)
        }
        .offset(y: preferences.accentColor == appColor ? -7 : 0)
        .contentShape(Rectangle())
        .onTapGesture {
            HapticKit.selection.generate()
            withAnimation(.spring(duration: 0.3, bounce: 0.5, blendDuration: 0.7)) {
                preferences.accentColor = appColor
            }
        }
        .padding(.top, 10)
    }
    
}

#Preview {
    NavigationView {
        ChooseColorScreen()
    }
    .previewEnvironment()
}
