//
//  Date+.swift
//  CryptoKeeper
//
//  Created by Denny on 02.12.2022.
//

import Foundation

extension Date {
    func toDay() -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: self)
    }
}
 
