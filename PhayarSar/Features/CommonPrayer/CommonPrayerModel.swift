//
//  CommonPrayerModel.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

final class CommonPrayerModel: ObservableObject {
    @Published var noBlurCellIndex: Int = 1
    @Published var currentTime: Int = 0
}
