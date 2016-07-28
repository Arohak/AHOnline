//
//  AccountInteractorOutput.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

protocol AccountInteractorOutput: class, PresentViewControllerProtocol, ModalPresentViewControllerProtocol {

    func userDataIsReady(user: User)
}
