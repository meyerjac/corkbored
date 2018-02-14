//
//  tabbedProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/10/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth

class tabbedProfileViewController: UIViewController {
    
    @IBAction func Logout(_ sender: Any) {
        do {
                        try Auth.auth().signOut()
               
                       } catch let logoutError {
                
                            print(logoutError)
                
                        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
