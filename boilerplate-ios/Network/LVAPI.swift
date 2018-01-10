//
//  LVAPI.swift
//  boilerplate-ios
//
//  Created by Leo Vigna on 24/10/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

///Connect to the API with simple http GET/POST.
class LVAPI {
    ///Base API url.
    private let baseUrl: String;
    ///Client secure access token.
    private let headers: HTTPHeaders;
    
    /**
     Initialize API client
     
     - parameter base_url: API base url to which all requests will be attached to.
     - parameter headers: Any headers you wish to pass by default on all requests.
     - returns: The API client.
     
     ## Example ##
     ````
     LVAPI(
        baseUrl:"http://api.boilerplate.com"
        headers:["Authorization": API_TOKEN,"Accept": "application/json"])
     ````
     
     */
    init(baseUrl: String, headers: HTTPHeaders = [:]) {
        self.baseUrl = baseUrl;
        self.headers = headers;
    }
    
    /**
     HTTP GET request to API.
     
     - parameter url: The API endpoint.
     - returns: A Promise with the formatted JSON respones.
     
     ## Example ##
     ````
     LVAPI.get("/")
     .then { response in
     print(response)
     }
     .catch { err in print("Error: \(err)") }
     ````
     
     */
    func get(url:String,
             headers: HTTPHeaders = [:]) -> Promise<Dictionary<String,Any>> {
        
        return Promise { fulfill, reject in
            let fullUrl = self.baseUrl + url
            var fullHeaders = self.headers;
            fullHeaders.update(other: headers);
            
            Alamofire.request(fullUrl, method: .get, headers: fullHeaders).responseJSON { response in
                if let JSON = response.result.value as? Dictionary<String,Any>, response.response?.statusCode == 200 {
                    print("JSON Succesful response received")
                    fulfill(JSON)
                }
                else if let JSON = response.result.value as? Dictionary<String,Any>, response.response?.statusCode == 500 {
                    print("JSON Error response received")
                    print(JSON)
                    reject(JSON as! Error)
                }
                else if let JSON = response.result.value as? Dictionary<String,Any> {
                    print("JSON Error response received")
                    print(JSON)
                    reject(JSON as! Error)
                }
                else {
                    print("Http Error: No JSON response")
                    print(response)
                    reject("Http Error: No JSON response")
                }
            }
        }
    }
    
    /**
     HTTP POST request to API.
     
     - parameter url: The API endpoint.
     - parameter parameters: The request parmeters.
     - returns: A Promise with the formatted JSON response.
     
     ## Example ##
     ```
     LVAPI.post("/",["foo":"bar"])
     .then { response in
     print(response)
     }
     .catch { err in print("Error: \(err)") }
     ```
     
     */
    func post(url:String,
              parameters: Parameters = [:],
              headers: HTTPHeaders = [:]) -> Promise<Dictionary<String,Any>> {
        return Promise { fulfill, reject in
            let fullUrl = self.baseUrl + url
            var fullHeaders = self.headers;
            fullHeaders.update(other: headers);
            
            Alamofire.request(fullUrl, method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: fullHeaders).responseJSON { response in
                
                if let JSON = response.result.value as? Dictionary<String,Any>, response.response?.statusCode == 200 {
                    print("JSON Succesful response received")
                    print(JSON)
                    fulfill(JSON)
                }
                else if let JSON = response.result.value as? Dictionary<String,Any>, response.response?.statusCode == 500 {
                    print("JSON Error response received")
                    print(JSON)
                    reject("Http 500 Error")
                }
                else if let JSON = response.result.value as? Dictionary<String,Any> {
                    print("Unknown JSON Error response received")
                    print(JSON)
                    reject("Unknown Http Error")
                }
                else {
                    print("Http Error: No JSON response")
                    print(response)
                    reject("Http Error: No JSON response")
                }
            }
        }
    }
}
