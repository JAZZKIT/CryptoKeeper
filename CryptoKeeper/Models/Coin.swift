//
//  Coin.swift
//  CryptoKeeper
//
//  Created by Denny on 03.12.2022.
//

import Foundation

struct Coin: Decodable {
    let bpi: USD
}

struct USD: Decodable {
    let USD: Data
}

struct Data: Decodable {
    let rateFloat: Double
}

