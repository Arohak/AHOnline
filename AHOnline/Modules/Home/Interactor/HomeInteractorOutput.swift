//
//  HomeInteractorOutput.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

protocol HomeInteractorOutput: class, ObjectDataIsReadyProtocol {

    func createUserIsReady(user:User)
    func homeDataIsReady(home: Home)
}
