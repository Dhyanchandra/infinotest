//
//  FirstViewController.swift
//  InfinoText
//
//  Created by Rohit on 07/06/19.
//  Copyright © 2019 Rohit. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        

    }
    
    
    @IBAction func logout(_ sender: Any) {
        
        let appd = UIApplication.shared.delegate as! AppDelegate
        appd.logout()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
