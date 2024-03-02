//
//  PageControlView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 01/03/2024.
//

import SwiftUI

struct PageControlView: UIViewRepresentable {
  @Binding var currentPage: Int
  var currentPageIndicatorTintColor: Color
  var numberOfPages: Int
  
  func makeUIView(context: Context) -> UIPageControl {
    let view = UIPageControl()
    view.numberOfPages = numberOfPages
    view.pageIndicatorTintColor = .secondaryLabel
    return view
  }
  
  func updateUIView(_ pageControl: UIPageControl, context: Context) {
    pageControl.currentPage = currentPage
    pageControl.currentPageIndicatorTintColor = UIColor(currentPageIndicatorTintColor)

  }
}
