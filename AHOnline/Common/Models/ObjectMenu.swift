//
//  ObjectMenu.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class ObjectMenu: Object {
    
    dynamic var id = 0
    dynamic var name: String!
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(data: JSON) {
        self.init()
        
        self.id         = data["id"].intValue
        self.name       = data["name"].stringValue
    }
}