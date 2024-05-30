//
//  SwiftPackagesScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/03/2024.
//

import SwiftUI

struct SwiftPackagesScreen: View {
  private let packages: [(String, String)] = [
    ("SwiftUIBackports", "https://github.com/shaps80/SwiftUIBackports"),
    ("CompactSlider", "https://github.com/buh/CompactSlider"),
    ("SwipeActions", "https://github.com/aheze/SwipeActions"),
    ("AlertToast", "https://github.com/elai950/AlertToast"),
    ("SwiftUICharts", "https://github.com/willdale/SwiftUICharts"),
    ("Firebase", "https://github.com/firebase/firebase-ios-sdk")
  ]
  
  var body: some View {
    
    List(packages, id: \.0) { package in
      Link(destination: URL(string: package.1)!, label: {
        VStack(alignment: .leading, spacing: 4) {
          Text(package.0)
            .font(.qsSb(16))
          Text("(\(package.1))")
            .font(.qsSb(12))
            .underline()
            .foregroundColor(.blue)
        }
        .foregroundColor(.primary)
        .padding(.vertical, 1)
      })
    }
    .navigationTitle(.licenses)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationView {
    SwiftPackagesScreen()
  }
  .previewEnvironment()
}
