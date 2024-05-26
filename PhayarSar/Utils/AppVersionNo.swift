//
//  AppVersionNo.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 25/05/2024.
//

import Foundation

let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"

func isCurrentVersionLower(minimumVersion: String) -> Bool {
  var currentComponents = appVersion.split(separator: ".").compactMap { Int($0) }
  var minimumComponents = minimumVersion.split(separator: ".").compactMap { Int($0) }
  
  while currentComponents.count <= 3 {
    currentComponents.append(0)
  }
  
  while minimumComponents.count <= 3 {
    minimumComponents.append(0)
  }

  // Compare major, minor, and patch versions
  for i in 0..<3 {
    if currentComponents[i] < minimumComponents[i] {
      return true
    } else if currentComponents[i] > minimumComponents[i] {
      return false
    }
  }
  
  // Versions are equal
  return false
}
