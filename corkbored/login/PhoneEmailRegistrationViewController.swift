//
//  PhoneEmailRegistrationViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/5/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseAuthUI

class PhoneEmailRegistrationViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInClicked(_ sender: Any) {
        let vc = LoginViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        nextButton.isEnabled = false

            let email: String = emailTextField.text!
            let password: String = passwordTextField.text!
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
                        switch action.style{
                        case .cancel:
                            self.nextButton.isEnabled = true
                            print("cancel")
                        case .default:
                            self.nextButton.isEnabled = true
                            print("default case")
                        case .destructive:
                            self.nextButton.isEnabled = true
                            print("destructive case")
                        }
                    }))
                } else {
                    self.handleCreateUser()
                }
            })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUIStuff()
    }
    
    func loadUIStuff() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleCreateUser() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        let email = userInfo?.email
        
        let delimiter = "@"
        var token = email?.components(separatedBy: delimiter)
        let username = token![0]
        
        let emptyArray = [String]()
        
        let newUser = User(name: "", username: username, currentCity: "", profilePic: "", posts: emptyArray, birthday: "", bio: "")

        ref.child("users").child(uid!).setValue(newUser.toAnyObject())
        self.performSegue(withIdentifier: "segue1", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
