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
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HeaderView()
        TextPreviewView()
        
        ScrollView(showsIndicators: false) {
          FontPickerView()
          Divider().padding(.top)
          FontSizeView()
          Divider().padding(.top)
          ColorPickerView()
          Divider().padding(.top)
          LetterAndLineSpacingView()
          
          Divider().padding(.top)
          Toggle(isOn: $showPronunciation, label: {
            LocalizedLabel(.show_pronunciation, systemImage: "captions.bubble.fill")
              .font(.dmSerif(16))
          })
          .padding(.horizontal, 2)
          .padding(.top, 12)
          .tint(preferences.accentColor.color)
          
          Divider().padding(.top)
          Toggle(isOn: $spotlightTextEnable, label: {
            LocalizedLabel(.spotlight_text, systemImage: "text.line.first.and.arrowtriangle.forward")
              .font(.dmSerif(16))
          })
          .padding(.horizontal, 2)
          .padding(.top, 12)
          .padding(.bottom, safeAreaInsets.bottom)
          .tint(preferences.accentColor.color)
        }
        .clipShape(
          CustomCornerView(corners: [.topLeft, .topRight], radius: 20)
        )
      }
      .padding()
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
  }
  
  @ViewBuilder
  private func TextPreviewView() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(.ultraThickMaterial)
        .frame(height: 140)
      
      Group {
        Text("သီဟိုဠ်မှ ဉာဏ်ကြီးရှင်သည် အာယုဝဍ္ဎနဆေးညွှန်းစာကို ဇလွန်ဈေးဘေး ဗာဒံပင်ထက် အဓိဋ္ဌာန်လျက် ဂဃနဏဖတ်ခဲ့သည်။")
          .tracking(1)
          .font(.jasmine(16))
          .lineSpacing(10)
          .padding()
      }
      .scrollOnOverflow()
    }
    .frame(height: 140)
    .padding(.top)
  }
  
  @ViewBuilder
  private func FontPickerView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      LocalizedText(.font)
        .font(.dmSerif(20))
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
              if font == .jasmine {
                RoundedRectangle(cornerRadius: 12)
                  .stroke(preferences.accentColor.color, lineWidth: 3)
              }
            }
        }
      }
      .frame(height: 100)
      .padding(.horizontal, 2)
    }
    .padding(.top, 20)
  }
  
  @ViewBuilder
  private func ColorPickerView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      LocalizedText(.background_and_color)
        .font(.dmSerif(20))
      
      ScrollView {
        HStack {
          ForEach(PageColor.allCases) { color in
            Circle()
              .stroke(color == .grey ? preferences.accentColor.color : .clear, style: .init(lineWidth: 2))
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
                if color == .grey {
                  Image(systemName: "checkmark")
                    .foregroundColor(color.tintColor)
                    .font(.footnote.bold())
                }
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
        .font(.dmSerif(20))
      
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
        .font(.dmSerif(20))
      
      HStack(alignment: .top, spacing: 12) {
        VStack {
          IncreaseDecreaseBtn()
          TextSizeIndicator()
        }
        
        Menu {
          ForEach(PrayerAlignment.allCases) { alignment in
            Button {
              
            } label: {
              alignment.label()
            }
          }
//          Button {
//            
//          } label: {
//            LocalizedLabel(.align_left, systemImage: "text.alignleft")
//          }
//          
//          Button {
//            
//          } label: {
//            LocalizedLabel(.align_center, systemImage: "text.aligncenter")
//          }
//          
//          Button {
//            
//          } label: {
//            LocalizedLabel(.justify, systemImage: "text.justify")
//          }
        } label: {
          Image(systemName: "text.alignleft")
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
            .fill(preferences.accentColor.color.opacity(id < 8 ? 1 : 0.3))
            .frame(height: 4)
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
    ThemesAndSettingsScreen()
  }
  .previewEnvironment()
}
