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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        checkIfUserIsLoggedIn()
    }
    
    func loadViews() {
        let subtitleBottomCoor = subtitleLabel.frame.origin.y + subtitleLabel.frame.size.height + 78
        
        signUpButton.frame = CGRect(x: view.frame.size.width * 0.1225 , y: subtitleBottomCoor, width: view.frame.width * 0.75, height: 40)
        
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        signUpButton.clipsToBounds = true
        
        loginButton.frame = CGRect(x: view.frame.size.width * 0.1225 , y: signUpButton.frame.origin.y + signUpButton.frame.size.height + 8, width: view.frame.width * 0.75, height: 40)
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.clipsToBounds = true
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
        performSegue(withIdentifier: "toNavigationalController", sender: self)
    }
}

