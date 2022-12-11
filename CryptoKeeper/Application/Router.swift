//
//  Router.swift
//  CryptoKeeper
//
//  Created by Denny on 08.12.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewContorller()
    func showTransaction(coreDataManager: CoreDataManagerProtocol)
    func popToRoot(transaction: Transaction)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController? = nil, assemblyBuilder: AssemblyBuilderProtocol? = nil) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewContorller() {
        if let navigationController = navigationController {
            guard let mainViewContorller = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainViewContorller]
        }
    }
    
    func showTransaction(coreDataManager: CoreDataManagerProtocol) {
        if let navigationController = navigationController {
            guard let detailViewContorller = assemblyBuilder?.createTransactionModule(coreDataManager: coreDataManager, router: self) else { return }
            navigationController.pushViewController(detailViewContorller, animated: true)
        }
    }
    
    func popToRoot(transaction: Transaction) {
        print(transaction)
        if let navigationController = navigationController?.viewControllers.first as? MainViewController{
            navigationController.presenter?.updateTransactions(transaction: transaction)
            navigationController.navigationController?.popToViewController(navigationController, animated: true)
        }
    }
}
