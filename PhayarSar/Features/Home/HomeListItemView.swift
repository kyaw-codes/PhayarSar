//
//  HomeListItemView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import SwiftUI

struct HomeListItemView: View {
    @EnvironmentObject private var preferences: UserPreferences
    var title: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(.wheel)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
            Text(title)
                .font(.footnote.bold())
                .foregroundColor(.primary)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(preferences.accentColor.color.opacity(0.2), lineWidth: 1.0)
                }
        )
    }
}

#Preview {
    HomeListItemView(title: "နတ်ပင့်")
        .previewEnvironment()
}
