//
//  SpotlightScrollManager.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 06/01/2024.
//

import SwiftUI
import Combine

final class SpotlightScrollManager: ObservableObject {
    
    @Published var isPlaying = false
    @Published var currentIndex = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// Used to force recalculate `body` of paragraph view
    @Published var paragraphRefreshId = UUID().uuidString
    
    func startScrolling() {
        isPlaying = true
    }
}
