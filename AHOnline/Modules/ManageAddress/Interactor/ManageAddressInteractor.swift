//
//  ManageAddressInteractor.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class ManageAddressInteractor -
class ManageAddressInteractor {

    weak var output: ManageAddressInteractorOutput!
    
    var user: User {
        return DBManager.getUser()!
    }
    
    // MARK: - Internal Methods -
    internal func getCountriesFromNSLocale() -> [String] {
        var dictionary = Dictionary<String,String>()
        for countryCode in Locale.isoRegionCodes {
            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : countryCode])
            if let country = (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: identifier) {
                dictionary[country] = identifier
            }
        }
        let keys = Array(dictionary.keys).sorted(by: <)
        
        return keys
    }
    
    internal func getCitiesFromDelivery(deliveries: [Delivery]) -> [(String, String)] {
        var cities: [(String, String)] = []
        for delivery in deliveries {
            cities.append((delivery.city, delivery.alias))
        }
        
        return cities
    }
}

//MARK: - extension for ManageAddressInteractorInput -
extension ManageAddressInteractor: ManageAddressInteractorInput {
    
    func getDeliveries() {
        _ = APIManager.getDeliveries()
            .subscribe(onNext: { result in
                if result != nil {
                    var deliveries: [Delivery] = []
                    for item in result["data"].arrayValue {
                        deliveries.append(Delivery(data: item))
                    }
                    DBManager.storeDeliveries(deliveries: deliveries)
                    self.output.dataIsReady(
                        user: self.user,
                        countries: self.getCountriesFromNSLocale(),
                        citiesTuple: self.getCitiesFromDelivery(deliveries: deliveries))
                }
                }, onError: { error in
                    let deliveries = DBManager.getDeliveries()
                    self.output.dataIsReady(
                        user: self.user,
                        countries: self.getCountriesFromNSLocale(),
                        citiesTuple: self.getCitiesFromDelivery(deliveries: Array(deliveries)))
            })
    }
    
    func saveDeliveryAddressData(json: JSON) {
        if let address = user.address {
            let json = JSON([
                "user_id"   : user.id,
                "country"   : json["country"].stringValue,
                "city"      : json["city"].stringValue,
                "alias"     : json["alias"].stringValue,
                "address"   : json["address"].stringValue,
                "def"       : json["def"].boolValue])
            
            _ = APIManager.updateDeliveryAddress(id: "\(address.id)", json: json)
                .subscribe(onNext: { result in
                    if result != nil {
                        let info = DeliveryAddressInfo(data: result["data"])
                        DBManager.updateDeliveryAddress(info: info)
                        
                        self.output.saveAddressIsReady()
                    }
                })
        } else {
            let json = JSON([
                "user_id"   : user.id,
                "country"   : json["country"].stringValue,
                "city"      : json["city"].stringValue,
                "alias"     : json["alias"].stringValue,
                "address"   : json["address"].stringValue])
            
            _ = APIManager.createDeliveryAddress(json: json)
                .subscribe(onNext: { result in
                    if result != nil {
                        let address = DeliveryAddress(data: result["data"])
                        DBManager.storeDeliveryAddress(address: address)
                        
                        self.output.saveAddressIsReady()
                    }
                })
        }
    }
}
