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
  @NSManaged var lastUpdated: Date
  
  var selectedDaysEnum: [DaysOfWeek]? {
    guard let selectedDays else { return nil }
    let decoder = JSONDecoder()
    let arr = try? decoder.decode([String].self, from: selectedDays)
    let daysOfWeek = arr?.compactMap(DaysOfWeek.init(rawValue:))
    return daysOfWeek.orElse([])
  }
  
  var selectedDaysEnumForList: [DaysOfWeek]? {
    guard let selectedDays else { return nil }
    let decoder = JSONDecoder()
    let arr = try? decoder.decode([String].self, from: selectedDays)
    let daysOfWeek = arr?.compactMap(DaysOfWeek.init(rawValue:))
    return daysOfWeek.orElse([]).contains(.everyday) ? DaysOfWeek.allCases : daysOfWeek
  }
  
  var selectedPrayers: [NatPintVO] {
    guard let selectedPrayerIds else { return [] }
    let decoder = JSONDecoder()
    let arr = try? decoder.decode([String].self, from: selectedPrayerIds)
    
    return allPrayers.filter { prayer in arr.orElse([]).contains(prayer.id) }
  }
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    
    setPrimitiveValue(false, forKey: "enableReminder")
    setPrimitiveValue(false, forKey: "hasPrayingTime")
    setPrimitiveValue(Int16(3), forKey: "remindMeBefore")
    setPrimitiveValue(Date(), forKey: "lastUpdated")
    setPrimitiveValue(try? JSONEncoder().encode([DaysOfWeek.everyday.rawValue]), forKey: "selectedDays")
  }
}

extension WorshipPlan {
  static var planFetchRequest: NSFetchRequest<WorshipPlan> {
    NSFetchRequest(entityName: "WorshipPlan")
  }
  
  static func latest() -> NSFetchRequest<WorshipPlan> {
    let request: NSFetchRequest<WorshipPlan> = planFetchRequest
    request.sortDescriptors = [
      .init(keyPath: \WorshipPlan.lastUpdated, ascending: false),
    ]
    return request
  }
  
  static func `default`() -> NSFetchRequest<WorshipPlan> {
    let request: NSFetchRequest<WorshipPlan> = planFetchRequest
    request.sortDescriptors = []
    return request
  }
  
  @discardableResult
  static func makePreview(count: Int, in context: NSManagedObjectContext) -> [WorshipPlan] {
    var configs = [WorshipPlan]()
    
    for i in 0 ..< count {
      let obj = WorshipPlan(context: context)
      obj.planName = "Plan \(i + 1)"
      obj.lastUpdated = .init()
      configs.append(obj)
    }
    
    return configs
  }
  
  static func preview(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> WorshipPlan {
      return makePreview(count: 1, in: context)[0]
  }
  
  static func empty(in context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> WorshipPlan {
    return WorshipPlan(context: context)
  }
}

extension WorshipPlan: Identifiable {
  var id: NSManagedObjectID { self.objectID }
}
