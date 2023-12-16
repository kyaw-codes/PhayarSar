//
//  ContentView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(natPint.body) { vo in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(vo.content)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("(\(vo.pronunciation))")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle(natPint.title)
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
