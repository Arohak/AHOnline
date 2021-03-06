//
//  APIHelper.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

let apiHelper = APIHelper.sharedInstance

let HTTPS   = "http://"
let IP      = "localhost"
let PORT    = ":3000/"
let AHO     = "api/v1/"
let baseURL = HTTPS + IP + PORT + AHO
//let baseURL = "http://buyonline-arohak.c9users.io/api/v1/"

class APIHelper {
    
    static let sharedInstance = APIHelper()
    let manager = Manager()

    //MARK: - Request -
    func rx_Request(method: Alamofire.Method,
                            url: String,
                            parameters: [String: AnyObject]? = nil,
                            showProgress: Bool = true)
                            -> Observable<JSON>
    {
        return Observable.create { observer in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if showProgress { UIHelper.showSpinner() }

            let URL = baseURL + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            _ = self.manager.rx_request(method, URL, parameters: parameters, encoding: .URL)
                .observeOn(MainScheduler.instance)
                
                .flatMap {
                    $0.rx_JSON()
                }
                .subscribe(
                    onNext: {
                        observer.onNext(JSON($0))
                    },
                    onError: {
                        observer.onError($0)
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if showProgress { UIHelper.hideSpinner() }
                        observer.onError($0)
                    },
                    onCompleted: {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if showProgress { UIHelper.hideSpinner() }
                        observer.onCompleted()
                    })
            
            return AnonymousDisposable { }
        }
    }
    
    func request(method: Alamofire.Method,
                        url: String,
                        parameters: [String: AnyObject]? = nil,
                        showProgress: Bool = true)
                        -> Observable<JSON>
    {
        return Observable.create { observer in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if showProgress { UIHelper.showSpinner() }
            
            let URL = baseURL + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            self.manager.request(method, URL, parameters: parameters, encoding: .URL, headers: ["locale" : Preferences.getAppLanguage()])
                .responseJSON { response in
                    switch response.result {
                    case .Success(let data):
                        observer.onNext(self.handleResponse(data))
                    case .Failure(let error):
                        UIHelper.showHUD(error.localizedDescription)
                        observer.onError(error)
                    }
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if showProgress { UIHelper.hideSpinner() }
            }
            
            return AnonymousDisposable { }
        }
    }
    
    func requestNSData(method: Alamofire.Method,
                    url: String,
                    parameters: [String: AnyObject]? = nil,
                    showProgress: Bool = true)
        -> Observable<NSData>
    {
        return Observable.create { observer in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if showProgress { UIHelper.showSpinner() }
            
            let URL = baseURL + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            self.manager.request(method, URL, parameters: parameters, encoding: .URL)
                .responseData { response in
                    observer.onNext(response.data!)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if showProgress { UIHelper.hideSpinner() }
            }
            
            return AnonymousDisposable { }
        }
    }
    
    //MARK: - Private Methods -
    private func handleResponse(response: AnyObject) -> JSON {
        let data = JSON(response)
        let result = Result(data: data["result"])
        
        switch result.status {
        case "SUCCESS":
            if !result.message.isEmpty { UIHelper.showHUD(result.message) }
            return data
            
        case "USER_SESSION_EXPIRED", "USER_SESSION_NOT_FOUND":
            if !result.message.isEmpty { UIHelper.showHUD(result.message) }
            Wireframe.start()
            return JSON.null
            
        case "CERTIFICATE_NOT_FOUND":
            if !result.message.isEmpty { UIHelper.showHUD(result.message) }
            return JSON.null
            
        default:
            UIHelper.showHUD(result.message)
            return JSON.null
        }
    }
    
    private func handleError(response: AnyObject) {
        let data = JSON(response)
        let number = data.intValue
        var error = "Error"
        switch number {
        case -1:
            error = ""
        case -2:
            error = ""
        case -3:
            error = ""
        default:
            break
        }
        UIHelper.showHUD(error)
    }
}
