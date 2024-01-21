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
  
  // Dependencies
  @Binding var model: Model
  @StateObject private var vm: CommonPrayerVM
  
  init(model: Binding<Model>) {
    self._model = model
    self._vm = .init(wrappedValue: CommonPrayerVM(prayerId: model.wrappedValue.id))
  }
}

extension CommonPrayerScreen: View {
  var body: some View {
    AutoScrollingView()
      .background(PageColor(rawValue: vm.config.backgroundColor).orElse(.classic).color)
      .overlay(alignment: .bottomTrailing) {
        // MARK: Progress/Play Area
        Group {
          if isPlaying {
            PrayingProgressView(progress: .constant(30), onPause: {
              
            }, onCancel: {
              withAnimation(.spring(duration: 0.5, bounce: 0.1, blendDuration: 0.2)) {
                isPlaying.toggle()
              }
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
      .navigationTitle(model.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem { PrayerMenu() }
      }
      .sheet(isPresented: $showAboutScreen) {
        NavigationView {
          AboutPrayerScreen(title: model.title, about: model.about)
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
      .onAppear {
//        model.body[0].isBlur = false
      }
      .onDisappear {
        vm.save()
      }
      .tint(preferences.accentColor.color)
      .id(vm.viewRefreshId)
  }
  
  func scrollToNextParagraph(proxy: ScrollViewProxy) {
    guard currentIndex < model.body.count else {
      currentIndex = 0
      isPlaying.toggle()
      return
    }
    
    let timeLapse = Date().timeIntervalSince1970 - startTime
    
    if timeLapse >= model.body[currentIndex].duration {
      defer {
        startTime = Date().timeIntervalSince1970
        currentIndex += 1
        paragraphRefreshId = UUID().uuidString
      }
      
      withAnimation(.easeIn) {
        proxy.scrollTo(model.body[currentIndex].id, anchor: .top)
      }
      
      for i in 0 ..< model.body.count {
//        model.body[i].isBlur = i != currentIndex
      }
    }
  }
}

fileprivate extension CommonPrayerScreen {
  @ViewBuilder func HeaderView() -> some View {
    GeometryReader {
      let size = $0.size
      Rectangle()
        .fill(.regularMaterial)
        .ignoresSafeArea()
        .overlay {
          Text(model.title)
            .frame(width: size.width * 0.75)
        }
        .overlay(alignment: .leading) {
          BackBtn()
            .padding(.leading, 8)
        }
        .overlay(alignment: .trailing) {
          PrayerMenu()
            .padding(.trailing)
        }
        .overlay(alignment: .bottom) {
          Divider()
        }
    }
    .frame(height: 50)
  }
  
  @ViewBuilder func AutoScrollingView() -> some View {
    GeometryReader {
      let size = $0.size
      
      ScrollViewReader { proxy in
        ScrollView {
          VStack(spacing: vm.config.paragraphSpacing) {
            ForEach($model.body) { prayer in
              CommonPrayerParagraphView<Model>(
                refreshId: $paragraphRefreshId,
                prayer: prayer,
                index: $currentIndex,
                scrollToId: $scrollToId,
                config: $vm.config
              )
              .foregroundColor(PageColor(rawValue: vm.config.backgroundColor).orElse(.classic).tintColor)
              .id(prayer.id)
              .measure(\.height) { value in
                if model.body.last?.id == prayer.wrappedValue.id {
                  lastParagraphHeight = value
                }
              }
              .padding(.bottom, calculatePaddingBottom(model: model, 
                                                       prayer: prayer.wrappedValue,
                                                       size: size,
                                                       lastParagraphHeight: lastParagraphHeight)
              )
            }
          }
          .padding(.horizontal)
        }
        .onReceive(timer) { _ in
          guard isPlaying else { return }
          scrollToNextParagraph(proxy: proxy)
        }
        .onChange(of: scrollToId, perform: { id in
          currentIndex = model.body.firstIndex(where: { $0.id == id })!
          
          withAnimation(.easeIn) {
            proxy.scrollTo(id, anchor: .top)
          }
          
          for i in 0 ..< model.body.count {
//            model.body[i].isBlur = i != currentIndex
          }
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
    Button {
      startTime = Date().timeIntervalSince1970
      
      withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.4)) {
        isPlaying.toggle()
      }
    } label: {
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
        LocalizedLabel(.about_x, args: [model.title], systemImage: "info.circle.fill")
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
    CommonPrayerScreen(model: .constant(natPint))
  }
  .previewEnvironment()
}
