//
//  NatPintVO.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import Foundation

protocol CommonPrayerProtocol: Identifiable {
    associatedtype Body: CommonPrayerBodyProtocol
    
    var id: String { get }
    var title: String { get }
    var about: String { get }
    var body: [Body] { get set }
}

protocol CommonPrayerBodyProtocol: Identifiable {
    var id: String { get }
    var content: String { get }
    var pronunciation: String { get }
    var isBlur: Bool { get set }
}

extension Array where Element: CommonPrayerBodyProtocol {
    func index(of element: some CommonPrayerBodyProtocol) -> Int {
        self.firstIndex(where: { $0.id == element.id }) ?? 0
    }
}

class NatPintVO: Decodable, CommonPrayerProtocol {
    var id: String { "NatPint" }
    let title: String
    let about: String
    var body: [NatPintVOBody]
}

class NatPintVOBody: Decodable, CommonPrayerBodyProtocol {
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

let natPint = Bundle.main.decode(NatPintVO.self, from: "NatPint.json")
