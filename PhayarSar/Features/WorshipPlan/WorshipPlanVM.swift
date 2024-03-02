//
//  WorshipPlanVM.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/03/2024.
//

import SwiftUI
import CoreData

final class WorshipPlanVM: ObservableObject {
  
  @Published var newPlan: WorshipPlan?
  
  private let stack = CoreDataStack.shared
  private lazy var newContext = stack.newContext

  func addNewPlan() {
    newPlan = WorshipPlan(context: newContext)
  }
  
  func cancel() {
    if let newPlan {
      do {
        try stack.delete(newPlan, in: newContext)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func saveToDb() {
    do {
      try stack.persist(in: newContext)
    } catch {
      print(error.localizedDescription)
    }
  }
}
