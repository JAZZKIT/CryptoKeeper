//
//  CoreDataManager.swift
//  CryptoKeeper
//
//  Created by Denny on 02.12.2022.
//

import UIKit
import CoreData

struct CoreDataManager {
    enum ActionType {
        case income
        case outcome
    }

    static let shared = CoreDataManager()
    
    private init() {}
    
    private let getManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Tramsaction Actions
    func saveTransaction(with amount: Double, category: String) {
        let context: NSManagedObjectContext = getManagedObjectContext
        
        let newTransaction = Transaction(context: context)
        newTransaction.amount = amount
        newTransaction.category = category
        newTransaction.date = Date()
        
        do {
            try context.save()
            let userInfo: [String: Transaction] = ["transaction": newTransaction]
            NotificationCenter.default.post(name: Notification.Name(rawValue: CryptoConstants.transactionKey), object: nil, userInfo: userInfo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
     
    func getTransactions(_ fetchOffset: Int) -> [Transaction] {
        var record = [Transaction]()
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let allElementsCount = try! context.count(for: fetchRequest)
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = fetchOffset
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let transactions = try context.fetch(fetchRequest)
             
            if transactions.count == 0 {
                return []
            } else {
                for transaction in transactions {
                    record.append(transaction)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return record
    }
    
    func getTransactionsCount() -> Int {
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Transaction.fetchRequest()
        
        do {
            let transactions = try context.fetch(fetchRequest)
            return transactions.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    // MARK: - Balance Actions
    func saveBalance(amout: Double) {
        let context: NSManagedObjectContext = getManagedObjectContext
        
        let newBalance = Balance(context: context)
        newBalance.balance = amout
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateBalance(amount: Double, action: ActionType) {
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Balance.fetchRequest()
        
        do {
            let balance = try context.fetch(fetchRequest)
            
            if balance.isEmpty {
                let userInfo: [String: Double] = ["balance": amount]
                NotificationCenter.default.post(name: Notification.Name(rawValue: CryptoConstants.balanceKey), object: nil, userInfo: userInfo)
                saveBalance(amout: amount)
            } else {
                switch action {
                case .income:
                    balance[0].balance += amount
                case .outcome:
                    balance[0].balance -= amount
                }
                let userInfo: [String: Double] = ["balance": balance[0].balance]
                NotificationCenter.default.post(name: Notification.Name(rawValue: CryptoConstants.balanceKey), object: nil, userInfo: userInfo)
                try context.save()
            }
        } catch {
            print("Could not update. \(error))")
        }
    }
    
    func getBalance() -> Balance? {
        let context: NSManagedObjectContext? = getManagedObjectContext
        let fetchRequest = Balance.fetchRequest()
        
        do {
            guard let balance = try context?.fetch(fetchRequest).first else {
                return nil
            }
            let userInfo: [String: Double] = ["balance": balance.balance]
            NotificationCenter.default.post(name: Notification.Name(rawValue: CryptoConstants.balanceKey), object: nil, userInfo: userInfo)
            return balance
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
