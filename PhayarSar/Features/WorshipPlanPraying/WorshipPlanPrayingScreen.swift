//
//  WorshipPlanPrayingScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 09/03/2024.
//

import SwiftUI

struct WorshipPlanPrayingScreen: View {
  @Environment(\.safeAreaInsets) private var safeAreaInsets
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var prayingTimeRepo: DailyPrayingTimeRepository
  @Binding var worshipPlan: WorshipPlan
  
  @State private var currentPrayerId: String = ""
  
  @State private var currentIndex: Double = 0
  
  var body: some View {
    VStack(spacing: 0) {
      SafeAreaFillerView()

      CommonPrayerTabView()
      
      Rectangle()
        .fill(Color.cardBg)
        .overlay(alignment: .top) {
          CurrentPrayerTitleView()
        }
        .overlay {
          NextPreviousControlView()
        }
        .frame(height: 48 + safeAreaInsets.bottom)
    }
    .background(Color.cardBg)
    .ignoresSafeArea()
    .onAppear {
      currentPrayerId = worshipPlan.selectedPrayers.first?.id ?? ""
      prayingTimeRepo.startRecordingTime()
    }
    .onDisappear {
      prayingTimeRepo.stopRecordingTime()
    }
    .onChange(of: currentPrayerId) { id in
      currentIndex = Double(index(of: id))
    }
  }
  
  private func index(of currentPrayerId: String) -> Int {
    worshipPlan.selectedPrayers.firstIndex(where: { $0.id == currentPrayerId }) ?? 0
  }
  
  @ViewBuilder
  func SafeAreaFillerView() -> some View {
    Rectangle()
      .fill(Color.navBar)
      .frame(height: safeAreaInsets.top)
  }
  
  @ViewBuilder
  func SilverBorderView() -> some View {
    CustomCornerView(corners: [.bottomLeft, .bottomRight], radius: 30)
      .stroke(
        LinearGradient(
          colors: [
            .clear,
            .secondary.opacity(0.2),
            .secondary.opacity(0.2),
            .secondary.opacity(0.2)
          ],
          startPoint: .top,
          endPoint: .bottom
        ),
        lineWidth: 1.5
      )
  }
  
  @ViewBuilder
  func CommonPrayerTabView() -> some View {
    TabView(selection: $currentPrayerId) {
      ForEach(worshipPlan.selectedPrayers) { prayer in
        CommonPrayerScreen(model: prayer, worshipPlanName: worshipPlan.planName) {
          if let currentIndex = worshipPlan.selectedPrayers.firstIndex(of: prayer) {
            currentPrayerId = worshipPlan.selectedPrayers[currentIndex + 1].id
          }
        }
        .tag(prayer.id)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .animation(.default, value: currentPrayerId)
    .mask { CustomCornerView(corners: [.bottomLeft, .bottomRight], radius: 30) }
    .overlay { SilverBorderView() }
  }
  
  @ViewBuilder
  func CurrentPrayerTitleView() -> some View {
    VStack(spacing: 4) {
      if preferences.appLang == .Mm {
        LocalizedText(
          .x_of_y,
          args: [localizeNumber(preferences.appLang, str: "\(index(of: currentPrayerId) + 1)"), localizeNumber(preferences.appLang, str: "\(worshipPlan.selectedPrayers.count)")]
        )
        .foregroundColor(.secondary)
        .font(.qsB(12))
      } else {
        AnimateNumberText(
          font: .qsB(12),
          value: .init(get: { currentIndex + 1 }, set: { currentIndex = $0 }),
          textColor: .init(get: { .secondary }, set: { _ in }),
          stringFormatter: "%@ of \(worshipPlan.selectedPrayers.count)"
        )
      }
      
      Text(worshipPlan.selectedPrayers[index(of: currentPrayerId)].title)
        .font(.qsB(14))
        .foregroundColor(preferences.accentColor.color)
    }
    .padding(.top, 12)
  }
  
  @ViewBuilder
  func NextPreviousControlView() -> some View {
    HStack {
      PreviousPrayerControlView()
      Spacer()
      NextPrayerControlView()
    }
    .padding(.horizontal, 40)
  }
  
  @ViewBuilder
  func PreviousPrayerControlView() -> some View {
    Button {
      guard worshipPlan.selectedPrayers.first?.id != currentPrayerId else { return }
      let index = index(of: currentPrayerId)
      withAnimation {
        currentPrayerId = worshipPlan.selectedPrayers[index - 1].id
      }
    } label: {
      Image(systemName: "arrow.left")
        .font(.headline)
        .padding(8)
        .foregroundColor(preferences.accentColor.color)
        .background(
          Circle()
            .fill(.white)
        )
    }
  }
  
  @ViewBuilder
  func NextPrayerControlView() -> some View {
    Button {
      guard worshipPlan.selectedPrayers.last?.id != currentPrayerId else { return }
      let index = index(of: currentPrayerId)
      withAnimation {
        currentPrayerId = worshipPlan.selectedPrayers[index + 1].id
      }
    } label: {
      Image(systemName: "arrow.right")
        .font(.headline)
        .padding(8)
        .foregroundColor(preferences.accentColor.color)
        .background(
          Circle()
            .fill(.white)
        )
    }
  }
}

struct WorshipPlanPrayingScreenPreview: View {
  let plan: WorshipPlan!
  
  init() {
    let encoder = JSONEncoder()
    let plan = WorshipPlan(context: CoreDataStack.shared.viewContext)
    plan.planName = "Chloe's parying time"
    plan.selectedPrayerIds = try? encoder.encode(cantotkyo.map(\.id))
    plan.selectedDays = try? encoder.encode([DaysOfWeek.mon, .tue, .thu].map(\.rawValue))
    plan.hasPrayingTime = true
    plan.selectedTime = .init()
    plan.enableReminder = true
    plan.remindMeBefore = 5
    plan.lastUpdated = .init()
    self.plan = plan
  }
  
  var body: some View {
    WorshipPlanPrayingScreen(worshipPlan: .constant(plan))
      .previewEnvironment()
  }
}

#Preview {
  WorshipPlanPrayingScreenPreview()
}
