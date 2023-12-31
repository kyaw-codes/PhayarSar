//
//  NatPintVO.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 03/12/2023.
//

import Foundation

protocol CommonPrayerProtocol: Identifiable {
    associatedtype Body: CommonPrayerBodyProtocol
    
    var id: String { get }
    var title: String { get }
    var about: String { get }
    var body: [Body] { get }
}

protocol CommonPrayerBodyProtocol: Identifiable {
    var id: String { get }
    var content: String { get }
    var pronunciation: String { get }
}

struct NatPintVO: Decodable, CommonPrayerProtocol {
    var id: String { "NatPint" }
    let title: String
    let about: String
    let body: [NatPintVOBody]
}

struct NatPintVOBody: Decodable, CommonPrayerBodyProtocol {
    var id: String { UUID().uuidString }
    let content: String
    let pronunciation: String
}

let natPint = Bundle.main.decode(NatPintVO.self, from: "NatPint.json")
