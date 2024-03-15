//
//  WorshipPlanCardView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/03/2024.
//

import SwiftUI

struct WorshipPlanCardView: View {
  let worshipPlan: WorshipPlan
  @EnvironmentObject private var preferences: UserPreferences
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .foregroundColor(.cardBg)
      
      VStack {
        HStack {
          HStack(spacing: 4) {
            Image(systemName: "alarm")
            if let selectedTime = worshipPlan.selectedTime, worshipPlan.hasPrayingTime {
              Text(localizeTime(preferences.appLang, str: selectedTime.toStringWith(.hmm_a)))
            } else {
              LocalizedText(.not_specified)
            }
          }
          .font(.qsSb(12))
          
          Spacer(minLength: 20)
          
          SelectedWorshipDaysView(selectedDaysEnum: worshipPlan.selectedDaysEnumForList.orElse([]))
        }
        
        HStack {
          Text(worshipPlan.planName)
            .font(.qsB(20))
            .padding(.top, -10)
          
          Spacer(minLength: 20)
        }
        .padding(.top, 20)
        
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Image(systemName: worshipPlan.enableReminder ? "bell.fill" : "bell.slash.fill")
            if worshipPlan.enableReminder {
              LocalizedText(.notify_x_mins_before, args: [localizeNumber(preferences.appLang, str: "\(worshipPlan.remindMeBefore)")])
            } else {
              LocalizedText(.disabled)
            }
          }
          .font(.qsB(12))
          
          HStack(spacing: 5) {
            Image(systemName: "book.closed.fill")
            LocalizedText(.x_prayers, args: [localizeNumber(preferences.appLang, str: "\(worshipPlan.selectedPrayers.count)")])
          }
          .font(.qsB(12))
          
          Spacer()

        }
        .foregroundColor(.secondary)
        .padding(.top, 10)
      }
      .padding()
    }

  }
}

//#Preview {
//    WorshipPlanCardView()
//}
