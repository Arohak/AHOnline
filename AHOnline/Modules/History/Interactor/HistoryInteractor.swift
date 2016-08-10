//
//  HistoryInteractor.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class HistoryInteractor -
class HistoryInteractor {

    weak var output: HistoryInteractorOutput!
}

//MARK: - extension for HistoryInteractorInput -
extension HistoryInteractor: HistoryInteractorInput {
    
    func getHistoryOrders() {
        let historyOrders = DBManager.getHistoryOrders()
        output.historyOrdersDataIsReady(Array(historyOrders))
    }
    
    func configureCartViewControllerFromHistoryOrder(vc: CartViewController, historyOrder: HistoryOrder) {
        vc.historyOrder = historyOrder
        DBManager.configureCartFromHistoryOrder(vc.cart, historyOrder: historyOrder)        
    }
}