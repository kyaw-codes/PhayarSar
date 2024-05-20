//
//  AskForReview.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 20/05/2024.
//

import SwiftUI
import StoreKit

@available(iOS 16, *)
fileprivate struct AskForReviewModifier: ViewModifier {
  @Environment(\.requestReview) private var requestReview
  var onAppear = true
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        if onAppear {
          requestReview()
        }
      }
      .onDisappear {
        if !onAppear {
          requestReview()
        }
      }
  }
}

extension View {
  @ViewBuilder func askForReviewOnAppear() -> some View {
    if #available(iOS 16, *) {
      modifier(AskForReviewModifier())
    } else {
      self
    }
  }
  
  @ViewBuilder func askForReviewOnDisappear() -> some View {
    if #available(iOS 16, *) {
      modifier(AskForReviewModifier(onAppear: false))
    } else {
      self
    }
  }
}
