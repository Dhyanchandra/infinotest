
//
//  WebServiceClass.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import Foundation
import UIKit

class WebServiceClass {
    
    //MARK:- Data task
    static func dataTask(urlName: String, method: String, params: String, completion: @escaping ( _ success: Bool,  _ object: Any, _ errorMsg: String) -> ()) {
        
        let urlString: URL = URL(string: urlName)!
        
        //let body = self.createMultiPartBody(parameters: params as [[String : AnyObject]])
        print("API Name:- \(urlString) Get body Data: \(params)")
        
        let request = NSMutableURLRequest(url: urlString,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = method
        
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // request.allHTTPHeaderFields = self.requestHeaders()
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                print(data ?? "No Data found")
                print(response ?? "No Data found")
                print(error?.localizedDescription ?? "No Data found")
                
                if (error != nil) {
                    
                    //print(error?.localizedDescription ?? "error details not found")
                    //print(error ?? "error not found")
                    
                    completion(false, "", Constants.CommonErrorMessages.UNKNOWN_ERROR_FROM_SERVER)
                    
                } else {
                    
                    if let response = response as? HTTPURLResponse  {
                        
                        if response.statusCode == 201 || response.statusCode == 200 {
                            
                            // Check Data
                            if let data = data {
                                
                                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                                print(jsonString)
                                
                                // Json Response
                                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                                    
                                    completion(true, jsonResponse, "")
                                    
                                } else {
                                    
                                    completion(false, "", Constants.CommonErrorMessages.INTERNAL_SERVER_ERROR)
                                    
                                }
                                
                            } else {
                                completion(false, "", Constants.CommonErrorMessages.INTERNAL_SERVER_ERROR)
                            }
                            
                        } else {
                            completion(false, "", Constants.CommonErrorMessages.INTERNAL_SERVER_ERROR)
                        }
                        
                    } else {
                        
                        completion(false, "", Constants.CommonErrorMessages.UNKNOWN_ERROR_FROM_SERVER)
                    }
                    
                }
                
            })
            
        })
        
        dataTask.resume()
        
    }
    
   
}



