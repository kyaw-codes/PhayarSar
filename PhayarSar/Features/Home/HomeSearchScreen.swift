//
//  HomeSearchScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/03/2024.
//

import SwiftUI

struct HomeSearchScreen: View {
  @Environment(\.safeAreaInsets) private var safeAreaInsets
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var planRepo: WorshipPlanRepository
  @Binding var showSearchView: Bool
  @Binding var showTabBar: Bool
  @State private var searchText = ""
  @FocusState private var focusedName: String?
  
  @State private var prayers = [PhayarSarModel]()
  @State private var allPlans = [WorshipPlan]()
  @State private var plans = [WorshipPlan]()
  
  var animation: Namespace.ID
  
  var body: some View {
    ZStack {
      
      VStack(spacing: 30) {
        if #available(iOS 16.0, *) {
          Rectangle()
            .fill(preferences.accentColor.color.gradient)
            .frame(height: UIScreen.main.bounds.height * 0.15)
            .padding(.top, UIScreen.main.bounds.height * 0.1)
        } else {
          Rectangle()
            .fill(preferences.accentColor.color)
            .frame(height: UIScreen.main.bounds.height * 0.15)
            .padding(.top, UIScreen.main.bounds.height * 0.1)
        }
        
        Spacer(minLength: 0)
      }
      .padding()

      Rectangle()
        .fill(.regularMaterial)
        .ignoresSafeArea()
      
      VStack(spacing: 30) {
        SearchNavView()
        SearchField()
        
        DismissableScrollView {
          
          LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
            
            Section {
              LazyVStack(spacing: 12) {
                ForEach(prayers) { prayer in
                  NavigationLink {
                    CommonPrayerScreen(model: prayer)
                  } label: {
                    PrayerCardView(prayer: prayer)
                  }
                }
              }
              .padding(.vertical)
            } header: {
              SearchResultHeaderView(.prayers, results: prayers.count)
            }

            Section {
              LazyVStack(spacing: 20) {
                ForEach($plans, id: \.objectID) { $plan in
                  NavigationLink {
                    WorshipPlanDetailScreen(plan: $plan)
                  } label: {
                    WorshipPlanCardView(worshipPlan: plan)
                  }
                }
              }
              .padding(.top)
            } header: {
              SearchResultHeaderView(.plans, results: plans.count)
            }
            
          }
          .padding(.bottom, safeAreaInsets.bottom)
        }
      }
      .padding()
    }
    .onChange(of: searchText) { searchWord in
      guard !searchWord.isEmpty else {
        prayers = []
        plans = []
        return
      }
      
      let filteredPrayers = allPrayers
        .filter { prayer in
          prayer.title.contains(searchWord) ||
          prayer.body.map { $0.content.contains(searchWord) || $0.pronunciation.contains(searchWord) }.reduce(false, { $0 || $1 })
        }
      let filteredPlans = allPlans.filter { $0.planName.lowercased().contains(searchWord.lowercased()) }
      withAnimation(.smooth) {
        prayers = filteredPrayers
        plans = filteredPlans
      }
      
    }
    .edgesIgnoringSafeArea(.bottom)
    .onAppear {
      delay(0.5) {
        focusedName = "search"
      }
      
      planRepo.fetchAllPlan()
      allPlans = planRepo.latestPlans
    }
  }
  
  @ViewBuilder
  private func PrayerCardView(prayer: PhayarSarModel) -> some View {
    HStack(spacing: 6) {
      Image(systemName: "hands.and.sparkles.fill")
        .foregroundColor(.primary)
      
      Text(prayer.title)
        .font(.footnote.bold())
        .foregroundColor(.primary)
        .padding(.vertical, 16)
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundColor(preferences.accentColor.color)
        .padding(.trailing)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(.cardBg)
        .overlay {
          RoundedRectangle(cornerRadius: 12)
            .stroke(preferences.accentColor.color, lineWidth: 0.5)
        }
    )
    .padding(.horizontal, 1)
  }
  
  @ViewBuilder
  private func SearchResultHeaderView(_ title: LocalizedKey, results: Int) -> some View {
    VStack(alignment: .leading) {
      Divider()
      HStack {
        LocalizedText(title)
        Spacer()
        LocalizedText(.x_found, args: [localizeNumber(preferences.appLang, str: "\(results)")])
      }
      .font(.qsB(14))
      Divider()
    }
    .padding(.horizontal, 4)
    .background(.cardBg)
  }
  
  @ViewBuilder
  private func SearchField() -> some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(preferences.accentColor.color)
        .padding(.leading)
        .matchedGeometryEffect(id: "search_icon", in: animation)
      
      TextField("", text: $searchText)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .focused($focusedName, equals: "search")
        .font(.qsSb(16))
        .tint(preferences.accentColor.color)
        .overlay(alignment: .leading) {
          if searchText.isEmpty {
            LocalizedText(.search_placeholder)
              .font(.qsSb(16))
              .foregroundColor(preferences.accentColor.color.opacity(0.4))
          }
        }
      
      ClearTextBtn()
    }
    .onTapGesture {
      focusedName = "search"
    }
    .background {
      Capsule()
        .fill(preferences.accentColor.color.opacity(0.2))
        .frame(height: 48)
        .overlay {
          Capsule()
            .stroke(.secondary.opacity(0.2), lineWidth: 1)
        }
        .matchedGeometryEffect(id: "capsule", in: animation)
    }
  }
  
  @ViewBuilder
  private func SearchNavView() -> some View {
    HStack {
      LocalizedText(.search)
        .font(.dmSerif(30))
      CloseBtn()
    }
  }
  
  @ViewBuilder
  private func DismissableScrollView<V: View>(@ViewBuilder content: @escaping () -> V) -> some View {
    if #available(iOS 16.0, *) {
      ScrollView(showsIndicators: false) {
        content()
      }
      .scrollDismissesKeyboard(.interactively)
    } else {
      ScrollView(showsIndicators: false) {
        content()
      }
    }
  }
  
  @ViewBuilder
  private func ClearTextBtn() -> some View {
    Button {
      searchText = ""
    } label: {
      Image(systemName: "xmark.circle.fill")
        .foregroundColor(preferences.accentColor.color)
        .padding(.trailing)
        .scaleEffect(searchText.isEmpty || focusedName == nil ? 0.01 : 1)
        .animation(.bouncy, value: searchText.isEmpty)
        .animation(.bouncy, value: focusedName)
    }
  }
  
  @ViewBuilder
  private func CloseBtn() -> some View {
    Button {
      focusedName = nil
      delay(0.1) {
        withAnimation(.snappy) {
          HapticKit.impact(.soft).generate()
          showTabBar.toggle()
          showSearchView.toggle()
        }
      }
    } label: {
      Image(systemName: "xmark")
        .font(.title2)
    }
    .tint(.primary)
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}

fileprivate struct HomeSearchScreenPreviewContainer: View {
  @Namespace var namespace
  
  var body: some View {
    HomeSearchScreen(
      showSearchView: .constant(true),
      showTabBar: .constant(false),
      animation: namespace
    )
    .previewEnvironment()
  }
}

#Preview {
  HomeSearchScreenPreviewContainer()
}
