//
//  Constants.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import Foundation

struct Constants {

    static let tokenExpireSeconds = 900 // 15 minute
    
    struct Apis {
        
        
        static let baseUrl = "https://startdesigns.website/automobilefirst/api/"
        static let getToken = "users/chat-login"
        
    }
    
    struct CommonErrorMessages {
        
        
        static let NO_INTERNET_AVAILABLE = "It seems you do not have adequate internet connection. Please refresh!"
        static let INTERNAL_SERVER_ERROR = "Unable to connect to server, please try again later."
        static let UNKNOWN_ERROR_FROM_SERVER = "Something went wrong. Please try again."
        
    }
    
    
}
