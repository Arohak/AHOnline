//
//  MapInteractor.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class MapInteractor -
class MapInteractor {

    weak var output: MapInteractorOutput!
}

//MARK: - extension for MapInteractorInput -
extension MapInteractor: MapInteractorInput {
    
    func getObjects() {
        _ = APIManager.getObjectsForLimit("4")
            .subscribe(onNext: { result in
                if result != nil {
                    var objects: [AHObject] = []
                    for item in result["data"].arrayValue {
                        objects.append(AHObject(data: item))
                    }
                    
                    self.output.objectsDataIsReady(objects)
                }
            })
    }
    
    func getNearstObjects(json: JSON) {
        _ = APIManager.getNearsObjects(json)
            .subscribe(onNext: { result in
                if result != nil {
                    var objects: [AHObject] = []
                    for item in result["data"].arrayValue {
                        objects.append(AHObject(data: item))
                    }
                    
                    self.output.objectsDataIsReady(objects)
                }
            })
    }
}