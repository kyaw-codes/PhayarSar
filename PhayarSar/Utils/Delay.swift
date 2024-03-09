//
//  Delay.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 09/03/2024.
//

import Foundation

func delay(_ seconds: TimeInterval, _ fn: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { fn() }
}
