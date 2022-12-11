//
//  MainPresenter.swift
//  CryptoKeeper
//
//  Created by Denny on 08.12.2022.
//

import Foundation

// Output
protocol MainViewProtocol: AnyObject {
    func updateTransactions(transactions: [Transaction])
    func updateTransactions(transaction: Transaction)
    func updateBTC(price: Double)
    func updateBalance(balance: Double)
    func failure(error: CKError)
}

// Input
protocol MainViewPresenterProtocol {
    var getTransactionsCount: Int { get }
    
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, router: RouterProtocol)
    func addTransaction()
    func getTransactions(fetchOffset: Int)
    func getBalance()
    func getBTC()
    func replenishBalance(amount: Double)
    func updateTransactions(transaction: Transaction)
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    private let networkManager: NetworkManagerProtocol?
    private let coreDataManager: CoreDataManagerProtocol?

    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.router = router
    }
    
    @objc func addTransaction() {
        guard let coreDataManager = coreDataManager else { return }
        router?.showTransaction(coreDataManager: coreDataManager)
    }
    
    var getTransactionsCount: Int {
        var count = 0
        
        coreDataManager?.getTransactionsCount { [weak self] result in
            guard let stongSelf = self else { return }
            switch result {
            case .success(let transactionCount):
                count = transactionCount
            case .failure(let error):
                stongSelf.view?.failure(error: error)
            }
        }

        return count
    }
    
    func replenishBalance(amount: Double) {
        coreDataManager?.replenishBalance(amount: amount) { [weak self] result in
            guard let stongSelf = self else { return }
            
            switch result {
            case .success(let balance):
                stongSelf.view?.updateBalance(balance: balance)
            case .failure(let error):
                stongSelf.view?.failure(error: error)
            }
        }
    }
    
    func updateTransactions(transaction: Transaction) {
        getBalance()
        view?.updateTransactions(transaction: transaction)
    }
    
    func getTransactions(fetchOffset: Int) {
        coreDataManager?.getTransactions(fetchOffset) { [weak self] result in
            guard let stongSelf = self else { return }
            
            switch result {
            case .success(let transactions):
                stongSelf.view?.updateTransactions(transactions: transactions)
            case .failure(let error):
                stongSelf.view?.failure(error: error)
            }
        }
    }
    
    func getBalance() {
        coreDataManager?.getBalance { [weak self] result in
            guard let stongSelf = self else { return }
            
            switch result {
            case .success(let balance):
                stongSelf.view?.updateBalance(balance: balance)
            case .failure(let error):
                stongSelf.view?.failure(error: error)
            }
        }
    }
    
    func getBTC() {
        networkManager?.fetchBTCprice { [weak self] result in
            guard let stongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let price):
                    stongSelf.view?.updateBTC(price: price)
                case .failure(let error):
                    stongSelf.view?.failure(error: error)
                }
            }
        }
    }
}
