//
//  HomeInteractor.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class HomeInteractor -
class HomeInteractor {

    weak var output: HomeInteractorOutput!
}

//MARK: - extension for HomeInteractorInput -
extension HomeInteractor: HomeInteractorInput {
    
    func getRestaurantsHome() {
        _ = HomeAPIManager.getRestaurantsHome()
            .subscribe(onNext: { data in
                if data != nil {
                    let home = Home(data: data["data"])
                    self.output.homeDataIsReady(home)
                }
            })
    }
}