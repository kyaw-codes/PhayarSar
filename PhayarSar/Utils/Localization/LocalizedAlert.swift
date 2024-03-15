//
//  LocalizedAlert.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/03/2024.
//

import SwiftUI

extension View {
  func alert<A, T>(
    _ titleKey: LocalizedKey,
    args: [String] = [],
    defaultValue: String = "",
    isPresented: Binding<Bool>,
    presenting data: T? = nil,
    @ViewBuilder actions: @escaping () -> A
  ) -> some View where A : View {
    self.modifier(
      LocalizedAlertModifire(
        titleKey: titleKey,
        args: args,
        defaultValue: defaultValue,
        isPresented: isPresented,
        data: data,
        actions: actions
      )
    )
  }
  
  func alert<A>(
    _ titleKey: LocalizedKey,
    args: [String] = [],
    defaultValue: String = "",
    isPresented: Binding<Bool>,
    @ViewBuilder actions: @escaping () -> A
  ) -> some View where A : View {
    self.modifier(
      LocalizedAlertModifireTwo(
        titleKey: titleKey,
        args: args,
        defaultValue: defaultValue,
        isPresented: isPresented,
        actions: actions
      )
    )
  }
}


fileprivate struct LocalizedAlertModifireTwo<A: View>: ViewModifier {
  @EnvironmentObject private var preferences: UserPreferences
  let titleKey: LocalizedKey
  let args: [String]
  let defaultValue: String
  let isPresented: Binding<Bool>
  let actions: () -> A
  
  init(
    titleKey: LocalizedKey,
    args: [String] = [],
    defaultValue: String = "",
    isPresented: Binding<Bool>,
    @ViewBuilder actions: @escaping () -> A
  ) {
    self.titleKey = titleKey
    self.args = args
    self.defaultValue = defaultValue
    self.isPresented = isPresented
    self.actions = actions
  }
  
  func body(content: Content) -> some View {
    content
      .alert(
        titleKey.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultValue),
        isPresented: isPresented,
        actions: actions
      )
  }
}

fileprivate struct LocalizedAlertModifire<A: View, T>: ViewModifier {
  @EnvironmentObject private var preferences: UserPreferences
  let titleKey: LocalizedKey
  let args: [String]
  let defaultValue: String
  let isPresented: Binding<Bool>
  let data: T?
  let actions: () -> A
  
  init(
    titleKey: LocalizedKey,
    args: [String] = [],
    defaultValue: String = "",
    isPresented: Binding<Bool>,
    data: T?,
    @ViewBuilder actions: @escaping () -> A
  ) {
    self.titleKey = titleKey
    self.args = args
    self.defaultValue = defaultValue
    self.isPresented = isPresented
    self.data = data
    self.actions = actions
  }
  
  func body(content: Content) -> some View {
    content
      .alert(
        titleKey.localize(preferences.appLang, args: args).ifNilOrEmpty(defaultValue),
        isPresented: isPresented,
        actions: actions
      )
  }
}
