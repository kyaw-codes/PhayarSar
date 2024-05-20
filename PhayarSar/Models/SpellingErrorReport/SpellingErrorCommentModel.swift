//
//  SpellingErrorCommentModel.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 19/05/2024.
//

import Foundation

struct SpellingErrorCommentModel: Identifiable, Hashable {
  var id: Int { index }
  
  let prayerTitle: String
  let content: String
  let pronunciation: String?
  let index: Int
  var comment: String
  
  init(prayerTitle: String, content: String, pronunciation: String?, index: Int, comment: String) {
    self.prayerTitle = prayerTitle
    self.content = content
    self.pronunciation = pronunciation
    self.index = index
    self.comment = comment
  }
}
