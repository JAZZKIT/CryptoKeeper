//
//  TransactionTableViewCell.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    static let id = "TransactionTableViewCell"
    
    var transactionLabel: CKTitleLabel = {
       let label = CKTitleLabel()
        label.text = "Groceries"
        label.font = UIFont(name: "BrandonGrotesque-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var transactionValueLabel: CKTitleLabel = {
       let label = CKTitleLabel()
        label.text = "-555$"
        label.font = UIFont(name: "BrandonGrotesque-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionImageView: UIImageView = {
        let image = UIImage(named: "Other Stuff")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var transactionDateLabel: CKTitleLabel = {
       let label = CKTitleLabel()
        label.text = "Jun"
        label.font = UIFont(name: "BrandonGrotesque-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(transactionLabel)
        addSubview(transactionValueLabel)
        addSubview(transactionImageView)
        addSubview(transactionDateLabel)
        
        NSLayoutConstraint.activate([
            transactionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            transactionImageView.heightAnchor.constraint(equalToConstant: 30),
            transactionImageView.widthAnchor.constraint(equalToConstant: 30),
            
            transactionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            transactionLabel.leadingAnchor.constraint(equalTo: transactionImageView.trailingAnchor, constant: 10),
            
            transactionDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            transactionDateLabel.leadingAnchor.constraint(equalTo: transactionLabel.trailingAnchor, constant: 10),
            
            transactionValueLabel.topAnchor.constraint(equalTo: transactionDateLabel.topAnchor),
            transactionValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
