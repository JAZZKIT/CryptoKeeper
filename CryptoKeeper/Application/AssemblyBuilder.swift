//
//  AssemblyBuilder.swift
//  CryptoKeeper
//
//  Created by Denny on 08.12.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createTransactionModule(coreDataManager: CoreDataManagerProtocol, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkManager = NetworkManager()
        let coreDataManager = CoreDataManager()
        let presenter = MainPresenter(view: view, networkManager: networkManager, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createTransactionModule(coreDataManager: CoreDataManagerProtocol, router: RouterProtocol) -> UIViewController {
        let view = TransactionViewController()
        let presenter = TransactionPresenter(view: view, coreDataManager: coreDataManager, router: router)
        view.presenter = presenter
        
        return view
    }
}
