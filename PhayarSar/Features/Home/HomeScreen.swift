//
//  HomeScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/12/2023.
//

import SwiftUI
import CoreData

struct HomeScreen: View {
  @Binding var showTabBar: Bool
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var worshipPlanRepo: WorshipPlanRepository
  @EnvironmentObject private var prayingTimeRepo: DailyPrayingTimeRepository
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.managedObjectContext) private var moc
  
  @State private var showOnboarding = false
  @State private var offset: CGPoint = .zero
  @State private var payeikCollapsed = true
  @State private var showWorshipPlanScreen = false
  @State private var currentWorshipPlan: NSManagedObjectID = .init()
  @State private var showSearchView = false
  @State private var worshipPlanListRefresh = UUID()
  @Namespace private var animation
  
  var body: some View {
    OffsetObservingScrollView(offset: $offset) {
      navView
      
      LazyVStack(spacing: 12) {
        if worshipPlanRepo.latestPlans.isEmpty {
          addNewWorshipPlanView
            .padding(.bottom)
        } else {
          WorshipPlansSection()
        }
        
        canTokKyoSection
        
        OthersSection()
        
        myittarPoeSection
        
        PrayingDurationChartView()
          .padding(.top, 30)
      }
      .padding([.horizontal, .top])
      .padding(.bottom, 92)
    }
    .overlay(alignment: .top) {
      inlineNavView
    }
    .overlay {
      if showSearchView {
        NavigationView {
          HomeSearchScreen(
            showSearchView: $showSearchView,
            showTabBar: $showTabBar,
            animation: animation
          )
        }
        .environmentObject(preferences)
        .environmentObject(prayingTimeRepo)
        .environmentObject(worshipPlanRepo)
      }
    }
    .onAppear {
      showOnboarding = preferences.isFirstLaunch == nil
      worshipPlanListRefresh = .init()
    }
    .sheet(isPresented: $showOnboarding) {
      OnboardingScreen()
    }
    .fullScreenCover(isPresented: $showWorshipPlanScreen, content: {
      WorshipPlanScreen(worshipPlan: .constant(nil))
    })
  }
  
  var canTokKyoSection: some View {
    PrayerCardView(
      title: "ဘုရားရှိခိုး ဂါထာများ",
      subtitle: "ဘုရားကန်တော့",
      systemImage: "hands.and.sparkles.fill",
      duration: "8",
      list: cantotkyo,
      color: preferences.accentColor.color
    )
  }
  
  var myittarPoeSection: some View {
    PrayerCardView(
      title: "မေတ္တာပို့ အမျှဝေ",
      subtitle: "အမျှဝေ",
      systemImage: "heart.circle.fill",
      duration: "3",
      list: myittarPoe,
      color: .pink
    )
  }
  
  var navView: some View {
    VStack {
      HStack(alignment: .center) {
        VStack(alignment: .leading, spacing: 4) {
          Text("PhayarSar")
            .font(.dmSerif(32))
          
          HStack(spacing: 0) {
            LocalizedText(.today_pray_time)
              .foregroundColor(preferences.accentColor.color)
            
            if prayingTimeRepo.today.durationInSeconds < 60 {
              LocalizedText(.x_sec, args: [localizeNumber(preferences.appLang, str: "\(prayingTimeRepo.today.durationInSeconds)")])
            } else if prayingTimeRepo.today.durationInSeconds >= 60 && prayingTimeRepo.today.durationInSeconds < 3600 {
              LocalizedText(.x_min, args: [localizeNumber(preferences.appLang, str: "\(prayingTimeRepo.today.durationInSeconds / 60)")])
            } else {
              LocalizedText(
                .x_hour_y_min,
                args: [
                  localizeNumber(preferences.appLang, str: "\(prayingTimeRepo.today.durationInSeconds / 3600)"),
                  localizeNumber(preferences.appLang, str: "\((prayingTimeRepo.today.durationInSeconds % 3600) / 60)")
                ]
              )
            }
          }
          .font(.qsSb(14))
        }
        Spacer()
        
        Button {
          withAnimation(.snappy) {
            HapticKit.impact(.soft).generate()
            showSearchView.toggle()
            showTabBar.toggle()
          }
        } label: {
          Image(systemName: "magnifyingglass")
            .foregroundColor(preferences.accentColor.color)
            .padding(8)
            .matchedGeometryEffect(id: "search_icon", in: animation)
            .background(
              Capsule()
                .fill(preferences.accentColor.color.opacity(0.3))
                .matchedGeometryEffect(id: "capsule", in: animation)
            )
        }
      }
      .padding(.horizontal, 20)
      
      Divider()
        .frame(height: 0.5)
        .background(Color.secondary.opacity(0.2))
        .padding(.horizontal)
        .padding(.top, 8)
    }
  }
  
  var inlineNavView: some View {
    Rectangle()
      .fill(.thinMaterial)
      .ignoresSafeArea(edges: .top)
      .frame(height: 50)
      .overlay {
        Text("PhayarSar")
          .font(.dmSerif(20))
      }
      .overlay(alignment: .bottom, content: {
        Divider()
      })
      .opacity(min(1, offset.y / CGFloat(44)))
  }
  
  var btnPray: some View {
    Button {
      
    } label: {
      HStack(spacing: 5) {
        Image(.pray)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20)
        
        LocalizedText(.btn_pray)
          .foregroundColor(.white)
      }
      .font(.dmSerif(16))
      .padding(.horizontal)
      .padding(.vertical, 8)
      .background(Capsule().fill(preferences.accentColor.color))
    }
  }
  
  var btnAdd: some View {
    Button {
      
    } label: {
      HStack(spacing: 5) {
        Image(systemName: "plus")
          .foregroundColor(.white)
        
        LocalizedText(.btn_add)
          .foregroundColor(.white)
      }
      .font(.dmSerif(16))
      .padding(.horizontal)
      .padding(.vertical, 8)
      .background(Capsule().fill(preferences.accentColor.color))
    }
  }
  
  var addNewWorshipPlanView: some View {
    HStack(spacing: 20) {
      Image(systemName: "sparkles.rectangle.stack")
        .renderingMode(.template)
        .foregroundColor(preferences.accentColor.color)
        .scaleEffect(1.3)
      
      LocalizedText(.worship_plan_helps_you_pray)
        .foregroundColor(preferences.accentColor.color)
        .font(.qsSb(14))
      
      Spacer(minLength: 0)
      
      Button {
        showWorshipPlanScreen.toggle()
      } label: {
        LocalizedText(.add_new)
          .font(.qsB(14))
          .foregroundColor(preferences.accentColor.color)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background {
            RoundedRectangle(cornerRadius: 12)
              .stroke(preferences.accentColor.color)
              .background {
                RoundedRectangle(cornerRadius: 12)
                  .fill(.white)
              }
          }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background {
      RoundedRectangle(cornerRadius: 8)
        .fill(preferences.accentColor.color)
        .opacity(0.3)
    }
  }
  
  @ViewBuilder
  private func WorshipPlansSection() -> some View {
    VStack(alignment: .leading) {
      HStack {
        LocalizedText(.worship_plan)
          .font(.qsB(22))
        Spacer(minLength: 20)
        NavigationLink {
          WorshipPlanListScreen()
            .onAppear {
              showTabBar = false
            }
        } label: {
          HStack(spacing: 4) {
            LocalizedText(.view_more)
            Image(systemName: "chevron.right")
              .font(.caption.bold())
          }
          .font(.qsB(14))
          .foregroundColor(preferences.accentColor.color)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack {
        TabView(selection: $currentWorshipPlan) {
          ForEach(worshipPlanRepo.latestPlans.prefix(5).map { $0 }, id: \.objectID) { worship in
            NavigationLink {
              WorshipPlanDetailScreen(plan: .constant(worship))
                .onAppear {
                  showTabBar = false
                }
            } label: {
              WorshipPlanCardView(worshipPlan: worship)
                .padding(.horizontal)
                .tag(worship.objectID)
                .tint(.primary)
            }
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.horizontal, -15)
        .frame(height: 130)
        .padding(.bottom, worshipPlanRepo.latestPlans.count > 1 ? 0 : 15)
        .id(worshipPlanListRefresh)
        
        if worshipPlanRepo.latestPlans.count > 1 {
          PageControlView(
            currentPage: worshipPlanRepo.latestPlans.prefix(5).map(\.objectID).firstIndex(of: currentWorshipPlan) ?? 0,
            currentPageIndicatorTintColor: preferences.accentColor.color,
            numberOfPages: min(5, worshipPlanRepo.latestPlans.count)
          )
          .id(worshipPlanListRefresh)
          .padding(.bottom, 8)
          .allowsHitTesting(false)
        }
        
//        Button {
//          showWorshipPlanScreen.toggle()
//        } label: {
//          HStack {
//            LocalizedText(.new_worship_plan)
//              .font(.qsB(16))
//            Spacer()
//            Image(systemName: "plus.circle")
//              .font(.body.bold())
//          }
//          .padding(.vertical, 15)
//          .padding(.horizontal)
//          .foregroundColor(.white)
//          .background {
//            RoundedRectangle(cornerRadius: 12)
//              .fill(LinearGradient(
//                colors: [preferences.accentColor.color.opacity(0.9), preferences.accentColor.color.opacity(0.8)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing)
//              )
//          }
//        }
//        .padding(.bottom, 12)
      }
    }
  }
  
  @ViewBuilder
  private func PrayerListCell(_ model: NatPintVO, systemImage: String, hideSeparator: Bool = false) -> some View {
    NavigationLink {
      CommonPrayerScreen(model: model)
        .onAppear {
          showTabBar = false
        }
    } label: {
      VStack {
        HStack {
          Image(systemName: systemImage)
            .font(.footnote)
          Text(model.title)
            .font(.system(size: 12))
            .fontWeight(.semibold)
          
          Spacer()
          Image(systemName: "chevron.right")
            .font(.footnote)
        }
        
        if !hideSeparator {
          Rectangle()
            .frame(height: 1)
            .opacity(0.2)
            .padding(.leading, 28)
        }
      }
    }
  }
  
  @ViewBuilder
  private func PrayerCardView(title: String, subtitle: String, systemImage: String, duration: String, list: [NatPintVO], color: Color) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text(subtitle)
          .font(.qsB(12))
        Spacer()
        HStack(spacing: 3) {
          Image(systemName: "clock.fill")
          LocalizedText(.x_min, args: [localizeNumber(preferences.appLang, str: duration)])
            .padding(.top, preferences.appLang == .Eng ? 0 : -4)
        }
        .font(.qsB(12))
      }
      .opacity(0.85)
      
      Text(title)
        .font(.qsB(18))
        .padding(.top, 2)
      
      Rectangle()
        .opacity(0.8)
        .frame(height: 0.4)
        .padding(.top, 8)
      
      VStack(spacing: 12) {
        VStack(spacing: 8) {
          ForEach(0 ..< min(list.count, 3), id: \.self) { id in
            PrayerListCell(list[id], systemImage: systemImage, hideSeparator: id == 2 || id == list.count - 1)
          }
        }
        .padding()
        .padding(.vertical, 2)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .fill(.thinMaterial)
            .colorScheme(.dark)
        }
        
        if list.count > 3 {
          NavigationLink {
            PrayerCollectionsScreen(
              title: title,
              systemImage: systemImage,
              prayers: list
            )
            .onAppear {
              showTabBar = false
            }
          } label: {
            HStack {
              LocalizedText(.view_collection)
                .font(.qsB(14))
                .padding(.vertical, 12)
              Spacer()
              HStack(spacing: 4) {
                LocalizedText(.plus_x_more, args: [localizeNumber(preferences.appLang, str: String(list.count - 3))])
                  .font(.qsB(12))
                Image(systemName: "chevron.right")
                  .font(.footnote.bold())
              }
            }
            .padding(.horizontal)
            .foregroundColor(color)
            .background {
              RoundedRectangle(cornerRadius: 12)
            }
          }
        }
      }
      .padding(.top, 10)
    }
    .foregroundColor(.white)
    .padding()
    .background {
      RoundedRectangle(cornerRadius: 12)
        .fill(LinearGradient(colors: [color.opacity(0.8), color.opacity(0.8), color.opacity(0.9), color], startPoint: .top, endPoint: .bottom))
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 4)
    }
  }
  
  @ViewBuilder
  private func OthersSection() -> some View {
    VStack {
      HStack(spacing: 6) {
        Image(systemName: "books.vertical")
        LocalizedText(.other_prayers)
          .font(.qsB(20))
        Spacer()
      }
      .padding(.top, 8)
      .padding(.bottom)
      
      VStack(spacing: 8) {
        ForEach(others) {
          OtherListCell(model: $0)
        }
        
        VStack(spacing: 0) {
          HStack(spacing: 6) {
            Image(systemName: "text.book.closed.fill")
              .foregroundColor(.primary)
            
            Text("ပရိတ်ကြီး ဆယ့်တစ်သုတ်")
              .font(.footnote.bold())
              .foregroundColor(.primary)
              .padding(.vertical, 16)
            
            Spacer()
            
            Image(systemName: "chevron.down")
              .rotationEffect(.degrees(payeikCollapsed ? 0 : 180))
              .foregroundColor(preferences.accentColor.color)
              .padding(.trailing)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 12)
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeOut) {
              payeikCollapsed.toggle()
            }
          }
          
          if !payeikCollapsed {
            Divider()
              .padding(.bottom, 8)
            ForEach(payeik) { model in
              OtherListCell(model: model)
              Divider()
            }
          }
        }
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(.cardBg)
        )
        
        OtherListCell(model: pahtanShort)
        OtherListCell(model: pahtanLong)
      }
    }
    .padding(.vertical)
    .background {
      Rectangle()
        .fill(.cardBgTwo)
        .padding(.horizontal, -20)
    }
    .padding(.top, 8)
  }
  
  @ViewBuilder
  private func OtherListCell(model: NatPintVO) -> some View {
    NavigationLink {
      CommonPrayerScreen(model: model)
        .onAppear {
          showTabBar = false
        }
    } label: {
      HStack(spacing: 6) {
        Image(systemName: "text.book.closed.fill")
          .foregroundColor(.primary)
        
        Text(model.title)
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
      )
    }
  }
}

fileprivate struct HomeScreenPreviewContainer: View {
  
  init() {
    WorshipPlan.makePreview(count: 3, in: CoreDataStack.shared.viewContext)
  }
  
  var body: some View {
    NavigationView{
      HomeScreen(showTabBar: .constant(true))
    }
    .previewEnvironment()
  }
}

#Preview {
  HomeScreenPreviewContainer()
}
