//
//  MainViewController.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

final class MainViewController: UIViewController {
    var transactions: [Transaction] = []
    var fetchOffset = 0
    private let mainView = MainView()
    
    var presenter: MainViewPresenterProtocol?
    
    override func loadView() {
        view = mainView
    }
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDidLoad()
    }
    
    private func setupViewDidLoad() {
        setup()
        presenter?.getBTC()
        presenter?.getBalance()
        presenter?.getTransactions(fetchOffset: fetchOffset)
    }
    
    // MARK: - Action
    @objc private func addTransaction() {
        presenter?.addTransaction()
    }
    
    @objc private func presentBalanceUpdateAlertController() {
        let ac = UIAlertController(title: "How munch Bitcoin do you want?", message: nil, preferredStyle: .alert)
        ac.addTextField { tf in
            tf.placeholder = "Enter your sum"
        }
        let updateBalance = UIAlertAction(title: "Update", style: .default) { action in
            let textField = ac.textFields?.first
            guard let newBalance = textField?.text else { return }
            if newBalance != "", newBalance.isNumeric {
                let balance = newBalance.split(separator: " ").joined(separator: "%20")
                self.presenter?.replenishBalance(amount: Double(balance)!)
            } else {
                self.presentGFAlertOnMainThread(title: "Something went worng", message: "Please entry only Numeric values", buttonTitle: "OK")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(updateBalance)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Layout
    func setup() {
        navigationItem.title = "🏠 Main"
        mainView.transactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        mainView.upLoadButton.addTarget(self, action: #selector(presentBalanceUpdateAlertController), for: .touchUpInside)
        mainView.transactionsTableVew.delegate = self
        mainView.transactionsTableVew.dataSource = self
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func updateTransactions(transaction: Transaction) {
        DispatchQueue.main.async {
            self.transactions.insert(transaction, at: 0)
            self.mainView.transactionsTableVew.reloadData()
        }
    }
    
    func updateTransactions(transactions: [Transaction]) {
        self.transactions += transactions
        mainView.transactionsTableVew.reloadData()
    }
    
    func updateBalance(balance: Double) {
        mainView.currentBalanceValueLabel.text = "\(balance)$"
    }
    
    func updateBTC(price: Double) {
        mainView.currentBTClabel.text = "$\(price) BTC"
    }
    
    func failure(error: CKError) {
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
    }
}
