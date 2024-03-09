//
//  WorshipPlanListScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/03/2024.
//

import SwiftUI
import SwipeActions
import AlertToast
import Combine

struct WorshipPlanListScreen: View {
  
  @ObservedObject var worshipPlanRepo: WorshipPlanRepository
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var preferences: UserPreferences
  
  @State private var showWorshipPlanScreen = false
  @State private var worshipPlanToEdit: WorshipPlan?
  
  @State private var showDeletedToast = false
  @State private var refreshList = UUID()
  @State private var closeSwipeAction = PassthroughSubject<Void, Never>()
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 20) {
        ForEach($worshipPlanRepo.latestPlans, id: \.objectID) { $plan in
          NavigationLink {
            WorshipPlanDetailScreen(plan: $plan, worshipPlanRepo: worshipPlanRepo)
          } label: {
            SwipeView {
              WorshipPlanCardView(worshipPlan: plan)
            } trailingActions: { context in
              TrailingActions(plan: plan, context: context)
            }
            .swipeActionsStyle(.mask)
          }

        }
      }
      .padding()
    }
    .id(refreshList)
    .navigationTitle(.all_worship_plans)
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) {
      AddNewWorshipButton()
    }
    .toast(isPresenting: $showDeletedToast) {
      DeletedSuccessfullyToast()
    }
    .fullScreenCover(isPresented: $showWorshipPlanScreen) {
      WorshipPlanScreen(worshipPlanRepo: worshipPlanRepo, worshipPlan: .constant(nil))
    }
    .fullScreenCover(
      item: $worshipPlanToEdit,
      onDismiss: {
        closeSwipeAction.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          refreshList = .init()
        }
      }
    ) { _ in
      WorshipPlanScreen(worshipPlanRepo: worshipPlanRepo, worshipPlan: $worshipPlanToEdit)
    }
  }
}

// MARK: - sub views
extension WorshipPlanListScreen {
  @ViewBuilder
  private func DeletedSuccessfullyToast() -> AlertToast {
    AlertToast(
      displayMode: .banner(.pop),
      type: .systemImage("checkmark.circle.fill", .white),
      title: LocalizedKey.plan_deleted_successfully.localize(preferences.appLang),
      style: .style(backgroundColor: .green, titleColor: .white, subTitleColor: .white, titleFont: .qsSb(16), subTitleFont: nil)
    )
  }
  
  @ViewBuilder
  private func AddNewWorshipButton() -> some View {
    Button {
      showWorshipPlanScreen.toggle()
    } label: {
      HStack {
        Image(systemName: "plus.circle.fill")
          .font(.title)
        LocalizedText(.new_worship_plan)
        Spacer()
      }
      .font(.qsB(18))
    }
    .foregroundColor(preferences.accentColor.color)
    .padding()
    .background {
      Rectangle()
        .fill(.regularMaterial)
        .edgesIgnoringSafeArea(.bottom)
    }
  }
  
  @ViewBuilder
  private func TrailingActions(plan: WorshipPlan, context: SwipeContext) -> some View {
    SwipeAction {
      worshipPlanToEdit = plan
    } label: { context in
      VStack(spacing: 15) {
        Image(systemName: "square.and.pencil")
        LocalizedText(.edit)
      }
      .font(.qsB(18))
      .foregroundColor(.white)
    } background: { _ in
      Color.orange
    }
    .onReceive(closeSwipeAction) { _ in
      context.state.wrappedValue = .closed
    }
    
    SwipeAction {
      var planToDelete: WorshipPlan?
      withAnimation {
        planToDelete = plan
        worshipPlanRepo.latestPlans.removeAll(where: { $0 == plan })
      }
      delay(0.3) {
        if let planToDelete {
          worshipPlanRepo.delete(planToDelete)
        }
      }
      HapticKit.selection.generate()
      showDeletedToast.toggle()
    } label: { _ in
      VStack(spacing: 15) {
        Image(systemName: "trash.fill")
        LocalizedText(.delete)
      }
      .font(.qsB(18))
      .foregroundColor(.white)
    } background: { _ in
      Color.red
    }
    .allowSwipeToTrigger()
  }
  
  @ViewBuilder
  private func NoResultFoundView() -> some View {
    VStack(spacing: 8) {
      Image(.empty)
        .renderingMode(.template)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100)
        .foregroundColor(Color(uiColor: .label))
        .background(alignment: .topLeading) {
          RoundedRectangle(cornerRadius: 12)
            .fill(preferences.accentColor.color.opacity(colorScheme == .dark ? 0.6 : 0.2))
            .frame(width: 80, height: 68)
            .padding(.leading, 20)
            .padding(.top, 28)
        }
      
      Text("No plan found")
        .font(.qsB(26))
        .padding(.top)
      
      LocalizedText(.worship_plan_helps_you_pray)
        .font(.qsSb(16))
        .padding(.top, 4)
      
      Button {
        showWorshipPlanScreen.toggle()
      } label: {
        HStack {
          LocalizedText(.add_new)
            .font(.qsB(16))
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .foregroundColor(preferences.accentColor.color)
        .background {
          RoundedRectangle(cornerRadius: 12)
            .stroke(preferences.accentColor.color, lineWidth: 2)
        }
      }
      .padding(.top)
    }
    .multilineTextAlignment(.center)
    .padding(.horizontal, 40)
  }
}

#Preview {
  WorshipPlanListScreen(worshipPlanRepo: WorshipPlanRepository())
    .previewEnvironment()
}
