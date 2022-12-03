//
//  TransactionViewController.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

final class TransactionViewController: UIViewController {
    var bitcoinImageView = UIImageView()
    var titleLabel = UILabel()
    var textField = TextField()
    var categoryPicker = UIPickerView()
    var selectedCategory = "Groceries"
    
    private lazy var confirmTransactionButton: GradientButton = {
        let button = GradientButton(title: "Confirm Transaction", size: 20)
        button.gradientLayer.cornerRadius = 12
        button.addTarget(self, action: #selector(confirmTransaction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        style()
        layout()
    }
    
    private func configureController() {
        view.backgroundColor = .systemBackground
        title = "New Transaction"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
    }
}

// MARK: - Actions
extension TransactionViewController {
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func confirmTransaction() {
        if textField.text == "" {
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: "Please fill the field😇", buttonTitle: "OK")
        } else {
            
            if let amount = Double(textField.text ?? "0"), let balance = CoreDataManager.shared.getBalance(), balance.balance - amount >= 0 {
                CoreDataManager.shared.saveTransaction(with: amount, category: selectedCategory)
                CoreDataManager.shared.updateBalance(amount: amount, action: .outcome)
                dismiss(animated: true)
            } else {
                self.presentGFAlertOnMainThread(title: "Opps..", message: "You run out of money💸", buttonTitle: "OK")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension TransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension TransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CryptoConstants.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = CryptoConstants.categories[row]
        return category
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = CryptoConstants.categories[row]
    }
}

// MARK: - UI Configuration
extension TransactionViewController {
    private func style() {
        bitcoinImageView.translatesAutoresizingMaskIntoConstraints = false
        bitcoinImageView.contentMode = .scaleAspectFit
        bitcoinImageView.image = UIImage(named: "bitcoin")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .black
        titleLabel.text = "Let's check blockchain 💰"
        titleLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 25)
        
        textField.delegate = self
        
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    private func layout() {
        view.addSubviews(bitcoinImageView, titleLabel, textField, categoryPicker, confirmTransactionButton)
    
        NSLayoutConstraint.activate([
            bitcoinImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            bitcoinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bitcoinImageView.heightAnchor.constraint(equalToConstant: 200),
            bitcoinImageView.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: bitcoinImageView.bottomAnchor, constant: 20),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryPicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            confirmTransactionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            confirmTransactionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            confirmTransactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
    }
}
