//
//  VerifyPhoneNumberInteractor.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class VerifyPhoneNumberInteractor -
class VerifyPhoneNumberInteractor {

    weak var output: VerifyPhoneNumberInteractorOutput!
}

//MARK: - extension for VerifyPhoneNumberInteractorInput -
extension VerifyPhoneNumberInteractor: VerifyPhoneNumberInteractorInput {
    
    func send(number: String) {
        
       output.sendDataIsReady()
    }
    
    func accept(pin: String) {
        
        output.acceptDataIsReady()
    }
}