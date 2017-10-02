//
//  CategoriesInteractor.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class CategoriesInteractor -
class CategoriesInteractor {

    weak var output: CategoriesInteractorOutput!
}

//MARK: - extension for CategoriesInteractorInput -
extension CategoriesInteractor: CategoriesInteractorInput {
    
    func getCategories() {
        _ = CategoryEndpoint.getCategories()
            .subscribe(onNext: { result in
                if let result = result {
                    var categories: [Category] = []
                    for item in result["data"].arrayValue {
                       categories.append(Category(data: item))
                    }
                    
                    self.output.categoriesDataIsReady(categories: categories)
                }
            })
    }
}
