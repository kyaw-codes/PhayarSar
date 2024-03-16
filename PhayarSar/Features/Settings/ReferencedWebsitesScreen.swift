//
//  ReferencedWebsitesScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/03/2024.
//

import SwiftUI

struct ReferencedWebsitesScreen: View {
  private let websites: [(String, String)] = [
    ("Wikipedia", "https://my.wikipedia.org"),
    ("BawdiWiki", "https://www.bawdiwiki.com/"),
    ("Burmese Buddhist Temple", "https://www.bbt.org.sg/maha-paritta/maha-paritta-pali-burmese/"),
    ("MahaMyaing", "https://mahamyaing.org/worship-and-prayer/")
  ]
  
  var body: some View {
    
    List(websites, id: \.0) { package in
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
    .navigationTitle(.websites_referenced_for_prayers)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationView {
    ReferencedWebsitesScreen()
  }
  .previewEnvironment()
}
