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

let natPint = Bundle.main.decode(PhayarSarModel.self, from: "NatPint.json")

let cantotkyo: [PhayarSarModel] = [
  Bundle.main.decode(PhayarSarModel.self, from: "သြကာသ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "စိန်ရောင်ခြည်.json"),
  natPint,
  Bundle.main.decode(PhayarSarModel.self, from: "သီလတောင်း.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "သရဏဂုံ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ငါးပါးသီလ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ရှစ်ပါးသီလ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဆယ်ပါးသီလ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဘုရားဂုဏ်တော်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "တရားဂုဏ်တော်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "သံဃာဂုဏ်တော်.json")
]

let others = [
  Bundle.main.decode(PhayarSarModel.self, from: "သမ္ဗုဒ္ဓေ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ရှင်သီဝလိ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "Dhammacakka.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "အနတ္တလက္ခဏသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "မဟာသမယသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဂုဏ်တော်ကွန်ချာ.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "မစ္ဆရာဇသုတ်.json")
]

let myittarPoe: [PhayarSarModel] = [
  Bundle.main.decode(PhayarSarModel.self, from: "မေတ္တာသုတ်လာမ္မေတ္တာပွား.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဆယ်မျက်နှာမ္မေတ္တာပွား.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "အမျှဝေ.json")
]

let payeik: [PhayarSarModel] = [
  Bundle.main.decode(PhayarSarModel.self, from: "မင်္ဂလသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ရတနသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "မေတ္တသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ခန္ဓသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "မောရသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဝဋ္ဋသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဓဇဂ္ဂသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "အာဋာနာဋိယသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "အင်္ဂုလိမာလသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ဗောဇ္ဈင်္ဂသုတ်.json"),
  Bundle.main.decode(PhayarSarModel.self, from: "ပုဗ္ဗဏှသုတ်.json"),
]

let pahtanShort = Bundle.main.decode(PhayarSarModel.self, from: "ပဋ္ဌာန်းအကျဥ်း.json")
let pahtanLong = Bundle.main.decode(PhayarSarModel.self, from: "ပဋ္ဌာန်းအကျယ်.json")

let allPrayers = cantotkyo + others + myittarPoe + payeik + [pahtanShort, pahtanLong]
