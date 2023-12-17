//
//  CustomCornerView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 17/12/2023.
//

import SwiftUI

struct CustomCornerView: Shape {
    
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
