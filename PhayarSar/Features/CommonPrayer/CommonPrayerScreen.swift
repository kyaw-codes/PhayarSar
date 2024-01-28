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
  
  @State private var scrollingSpeed: ScrollingSpeed = .x1
  @State private var isPlaying = false
  @State private var currentIndex = 0
  @State private var lastParagraphHeight = 0.0
  @State private var paragraphRefreshId = UUID().uuidString
  @State private var startTime = Date().timeIntervalSince1970
  
  @State private var scrollToId: String?
  
  private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
  
  // MARK: Dependencies
  @StateObject private var vm: CommonPrayerVM<Model>
  
  init(model: Model) {
    self._vm = .init(wrappedValue: .init(model: model))
  }
}

// MARK: View
extension CommonPrayerScreen: View {
  var body: some View {
    AutoScrollingView()
      .background(PageColor(rawValue: vm.config.backgroundColor).orElse(.classic).color)
      .overlay(alignment: .bottomTrailing) { PrayOrProgressView() }
      .navigationTitle(vm.model.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { ToolbarItem { PrayerMenu() } }
      .sheet(isPresented: $showAboutScreen) {
        NavigationView {
          AboutPrayerScreen(title: vm.model.title, about: vm.model.about)
        }
      }
      .sheet(isPresented: $showThemesScreen) {
        NavigationView {
          ThemesAndSettingsScreen(vm: vm)
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
      .onDisappear {
        vm.saveThemeAndSettings()
      }
      .tint(preferences.accentColor.color)
      .id(vm.viewRefreshId)
  }
}

// MARK: Sub-views
fileprivate extension CommonPrayerScreen {

  @ViewBuilder 
  func PrayOrProgressView() -> some View {
    Group {
      if vm.isPlaying {
        PrayingProgressView(progress: .constant(30), onPause: {
          
        }, onCancel: {
            vm.stopPraying()
        })
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
  
  @ViewBuilder func AutoScrollingView() -> some View {
    GeometryReader {
      let size = $0.size
      
      ScrollViewReader { proxy in
        ScrollView {
          VStack(spacing: vm.config.paragraphSpacing) {
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
        
        Button {
          showAboutScreen.toggle()
        } label: {
          LocalizedLabel(.about_x, args: [vm.model.title], systemImage: "info.circle.fill")
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
