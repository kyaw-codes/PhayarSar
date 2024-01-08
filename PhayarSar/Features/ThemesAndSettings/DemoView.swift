//
//  DemoView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 08/01/2024.
//

import SwiftUI

struct DemoView: View {
  var body: some View {
    TextPreviewView()
  }
  
  @ViewBuilder
  private func TextPreviewView() -> some View {
    ScrollView {
      // 12
      
      // 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44
      VStack {
        ForEach(MyanmarFont.allCases) { font in
          Text("သီဟိုဠ်မှ ဉာဏ်ကြီးရှင်သည် အာယုဝဍ္ဎနဆေးညွှန်းစာကို ဇလွန်ဈေးဘေး ဗာဒံပင်ထက် အဓိဋ္ဌာန်လျက် ဂဃနဏဖတ်ခဲ့သည်။")
            .font(font.font(28))
            .tracking(18)
            .lineSpacing(15)
            .multilineTextAlignment(.leading)
            .padding()
        }
      }
    }
    .padding(.top)
  }
}

#Preview {
  Group {
    DemoView()
  }
}
