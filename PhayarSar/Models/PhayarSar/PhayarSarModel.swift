//
//  PhayarSarModel.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import Foundation

class PhayarSarModel: Decodable, Equatable, CommonPrayerProtocol {
  static func == (lhs: PhayarSarModel, rhs: PhayarSarModel) -> Bool {
    lhs.id == rhs.id
  }
  
    let id: String
    let title: String
    let about: String
    var body: [PhayarSarBodyModel]
}

class PhayarSarBodyModel: Decodable, CommonPrayerBodyProtocol {
    lazy var id: String = UUID().uuidString

    let content: String
    let pronunciation: String
    var isBlur: Bool
    
    enum CodingKeys: CodingKey {
        case content
        case pronunciation
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.pronunciation = try container.decode(String.self, forKey: .pronunciation)
        self.isBlur = true
    }
}
