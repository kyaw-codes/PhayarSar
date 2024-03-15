//
//  DailyPrayingTime.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/03/2024.
//

import Foundation
import CoreData

final class DailyPrayingTime: NSManagedObject {
  @NSManaged var date: Date
  @NSManaged var durationInSeconds: Int64
}

extension DailyPrayingTime {
  static var timeFetchRequest: NSFetchRequest<DailyPrayingTime> {
    NSFetchRequest(entityName: "DailyPrayingTime")
  }
  
  static func today() -> NSFetchRequest<DailyPrayingTime> {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    let request: NSFetchRequest<DailyPrayingTime> = timeFetchRequest
    request.predicate = .init(
      format: "date >= %@ AND date <= %@",
      today as NSDate,
      calendar.date(byAdding: .day, value: 1, to: today)! as NSDate
    )
    return request
  }
  
  static func preview(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> DailyPrayingTime {
    let obj = DailyPrayingTime(context: context)
    obj.date = .init()
    obj.durationInSeconds = 120
    return obj
  }
}
