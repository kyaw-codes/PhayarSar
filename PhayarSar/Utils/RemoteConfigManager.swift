//
//  RemoteConfigManager.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 20/05/2024.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

private(set) var natpint: PhayarSarModel!
private(set) var သြကာသ: PhayarSarModel!
private(set) var စိန်ရောင်ခြည်: PhayarSarModel!
private(set) var သီလတောင်း: PhayarSarModel!
private(set) var သရဏဂုံ: PhayarSarModel!
private(set) var ငါးပါးသီလ: PhayarSarModel!
private(set) var ရှစ်ပါးသီလ: PhayarSarModel!
private(set) var ဆယ်ပါးသီလ: PhayarSarModel!
private(set) var ဘုရားဂုဏ်တော်: PhayarSarModel!
private(set) var တရားဂုဏ်တော်: PhayarSarModel!
private(set) var သံဃာဂုဏ်တော်: PhayarSarModel!
private(set) var သမ္ဗုဒ္ဓေ: PhayarSarModel!
private(set) var ရှင်သီဝလိ: PhayarSarModel!
private(set) var dhammacakka: PhayarSarModel!
private(set) var အနတ္တလက္ခဏသုတ်: PhayarSarModel!
private(set) var မဟာသမယသုတ်: PhayarSarModel!
private(set) var ဂုဏ်တော်ကွန်ချာ: PhayarSarModel!
private(set) var မစ္ဆရာဇသုတ်: PhayarSarModel!
private(set) var မေတ္တာသုတ်လာမ္မေတ္တာပွား: PhayarSarModel!
private(set) var ဆယ်မျက်နှာမ္မေတ္တာပွား: PhayarSarModel!
private(set) var အမျှဝေ: PhayarSarModel!
private(set) var မင်္ဂလသုတ်: PhayarSarModel!
private(set) var ရတနသုတ်: PhayarSarModel!
private(set) var မေတ္တသုတ်: PhayarSarModel!
private(set) var ခန္ဓသုတ်: PhayarSarModel!
private(set) var မောရသုတ်: PhayarSarModel!
private(set) var ဝဋ္ဋသုတ်: PhayarSarModel!
private(set) var ဓဇဂ္ဂသုတ်: PhayarSarModel!
private(set) var အာဋာနာဋိယသုတ်: PhayarSarModel!
private(set) var အင်္ဂုလိမာလသုတ်: PhayarSarModel!
private(set) var ဗောဇ္ဈင်္ဂသုတ်: PhayarSarModel!
private(set) var ပုဗ္ဗဏှသုတ်: PhayarSarModel!
private(set) var pahtanShortFiles: PhayarSarModel!
private(set) var pahtanLongFiles: PhayarSarModel!

@MainActor
final class RemoteConfigManager: ObservableObject {
  @Published private(set) var hasFetched = false
  @Published private(set) var whisnwModels: [WhatIsNewFRCModel] = []
  @Published private(set) var minAppVersion: String  = "1.0.0"
  @Published private(set) var latestAppVersion: String = "1.0.0"
  @Published private (set) var phayarsars: AllPhayarSar?
  
  private var remoteConfig: RemoteConfig
  
  init() {
    remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    #if DEBUG
    settings.minimumFetchInterval = 0
    #endif
    remoteConfig.configSettings = settings
  }

  func fetch() {
    Task {
      if
        let status = try? await remoteConfig.fetchAndActivate(),
        status == .successUsingPreFetchedData || status == .successFetchedFromRemote
      {
        setupConfigData()
        hasFetched = true
      } else {
        hasFetched = true
      }
    }
  }
  
  private func setupConfigData() {
    if let str = remoteConfig["what_is_new"].stringValue, let data = str.data(using: .utf8) {
      whisnwModels = (try? JSONDecoder().decode([WhatIsNewFRCModel].self, from: data)) ?? []
    }
    
    if let str = remoteConfig["minimum_app_version"].stringValue {
      minAppVersion = str
    }
    
    if let str = remoteConfig["latest_app_version"].stringValue {
      latestAppVersion = str
    }
    
    if let str = remoteConfig["phayarsars"].stringValue, let data = str.data(using: .utf8) {
      phayarsars = (try? JSONDecoder().decode(AllPhayarSar.self, from: data))
      natpint = phayarsars!.NatPint
      သြကာသ = phayarsars!.သြကာသ
      စိန်ရောင်ခြည် = phayarsars!.စိန်ရောင်ခြည်
      သီလတောင်း = phayarsars!.သီလတောင်း
      သရဏဂုံ = phayarsars!.သရဏဂုံ
      ငါးပါးသီလ = phayarsars!.ငါးပါးသီလ
      ရှစ်ပါးသီလ = phayarsars!.ရှစ်ပါးသီလ
      ဆယ်ပါးသီလ = phayarsars!.ဆယ်ပါးသီလ
      ဘုရားဂုဏ်တော် = phayarsars!.ဘုရားဂုဏ်တော်
      တရားဂုဏ်တော် = phayarsars!.တရားဂုဏ်တော်
      သံဃာဂုဏ်တော် = phayarsars!.သံဃာဂုဏ်တော်
      သမ္ဗုဒ္ဓေ = phayarsars!.သမ္ဗုဒ္ဓေ
      ရှင်သီဝလိ = phayarsars!.ရှင်သီဝလိ
      dhammacakka = phayarsars!.Dhammacakka
      အနတ္တလက္ခဏသုတ် = phayarsars!.အနတ္တလက္ခဏသုတ်
      မဟာသမယသုတ် = phayarsars!.မဟာသမယသုတ်
      ဂုဏ်တော်ကွန်ချာ = phayarsars!.ဂုဏ်တော်ကွန်ချာ
      မစ္ဆရာဇသုတ် = phayarsars!.မစ္ဆရာဇသုတ်
      မေတ္တာသုတ်လာမ္မေတ္တာပွား = phayarsars!.မေတ္တာသုတ်လာမ္မေတ္တာပွား
      ဆယ်မျက်နှာမ္မေတ္တာပွား = phayarsars!.ဆယ်မျက်နှာမ္မေတ္တာပွား
      အမျှဝေ = phayarsars!.အမျှဝေ
      မင်္ဂလသုတ် = phayarsars!.မင်္ဂလသုတ်
      ရတနသုတ် = phayarsars!.ရတနသုတ်
      မေတ္တသုတ် = phayarsars!.မေတ္တသုတ်
      ခန္ဓသုတ် = phayarsars!.ခန္ဓသုတ်
      မောရသုတ် = phayarsars!.မောရသုတ်
      ဝဋ္ဋသုတ် = phayarsars!.ဝဋ္ဋသုတ်
      ဓဇဂ္ဂသုတ် = phayarsars!.ဓဇဂ္ဂသုတ်
      အာဋာနာဋိယသုတ် = phayarsars!.အာဋာနာဋိယသုတ်
      အင်္ဂုလိမာလသုတ် = phayarsars!.အင်္ဂုလိမာလသုတ်
      ဗောဇ္ဈင်္ဂသုတ် = phayarsars!.ဗောဇ္ဈင်္ဂသုတ်
      ပုဗ္ဗဏှသုတ် = phayarsars!.ပုဗ္ဗဏှသုတ်
      pahtanShortFiles = phayarsars!.ပဋ္ဌာန်းအကျဥ်း
      pahtanLongFiles = phayarsars!.ပဋ္ဌာန်းအကျယ်
    }
  }
}

struct AllPhayarSar: Decodable {
  var Dhammacakka: PhayarSarModel
  var NatPint: PhayarSarModel
  var ခန္ဓသုတ်: PhayarSarModel
  var ဂုဏ်တော်ကွန်ချာ: PhayarSarModel
  var ငါးပါးသီလ: PhayarSarModel
  var စိန်ရောင်ခြည်: PhayarSarModel
  var ဆယ်ပါးသီလ: PhayarSarModel
  var ဆယ်မျက်နှာမ္မေတ္တာပွား: PhayarSarModel
  var တရားဂုဏ်တော်: PhayarSarModel
  var ဓဇဂ္ဂသုတ်: PhayarSarModel
  var ပဋ္ဌာန်းအကျယ်: PhayarSarModel
  var ပဋ္ဌာန်းအကျဥ်း: PhayarSarModel
  var ပုဗ္ဗဏှသုတ်: PhayarSarModel
  var ဗောဇ္ဈင်္ဂသုတ်: PhayarSarModel
  var ဘုရားဂုဏ်တော်: PhayarSarModel
  var မင်္ဂလသုတ်: PhayarSarModel
  var မစ္ဆရာဇသုတ်: PhayarSarModel
  var မဟာသမယသုတ်: PhayarSarModel
  var မေတ္တသုတ်: PhayarSarModel
  var မေတ္တာသုတ်လာမ္မေတ္တာပွား: PhayarSarModel
  var မောရသုတ်: PhayarSarModel
  var ရတနသုတ်: PhayarSarModel
  var ရှင်သီဝလိ: PhayarSarModel
  var ရှစ်ပါးသီလ: PhayarSarModel
  var ဝဋ္ဋသုတ်: PhayarSarModel
  var သံဃာဂုဏ်တော်: PhayarSarModel
  var သမ္ဗုဒ္ဓေ: PhayarSarModel
  var သရဏဂုံ: PhayarSarModel
  var သြကာသ: PhayarSarModel
  var သီလတောင်း: PhayarSarModel
  var အင်္ဂုလိမာလသုတ်: PhayarSarModel
  var အနတ္တလက္ခဏသုတ်: PhayarSarModel
  var အမျှဝေ: PhayarSarModel
  var အာဋာနာဋိယသုတ်: PhayarSarModel
}
