//
//  CartInteractor.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class CartInteractor -
class CartInteractor {

    weak var output: CartInteractorOutput!
    
    func getOrdersTotalPrice() -> Double {
       return DBManager.getOrdersTotalPrice()
    }
    
    func getUser() -> User {
        return DBManager.getUser()
    }
}

//MARK: - extension for CartInteractorInput -
extension CartInteractor: CartInteractorInput {
    
    func getOrders() {
        let orders = DBManager.getOrders()
        let user = getUser()
        let price = getOrdersTotalPrice()
        output.ordersDataIsReady(user, orders: Array(orders), ordersPrice: price)
    }
    
    func getDeliveries() {
        _ = APIManager.getDeliveries()
            .subscribe(onNext: { result in
                if result != nil {
                    var deliveries: [Delivery] = []
                    for item in result["data"].arrayValue {
                        deliveries.append(Delivery(data: item))
                    }
                    
                    self.output.deliveriesDataIsReady(deliveries)
                }
            })
    }
    
    func updateOrder(product: Product, count: Int) {
        DBManager.updateOrder(product, count: count)
        output.ordersPriceDataIsReady(getOrdersTotalPrice())
    }
    
    func removeOrder(product: Product) {
        DBManager.removeOrder(product)
        output.ordersPriceDataIsReady(getOrdersTotalPrice())
    }
    
    func removeOrders(products: [Product]) {
        for product in products {
            DBManager.removeOrder(product)
        }
    }
}