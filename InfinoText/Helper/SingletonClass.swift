
//
//  SingletonClass.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import Foundation

public class SingletonClass : NSObject{
    
    static let sharedInstance = SingletonClass()
    
    func getTokenData() ->String?{

    
        guard let token =  UserDefaults.standard.string(forKey: "auth_token")  else {
            return nil
        }
        return token
    }
    
    func getLoginStatus() ->Bool{
        
        
        guard let token =  UserDefaults.standard.object(forKey: "isLogin")  else {
            return false
        }
        return true
    }
    func setLoginStatus(_ status:Bool){
        
        UserDefaults.standard.set(status, forKey: "isLogin")
       
    }
    func setTokenData(token:String){
        
        print("token updated \(self.getcurrentDateTime())")
        UserDefaults.standard.set(token, forKey: "auth_token")
        UserDefaults.standard.set(self.getcurrentDateTime(), forKey: "tokenTimeStamp")
    }
    
    
    func convertStringToDate(dateString:String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let result = formatter.date(from: dateString)
        return result
        
    }
    func getcurrentDateTime() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let result = formatter.string(from: date)
        return result
        
    }
    
    func isTokenExpired() -> Bool {
        
        if let tokenTimeStamp =  UserDefaults.standard.string(forKey: "tokenTimeStamp") {
           
            let timeStampToken = self.convertStringToDate(dateString: tokenTimeStamp)
            let timeStampCurrent = self.convertStringToDate(dateString: self.getcurrentDateTime())
            
            
            let secondsLeft = timeStampToken?.timeDifference(lhs: timeStampCurrent!, rhs: timeStampToken!)
            
            print(tokenTimeStamp)

            print(self.getcurrentDateTime())

            print(secondsLeft)
            
            if Int(secondsLeft!) < Constants.tokenExpireSeconds{
                
                return false
            }
        }
       
        return true
        
    }
    
    
}
extension Date {
     func timeDifference(lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
