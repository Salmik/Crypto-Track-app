//
//  Models.swift
//  CryptoTrack
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String?
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let url: String
    let asset_id: String
}

struct CryptoTableViewCellViewModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
}
