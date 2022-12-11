//
//  MainView.swift
//  CryptoKeeper
//
//  Created by Denny on 10.12.2022.
//

import UIKit

class MainView: UIView {
    let balanceStackView = UIStackView()
    let currentBalanceLabel = UILabel()
    let currentBalanceValueLabel = UILabel()
    let currentBTClabel = CKTitleLabel()
    let transactionButton = GradientButton(title: "Add Transaction", size: 20)
    let upLoadButton = GradientButton(title: "+", size: 100)
    let transactionsTableVew = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    func style() {
        backgroundColor = .systemBackground

        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        balanceStackView.axis = .vertical
        balanceStackView.spacing = 10

        currentBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        currentBalanceLabel.text = "🏦 Current Balance"
        currentBalanceLabel.textColor = UIColor.systemPurple
        currentBalanceLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 25)

        currentBalanceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        currentBalanceValueLabel.text = "0$"
        currentBalanceValueLabel.font = UIFont(name: "BrandonGrotesque-Bold", size: 40)

        currentBTClabel.text = "Loading..."
        currentBTClabel.textColor = UIColor.systemPurple

        transactionButton.translatesAutoresizingMaskIntoConstraints = false
        transactionButton.gradientLayer.cornerRadius = 12

        upLoadButton.translatesAutoresizingMaskIntoConstraints = false
        upLoadButton.gradientLayer.cornerRadius = 50

        transactionsTableVew.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableVew.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.id)
        transactionsTableVew.separatorStyle = .none
        transactionsTableVew.rowHeight = 50
    }
    
    //MARK: - Layout
    func layout() {
        balanceStackView.addArrangedSubview(currentBalanceLabel)
        balanceStackView.addArrangedSubview(currentBalanceValueLabel)
        
        addSubviews(balanceStackView, upLoadButton, currentBTClabel, transactionButton, transactionsTableVew)
        
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            balanceStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            upLoadButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            upLoadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            upLoadButton.widthAnchor.constraint(equalToConstant: 100),
            upLoadButton.heightAnchor.constraint(equalToConstant: 100),
            
            currentBTClabel.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10),
            currentBTClabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentBTClabel.heightAnchor.constraint(equalToConstant: 28),

            transactionButton.topAnchor.constraint(equalTo: currentBTClabel.bottomAnchor, constant: 10),
            transactionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            transactionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            transactionsTableVew.topAnchor.constraint(equalTo: transactionButton.bottomAnchor, constant: 10),
            transactionsTableVew.bottomAnchor.constraint(equalTo: bottomAnchor),
            transactionsTableVew.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionsTableVew.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
