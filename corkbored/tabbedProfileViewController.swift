//
//  tabbedProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/10/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class tabbedProfileViewController: UIViewController {
    var profileUid = String()
    
    @IBAction func Logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            print("signing out")
            try firebaseAuth.signOut()
             FBSDKLoginManager().logOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
         print("success signing out of firebase")
        performSegue(withIdentifier: "logout", sender: nil)
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
