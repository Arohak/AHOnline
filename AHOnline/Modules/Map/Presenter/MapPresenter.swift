//
//  MapPresenter.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class MapPresenter -
class MapPresenter {

    weak var view: MapViewInput!
    var interactor: MapInteractorInput!
    var router: MapRouterInput!
}

//MARK: - extension for MapViewOutput -
extension MapPresenter: MapViewOutput {
    
    func viewIsReady() {
        interactor.getObjects()
    }
    
    func getNearestObjects(json: JSON) {
        interactor.getNearstObjects(json)
    }
    
    func didSelectObject(object: AHObject) {
        let vc = ObjectViewController(object: object)
        _ = ObjectModuleInitializer(viewController: vc)
        
        router.pushViewController(vc)
    }
    
    func presentViewController(vc: UIViewController) {
        router.presentViewController(vc)
    }
}

//MARK: - extension for MapInteractorOutput -
extension MapPresenter: MapInteractorOutput {
 
    func objectsDataIsReady(objects: [AHObject]) {
        view.setupInitialState(objects)
    }
}