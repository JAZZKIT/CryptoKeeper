//
//  MainViewController.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

final class MainViewController: UIViewController {
    private var transactions: [Transaction] = []
    private var fetchOffset = 0
    let balance = Notification.Name(rawValue: CryptoConstants.balanceKey)
    let transaction = Notification.Name(rawValue: CryptoConstants.transactionKey)
    
    //MARK: - Balance UI
    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentBalanceLabel, currentBalanceValueLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let currentBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "🏦 Current Balance"
        label.textColor = UIColor.systemPurple
        label.font = UIFont(name: "BrandonGrotesque-Medium", size: 25)
        return label
    }()
    
    private let currentBalanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0$"
        label.font = UIFont(name: "BrandonGrotesque-Bold", size: 40)
        return label
    }()
    
    private let currentBTClabel: CKTitleLabel = {
        let label = CKTitleLabel(textAligment: .center, fontSize: 25)
        label.text = "Loading..."
        label.textColor = UIColor.systemPurple
        return label
    }()
    
    // MARK: - Transaction button
    private lazy var transactionButton: GradientButton = {
        let button = GradientButton(title: "Add Transaction", size: 20)
        button.gradientLayer.cornerRadius = 12
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - UpLoad button
    private lazy var upLoadButton: GradientButton = {
        let button = GradientButton(title: "+", size: 100)
        button.gradientLayer.cornerRadius = 50
        button.addTarget(self, action: #selector(presentBalanceUpdateAlertController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - TransactionsTableView
    private lazy var transactionsTableVew: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDidLoad()
    }
    
    private func setupViewDidLoad() {
        view.backgroundColor = .white
        navigationItem.title = "🏠 Main"
        layout()
        createObservers()
        CoreDataManager.shared.getBalance()
        transactions = CoreDataManager.shared.getTransactions(fetchOffset)
        getBTC()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    func getBTC() {
        NetworkManager.shared.fetchBTCprice { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { self.currentBTClabel.text = "$\(success) BTC" }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @objc private func addTransaction() {
        let transactionViewController = TransactionViewController()
        let navController = UINavigationController(rootViewController: transactionViewController)
        present(navController, animated: true)
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
                CoreDataManager.shared.updateBalance(amount: Double(balance)!, action: .income)
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
    private func layout() {
        view.addSubviews(balanceStackView, upLoadButton, currentBTClabel, transactionButton, transactionsTableVew)
        
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 20),
            balanceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            upLoadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upLoadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            upLoadButton.widthAnchor.constraint(equalToConstant: 100),
            upLoadButton.heightAnchor.constraint(equalToConstant: 100),
            
            currentBTClabel.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10),
            currentBTClabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentBTClabel.heightAnchor.constraint(equalToConstant: 28),

            transactionButton.topAnchor.constraint(equalTo: currentBTClabel.bottomAnchor, constant: 10),
            transactionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            transactionsTableVew.topAnchor.constraint(equalTo: transactionButton.bottomAnchor, constant: 10),
            transactionsTableVew.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionsTableVew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableVew.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.id) as! TransactionTableViewCell
        
        cell.transactionLabel.text = transactions[indexPath.row].category
        cell.transactionValueLabel.text = String(transactions[indexPath.row].amount)
        cell.transactionDateLabel.text = transactions[indexPath.row].date?.toDay()
        cell.transactionImageView.image = UIImage(named: transactions[indexPath.row].category ?? "Other Stuff")
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 50.0 {
            if CoreDataManager.shared.getTransactionsCount() > 20 {
                fetchOffset += 20
                transactions += CoreDataManager.shared.getTransactions(fetchOffset)
                transactionsTableVew.reloadData()
            }
        }
    }
}

// MARK: - TransactionsTableViewHeader
extension MainViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 75))
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: -25, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "Transactions"
        label.textColor = .gray
        label.font = UIFont(name: "BrandonGrotesque-Medium", size: 25)
        headerView.addSubview(label)
        
        return headerView
    }
}

// MARK: - Notification Center
extension MainViewController {
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateBalance(notification:)), name: balance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateTransactions(notification:)), name: transaction, object: nil)
    }
    
    @objc func updateBalance(notification: Notification) {
        if let balance = notification.userInfo?["balance"] as? Double {
            DispatchQueue.main.async {
                self.currentBalanceValueLabel.text = "\(balance)$"
            }
        }
    }
    
    @objc func updateTransactions(notification: Notification) {
        if let transaction = notification.userInfo?["transaction"] as? Transaction {
            DispatchQueue.main.async {
                self.transactions.insert(transaction, at: 0)
                self.transactionsTableVew.reloadData()
            }
        }
    }
}
