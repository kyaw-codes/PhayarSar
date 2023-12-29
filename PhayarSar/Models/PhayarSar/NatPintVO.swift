//
//  NatPintVO.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import Foundation

struct NatPintVO: Decodable, Identifiable {
    var id: String { "NatPint" }
    let title: String
    let about: String
    let body: [NatPintVOBody]
}

struct NatPintVOBody: Decodable, Identifiable {
    var id: String { UUID().uuidString }
    let content: String
    let pronunciation: String
}

let natPint = Bundle.main.decode(NatPintVO.self, from: "NatPint.json")
