//
//  ViewDidAppearModifier.swift
//  PhayarSar
//
//  Created by winlwinoo on 19/05/2024.
//

import SwiftUI
import UIKit

struct UIKitViewDidAppearWrapper: UIViewControllerRepresentable {
    var onAppear: () -> Void
    
    func makeUIViewController(context: Context) -> WrapperViewController {
        let viewController = WrapperViewController()
        viewController.onAppear = onAppear
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: WrapperViewController, context: Context) {}
}

class WrapperViewController: UIViewController {
    var onAppear: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onAppear?()
    }
}
