//
//  SpotlightScrollManager.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 06/01/2024.
//

import SwiftUI
import Combine

final class SpotlightScrollManager<Model>: ObservableObject where Model: CommonPrayerProtocol {
    
    @Published private(set) var isPlaying = false
    @Published private(set) var currentId = ""
    @Published var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// Used to force recalculate `body` of paragraph view
    @Published var paragraphRefreshId = UUID().uuidString
    
    func startScrolling() {
        isPlaying.toggle()
        
        guard isPlaying else { return }
        paragraphRefreshId = UUID().uuidString
    }
    
    func scrollTo(_ id: String) {
        currentId = id
    }
}
