//
//  WorshipPlan.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/02/2024.
//

import Foundation
import CoreData

final class WorshipPlan: NSManagedObject {
  @NSManaged var enableReminder: Bool
  @NSManaged var hasPrayingTime: Bool
  @NSManaged var planName: String
  @NSManaged var remindMeBefore: Int16
  @NSManaged var selectedDays: Data?
  @NSManaged var selectedPrayerIds: Data?
  @NSManaged var selectedTime: Date?
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    
    setPrimitiveValue(false, forKey: "enableReminder")
    setPrimitiveValue(false, forKey: "hasPrayingTime")
    setPrimitiveValue(Int16(3), forKey: "remindMeBefore")
    setPrimitiveValue(try? JSONEncoder().encode([DaysOfWeek.everyday.rawValue]), forKey: "selectedDays")
  }
}
