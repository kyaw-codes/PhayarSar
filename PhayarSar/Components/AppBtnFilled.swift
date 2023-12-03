//
//  AppBtnFilled.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

struct AppBtnFilled: View {
    var action: () -> Void
    var title: String
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.appGreen)
                    .frame(height: 60)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.qsB(18))
            }
                
        }
    }
}
