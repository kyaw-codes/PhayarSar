//
//  CommonPrayerScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI
import SwiftUIBackports

struct CommonPrayerScreen<Model> where Model: CommonPrayerProtocol {
  @State private var showPronounciation = true
  @EnvironmentObject var preferences: UserPreferences
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) var moc
  
  @State private var showAboutScreen = false
  @State private var showThemesScreen = false
  @State private var showModeScreen = false
  @State private var lastParagraphHeight = 0.0
  
  @State private var startPulsating = false
  @State private var pageColor: PageColor = .classic
  
  // MARK: Dependencies
  @StateObject private var vm: CommonPrayerVM<Model>
  private let worshipPlanName: String
  
  init(model: Model, worshipPlanName: String = "") {
    self._vm = .init(wrappedValue: .init(model: model))
    self.worshipPlanName = worshipPlanName
  }
}

// MARK: View
extension CommonPrayerScreen: View {
  var body: some View {
    VStack(spacing: 0) {
      if !worshipPlanName.isEmpty {
        FakeNavView()
      }
      AutoScrollingView()
        .background(pageColor.color)
    }
    .overlay(alignment: .bottomTrailing) {
      PrayOrProgressView()
    }
    .navigationTitle(vm.model.title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        if vm.isPlaying {
          PulsatingScrollSpeedView()
            .transition(.slide)
        }
      }
      ToolbarItem { PrayerMenu() }
    }
    .sheet(isPresented: $showAboutScreen) {
      NavigationView {
        AboutPrayerScreen(title: vm.model.title, about: vm.model.about)
      }
    }
    .sheet(isPresented: $showThemesScreen) {
      NavigationView {
        ThemesAndSettingsScreen(vm: vm, pageColor: $pageColor)
          .ignoresSafeArea()
      }
      .backport.presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showModeScreen) {
      NavigationView {
        PrayerModeScreen(vm: vm)
          .ignoresSafeArea()
      }
      .backport.presentationDetents([.medium])
    }
    .onChange(of: vm.config.mode, perform: { mode in
      if mode == PrayingMode.reader.rawValue {
        vm.resetPrayingState()
      }
    })
    .onAppear {
      vm.makeFirstParagraphVisibleIfNeeded()
      pageColor = PageColor(rawValue: vm.config.backgroundColor).orElse(.classic)
    }
    .onDisappear {
      vm.saveThemeAndSettings()
    }
    .navigationBarHidden(!worshipPlanName.isEmpty)
    .navigationBarBackButtonHidden(vm.isPlaying)
    .tint(preferences.accentColor.color)
    .id(vm.viewRefreshId)
  }
}

// MARK: Sub-views
fileprivate extension CommonPrayerScreen {
  
  @ViewBuilder
  func FakeNavView() -> some View {
    HStack {
      Spacer()
      Text(worshipPlanName)
        .font(.qsSb(18))
        .padding(.vertical)
      Spacer()
    }
    .background(Color.navBar)
    .overlay(alignment: .leading) {
      if vm.isPlaying {
        HStack {
          PulsatingScrollSpeedView()
            .frame(width: 70, height: 30)
            .transition(.slide)
          Spacer()
        }
        .padding(.leading)
      } else {
        HStack(spacing: 4) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .font(.system(size: 20, weight: .semibold))
//            Text("Back")
          }
        }
        .padding(.leading)
        .foregroundColor(preferences.accentColor.color)
      }
    }
    .overlay(alignment: .trailing) {
      PrayerMenu()
        .scaleEffect(1.3)
        .padding(.trailing)
    }
    .overlay(alignment: .bottom) {
      Divider()
    }
  }
  
  @ViewBuilder
  func PulsatingScrollSpeedView() -> some View {
    ZStack {
      Capsule()
        .foregroundColor(preferences.accentColor.color)
        .opacity(0.1)
        .scaleEffect(startPulsating ? 1.6 : 1)
      
      Capsule()
        .foregroundColor(preferences.accentColor.color)
        .opacity(0.3)
        .scaleEffect(startPulsating ? 1.4 : 1)
      
      Capsule()
        .foregroundColor(preferences.accentColor.color)
        .opacity(0.5)
        .scaleEffect(startPulsating ? 1.2 : 0.9)
      
      LocalizedText(ScrollingSpeed(rawValue: vm.config.scrollingSpeed).orElse(.x1).key)
        .font(.qsB(12))
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
          Capsule()
            .fill(preferences.accentColor.color)
            .frame(height: 20)
        }
    }
    .onAppear {
      withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: true)) {
        startPulsating.toggle()
      }
    }
  }
  
  @ViewBuilder
  func PrayOrProgressView() -> some View {
    if vm.config.mode == PrayingMode.player.rawValue {
      Group {
        if vm.isPlaying || vm.isPaused {
          PrayingProgressView(
            progress: vm.progress * 100,
            onPause: vm.pausePraying,
            onCancel:vm.resetPrayingState,
            isPaused: vm.isPaused
          )
          .transition(.move(edge: .bottom).combined(with: .scale).combined(with: .offset(y: 30)))
        } else {
          if PrayingMode(rawValue: vm.config.mode).orElse(.reader) != .reader {
            PrayBtn()
              .transition(.move(edge: .trailing).combined(with: .scale))
          }
        }
      }
      .padding()
      .padding(.trailing)
    }
  }
  
  @ViewBuilder func AutoScrollingView() -> some View {
    GeometryReader {
      let size = $0.size
      
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack(spacing: vm.config.paragraphSpacing) {
            ForEach($vm.model.body) { prayer in
              
              CommonPrayerParagraphView<Model>(
                prayer: prayer,
                vm: vm
              )
              .foregroundColor(PageColor(rawValue: vm.config.backgroundColor).orElse(.classic).tintColor)
              .id(prayer.id)
              .measure(\.height) { value in
                if vm.model.body.last?.id == prayer.wrappedValue.id {
                  lastParagraphHeight = value
                }
              }
              .padding(.bottom, calculatePaddingBottom(model: vm.model,
                                                       prayer: prayer.wrappedValue,
                                                       size: size,
                                                       lastParagraphHeight: lastParagraphHeight)
              )
            }
          }
          .padding(.horizontal)
        }
        .onReceive(vm.timer) { _ in
          vm.scrollToNextParagraph(proxy: proxy)
        }
        .onChange(of: vm.scrollToId, perform: { _ in
          vm.scrollToSpecificParagraph(proxy: proxy)
        })
        .onChange(of: vm.config.mode, perform: { _  in
          vm.makeFirstParagraphVisibleIfNeeded()
        })
      }
    }
  }
  
  private func calculatePaddingBottom(model: Model, prayer: Model.Body, size: CGSize, lastParagraphHeight: Double) -> CGFloat {
    if vm.config.mode == PrayingMode.player.rawValue {
      return model.body.last?.id == prayer.id ? size.height - lastParagraphHeight - 60 : 0
    } else {
      return 0
    }
  }
  
  @ViewBuilder func PrayBtn() -> some View {
    Button(action: vm.startPraying) {
      HStack(spacing: 5) {
        Image(systemName: "play.circle.fill")
        
        LocalizedText(.btn_pray)
      }
      .foregroundColor(.white)
      .font(.dmSerif(16))
      .padding(.horizontal)
      .padding(.vertical, 12)
      .background(Capsule().fill(preferences.accentColor.color))
    }
  }
  
  @ViewBuilder func PrayerMenu() -> some View {
    if !vm.isPlaying {
      Menu {
        Button {
          showModeScreen.toggle()
        } label: {
          LocalizedLabel(.mode, systemImage: "dpad.left.filled")
        }
        
        Button {
          showThemesScreen.toggle()
        } label: {
          LocalizedLabel(.themes_and_settings, default: "Themes & Settings", systemImage: "textformat.size")
        }
        
        if vm.config.mode == PrayingMode.player.rawValue {
          Menu {
            ForEach(ScrollingSpeed.allCases) { speed in
              Button {
                vm.config.scrollingSpeed = speed.rawValue
                vm.reCalculate()
              } label: {
                HStack {
                  LocalizedText(speed.key)
                  if speed == .init(rawValue: vm.config.scrollingSpeed).orElse(.x1) {
                    Image(systemName: "checkmark")
                  }
                }
              }
            }
          } label: {
            LocalizedLabel(.scrolling_speed, systemImage: "dial.medium")
          }
        }
        
        if !vm.model.about.isEmpty {
          Button {
            showAboutScreen.toggle()
          } label: {
            LocalizedLabel(.about_x, args: [vm.model.title], systemImage: "info.circle.fill")
          }
        }
      } label: {
        Image(systemName: "line.3.horizontal.circle.fill")
          .symbolRenderingMode(.monochrome)
          .background(
            Circle()
              .fill(Color.white)
          )
      }
    }
  }
  
  @ViewBuilder func BackBtn() -> some View {
    Button {
      dismiss()
    } label: {
      HStack(spacing: 4) {
        Image(systemName: "chevron.left")
          .font(.title2.weight(.medium))
        Text("Back")
      }
    }
  }
}

#Preview {
  NavigationView {
    CommonPrayerScreen(model: natPint)
  }
  .previewEnvironment()
}
