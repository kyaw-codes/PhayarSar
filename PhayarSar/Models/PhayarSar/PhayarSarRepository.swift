//
//  PhayarSarRepository.swift
//  PhayarSar
//
//  Created by Htain Lin Shwe on 08/05/2024.
//

import Foundation

enum PhayarSarType {
    case natPint
    case cantotkyo
    case others
    case myittarPoe
    case payeik
    case pahtanShort
    case pahtanLong
}

struct PhayarSarRepository {
    
    private static let natPintFiles = [
        "NatPint.json"
    ]
    
    private static let cantotkyoFiles = [
        "သြကာသ.json",
        "စိန်ရောင်ခြည်.json",
        "NatPint.json",
        "သီလတောင်း.json",
        "သရဏဂုံ.json",
        "ငါးပါးသီလ.json",
        "ရှစ်ပါးသီလ.json",
        "ဆယ်ပါးသီလ.json",
        "ဘုရားဂုဏ်တော်.json",
        "တရားဂုဏ်တော်.json",
        "သံဃာဂုဏ်တော်.json"
    ]

    private static let othersFiles = [
      "သမ္ဗုဒ္ဓေ.json",
      "ရှင်သီဝလိ.json",
      "Dhammacakka.json",
      "အနတ္တလက္ခဏသုတ်.json",
      "မဟာသမယသုတ်.json",
      "ဂုဏ်တော်ကွန်ချာ.json",
      "မစ္ဆရာဇသုတ်.json"
    ]

    private static let myittarPoeFiles = [
      "မေတ္တာသုတ်လာမ္မေတ္တာပွား.json",
      "ဆယ်မျက်နှာမ္မေတ္တာပွား.json",
      "အမျှဝေ.json",
    ]

    private static let payeikFiles  = [
      "မင်္ဂလသုတ်.json",
      "ရတနသုတ်.json",
      "မေတ္တသုတ်.json",
      "ခန္ဓသုတ်.json",
      "မောရသုတ်.json",
      "ဝဋ္ဋသုတ်.json",
      "ဓဇဂ္ဂသုတ်.json",
      "အာဋာနာဋိယသုတ်.json",
      "အင်္ဂုလိမာလသုတ်.json",
      "ဗောဇ္ဈင်္ဂသုတ်.json",
      "ပုဗ္ဗဏှသုတ်.json",
    ]

    private static let pahtanShortFiles = ["ပဋ္ဌာန်းအကျဥ်း.json"]
    private static let pahtanLongFiles = ["ပဋ္ဌာန်းအကျယ်.json"]
    
    private static func decodeModels(from fileNames: [String]) -> [PhayarSarModel] {
        fileNames.compactMap { Bundle.main.decode(PhayarSarModel.self, from: $0) }
    }
    
    static func getData(type: PhayarSarType) -> [PhayarSarModel] {
        switch type {
        case .natPint:
            decodeModels(from: natPintFiles)
        case .cantotkyo:
            decodeModels(from: cantotkyoFiles)
        case .others:
            decodeModels(from: othersFiles)
        case .myittarPoe:
            decodeModels(from: myittarPoeFiles)
        case .payeik:
            decodeModels(from: payeikFiles)
        case .pahtanShort:
            decodeModels(from: pahtanShortFiles)
        case .pahtanLong:
            decodeModels(from: pahtanLongFiles)
        }
    }
    
}
