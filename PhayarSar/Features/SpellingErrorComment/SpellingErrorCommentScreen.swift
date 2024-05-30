//
//  SpellingErrorCommentScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 19/05/2024.
//

import SwiftUI
import SwiftUIBackports

struct SpellingErrorCommentScreen: View {
  @EnvironmentObject private var preferences: UserPreferences
  @Binding private var comments: [Int: SpellingErrorCommentModel]
  @FocusState private var firstCommentIndex: Int?
  
  init(comments: Binding<[Int: SpellingErrorCommentModel]>) {
    self._comments = comments
    UITextView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 20) {
        ForEach(comments.values.sorted(by: { $0.index < $1.index }).map(\.index), id: \.self) { key in
          CommentSection(key)
        }
      }
      .padding(.vertical, 20)
    }
    .backport.scrollDismissesKeyboard(.interactively)
    .navigationTitle(.comment)
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) {
      VStack {
        Divider()
        
        Button {
          let prayerTitle = comments.values.first?.prayerTitle ?? ""
          let subject = "PhayarSar App - \(prayerTitle) စာပိုဒ်အမှား အကြောင်းကြားစာ"
          let body = comments.values.map {
            "Index: \($0.index)\n\($0.content)\n(\($0.pronunciation.orEmpty.isEmpty ? "အသံထွက်မရှိပါ" : $0.pronunciation.orEmpty))\nမှတ်ချက်: \($0.comment.isEmpty ? "မရှိပါ" : $0.comment)"
          }
          .reduce("") {
            $0 + $1 + "\n\n"
          }

          let mailtoString = "mailto:kyaw.codes@gmail.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
          
          let mailToUrl = URL(string: mailtoString!)!
          
          if UIApplication.shared.canOpenURL(mailToUrl) {
            UIApplication.shared.open(mailToUrl, options: [:])
          }
        } label: {
          HStack {
            Spacer()
            Image(systemName: "paperplane.fill")
            LocalizedText(.send)
            Spacer()
          }
          .foregroundStyle(.white)
          .padding()
          .background {
            RoundedRectangle(cornerRadius: 12)
              .fill(preferences.accentColor.color)
          }
        }
        .padding()
      }
      .background(.thinMaterial)
    }
    .onAppear {
      firstCommentIndex = comments.values.sorted(by: { $0.index < $1.index }).map(\.index).first
    }
  }
  
  @ViewBuilder
  private func CommentSection(_ key: Int) -> some View {
    if let comment = comments[key] {
      VStack(alignment: .leading, spacing: 2) {
        VStack(alignment: .leading, spacing: 12) {
          Text(comment.content)
          if let pronunciation = comment.pronunciation, !pronunciation.isEmpty {
            Text("(\(pronunciation))")
              .opacity(0.5)
          }
        }
        .font(.qsSb(18))
        
        TextEditor(text: .init(
          get: { comments[key]?.comment ?? "" },
          set: { str in DispatchQueue.main.async { comments[key]?.comment = str } })
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .focused($firstCommentIndex, equals: key)
        .overlay(alignment: .leading) {
          if comments[key]?.comment.isEmpty ?? true {
            LocalizedText(.write_down_your_comment)
              .padding(.horizontal, 3)
              .opacity(0.4)
              .allowsHitTesting(false)
          }
        }
        .frame(minHeight: 38, alignment: .leading)
        .frame(maxHeight: 300)
        .cornerRadius(10, antialiased: true)
        .font(.qsSb(16))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(.leading)
        .background {
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
        }
        .padding(.vertical)
        
        Divider()
          .padding(.horizontal, -20)
      }
      .padding(.horizontal)
    }
  }
}

#Preview {
  NavigationView {
    SpellingErrorCommentScreen(comments: .constant(
      [
        0: .init(prayerTitle: "နတ်ပင့်", content: "သမန္တာ စက္ကဝါဠေသု၊", pronunciation: "သမန်တာ စက်ကဝါလေသု", index: 0, comment: ""),
        1: .init(prayerTitle: "နတ်ပင့်", content: "အတြာ ဂစ္ဆန္တု ဒေဝတာ။", pronunciation: "အတြာ ဂစ်ဆန်တု ဒေဝတာ", index: 1, comment: ""),
        2: .init(prayerTitle: "နတ်ပင့်", content: "သဒ္ဓမ္မံ မုနိရာဇဿ၊", pronunciation: "သတ်ဓမံ မုနိရာဇဿ", index: 2, comment: "")
      ]
    ))
  }
  .previewEnvironment()
}
