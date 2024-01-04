//
//  ThemesAndSettingsScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI

struct ThemesAndSettingsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var preferences: UserPreferences
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderView()
                TextPreviewView()
                
                ScrollView {
                    FontPickerView()

                    Divider()
                        .padding(.top)
                    
                    ColorPickerView()
                }
                .clipShape(
                    CustomCornerView(corners: [.topLeft, .topRight], radius: 20)
                )
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            LocalizedText(.themes_and_settings)
                .font(.dmSerif(24))
            Spacer()
            
            BtnCloseCircle { dismiss() }
        }
    }
    
    @ViewBuilder
    private func TextPreviewView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .frame(height: 140)
            
            Group {
                Text("သီဟိုဠ်မှ ဉာဏ်ကြီးရှင်သည် အာယုဝဍ္ဎနဆေးညွှန်းစာကို ဇလွန်ဈေးဘေး ဗာဒံပင်ထက် အဓိဋ္ဌာန်လျက် ဂဃနဏဖတ်ခဲ့သည်။")
                    .tracking(1)
                    .font(.yoeYar(20))
                    .lineSpacing(10)
                    .padding()
            }
            .scrollOnOverflow()
        }
        .frame(height: 140)
        .padding(.top)
    }
    
    @ViewBuilder
    private func FontPickerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Font")
                .font(.dmSerif(20))
            HStack(spacing: 14) {
                ForEach(MyanmarFont.allCases) { font in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cardBg)
                        .overlay {
                            Text("ကခဂ")
                                .font(font.font(30))
                                .padding(.bottom)
                        }
                        .overlay(alignment: .bottom) {
                            LocalizedText(font.key)
                                .font(.qsB(13))
                                .padding(.bottom)
                        }
                        .overlay {
                            if font == .jasmine {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(preferences.accentColor.color, lineWidth: 3)
                            }
                        }
                }
            }
            .frame(height: 100)
            .padding(.horizontal, 2)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func ColorPickerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Background & Color")
                .font(.dmSerif(20))
            
            ScrollView {
                HStack {
                    ForEach(PageColor.allCases) { color in
                        Circle()
                            .stroke(color == .grey ? preferences.accentColor.color : .clear, style: .init(lineWidth: 2))
                            .frame(width: 38)
                            .padding(3)
                            .overlay {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 30)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.gray, style: .init(lineWidth: 0.3))
                                    }
                            }
                            .overlay {
                                if color == .grey {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(color.tintColor)
                                        .font(.footnote.bold())
                                }
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        ThemesAndSettingsScreen()
    }
    .previewEnvironment()
}
