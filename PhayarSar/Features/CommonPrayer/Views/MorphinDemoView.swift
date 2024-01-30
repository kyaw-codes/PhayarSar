//
//  MorphinDemoView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 30/01/2024.
//

import SwiftUI

struct MorphinDemoView: View {
  @State private var currentImage = CustomShape.cloud
  @State private var pickerImage = CustomShape.cloud
  @State private var turnOffImageMorph = false
  @State private var blurRadius = CGFloat.zero
  @State private var animateMorph = false
  
  @State private var playPause = "play.fill"
  
  var body: some View {
    VStack {
      GeometryReader { proxy in
        let size = proxy.size
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
          .clipped()
          .overlay {
            Rectangle()
              .fill(.white)
              .opacity(turnOffImageMorph ? 1 : 0)
          }
          .mask {
            Canvas { context, size in
              context.addFilter(.alphaThreshold(min: 0.3))
              context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
              
              if let resolvedImage = context.resolveSymbol(id: 1) {
                context.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2), anchor: .center)
              }
            } symbols: {
              ResolvedImage(currentImage: $currentImage)
                .tag(1)
            }
            .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect(), perform: { _ in
              if animateMorph {
                if blurRadius <= 40 {
                  blurRadius += 0.5
                  
                  if blurRadius.rounded() == 20 {
                    currentImage = pickerImage
                  }
                }
                
                if blurRadius.rounded() == 40 {
                  animateMorph = false
                  blurRadius = 0
                }
              }
            })
          }
      }
      .frame(height: 400)
      
      Picker("", selection: $pickerImage) {
        ForEach(CustomShape.allCases, id: \.rawValue) { shape in
          Image(systemName: shape.rawValue)
            .tag(shape)
        }
      }
      .pickerStyle(.segmented)
      .padding(15)
      .padding(.top, -50)
      .onChange(of: pickerImage) { value in
        animateMorph = true
      }
      
      Toggle("Turn off image morph", isOn: $turnOffImageMorph)
        .padding(.horizontal, 15)
        .padding(.top, 10)
      
      Slider(value: $blurRadius, in:  0 ... 40)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .offset(y: -50)
  }
}

struct ResolvedImage: View {
  @Binding var currentImage: CustomShape
  
  var body: some View {
    Image(systemName: currentImage.rawValue)
      .font(.system(size: 200))
      .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
      .frame(width: 300, height: 300)
  }
}

enum CustomShape: String, CaseIterable {
  case cloud = "cloud.rain.fill"
  case bubble = "bubble.left.and.bubble.right.fill"
  case map = "map.fill"
  case square_1 = "square.fill.on.square.fill"
  case bell = "bell.and.waves.left.and.right.fill"
  case square = "square.fill.on.circle.fill"
}

#Preview {
  MorphinDemoView()
    .preferredColorScheme(.dark)
}
