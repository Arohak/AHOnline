//
//  ProductViewOutput.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

protocol ProductViewOutput {

    func getProducts(requestType: RequestType, json: JSON)
    func addProductBuy(product: Product)
    func favoriteButtonClicked(product: Product)
}
