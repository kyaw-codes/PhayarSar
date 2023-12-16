//
//  ChooseLanguageScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

struct ChooseLanguageScreen: View {
    @State private var showOnboarding = false
    @EnvironmentObject private var preferences: UserPreferences
    
    var isStandalone: Bool = false
    
    var body: some View {
        List {
            ForEach(AppLanguage.allCases, content: LangOptionView(lang:))
        }
        .navigationTitle(.choose_a_language)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isStandalone {
                LocalizedButton(.next, action:  { preferences.hasAppLangChosen = true })
                    .tint(.appGreen)
            }
        }
    }
    
    @ViewBuilder
    private func LangOptionView(lang: AppLanguage) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(lang.image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 34, height: 34)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lang.title).font(.qsB(15))
                    Text(lang.desc).font(.qsB(12)).foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
            }
            
            Spacer()
            
            if preferences.appLang == lang {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.appGreen)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            preferences.appLang = lang
        }
    }
}

#Preview {
    NavigationView {
        ChooseLanguageScreen()
    }
    .environmentObject(UserPreferences())
}
