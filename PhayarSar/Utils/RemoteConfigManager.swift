//
//  RemoteConfigManager.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 20/05/2024.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

@MainActor
final class RemoteConfigManager: ObservableObject {
  @Published var hasFetched = false
  
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
      let arr = try? JSONDecoder().decode([WhatIsNewFRCModel].self, from: data)
      // todo: 
    }
  }
}
