//
//  PageControlView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 01/03/2024.
//

import SwiftUI

struct PageControlView: UIViewRepresentable {
  var currentPage: Int
  var currentPageIndicatorTintColor: Color
  var numberOfPages: Int
  
  func makeUIView(context: Context) -> UIPageControl {
    let view = UIPageControl()
    view.numberOfPages = numberOfPages
    view.pageIndicatorTintColor = .label.withAlphaComponent(0.2)
    return view
  }
  
  func updateUIView(_ pageControl: UIPageControl, context: Context) {
    pageControl.currentPage = currentPage
    pageControl.currentPageIndicatorTintColor = UIColor(currentPageIndicatorTintColor)

  }
}
