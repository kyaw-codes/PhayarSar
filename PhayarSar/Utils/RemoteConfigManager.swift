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

private var cachedFileUrl: URL = {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  let documentsDirectory = paths[0]
  return URL(fileURLWithPath: documentsDirectory.path).appendingPathComponent("frccache.txt")
}()

@MainActor
final class RemoteConfigManager: ObservableObject {
  @Published private(set) var hasFetched = false
  @Published private(set) var whisnwModels: [WhatIsNewFRCModel] = []
  @Published private(set) var minAppVersion: String  = "1.0.0"
  @Published private(set) var latestAppVersion: String = "1.0.0"
  @Published private(set) var phayarsars: AllPhayarSar?
  
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
      _ = try? await remoteConfig.fetchAndActivate()
      setupConfigData()
      hasFetched = true
    }
  }
  
  private func decodeModel(from fileName: String) -> PhayarSarModel {
    Bundle.main.decode(PhayarSarModel.self, from: fileName)
  }
  
  private func write(data: Data, to cacheUrl: URL) {
    if FileManager.default.fileExists(atPath: cacheUrl.path) {
      // remove content first
      try? FileManager.default.removeItem(at: cacheUrl)
    }
    
    try? data.write(to: cacheUrl)
  }
  
  private func read(from cacheUrl: URL) -> AllPhayarSar? {
    guard let data = try? String(contentsOf: cacheUrl).data(using: .utf8) else {
      return nil
    }
    return try? JSONDecoder().decode(AllPhayarSar.self, from: data)
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
      write(data: data, to: cachedFileUrl)

      phayarsars = (try? JSONDecoder().decode(AllPhayarSar.self, from: data))
      let cached = read(from: cachedFileUrl)
      
      natpint = phayarsars?.NatPint ?? cached?.NatPint ?? decodeModel(from: "NatPint.json")
      သြကာသ = phayarsars?.သြကာသ ?? cached?.သြကာသ ?? decodeModel(from: "သြကာသ.json")
      စိန်ရောင်ခြည် = phayarsars?.စိန်ရောင်ခြည် ?? cached?.စိန်ရောင်ခြည် ?? decodeModel(from: "စိန်ရောင်ခြည်.json")
      သီလတောင်း = phayarsars?.သီလတောင်း ?? cached?.သီလတောင်း ?? decodeModel(from: "သီလတောင်း.json")
      သရဏဂုံ = phayarsars?.သရဏဂုံ ?? cached?.သရဏဂုံ ?? decodeModel(from: "သရဏဂုံ.json")
      ငါးပါးသီလ = phayarsars?.ငါးပါးသီလ ?? cached?.ငါးပါးသီလ ?? decodeModel(from: "ငါးပါးသီလ.json")
      ရှစ်ပါးသီလ = phayarsars?.ရှစ်ပါးသီလ ?? cached?.ရှစ်ပါးသီလ ?? decodeModel(from: "ရှစ်ပါးသီလ.json")
      ဆယ်ပါးသီလ = phayarsars?.ဆယ်ပါးသီလ ?? cached?.ဆယ်ပါးသီလ ?? decodeModel(from: "ဆယ်ပါးသီလ.json")
      ဘုရားဂုဏ်တော် = phayarsars?.ဘုရားဂုဏ်တော် ?? cached?.ဘုရားဂုဏ်တော် ?? decodeModel(from: "ဘုရားဂုဏ်တော်.json")
      တရားဂုဏ်တော် = phayarsars?.တရားဂုဏ်တော် ?? cached?.တရားဂုဏ်တော် ?? decodeModel(from: "တရားဂုဏ်တော်.json")
      သံဃာဂုဏ်တော် = phayarsars?.သံဃာဂုဏ်တော် ?? cached?.သံဃာဂုဏ်တော် ?? decodeModel(from: "သံဃာဂုဏ်တော်.json")
      သမ္ဗုဒ္ဓေ = phayarsars?.သမ္ဗုဒ္ဓေ ?? cached?.သမ္ဗုဒ္ဓေ ?? decodeModel(from: "သမ္ဗုဒ္ဓေ.json")
      ရှင်သီဝလိ = phayarsars?.ရှင်သီဝလိ ?? cached?.ရှင်သီဝလိ ?? decodeModel(from: "ရှင်သီဝလိ.json")
      dhammacakka = phayarsars?.Dhammacakka ?? cached?.Dhammacakka ?? decodeModel(from: "Dhammacakka.json")
      အနတ္တလက္ခဏသုတ် = phayarsars?.အနတ္တလက္ခဏသုတ် ?? cached?.အနတ္တလက္ခဏသုတ် ?? decodeModel(from: "အနတ္တလက္ခဏသုတ်.json")
      မဟာသမယသုတ် = phayarsars?.မဟာသမယသုတ် ?? cached?.မဟာသမယသုတ် ?? decodeModel(from: "မဟာသမယသုတ်.json")
      ဂုဏ်တော်ကွန်ချာ = phayarsars?.ဂုဏ်တော်ကွန်ချာ ?? cached?.ဂုဏ်တော်ကွန်ချာ ?? decodeModel(from: "ဂုဏ်တော်ကွန်ချာ.json")
      မစ္ဆရာဇသုတ် = phayarsars?.မစ္ဆရာဇသုတ် ?? cached?.မစ္ဆရာဇသုတ် ?? decodeModel(from: "မစ္ဆရာဇသုတ်.json")
      မေတ္တာသုတ်လာမ္မေတ္တာပွား = phayarsars?.မေတ္တာသုတ်လာမ္မေတ္တာပွား ?? cached?.မေတ္တာသုတ်လာမ္မေတ္တာပွား ?? decodeModel(from: "မေတ္တာသုတ်လာမ္မေတ္တာပွား.json")
      ဆယ်မျက်နှာမ္မေတ္တာပွား = phayarsars?.ဆယ်မျက်နှာမ္မေတ္တာပွား ?? cached?.ဆယ်မျက်နှာမ္မေတ္တာပွား ?? decodeModel(from: "ဆယ်မျက်နှာမ္မေတ္တာပွား.json")
      အမျှဝေ = phayarsars?.အမျှဝေ ?? cached?.အမျှဝေ ?? decodeModel(from: "အမျှဝေ.json")
      မင်္ဂလသုတ် = phayarsars?.မင်္ဂလသုတ် ?? cached?.မင်္ဂလသုတ် ?? decodeModel(from: "မင်္ဂလသုတ်.json")
      ရတနသုတ် = phayarsars?.ရတနသုတ် ?? cached?.ရတနသုတ် ?? decodeModel(from: "ရတနသုတ်.json")
      မေတ္တသုတ် = phayarsars?.မေတ္တသုတ် ?? cached?.မေတ္တသုတ် ?? decodeModel(from: "မေတ္တသုတ်.json")
      ခန္ဓသုတ် = phayarsars?.ခန္ဓသုတ် ?? cached?.ခန္ဓသုတ် ?? decodeModel(from: "ခန္ဓသုတ်.json")
      မောရသုတ် = phayarsars?.မောရသုတ် ?? cached?.မောရသုတ် ?? decodeModel(from: "မောရသုတ်.json")
      ဝဋ္ဋသုတ် = phayarsars?.ဝဋ္ဋသုတ် ?? cached?.ဝဋ္ဋသုတ် ?? decodeModel(from: "ဝဋ္ဋသုတ်.json")
      ဓဇဂ္ဂသုတ် = phayarsars?.ဓဇဂ္ဂသုတ် ?? cached?.ဓဇဂ္ဂသုတ် ?? decodeModel(from: "ဓဇဂ္ဂသုတ်.json")
      အာဋာနာဋိယသုတ် = phayarsars?.အာဋာနာဋိယသုတ် ?? cached?.အာဋာနာဋိယသုတ် ?? decodeModel(from: "အာဋာနာဋိယသုတ်.json")
      အင်္ဂုလိမာလသုတ် = phayarsars?.အင်္ဂုလိမာလသုတ် ?? cached?.အင်္ဂုလိမာလသုတ် ?? decodeModel(from: "အင်္ဂုလိမာလသုတ်.json")
      ဗောဇ္ဈင်္ဂသုတ် = phayarsars?.ဗောဇ္ဈင်္ဂသုတ် ?? cached?.ဗောဇ္ဈင်္ဂသုတ် ?? decodeModel(from: "ဗောဇ္ဈင်္ဂသုတ်.json")
      ပုဗ္ဗဏှသုတ် = phayarsars?.ပုဗ္ဗဏှသုတ် ?? cached?.ပုဗ္ဗဏှသုတ် ?? decodeModel(from: "ပုဗ္ဗဏှသုတ်.json")
      pahtanShortFiles = phayarsars?.ပဋ္ဌာန်းအကျဥ်း ?? cached?.ပဋ္ဌာန်းအကျဥ်း ?? decodeModel(from: "ပဋ္ဌာန်းအကျဥ်း.json")
      pahtanLongFiles = phayarsars?.ပဋ္ဌာန်းအကျယ် ?? cached?.ပဋ္ဌာန်းအကျယ် ?? decodeModel(from: "ပဋ္ဌာန်းအကျယ်.json")
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

