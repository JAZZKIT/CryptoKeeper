//
//  TransactionPresenter.swift
//  CryptoKeeper
//
//  Created by Denny on 09.12.2022.
//

import Foundation

// Output
protocol TransactionViewProtocol: AnyObject {
    func failure(error: CKError)
}

// Input
protocol TransactionPresenterProtocol: AnyObject {
    init(view: TransactionViewProtocol, coreDataManager: CoreDataManagerProtocol, router: RouterProtocol)
    func saveTransaction(with amount: String, category: String)
}

class TransactionPresenter: TransactionPresenterProtocol {
    weak var view: TransactionViewProtocol?
    var router: RouterProtocol?
    private let coreDataManager: CoreDataManagerProtocol?
    private var balance: Double = 0
    
    required init(view: TransactionViewProtocol, coreDataManager: CoreDataManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.router = router
        getBalance()
    }
    
    func getBalance() {
        coreDataManager?.getBalance { [weak self] result in
            guard let stongSelf = self else { return }
            
            switch result {
            case .success(let balance):
                stongSelf.balance = balance
            case .failure(let error):
                stongSelf.view?.failure(error: error)
            }
        }
    }
    
    func saveTransaction(with amount: String, category: String) {
        if amount == "" {
            view?.failure(error: .emptyFiled)
        } else {
            if let amount = Double(amount), balance - amount >= 0 {
                coreDataManager?.saveTransaction(with: amount, category: category) { [weak self] result in
                    guard let stongSelf = self else { return }
                    
                    switch result {
                    case .success(let transaction):
                        stongSelf.router?.popToRoot(transaction: transaction)
                    case .failure(let error):
                        stongSelf.view?.failure(error: error)
                    }
                }
            } else {
                view?.failure(error: .emptyBalance)
            }
        }
    }
}
