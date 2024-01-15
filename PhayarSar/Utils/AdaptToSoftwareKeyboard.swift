//
//  AdaptToSoftwareKeyboard.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/01/2024.
//

import SwiftUI
import Combine

fileprivate struct AdaptToSoftwareKeyboard: ViewModifier {
  @State private var currentHeight = CGFloat.zero
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, currentHeight)
      .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
      .onAppear(perform: subscribeToKeyboardEvents)
  }
  
  private func subscribeToKeyboardEvents() {
    NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
      .compactMap { notification in
        (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.height
      }
      .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    
    NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
      .compactMap { notification in
        CGFloat.zero
      }
      .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
  }
}

extension View {
  var keyboardAware: some View {
    self.modifier(AdaptToSoftwareKeyboard())
  }
}

struct KeyboardAwareView: View {
  @State private var firstName = ""
  @State private var lastName = ""
  @State private var phoneNo = ""
  @State private var email = ""
  @State private var address = ""
  
  var body: some View {
    ScrollView {
      Circle()
        .fill(.accent)
        .frame(width: 120)
      
      Text("KeyboardAwareDemo")
        .font(.qsB(28))
        .padding(.top)
      
      VStack(spacing: 14) {
        CustomTextField("First name", text: $firstName)
        CustomTextField("Last name", text: $lastName)
        CustomTextField("Phone number", text: $phoneNo)
        CustomTextField("Email", text: $email)
        CustomTextField("Address", text: $address)
      }
      .padding([.top, .horizontal])
      
      Button {
        
      } label: {
        RoundedRectangle(cornerRadius: 12)
          .fill(.accent)
          .frame(height: 56)
          .overlay {
            Text("Done")
              .font(.headline)
              .foregroundStyle(.white)
          }
          .padding(.horizontal)
      }
      .padding(.top, 30)
    }
    .keyboardAware
  }
  
  @ViewBuilder
  private func CustomTextField(_ placeholder: String, text: Binding<String>) -> some View {
    VStack {
      RoundedRectangle(cornerRadius: 12)
        .stroke(.accent, lineWidth: 1)
        .frame(height: 54)
        .overlay {
          TextField(placeholder, text: text)
            .padding(.horizontal)
        }
    }
  }
}

#Preview {
  KeyboardAwareView()
}
