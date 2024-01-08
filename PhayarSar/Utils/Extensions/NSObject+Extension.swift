//
//  NSObject+Extension.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 08/01/2024.
//

import Foundation

extension NSObject {
  var className: String {
    return String(describing: type(of: self))
  }
  
  class var className: String {
    return String(describing: self)
  }
}
