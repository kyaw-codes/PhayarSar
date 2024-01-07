//
//  PrayingProgressView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/01/2024.
//

import SwiftUI

struct PrayingProgressView: View {
    @EnvironmentObject private var preferences: UserPreferences
    
    @Binding var progress: CGFloat
    var onPause: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Button(action: onPause) {
                    Image(systemName: "pause.fill")
                        .padding(.trailing)
                }
                
                GeometryReader {
                    let width = $0.size.width
                    
                    Capsule()
                        .fill(.white)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .frame(width: (width / 100) * progress)
                        }
                }
                .frame(height: 6)

                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.callout.bold())
                        .padding(.leading)
                }
            }
            .foregroundColor(preferences.accentColor.color)
            .font(.dmSerif(16))
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Capsule().fill(preferences.accentColor.color.opacity(0.2)))
            .background(Capsule().fill(.ultraThinMaterial))
            
            Text("\(Int(progress))%")
                .padding(.vertical, 10)
                .foregroundColor(preferences.accentColor.color)
                .font(.qsB(12))
                .frame(width: 48)
                .background(Capsule().fill(.ultraThickMaterial))
        }
    }
}

#Preview {
    PrayingProgressView(
        progress: .constant(50),
        onPause: {},
        onCancel: {}
    )
    .padding()
    .previewEnvironment()
}
