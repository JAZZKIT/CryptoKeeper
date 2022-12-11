//
//  CoreDataManager.swift
//  CryptoKeeper
//
//  Created by Denny on 02.12.2022.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func saveTransaction(with amount: Double, category: String, completion: (Result<Transaction, CKError>) -> Void)
    func getTransactions(_ fetchOffset: Int, completion: (Result<[Transaction], CKError>) -> Void)
    func getTransactionsCount(completion: (Result<Int, CKError>) -> Void)
    func saveBalance(amout: Double)
    func replenishBalance(amount: Double, completion: (Result<Double, CKError>) -> Void)
    func getBalance(completion: (Result<Double, CKError>) -> Void)
}

struct CoreDataManager: CoreDataManagerProtocol {    
    private let getManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Tramsaction Actions
    func saveTransaction(with amount: Double, category: String, completion: (Result<Transaction, CKError>) -> Void) {
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Balance.fetchRequest()
        
        let newTransaction = Transaction(context: context)
        newTransaction.amount = amount
        newTransaction.category = category
        newTransaction.date = Date()
        
        do {
            let balance = try context.fetch(fetchRequest)
            balance[0].balance -= amount
            try context.save()
            completion(.success(newTransaction))
        } catch {
            completion(.failure(.invalidCoreDataRequest))
        }
    }
    
    func getTransactions(_ fetchOffset: Int, completion: (Result<[Transaction], CKError>) -> Void) {
        var record = [Transaction]()
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = fetchOffset
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let transactions = try context.fetch(fetchRequest)
             
            if transactions.count == 0 {
                completion(.success([]))
                return
            } else {
                for transaction in transactions {
                    record.append(transaction)
                }
            }
        } catch {
            completion(.failure(.invalidCoreDataRequest))
        }
        completion(.success(record))
    }
    
    func getTransactionsCount(completion: (Result<Int, CKError>) -> Void) {
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Transaction.fetchRequest()
        
        do {
            let transactions = try context.fetch(fetchRequest)
            completion(.success(transactions.count))
        } catch {
            completion(.failure(.invalidCoreDataRequest))
        }
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
    
    func replenishBalance(amount: Double, completion: (Result<Double, CKError>) -> Void) {
        let context: NSManagedObjectContext = getManagedObjectContext
        let fetchRequest = Balance.fetchRequest()
        
        do {
            let balance = try context.fetch(fetchRequest)
            
            if balance.isEmpty {
                completion(.success(amount))
                saveBalance(amout: amount)
            } else {
                balance[0].balance += amount
                completion(.success(balance[0].balance))
                try context.save()
            }
        } catch {
            completion(.failure(.invalidCoreDataRequest))
        }
    }
    
    func getBalance(completion: (Result<Double, CKError>) -> Void) {
        let context: NSManagedObjectContext? = getManagedObjectContext
        let fetchRequest = Balance.fetchRequest()
        
        do {
            guard let balance = try context?.fetch(fetchRequest).first else {
                completion(.failure(.invalidCoreDataRequest))
                return
            }
            let userInfo: [String: Double] = ["balance": balance.balance]
            NotificationCenter.default.post(name: Notification.Name(rawValue: CryptoConstants.balanceKey), object: nil, userInfo: userInfo)
            completion(.success(balance.balance))
        } catch {
            completion(.failure(.invalidCoreDataRequest))
        }
    }
}
