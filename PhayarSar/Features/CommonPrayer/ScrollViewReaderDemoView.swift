//
//  ScrollViewReaderDemoView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

struct ScrollViewReaderDemoView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var startTime = Date().timeIntervalSince1970
    
    var body: some View {
        GeometryReader { gProxy in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(0 ..< 4, id: \.self) { id in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange)
                                .frame(height: 100)
                                .hueRotation(.degrees(Double(id * 10)))
                                .padding(.bottom, id == 3 ? gProxy.size.height - 100 : 0)
                        }
                    }
                    .padding()
                }
                .onReceive(timer, perform: { _ in
                    let currentTime = Date().timeIntervalSince1970
                    index = Int(currentTime - startTime)
                    
                    withAnimation(.linear) {
                        proxy.scrollTo(index, anchor: .top)
                    }
                })
            }
        }
    }
}

#Preview {
    ScrollViewReaderDemoView()
}
