//
//  PhayarSarRepository.swift
//  PhayarSar
//
//  Created by Htain Lin Shwe on 08/05/2024.
//

import Foundation

enum PhayarSarType: String, CaseIterable {
    case natPint
    case cantotkyo
    case others
    case myittarPoe
    case payeik
    case pahtanShort
    case pahtanLong
}

var allPrayers = PhayarSarType.allCases.flatMap { PhayarSarRepository.getData(type: $0) }

struct PhayarSarRepository {
    static func getData(type: PhayarSarType) -> [PhayarSarModel] {
        switch type {
        case .natPint:
            return [natpint]
        case .cantotkyo:
          return [
            သြကာသ,
            စိန်ရောင်ခြည်,
            natpint,
            သီလတောင်း,
            သရဏဂုံ,
            ငါးပါးသီလ,
            ရှစ်ပါးသီလ,
            ဆယ်ပါးသီလ,
            ဘုရားဂုဏ်တော်,
            တရားဂုဏ်တော်,
            သံဃာဂုဏ်တော်
        ]
        case .others:
            return [
              သမ္ဗုဒ္ဓေ,
              ရှင်သီဝလိ,
              dhammacakka,
              အနတ္တလက္ခဏသုတ်,
              မဟာသမယသုတ်,
              ဂုဏ်တော်ကွန်ချာ,
              မစ္ဆရာဇသုတ်
            ]
        case .myittarPoe:
          return [
            မေတ္တာသုတ်လာမ္မေတ္တာပွား,
            ဆယ်မျက်နှာမ္မေတ္တာပွား,
            အမျှဝေ,
          ]
        case .payeik:
          return [
            မင်္ဂလသုတ်,
            ရတနသုတ်,
            မေတ္တသုတ်,
            ခန္ဓသုတ်,
            မောရသုတ်,
            ဝဋ္ဋသုတ်,
            ဓဇဂ္ဂသုတ်,
            အာဋာနာဋိယသုတ်,
            အင်္ဂုလိမာလသုတ်,
            ဗောဇ္ဈင်္ဂသုတ်,
            ပုဗ္ဗဏှသုတ်,
          ]
        case .pahtanShort:
          return [pahtanShortFiles]
        case .pahtanLong:
          return [pahtanLongFiles]
        }
    }
    
}
