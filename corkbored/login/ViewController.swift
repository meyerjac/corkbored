//
//  ViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 11/29/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()

    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
             print("user logged in")
            perform(#selector(login), with: nil, afterDelay: 0)
            
        } else {
            print("user not logged in")
        }
}

    @objc func login() {
        performSegue(withIdentifier: "autoLogin", sender: self)
    }
}

