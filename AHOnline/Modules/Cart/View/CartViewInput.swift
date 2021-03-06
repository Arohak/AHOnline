//
//  CartViewInput.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

protocol CartViewInput: class {

    func userComing(user: User)
    func updateTotalPrice()
    func showAlertForVerify()
    func acceptVerification()
    func updateViewAfterPlaceOrder()
}
