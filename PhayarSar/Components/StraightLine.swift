//
//  StraightLine.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import SwiftUI

struct StraightLine: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: .init(x: rect.midX, y: 0))
      path.addLine(to: .init(x: rect.midX, y: rect.maxY))
    }
  }
}
