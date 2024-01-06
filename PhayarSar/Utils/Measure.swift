//
//  Measure.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 05/01/2024.
//

import SwiftUI

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

fileprivate struct MeasureModifier: ViewModifier {
    let fn: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader {
                    Color.clear
                        .preference(key: SizeKey.self, value: $0.size)
                }
            }
            .onPreferenceChange(SizeKey.self, perform: fn)
    }
}

extension View {
    func measure(_ fn: @escaping (CGSize) -> Void) -> some View {
        modifier(MeasureModifier(fn: fn))
    }
    
    func measure(
        _ path: KeyPath<CGSize, CGFloat>,
        _ fn: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(MeasureModifier { fn($0[keyPath: path]) })
    }
}
