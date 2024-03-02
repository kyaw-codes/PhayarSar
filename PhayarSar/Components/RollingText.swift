//
//  RollingText.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import SwiftUI

struct RollingText: View {
  var font: Font
  var weight: Font.Weight = .regular
  
  @Binding var value: Int
  @State private var animationRange: [Int] = []
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(0 ..< animationRange.count, id: \.self) { index in
        Text("8")
          .font(font)
          .fontWeight(weight)
          .opacity(0)
          .overlay {
            GeometryReader {
              let size = $0.size
              
              VStack(spacing: 0) {
                ForEach(0 ... 9, id: \.self) { number in
                  Text("\(number)")
                    .font(font)
                    .fontWeight(weight)
                    .frame(width: size.width, height: size.height, alignment: .center)
                }
              }
              .offset(y: -CGFloat(animationRange[index]) * size.height)
            }
            .clipped()
          }
      }
    }
    .onAppear {
      animationRange = Array(repeating: 0, count: "\(value)".count)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
        updateText()
      }
    }
    .onChange(of: value) { newValue in
      updateText()
    }
  }
  
  private func updateText() {
    let stringValue = "\(value)"
    for (index, value) in zip(0 ..< stringValue.count, stringValue) {
      var fraction = Double(index) * 0.15
      fraction = (fraction > 0.5 ? 0.5 : fraction)
      withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
        
        animationRange[index] = (String(value) as NSString).integerValue
      }
    }
  }
}

fileprivate struct RollingTextDemoView: View {
  @State private var number = 120
  
  var body: some View {
    VStack {
      RollingText(font: .system(size: 30), weight: .bold, value: $number)
        
      HStack {
        Button(action: {
          number += 1
        }, label: {
          Image(systemName: "plus")
            .padding()
        })
        .buttonStyle(.borderedProminent)
        
        Button(action: {
          number -= 1
        }, label: {
          Image(systemName: "minus")
            .padding()
        })
        .buttonStyle(.bordered)
      }
      .padding()
    }
  }
}

#Preview {
  RollingTextDemoView()
}
