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
    
    @State private var showAboutScreen = false
    @State private var showThemesScreen = false
    @State private var showPopover = false
    
    @State private var isPlaying = false
    @State private var currentIndex = 0
    @State private var lastParagraphHeight = 0.0
    @State private var paragraphRefreshId = UUID().uuidString
    @State private var startTime = Date().timeIntervalSince1970
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // Dependencies
    @Binding var model: Model
}

extension CommonPrayerScreen: View {
    var body: some View {
        GeometryReader { gProxy in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach($model.body) { prayer in
                            CommonPrayerParagraphView<Model>(refreshId: $paragraphRefreshId, prayer: prayer, index: $currentIndex)
                                .id(prayer.id)
                                .measure(\.height) { value in
                                    if model.body.last?.id == prayer.wrappedValue.id {
                                        lastParagraphHeight = value
                                    }
                                }
                                .padding(.bottom, model.body.last?.id == prayer.wrappedValue.id ? gProxy.size.height - lastParagraphHeight - 60 : 0)
                        }
                    }
                    .padding(.horizontal)
                }
                .allowsHitTesting(false)
                .onReceive(timer) { _ in
                    guard isPlaying else { return }
                    scrollToNextParagraph(proxy: proxy)
                }
            }
        }
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                PrayerMenu()
            }
            
            ToolbarItem {
                Button {
                    startTime = Date().timeIntervalSince1970
                    isPlaying.toggle()
                } label: {
                    Image(systemName: "play.circle.fill")
                }
            }
        }
        .tint(preferences.accentColor.color)
        .sheet(isPresented: $showAboutScreen) {
            NavigationView {
                AboutPrayerScreen(title: model.title, about: model.about)
            }
        }
        .sheet(isPresented: $showThemesScreen) {
            NavigationView {
                ThemesAndSettingsScreen()
                    .ignoresSafeArea()
            }
            .backport.presentationDetents([.medium, .large])
        }
        .onAppear {
            model.body[0].isBlur = false
        }
    }
}

fileprivate extension CommonPrayerScreen {
    
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
                model.body[i].isBlur = i != currentIndex
            }
        }
    }
    
    @ViewBuilder func PrayerMenu() -> some View {
        Menu {
            Button {
                showThemesScreen.toggle()
            } label: {
                LocalizedLabel(.themes_and_settings, default: "Themes & Settings", systemImage: "textformat.size")
            }
            Button {
                showAboutScreen.toggle()
            } label: {
                LocalizedLabel(.about_x, args: [model.title], systemImage: "info.circle.fill")
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .symbolRenderingMode(.monochrome)
                .background(
                    Circle()
                        .fill(Color.white)
                )
        }
    }
}

#Preview {
    NavigationView {
        CommonPrayerScreen(model: .constant(natPint))
    }
    .previewEnvironment()
}
