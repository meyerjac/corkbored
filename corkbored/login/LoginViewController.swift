//
//  LoginViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/5/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonClicked(_ sender: Any) {
       handleLogin()
    }
    
    @IBAction func dontHaveAnAccount(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }
    
    func handleLogin() {
        let email = emailTextView.text
        let password = passwordTextField.text
        print(email!)
          print(password!)
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
                    switch action.style{
                    case .cancel:
                        self.loginButton.isEnabled = true
                        print("cancel")
                    case .default:
                        self.loginButton.isEnabled = true
                        print("default case")
                    case .destructive:
                        self.loginButton.isEnabled = true
                        print("destructive case")
                    }
                }))
            } else {
                print("user logged in")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
