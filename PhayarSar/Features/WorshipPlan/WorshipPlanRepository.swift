//
//  WorshipPlanRepository.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 02/03/2024.
//

import SwiftUI
import CoreData
import UserNotifications

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
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: plan.reminderIdStrings)
    
    do {
      try stack.delete(plan, in: context)
      fetchAllPlan()
    } catch {
      print("Failed to delete plan: \(error)")
    }
  }
}
