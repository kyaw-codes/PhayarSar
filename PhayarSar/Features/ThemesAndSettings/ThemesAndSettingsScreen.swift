//
//  ThemesAndSettingsScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 31/12/2023.
//

import SwiftUI
import CompactSlider

struct ThemesAndSettingsScreen: View {
  @Environment(\.safeAreaInsets) var safeAreaInsets
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var preferences: UserPreferences
  @State private var letterSpacing = 10.0
  @State private var lineSpacing = 3.0
  @State private var showPronunciation = false
  @State private var spotlightTextEnable = true
  @State private var tapToScroll = false
  @State private var previewTextHeight = CGFloat.zero
  
  // Local properties
  @State private var selectedFont: MyanmarFont = .jasmine
  @State private var fontSize: CGFloat = 28
  @State private var showFontIndicator = false
  @State private var textAlignment: PrayerAlignment = .left
  @State private var pageColor: PageColor = .classic
  
  @ObservedObject private var vm: CommonPrayerVM
  @Namespace private var namespace
  
  private let colorSystemBg = Color(uiColor: .systemBackground)
  
  init(vm: CommonPrayerVM) {
    self._vm = .init(wrappedValue: vm)
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HeaderView()
        ZStack(alignment: .top) {
          TextPreviewView()
            .measure(\.height) { height in
              previewTextHeight = height
            }
            .zIndex(1)
          
          ScrollView(showsIndicators: false) {
            FontPickerView()
              .padding(.top, previewTextHeight)
            Divider().padding(.top)
            
            FontSizeView()
            Divider().padding(.top)
            
            ColorPickerView()
            Divider().padding(.top)
            
            LetterAndLineSpacingView()
            Divider().padding(.top)
            
            Toggle(isOn: $showPronunciation, label: {
              LocalizedLabel(.show_pronunciation, systemImage: "captions.bubble.fill")
                .font(.qsSb(16))
            })
            .padding(.horizontal, 2)
            .padding(.top, 12)
            .tint(preferences.accentColor.color)
            Divider().padding(.top)
            
            Toggle(isOn: $spotlightTextEnable, label: {
              LocalizedLabel(.spotlight_text, systemImage: "text.line.first.and.arrowtriangle.forward")
                .font(.qsSb(16))
            })
            .padding(.horizontal, 2)
            .padding(.top, 12)
            .tint(preferences.accentColor.color)
            Divider().padding(.top)
            
            Toggle(isOn: $tapToScroll, label: {
              LocalizedLabel(.tap_to_scroll, systemImage: "hand.tap.fill")
                .font(.qsSb(16))
            })
            .padding(.horizontal, 2)
            .padding(.top, 12)
            .padding(.bottom, safeAreaInsets.bottom)
            .tint(preferences.accentColor.color)
          }
        }
//        .clipShape(
//          CustomCornerView(corners: [.topLeft, .topRight], radius: 20)
//        )
        
      }
      .padding()
    }
    .id(vm.viewRefreshId)
    .onAppear {
      selectedFont = .init(rawValue: vm.config.font).orElse(.jasmine)
      fontSize = CGFloat(vm.config.textSize)
      textAlignment = PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left)
      pageColor = .init(rawValue: vm.config.backgroundColor).orElse(.classic)
    }
    .onDisappear {
      vm.save()
    }
    .onChange(of: showFontIndicator) {
      if $0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          withAnimation(.easeOut) {
            showFontIndicator = false
          }
        }
      }
    }
    .edgesIgnoringSafeArea(.bottom)
  }
  
  @ViewBuilder
  private func HeaderView() -> some View {
    HStack {
      LocalizedText(.themes_and_settings)
        .font(.dmSerif(24))
      Spacer()
      
      BtnCloseCircle { dismiss() }
    }
    .padding(.bottom)
  }
  
  @ViewBuilder
  private func TextPreviewView() -> some View {
    VStack(spacing: 0) {
      ZStack(alignment: .top) {
        RoundedRectangle(cornerRadius: 12)
          .fill(pageColor.color)
        
        Text("သီဟိုဠ်မှ ဉာဏ်ကြီးရှင်သည် အာယုဝဍ္ဎနဆေးညွှန်းစာကို ဇလွန်ဈေးဘေး ဗာဒံပင်ထက် အဓိဋ္ဌာန်လျက် ဂဃနဏဖတ်ခဲ့သည်။")
          .foregroundColor(pageColor.tintColor)
          .tracking(1)
          .multilineTextAlignment(textAlignment.alignment)
          .font(selectedFont.font(fontSize))
          .lineSpacing(10)
          .padding([.horizontal, .top])
      }
      .frame(height: 160)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .background(colorSystemBg)
      
      Rectangle()
        .fill(LinearGradient(colors: [colorSystemBg, colorSystemBg.opacity(0.7), colorSystemBg.opacity(0.1), colorSystemBg.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom))
        .frame(height: 30)
    }
  }
  
  @ViewBuilder
  private func FontPickerView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      LocalizedText(.font)
        .font(.qsSb(20))
      
      HStack(spacing: 14) {
        ForEach(MyanmarFont.allCases) { font in
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.cardBg)
            .overlay {
              Text("ကခဂ")
                .font(font.font(30))
                .padding(.bottom)
            }
            .overlay(alignment: .bottom) {
              LocalizedText(font.key)
                .font(.qsB(13))
                .padding(.bottom)
            }
            .overlay {
              if font == selectedFont {
                RoundedRectangle(cornerRadius: 12)
                  .stroke(preferences.accentColor.color, lineWidth: 3)
              }
            }
            .onTapGesture {
              HapticKit.selection.generate()
              withAnimation(.easeOut(duration: 0.3)) {
                selectedFont = font
              }
              vm.config.font = font.rawValue
            }
        }
      }
      .frame(height: 100)
      .padding(.horizontal, 2)
    }
  }
  
  @ViewBuilder
  private func ColorPickerView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      LocalizedText(.background_and_color)
        .font(.qsSb(20))
      
      ScrollView {
        HStack {
          ForEach(PageColor.allCases) { color in
            Circle()
              .stroke(pageColor == color ? preferences.accentColor.color : .clear, style: .init(lineWidth: 2))
              .frame(width: 38)
              .padding(3)
              .overlay {
                Circle()
                  .fill(color.color)
                  .frame(width: 30)
                  .overlay {
                    Circle()
                      .stroke(Color.gray, style: .init(lineWidth: 0.3))
                  }
              }
              .overlay {
                if pageColor == color {
                  Image(systemName: "checkmark")
                    .foregroundColor(color.tintColor)
                    .font(.footnote.bold())
                }
              }
              .onTapGesture {
                HapticKit.selection.generate()
                withAnimation(.easeIn(duration: 0.3)) {
                  pageColor = color
                }
                vm.config.backgroundColor = color.rawValue
              }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private func LetterAndLineSpacingView() -> some View {
    VStack(alignment: .leading) {
      LocalizedText(.letter_and_line_spacing)
        .font(.qsSb(20))
      
      CompactSlider(value: $letterSpacing, in: 2...18, step: 0.5) {
        LocalizedLabel(.letter_spacing, systemImage: "arrow.left.and.right.text.vertical")
          .font(.qsB(16))
        Spacer()
        Text("\(preferences.appLang == .Eng ? convertNumberMmToEng("\(Int(letterSpacing))") : convertNumberEngToMm("\(Int(letterSpacing))"))")
          .font(.dmSerif(18))
      }
      .compactSliderStyle(CustomCompactSliderStyle(accentColor: preferences.accentColor.color))
      
      CompactSlider(value: $lineSpacing, in: 15...30, step: 0.5) {
        LocalizedLabel(.line_spacing, systemImage: "arrow.up.and.down.text.horizontal")
          .font(.qsB(16))
        Spacer()
        Text("\(preferences.appLang == .Eng ? convertNumberMmToEng("\(Int(lineSpacing))") : convertNumberEngToMm("\(Int(lineSpacing))"))")
          .font(.dmSerif(18))
      }
      .compactSliderStyle(CustomCompactSliderStyle(accentColor: preferences.accentColor.color))
      .padding(.top, 4)
    }
  }
  
  @ViewBuilder
  private func FontSizeView() -> some View {
    VStack(alignment: .leading) {
      LocalizedText(.text_size_and_alignment)
        .font(.qsSb(20))
      
      HStack(alignment: .top, spacing: 12) {
        VStack {
          IncreaseDecreaseBtn()
          if showFontIndicator {
            TextSizeIndicator()
          }
        }
        
        Menu {
          ForEach(PrayerAlignment.allCases) { alignment in
            Button {
              self.textAlignment = alignment
              vm.config.textAlignment = alignment.rawValue
            } label: {
              alignment.label()
            }
          }
        } label: {
          Image(systemName: textAlignment.systemImage)
            .font(.body.bold())
            .foregroundColor(preferences.accentColor.color)
            .padding(12)
            .background {
              RoundedRectangle(cornerRadius: 10)
                .fill(preferences.accentColor.color.opacity(0.2))
            }
        }
      }
    }
  }
  
  @ViewBuilder
  private func IncreaseDecreaseBtn() -> some View {
    HStack {
      Button {
        HapticKit.selection.generate()
        let size = max(14, vm.config.textSize - 2)
        vm.config.textSize = size
        fontSize = CGFloat(size)
        
        withAnimation(.easeIn(duration: 0.2)) {
          showFontIndicator = true
        }
      } label: {
        HStack {
          Spacer()
          Image(systemName: "character")
            .font(.body)
            .padding(.vertical, 12)
          Spacer()
        }
      }
      
      Rectangle()
        .fill(preferences.accentColor.color.opacity(0.6))
        .frame(width: 1)
        .padding(.vertical, 10)
      
      Button {
        HapticKit.selection.generate()
        let size = min(vm.config.textSize + 2, 42)
        vm.config.textSize = size
        fontSize = CGFloat(size)
        withAnimation(.easeIn(duration: 0.2)) {
          showFontIndicator = true
        }
      } label: {
        HStack {
          Spacer()
          Image(systemName: "character")
            .font(.title2)
          Spacer()
        }
      }
    }
    .foregroundColor(preferences.accentColor.color)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .fill(preferences.accentColor.color.opacity(0.2))
    }
  }
  
  @ViewBuilder
  private func TextSizeIndicator() -> some View {
    HStack(spacing: 2) {
      ForEach(0 ..< 15, id: \.self) { id in
        HStack {
          RoundedRectangle(cornerRadius: 6)
            .fill(preferences.accentColor.color.opacity(id < (15 - (42 - vm.config.textSize) / 2) ? 1 : 0.3))
            .frame(height: 2)
        }
      }
    }
    .padding(.top, 8)
    .padding(.horizontal, 40)
  }
}

struct CustomCompactSliderStyle: CompactSliderStyle {
  let accentColor: Color
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(
        configuration.isHovering || configuration.isDragging ? accentColor : accentColor.opacity(0.7)
      )
      .background(
        accentColor.opacity(0.1)
      )
      .accentColor(accentColor)
      .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

#Preview {
  NavigationView {
    ThemesAndSettingsScreen(vm: .init(prayerId: natPint.id))
  }
  .previewEnvironment()
}
