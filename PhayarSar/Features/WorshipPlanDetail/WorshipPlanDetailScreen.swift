//
//  WorshipPlanDetailScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 09/03/2024.
//

import SwiftUI

struct WorshipPlanDetailScreen: View {
  @Binding var plan: WorshipPlan
  @EnvironmentObject var worshipPlanRepo: WorshipPlanRepository
  @EnvironmentObject private var preferences: UserPreferences
  @State private var showWorshipPlanScreen = false
  @State private var showWorshipPlanPrayingScreen = false
  @State private var showDeleteConfirmation = false
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 32) {
        Section(title: .plan_name) {
          Text(plan.planName)
            .font(.qsB(24))
            .padding(.top, 2)
        }
        
        Section(title: .prayers_x, args: [localizeNumber(preferences.appLang, str: "\(plan.selectedPrayers.count)")]) {
          VStack(spacing: 8) {
            ForEach(plan.selectedPrayers) { model in
              PrayerListCell(
                model: model,
                systemImage: "checkmark.circle.fill",
                hideSeparator: plan.selectedPrayers.last?.id == model.id
              )
            }
          }
          .padding()
          .padding(.vertical, 2)
          .background {
            RoundedRectangle(cornerRadius: 20)
              .fill(.thinMaterial)
          }
        }
        
        Section(title: .selected_days) {
          SelectedWorshipDaysView(selectedDaysEnum: plan.selectedDaysEnumForList.orElse([]), fontSize: 12)
        }
        
        HStack {
          Section(title: .time) {
            HStack(spacing: 4) {
              Image(systemName: "alarm")
              if let selectedTime = plan.selectedTime, plan.hasPrayingTime {
                Text(localizeTime(preferences.appLang, str: selectedTime.toStringWith(.hmm_a)))
              } else {
                LocalizedText(.not_specified)
              }
              
              Spacer(minLength: 20)
            }
            .font(.qsSb(16))
            .padding(.top, 2)
          }
          
          Divider()
            .padding(.leading, -20)
          
          Section(title: .remind_me_before) {
            HStack {
              Image(systemName: plan.enableReminder ? "bell.fill" : "bell.slash.fill")
              if plan.enableReminder {
                LocalizedText(.x_min_s, args: [localizeNumber(preferences.appLang, str: "\(plan.remindMeBefore)")])
              } else {
                LocalizedText(.disabled)
              }
              
              Spacer()
            }
            .font(.qsB(16))
            .padding(.top, 2)
          }
          .offset(x: -20)
          .padding(.leading)
          
        }
        
        VStack {
          Button {
            showWorshipPlanScreen.toggle()
          } label: {
            HStack {
              Image(systemName: "square.and.pencil")
                .font(.body.bold())
              LocalizedText(.edit)
                .font(.qsSb(18))
              Spacer()
            }
            .foregroundColor(preferences.accentColor.color)
            .padding()
            .background {
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBg)
            }
          }
          
          Button {
            showDeleteConfirmation.toggle()
          } label: {
            HStack {
              Image(systemName: "trash")
                .font(.body.bold())
              
              LocalizedText(.delete)
                .font(.qsSb(18))
              Spacer()
            }
            .foregroundColor(.red)
            .padding()
            .background {
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBg)
            }
          }
        }
        .padding(.top, 20)
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .navigationTitle(.plan_detail)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      BtnPray()
    }
    .alert(.delete_confirmation, isPresented: $showDeleteConfirmation) {
      Button(LocalizedKey.cancel.localize(preferences.appLang).orElse("Cancel"), role: .cancel) { }
      Button(LocalizedKey.delete.localize(preferences.appLang).orElse("Delete"), role: .destructive) {
        HapticKit.selection.generate()
        worshipPlanRepo.delete(plan)
      }
    }
    .fullScreenCover(isPresented: $showWorshipPlanPrayingScreen) {
      WorshipPlanPrayingScreen(worshipPlan: $plan)
    }
    .fullScreenCover(isPresented: $showWorshipPlanScreen) {
      WorshipPlanScreen(
        worshipPlan: .init(
          get: { .some(plan) },
          set: { if let p = $0 { plan = p } }
        )
      )
    }
//    .overlay {
//      Rectangle()
//        .opacity(0.8)
//        .ignoresSafeArea()
//        .overlay(alignment: .top) {
//          HStack {
//            Spacer(minLength: 20)
//            Text("Tap here to start praying")
//              .font(.qsB(20))
//              .padding(.top, 60)
//              .padding(.trailing, 20)
//            Image("arrow")
//              .renderingMode(.template)
//              .resizable()
//              .aspectRatio(contentMode: .fit)
//              .rotationEffect(.degrees(-130))
//              .frame(height: 60)
//              .padding(.trailing, 80)
//          }
//          .foregroundColor(.white)
//        }
//    }
  }
  
  @ViewBuilder
  private func BtnPray() -> some View {
    Button {
      showWorshipPlanPrayingScreen.toggle()
    } label: {
      HStack(spacing: 5) {
        Image(.pray)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20)
        
        LocalizedText(.btn_pray)
          .foregroundColor(.white)
      }
      .font(.dmSerif(14))
      .padding(.horizontal, 10)
      .padding(.vertical, 8)
      .background(Capsule().fill(preferences.accentColor.color))
    }
  }
  
  @ViewBuilder
  private func Section<V: View>(title: LocalizedKey, args: [String] = [], @ViewBuilder body: () -> V) -> some View {
    VStack(alignment: .leading) {
      LocalizedText(title, args: args)
        .font(.qsSb(16))
        .foregroundColor(.secondary)
      body()
    }
  }
  
  @ViewBuilder
  private func PrayerListCell(
    model: NatPintVO,
    systemImage: String,
    hideSeparator: Bool = false
  ) -> some View {
    NavigationLink {
      CommonPrayerScreen(model: model)
    } label: {
      VStack {
        HStack {
          Image(systemName: systemImage)
            .font(.system(size: 14))
          Text(model.title)
            .font(.system(size: 14))
            .fontWeight(.semibold)
          
          Spacer()
          Image(systemName: "chevron.right")
            .font(.footnote)
        }
        
        if !hideSeparator {
          Rectangle()
            .frame(height: 1)
            .opacity(0.1)
            .padding(.leading, 28)
            .padding(.vertical, 4)
        }
      }
      .padding(.vertical, 8)
      .tint(Color.primary)
    }
  }
}

fileprivate struct WorshipPlanDetailScreenPreview: View {
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
    NavigationView {
      WorshipPlanDetailScreen(plan: .constant(plan), worshipPlanRepo: .init())
    }
    .previewEnvironment()
  }
}

#Preview {
  WorshipPlanDetailScreenPreview()
}
