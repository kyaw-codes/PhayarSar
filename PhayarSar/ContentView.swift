//
//  ContentView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var presentOnboarding = false
    
    var body: some View {
        NavigationView {
            Text("Hello")
                .onAppear {
                    presentOnboarding.toggle()
                }
                .sheet(isPresented: $presentOnboarding, content: {
                    OnboardingScreen()
                })
        }
    }
}

#Preview {
    ContentView()
}
