//
//  OnboardingScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

struct OnboardingScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            logoImage
            
            VStack(spacing: 20) {
                titleText
                subtitleText
            }
            .padding(.top, 30)
            
            Spacer()
            
            getStartedButton
        }
        .padding()
        .padding(.horizontal)
    }
}

extension OnboardingScreen {
    var logoImage: some View {
        Image("logo")
            .resizable()
            .frame(width: 86, height: 86)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding(.top, 40)
    }
    
    var titleText: some View {
        LocalizedText(.welcome_to_phayarsar)
            .multilineTextAlignment(.center)
            .font(.dmSerif(32))
    }
    
    var subtitleText: some View {
        LocalizedText(.onboarding_desc)
            .multilineTextAlignment(.center)
            .font(.qsSb(16))
    }
    
    var getStartedButton: some View {
        AppBtnFilled(action: { dismiss() }, title: .btn_get_started)
    }
}

#Preview {
    OnboardingScreen()
        .environmentObject(UserPreferences())
}
