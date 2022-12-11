//
//  NetworkManager.swift
//  CryptoKeeper
//
//  Created by Denny on 03.12.2022.
//

import UIKit

protocol NetworkManagerProtocol {
    func fetchBTCprice(completion: @escaping(Result<Double, CKError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func fetchBTCprice(completion: @escaping (Result<Double, CKError>) -> Void) {
        guard let url = CryptoConstants.getCoinURL().url else  {
            return completion(.failure(.unableToComplete))
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                return completion(.failure(.invalidResponse))
            }
            
            guard let data = data else { return completion(.failure(.invalidData)) }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let newData = try? decoder.decode(Coin.self, from: data)
                guard let price = newData?.bpi.USD.rateFloat else {
                    return completion(.failure(.invalidData))
                }
                return completion(.success(price))
            }
        }.resume()
    }
}
