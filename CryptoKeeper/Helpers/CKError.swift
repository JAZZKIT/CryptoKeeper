//
//  CKError.swift
//  CryptoKeeper
//
//  Created by Denny on 03.12.2022.
//

import Foundation

enum CKError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case invalidCoreDataRequest = "Unable to save or retrieve data. Please try again."
    case emptyFiled = "Please fill the field😇"
    case emptyBalance = "You run out of money💸"
}
