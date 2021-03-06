//
//  ObjectsInteractor.swift
//  AHOnline
//
//  Created by AroHak on 17/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class ObjectsInteractor -
class ObjectsInteractor {

    weak var output: ObjectsInteractorOutput!
}

//MARK: - extension for ObjectsInteractorInput -
extension ObjectsInteractor: ObjectsInteractorInput {
    
    func getObjects(params: JSON) {
        _ = APIManager.getObjects(params)
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