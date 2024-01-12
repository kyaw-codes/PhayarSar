//
//  CommonPrayerVM.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 08/01/2024.
//

import SwiftUI
import CoreData

final class CommonPrayerVM: ObservableObject {
  private let stack = CoreDataStack.shared
  
  @Published var config: PrayerConfiguration
  @Published var viewRefreshId = ""
  
  init(prayerId: String) {
    if let config = PrayerConfiguration.findBy(prayerId: prayerId) {
      self.config = config
    } else {
      let newObj = PrayerConfiguration.empty()
      newObj.prayerId = prayerId
      try? stack.persist(in: stack.viewContext)
      config = newObj
    }
  }
  
  func save() {
    do {
      try stack.persist(in: stack.viewContext)
    } catch {
      print(error)
    }
  }
  
  func reCalculate() {
    viewRefreshId = UUID().uuidString
  }
}
