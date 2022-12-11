//
//  MainViewContorller+TableView.swift
//  CryptoKeeper
//
//  Created by Denny on 11.12.2022.
//

import UIKit

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
            if let count = presenter?.getTransactionsCount, count > 20 { //CoreDataManager.shared.getTransactionsCount() > 20 {
                fetchOffset += 20
                presenter?.getTransactions(fetchOffset: fetchOffset)
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
