//
//  PrayerConfiguration.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/01/2024.
//

import Foundation
import CoreData

final class PrayerConfiguration: NSManagedObject {
  @NSManaged var prayerId: String
  @NSManaged var font: String
  @NSManaged var textSize: Int16
  @NSManaged var textAlignment: String
  @NSManaged var letterSpacing: Int16
  @NSManaged var lineSpacing: Int16
  @NSManaged var backgroundColor: String
  @NSManaged var scrollingSpeed: String
  @NSManaged var spotlightText: Bool
  @NSManaged var showPronunciation: Bool
  @NSManaged var tapToScrollEnable: Bool
  @NSManaged var mode: String
  
  override func awakeFromInsert() {
    super.awakeFromInsert()

    setPrimitiveValue(MyanmarFont.jasmine.rawValue, forKey: "font")
    setPrimitiveValue(Int16(28), forKey: "textSize")
    setPrimitiveValue(PrayerAlignment.left.rawValue, forKey: "textAlignment")
    setPrimitiveValue(Int16(2), forKey: "letterSpacing")
    setPrimitiveValue(Int16(15), forKey: "lineSpacing")
    setPrimitiveValue(PageColor.classic.rawValue, forKey: "backgroundColor")
    setPrimitiveValue(ScrollingSpeed.x1.rawValue, forKey: "scrollingSpeed")
    setPrimitiveValue(true, forKey: "showPronunciation")
    setPrimitiveValue(false, forKey: "spotlightText")
    setPrimitiveValue(false, forKey: "tapToScrollEnable")
    setPrimitiveValue(PrayingMode.reader.rawValue, forKey: "mode")
  }
  
}

extension PrayerConfiguration {
  static var prayerFetchRequest: NSFetchRequest<PrayerConfiguration> {
    NSFetchRequest(entityName: "PrayerConfiguration")
  }
  
  static func all() -> NSFetchRequest<PrayerConfiguration> {
      let request: NSFetchRequest<PrayerConfiguration> = prayerFetchRequest
      request.sortDescriptors = [
        NSSortDescriptor(keyPath: \PrayerConfiguration.prayerId, ascending: false)
      ]
      return request
  }
  
  static func findBy(prayerId: String, in context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> PrayerConfiguration? {
    let req = PrayerConfiguration.prayerFetchRequest
    req.predicate = NSPredicate(format: "prayerId = %@", prayerId)
    
    if let arr = try? context.fetch(req) {
      return arr.first
    }
    
    return nil
  }
  
  @discardableResult
  static func makePreview(count: Int, in context: NSManagedObjectContext) -> [PrayerConfiguration] {
    var configs = [PrayerConfiguration]()
    
    for i in 0 ..< count {
      let obj = PrayerConfiguration(context: context)
      obj.prayerId = "id\(i)"
      configs.append(obj)
    }
    
    return configs
  }
  
  static func preview(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> PrayerConfiguration {
      return makePreview(count: 1, in: context)[0]
  }
  
  static func empty(in context: NSManagedObjectContext = CoreDataStack.shared.viewContext) -> PrayerConfiguration {
    return PrayerConfiguration(context: context)
  }
}
