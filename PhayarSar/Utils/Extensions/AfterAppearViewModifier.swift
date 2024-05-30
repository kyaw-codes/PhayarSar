//
//  AfterAppearModifier.swift
//  PhayarSar
//
//  Created by winlwinoo on 19/05/2024.
//

import SwiftUI
import UIKit

extension View {
    /// Adds an action to perform after this view appears.
    func afterAppear(perform action: @escaping () -> Void) -> some View {
        self.modifier(AfterAppearViewModifier(afterAppear: action))
    }
}


// MARK: - AfterAppearViewModifier
/**
 adds a background UIKitViewWrapper view, which is invisible but triggers the UIKit lifecycle events
 */
struct AfterAppearViewModifier: ViewModifier {
    var afterAppear: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(UIKitViewWrapper(afterAppear: afterAppear))
    }
}

// MARK: - UIKitViewWrapper
/**
 responsible to create a WrapperUIViewController
 */
struct UIKitViewWrapper: UIViewControllerRepresentable {
    var afterAppear: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        WrapperUIViewController(appear: afterAppear)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// MARK: - WrapperUIViewController
/**
 triggers afterAppear closure when viewDidAppear is called
 */
class WrapperUIViewController: UIViewController {
    var afterAppear: () -> Void
    
    init(appear afterAppear: @escaping () -> Void) {
        self.afterAppear = afterAppear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        afterAppear()
    }
}


