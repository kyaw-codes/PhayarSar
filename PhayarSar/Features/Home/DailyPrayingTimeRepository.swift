//
//  DailyPrayingTimeRepository.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/03/2024.
//

import SwiftUI
import CoreData

@MainActor
final class DailyPrayingTimeRepository: ObservableObject {
  @Published var prayingTimes: [DailyPrayingTime] = []
  @Published var today: DailyPrayingTime!
  
  private var timeInterval = Date().timeIntervalSince1970
  
  private let stack = CoreDataStack.shared
  private let calendar = Calendar.current
  private lazy var moc = stack.viewContext
  
  init() {
    do {
      try fetchPrayingTimes()
    } catch {
      print(error)
    }
  }
  
  func fetchPrayingTimes() throws {
    let request = DailyPrayingTime.timeFetchRequest
    prayingTimes = try moc.fetch(request)
    
    if let today = prayingTimes.first(where: { calendar.isDateInToday($0.date) }) {
      self.today = today
    } else {
      let today = DailyPrayingTime(context: moc)
      today.date = .init()
      today.durationInSeconds = 0
      try moc.save()
      self.today = today
    }
  }
  
  func startRecordingTime() {
    timeInterval = Date().timeIntervalSince1970
  }
  
  func stopRecordingTime() {
    today.durationInSeconds += Int64(Date().timeIntervalSince1970 - timeInterval)
    do {
      try moc.save()
      withAnimation {
        today = today
      }
    } catch {
      print(error)
    }
  }
}
