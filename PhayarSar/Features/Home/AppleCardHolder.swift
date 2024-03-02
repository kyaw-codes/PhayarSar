//
//  AppleCardHolder.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 04/02/2024.
//

import SwiftUI

struct AppleCardHolder: View {
  @State private var degrees = 40.0
  var body: some View {
    VStack(spacing: 100) {
      Text(text)
        .font(.largeTitle.weight(.semibold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
      
      HStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.tag20)
          .overlay(alignment: .bottom) {
            ZStack {
              CardHolderShape()
                .shadow(color: .black.opacity(0.3), radius: 10, x: -2, y: 0)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
                .frame(width: 90, height: 120)
                .padding(.bottom, 6)
              
              RoundedRectangle(cornerRadius: 12)
                .stroke(
                  LinearGradient(colors: [.clear, Color.black.opacity(0.1),  Color.black.opacity(0.2), Color.black.opacity(0.2), Color.black.opacity(0.2)], startPoint: .top, endPoint: .bottom),
                  style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .bevel, dash: [3], dashPhase: 2)
                )
                .frame(width: 88, height: 120)
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                  CustomCornerView(corners: [.bottomLeft, .bottomRight], radius: 12)
                    .stroke(
                      LinearGradient(colors: [
                        .clear, .black.opacity(0.1), .black.opacity(0.2), .black.opacity(0.2), .black.opacity(0.4)
                      ], startPoint: .top, endPoint: .bottom),
                      style: StrokeStyle(lineWidth: 4)
                    )
                    .frame(width: 85, height: 108)
                    .padding(.bottom, 10)
                    .blur(radius: 2)
                }
                .overlay(alignment: .trailing) {
                  CustomCornerView(corners: [.topRight, .bottomRight], radius: 12)
                    .fill(LinearGradient(colors: [.clear, Color.white.opacity(0.1), Color.white.opacity(0.2), Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottomLeading))
                    .frame(width: 10, height: 100)
                    .padding(.bottom, 10)
                    .padding(.trailing, 3)
                    .blur(radius: 5)
                }
                .overlay {
                  Image(systemName: "apple.logo")
                    .foregroundColor(Color.black)
                    .opacity(0.2)
                    .font(.title)
                    .offset(y: -8)
                }
            }
          }
      }
      .frame(width: 100, height: 140)
      .scaleEffect(3, anchor: .top)
      .rotation3DEffect(
        .degrees(degrees), axis: (x: 1.0, y: 0.0, z: 0.0),
        anchor: .bottom, anchorZ: 0, perspective: 0.4)
    }
    .offset(y: -200)
    .onAppear(perform: {
      withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 1).repeatForever(autoreverses: true)) {
        degrees = 0
      }
    })
  }
  
  var text: AttributedString {
    var attr = AttributedString(stringLiteral: "Card Holder")
    if let range = attr.range(of: "Holder") {
      attr[range].font = .largeTitle.bold()
      attr[range].foregroundColor = .tag20
    }
    return attr
  }
}

#Preview {
  AppleCardHolder()
}


struct CardHolderShape: View {
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.tag20)
        .mask {
          GeometryReader {
            let size = $0.size
            
            CardHolderLeftShape()
              .frame(width: size.width * 0.5 + 20)
            
            CardHolderLeftShape()
              .frame(width: size.width * 0.5)
              .rotation3DEffect( .degrees(-180), axis: (x: 0.0, y: 1.0, z: 0.0))
              .offset(x: size.width * 0.5)
          }
        }
        .clipShape(CustomCornerView(corners: [.bottomLeft, .bottomRight], radius: 10))
    }
  }
}

struct CardHolderLeftShape: Shape {
  func path(in rect: CGRect) -> Path {
    
    let p1 = Path { path in
      path.move(to: CGPoint(x: 0, y: 7))
      path.addCurve(to: .init(x: 12, y: 0), control1: .init(x: 8, y: 7), control2: .init(x: 7, y: 0))
      path.addLine(to: .init(x: rect.maxX - 12, y: 0))
      path.addLine(to: .init(x: rect.maxX, y: 0))
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
      path.addLine(to: .init(x: rect.minX, y: rect.maxY))
    }
    
    return p1
  }
}
