//
//  VerifyPhoneNumberInteractorInput.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

protocol VerifyPhoneNumberInteractorInput {

    func send(number: String)
    func accept(pin: String)
}
