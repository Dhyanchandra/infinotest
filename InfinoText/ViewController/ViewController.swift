//
//  ViewController.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    @IBAction func loginClicked(_ sender: Any) {
        
        
        let appd = UIApplication.shared.delegate as! AppDelegate
        
        //rohit@wisitech.com
        //Rohit@123
        appd.doLogin(_email: emailTextField.text!, _password: passwordTextField.text!){ (success,errorMsg) in
            if success {
                
                SingletonClass.sharedInstance.setLoginStatus(success)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                self.navigationController?.pushViewController(firstVC, animated: true)
            }
            else{
                
                let alert = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
//        let stt = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
//        self.navigationController?.pushViewController(stt, animated: true)
        
    }
    
    
}

