//
//  WorshipPlanVM.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/03/2024.
//

import SwiftUI
import CoreData

@MainActor
final class WorshipPlanRepository: ObservableObject {
  @Published var latestPlans: [WorshipPlan] = []
  
  private let stack = CoreDataStack.shared
  private lazy var moc = stack.viewContext
  
  init() {
    fetchAllPlan()
  }
  
  func fetchAllPlan() {
    let request = WorshipPlan.latest()
    do {
      latestPlans = try moc.fetch(request)
    } catch {
      print("Failed to fetch worship plans: \(error)")
    }
  }
  
  func savePlan(_ plan: WorshipPlan) {
    let context = plan.managedObjectContext ?? moc
    do {
      try stack.persist(in: context)
      fetchAllPlan()
    } catch {
      print("Failed to save plan: \(error)")
    }
  }
  
  func delete(_ plan: WorshipPlan) {
    let context = plan.managedObjectContext ?? moc
    
    do {
      try stack.delete(plan, in: context)
      fetchAllPlan()
    } catch {
      print("Failed to delete plan: \(error)")
    }
  }
}

/*
final class WorshipPlanVM: ObservableObject {
  
  @Published var newPlan: WorshipPlan?
  
  private let stack = CoreDataStack.shared
  private lazy var newContext = stack.viewContext
  
  func addNewPlan() {
    newPlan = WorshipPlan(context: newContext)
  }
  
  func editPlan(_ plan: WorshipPlan) {
    newPlan = plan
  }
  
  func update() {
    if let context = newPlan?.managedObjectContext {
      do {
        try CoreDataStack.shared.persist(in: context)
      } catch {
        print(error.localizedDescription)
      }
    }
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
  
  func delete(_ object: WorshipPlan) {
    do {
      try stack.delete(object, in: newContext)
    } catch {
      print(error.localizedDescription)
    }
  }
}
*/
