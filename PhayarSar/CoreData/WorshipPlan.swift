//
//  WorshipPlan.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import Foundation
import CoreData

final class WorshipPlan: NSManagedObject {
  @NSManaged var planName: String
  @NSManaged var selectedPrayerIds: Data?
  @NSManaged var selectedDays: Data?
  @NSManaged var hasPrayingTime: Bool
  @NSManaged var selectedTime: Date?
  @NSManaged var enableReminder: Bool
  @NSManaged var remindMeBefore: Int16
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    
    setPrimitiveValue(false, forKey: "enableReminder")
    setPrimitiveValue(false, forKey: "hasPrayingTime")
    setPrimitiveValue(Int16(3), forKey: "remindMeBefore")
    setPrimitiveValue(try? JSONEncoder().encode([DaysOfWeek.everyday.rawValue]), forKey: "selectedDays")
  }
}

extension WorshipPlan {
  static var planFetchRequest: NSFetchRequest<WorshipPlan> {
    NSFetchRequest(entityName: "WorshipPlan")
  }
  
  static func all() -> NSFetchRequest<WorshipPlan> {
    let request: NSFetchRequest<WorshipPlan> = planFetchRequest
    request.sortDescriptors = []
    return request
  }
}
