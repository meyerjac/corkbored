//
//  RulesAndInfoViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/23/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RulesAndInfoViewController: UIViewController {
    @IBAction func disagreeButton(_ sender: Any) {
        let alert = UIAlertController(title: "Awkward...", message: "you must agree to our terms of service and rules to be part of the family!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
    }
    
    @IBAction func agreeButton(_ sender: Any) {
        //add to database that they have agreed to terms of service
        
        if let uid = Auth.auth().currentUser?.uid {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(uid).child("acceptedTerms").setValue(true)
        }
        
        performSegue(withIdentifier: "rulesToFeed", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
