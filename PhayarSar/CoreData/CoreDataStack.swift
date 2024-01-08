//
//  CoreDataStack.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/01/2024.
//

import SwiftUI
import CoreData

final class CoreDataStack {
  static let shared = CoreDataStack()
  
  private let persistentContainer: NSPersistentContainer
  
  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  var newContext: NSManagedObjectContext {
    persistentContainer.newBackgroundContext()
  }
  
  private init() {
    persistentContainer = NSPersistentContainer(name: "PhayarSar")
    if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
      persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
    }
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    persistentContainer.loadPersistentStores { _, error in
      if let error {
        fatalError("Failed to load persistent store: \(error)")
      }
    }
  }
  
  func exisits<T: NSManagedObject>(_ object: T, in context: NSManagedObjectContext) -> T? {
    try? context.existingObject(with: object.objectID) as? T
  }
  
  func delete(_ object: some NSManagedObject, in context: NSManagedObjectContext) throws {
    if let existingObject = exisits(object, in: context) {
      context.delete(existingObject)
      Task(priority: .background) {
        try await context.perform {
          try context.save()
        }
      }
    }
  }
  
  func persist(in context: NSManagedObjectContext) throws {
    if context.hasChanges {
      try context.save()
    }
  }
}

extension EnvironmentValues {
  static var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }
}

extension Thread {
  var isRunningXCTest: Bool {
    for key in self.threadDictionary.allKeys {
      guard let keyAsString = key as? String else {
        continue
      }
      
      if keyAsString.split(separator: ".").contains("xctest") {
        return true
      }
    }
    return false
  }
}
