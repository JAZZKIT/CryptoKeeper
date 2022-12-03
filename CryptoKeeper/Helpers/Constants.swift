//
//  Constants.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import Foundation

enum CryptoConstants {
    static let categories: [String] = ["Groceries", "Taxi", "Electronics", "Restaurant", "Army", "Other stuff"]
    static let balanceKey = "crypto.keeper.balance"
    static let transactionKey = "crypto.keeper.transaction"
    
    static func getCoinURL() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coindesk.com"
        components.path = "/v1/bpi/currentprice.json"
        return components
    }
}

