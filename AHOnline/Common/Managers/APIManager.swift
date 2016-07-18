//
//  APIManager.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

struct APIManager {
    
    private struct ROUTERS
    {
        static let GET_RESTAURANTS_HOME                     = "home"
        static let GET_RESTAURANTS_LIMIT                    = "restaurants?limit=%@"
        static let GET_CATEGORIES                           = "categories"
        static let GET_DELIVERIES                           = "deliveries"
        static let GET_OBJECTS                              = "categories/%@/subcategories/%@"
        static let GET_OBJECT                               = "restaurants/%@"
        static let GET_PRODUCTS                             = "categoryitems/%@/products"
    }
    
    static func getRestaurantsHome() -> Observable<JSON> {
        return apiHelper.request(.GET, url: ROUTERS.GET_RESTAURANTS_HOME)
    }
    
    static func getCategories() -> Observable<JSON> {
        return apiHelper.request(.GET, url: ROUTERS.GET_CATEGORIES)
    }
    
    static func getDeliveries() -> Observable<JSON> {
        return apiHelper.request(.GET, url: ROUTERS.GET_DELIVERIES)
    }
    
    static func getObjects(json: JSON) -> Observable<JSON> {
        let url = String(format: ROUTERS.GET_OBJECTS,
                         json["category_id"].stringValue,
                         json["subcategory_id"].stringValue)
        return apiHelper.request(.GET, url: url)
    }
    
    static func getObject(id: String) -> Observable<JSON> {
        let url = String(format: ROUTERS.GET_OBJECT, id)
        return apiHelper.request(.GET, url: url)
    }
    
    static func getProducts(id: String) -> Observable<JSON> {
        let url = String(format: ROUTERS.GET_PRODUCTS, id)
        return apiHelper.request(.GET, url: url)
    }
    
    static func getObjectsForLimit(limit: String) -> Observable<JSON> {
        let url = String(format: ROUTERS.GET_RESTAURANTS_LIMIT, limit)
        return apiHelper.request(.GET, url: url)
    }
}
