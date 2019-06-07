//
//  AppDelegate.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    var timer: DispatchSourceTimer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("application launch")
        
        if SingletonClass.sharedInstance.getLoginStatus(){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            self.window?.rootViewController = mainVC
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        print("application resign")

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("application background")

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        print("application forground")

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        if SingletonClass.sharedInstance.getLoginStatus(){
            
            if timer == nil{
                
                startTimer(){(success,errorMsg) in
                    
                }
                
            }
            else{
                
                if SingletonClass.sharedInstance.isTokenExpired(){
                    
                    startTimer(){(success,errorMsg) in
                        
                    }
                    
                }
            }
            
        }
        
        
        
        print("application active")

        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
         self.stopTimer()
        
        print("application terminate")
        
    }


    func hitSignInAPI(completion: @escaping ( _ success: Bool,  _ token: String, _ errorMsg: String) -> ()){
        
        guard let email    = UserDefaults.standard.string(forKey: "email") else{
            return
        }
        
        guard let password = UserDefaults.standard.string(forKey: "password") else {
            return
        }
        
        let device_type = "3"
        let device_token = ""
        let urlString = Constants.Apis.baseUrl +  Constants.Apis.getToken
        
        //WebServiceClass.showLoader(view: self.view)
        let paramsStr =  "email=\(email)&password=\(password)&device_type=\(device_type)&device_token=\(device_token)"
        
        WebServiceClass.dataTask(urlName: urlString, method: "POST", params: paramsStr) { (success, response, errorMsg) in
            //WebServiceClass.hideLoader(view: self.view)
            if success == true {
                if let response = response as? Dictionary<String,AnyObject> {
                    print(response)
                    if let data = response["data"]as? Dictionary<String,AnyObject> {
                        
                        
                            
                        if let chatToken = data["chat_token"] as? String{
                            if let auth_token = data["auth_token"]  as? String{
                                
                                completion(true,auth_token,"")
                                
                                
                            }
                            else{
                                
                                completion(false,"",Constants.CommonErrorMessages.UNKNOWN_ERROR_FROM_SERVER)

                            }
                        }
                        else{
                            
                            completion(false,"",Constants.CommonErrorMessages.UNKNOWN_ERROR_FROM_SERVER)

                        }
                        
                        
                        
                    }
                    else{
                        
                        var errorStr = Constants.CommonErrorMessages.UNKNOWN_ERROR_FROM_SERVER
                        
                        if let data = response["error"]as? Dictionary<String,AnyObject> {
                            
                            if let error = data["message"] as? String{
                               
                                errorStr = error
                                
                            }
                            
                        }
                        
                        completion(false,"",errorStr)

                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                
                })}else {
                completion(false,"",errorMsg)
            }
        }
    }
    
    func doLogin(_email:String,_password:String,completion: @escaping ( _ success: Bool,_ errorMsg:String) -> ()){
        
        UserDefaults.standard.set(_email, forKey: "email")
        UserDefaults.standard.set(_password, forKey: "password")
        
        
        self.hitSignInAPI(){ (success,token,error) in
            
            if success == true{
                
                SingletonClass.sharedInstance.setTokenData(token:token)
                
                self.startTimer(){(success,errorMsg) in
                    
                    if success == false{
                        
                        self.stopTimer()
                    }
                    
                }
                
            }
            completion(success,error)
            
        }
        
    }
    
    func startTimer(completion: @escaping ( _ success: Bool,_ errorMsg:String) -> ()) {
        
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(Constants.tokenExpireSeconds))
        timer!.setEventHandler { [weak self] in
            // do whatever you want here
            self!.hitSignInAPI(){ (success,token,error) in
                
                if success == true{
                    
                    
                    SingletonClass.sharedInstance.setTokenData(token:token)

                }
                completion(success,error)
            }
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func logout()  {
        
        self.stopTimer()
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.window?.rootViewController = mainVC
        
    }
    
    
}

