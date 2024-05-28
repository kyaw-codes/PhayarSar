//
//  PrayerSpellingErrorReportScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 19/05/2024.
//

import SwiftUI
import SwiftUIBackports

struct PrayerSpellingErrorReportScreen {
  @EnvironmentObject private var preferences: UserPreferences
  @Environment(\.dismiss) var dismiss
  @ObservedObject private var vm: CommonPrayerVM<PhayarSarModel>
  
  @State private var comments: [Int: SpellingErrorCommentModel] = [:]
  
  private var screenWidth: CGFloat {
    UIScreen.main.bounds.width
  }
  
  init(vm: CommonPrayerVM<PhayarSarModel>) {
    self._vm = .init(wrappedValue: vm)
    self.vm.config.showPronunciation = true
  }
}

extension PrayerSpellingErrorReportScreen: View {
  var body: some View {
    ScrollView {
      LazyVStack(spacing: vm.config.paragraphSpacing) {
        ForEach(vm.model.body.enumerated().map { $0 }, id: \.offset) { (offset, prayer) in
          HStack(alignment: .top) {
            LazyVStack(alignment: .leading, spacing: 10) {
              Text(prayer.content)
                .tracking(vm.config.letterSpacing)
                .lineSpacing(vm.config.lineSpacing)
                .frame(maxWidth: .infinity,
                       alignment: PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).alignment)
              
              if vm.config.showPronunciation && !prayer.pronunciation.isEmpty {
                Text("(\(prayer.pronunciation))")
                  .font(MyanmarFont(rawValue: vm.config.font).orElse(.msquare).font(CGFloat(vm.config.textSize) * 0.9))
                  .tracking(vm.config.letterSpacing)
                  .lineSpacing(vm.config.lineSpacing)
                  .opacity(0.5)
                  .frame(maxWidth: .infinity,
                         alignment: PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).alignment)
              }
            }
            .font(MyanmarFont(rawValue: vm.config.font).orElse(.msquare).font(CGFloat(vm.config.textSize)))
            .multilineTextAlignment(PrayerAlignment(rawValue: vm.config.textAlignment).orElse(.left).textAlignment)
            .padding([.top, .bottom], 10)
            .padding(.horizontal, 12)
            .background {
              RoundedRectangle(cornerRadius: 12)
                .fill(
                  comments.keys.map({ $0 }).contains(offset) ? Color.red.opacity(0.8) : Color.gray.opacity(0.2)
                )
            }
            .frame(width: screenWidth - 24)
            .offset(x: comments.keys.map({ $0 }).contains(offset) ? -22 : 16)
            
            Image(systemName: "flag.fill")
              .foregroundStyle(
                comments.keys.map({ $0 }).contains(offset) ? Color.red.opacity(0.8) : Color.gray.opacity(0.2)
              )
              .font(.title2)
              .padding(.top, 4)
              .offset(x: comments.keys.map({ $0 }).contains(offset) ? -22 : 22)
          }
          .contentShape(.rect)
          .onTapGesture {
            withAnimation(.bouncy) {
              HapticKit.selection.generate()
              if comments.keys.map({ $0 }).contains(offset) {
                comments.removeValue(forKey: offset)
              } else {
                comments[offset] = .init(
                  prayerTitle: vm.model.title,
                  content: prayer.content,
                  pronunciation: prayer.pronunciation,
                  index: offset,
                  comment: ""
                )
              }
            }
          }
        }
      }
      .padding()
    }
    .navigationTitle(.report)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        BtnCloseCircle {
          dismiss()
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          SpellingErrorCommentScreen(comments: $comments)
        } label: {
          LocalizedText(.next)
            .font(.qsB(14))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 12).fill(preferences.accentColor.color).opacity(0.2))
        }
        .disabled(comments.isEmpty)
        .opacity(comments.isEmpty ? 0 : 1)
      }
    }
    .tint(preferences.accentColor.color)
  }
}

#Preview {
  NavigationView {
    PrayerSpellingErrorReportScreen(vm: .init(model: natPint))
  }
  .previewEnvironment()
}
