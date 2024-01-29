//
//  NatPintVO.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import Foundation

class NatPintVO: Decodable, CommonPrayerProtocol {
    let id: String
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

let allCommonPrayers: [NatPintVO] = [
  Bundle.main.decode(NatPintVO.self, from: "သြကာသ.json"),
  Bundle.main.decode(NatPintVO.self, from: "စိန်ရောင်ခြည်.json"),
  natPint,
  Bundle.main.decode(NatPintVO.self, from: "သီလတောင်း.json"),
  Bundle.main.decode(NatPintVO.self, from: "သရဏဂုံ.json"),
  Bundle.main.decode(NatPintVO.self, from: "ငါးပါးသီလ.json"),
  Bundle.main.decode(NatPintVO.self, from: "ရှစ်ပါးသီလ.json"),
  Bundle.main.decode(NatPintVO.self, from: "ဆယ်ပါးသီလ.json"),
  Bundle.main.decode(NatPintVO.self, from: "ဘုရားဂုဏ်တော်.json"),
  Bundle.main.decode(NatPintVO.self, from: "တရားဂုဏ်တော်.json"),
  Bundle.main.decode(NatPintVO.self, from: "သံဃာဂုဏ်တော်.json"),
  Bundle.main.decode(NatPintVO.self, from: "Dhammacakka.json"),
  Bundle.main.decode(NatPintVO.self, from: "မေတ္တာသုတ်လာမ္မေတ္တာပွား.json"),
  Bundle.main.decode(NatPintVO.self, from: "ဆယ်မျက်နှာမ္မေတ္တာပွား.json"),
  Bundle.main.decode(NatPintVO.self, from: "အမျှဝေ.json")  
]
