//
//  CommonPrayerVM.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 08/01/2024.
//

import SwiftUI
import CoreData

final class CommonPrayerVM<Model>: ObservableObject where Model: CommonPrayerProtocol {
  private let stack = CoreDataStack.shared
  
  @Published var config: PrayerConfiguration
  @Published var model: Model
  @Published var paragraphRefreshId = UUID().uuidString
  @Published var scrollToId: String?
  
  @Published private(set) var timer = Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()
  @Published private(set) var viewRefreshId = ""
  @Published private(set) var isPlaying = false
  @Published private(set) var isPaused = false
  @Published private(set) var progress: CGFloat = 0.0

  private var currentIndex = 0 {
    didSet {
      progress = CGFloat(currentIndex) / CGFloat(model.body.count)
      if progress == 1 {
        DispatchQueue.main.asyncAfter(deadline: .now() + model.body[model.body.count - 1].duration(config.scrollingSpeed)) { [weak self] in
          self?.resetPrayingState()
        }
      }
    }
  }
  private var startTime = Date().timeIntervalSince1970
  private var proxy: ScrollViewProxy?
  private var bgContext = CoreDataStack.shared.newContext
  
  init(model: Model) {
    let prayerId = model.id
    
    if let config = PrayerConfiguration.findBy(prayerId: prayerId) {
      self.config = config
    } else {
      let newObj = PrayerConfiguration.empty()
      newObj.prayerId = prayerId
      try? stack.persist(in: stack.viewContext)
      config = newObj
    }
    
    self.model = model
  }
  
  /// Core data helper to save config changes
  func saveThemeAndSettings() {
    do {
      try stack.persist(in: stack.viewContext)
    } catch {
      print(error)
    }
  }
  
  /// Force the SwiftUI layout to re-validate
  func reCalculate() {
    viewRefreshId = UUID().uuidString
  }
  
  
  func startPraying() {
    // Reset the start time
    startTime = Date().timeIntervalSince1970
    
    withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.4)) {
      isPlaying.toggle()
    }
  }
  
  func resetPrayingState() {
    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
      isPlaying = false
      isPaused = false
      currentIndex = 0
      proxy?.scrollTo(model.body[0].id)
      makeFirstParagraphVisibleIfNeeded()
    }
  }
  
  func pausePraying() {
    isPaused.toggle()
    isPlaying.toggle()
  }
  
  func scrollToNextParagraph(
    proxy: ScrollViewProxy,
    onScrollToEnd: (() -> Void)? = nil
  ) {
    if self.proxy == nil { self.proxy = proxy }
    guard isPlaying else { return }
    
    guard currentIndex < model.body.count else {
      onScrollToEnd?()
      return
    }
    
    let timeLapse = Date().timeIntervalSince1970 - startTime
    if timeLapse >= model.body[currentIndex].duration(config.scrollingSpeed) {
      defer {
        startTime = Date().timeIntervalSince1970
        currentIndex += currentIndex == 0 ? 2 : 1
        paragraphRefreshId = UUID().uuidString
      }
      
      withAnimation(.easeIn) {
        proxy.scrollTo(model.body[currentIndex == 0 ? currentIndex + 1 : currentIndex].id, anchor: .top)
      }
      
      for i in 0 ..< model.body.count {
        model.body[i].isBlur = i != (currentIndex == 0 ? currentIndex + 1 : currentIndex)
      }
    }
  }
  
  func scrollToSpecificParagraph(proxy: ScrollViewProxy) {
    currentIndex = model.body.firstIndex(where: { $0.id == scrollToId })!
    
    withAnimation(.easeIn) {
      proxy.scrollTo(scrollToId, anchor: .top)
    }
    
    for i in 0 ..< model.body.count {
      model.body[i].isBlur = i != currentIndex
    }
  }
  
  func makeFirstParagraphVisibleIfNeeded() {
    guard config.mode == PrayingMode.player.rawValue else { return }

    for i in 0 ..< model.body.count {
      model.body[i].isBlur = i != 0
    }
  }
}
