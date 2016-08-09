//
//  Cart.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class Cart: Object {

    dynamic var id = 0
    dynamic var totalPrice: Double = 0.0
    var products = List<Product>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(data: JSON) {
        self.init()

        self.id = data["id"].intValue
    }
}