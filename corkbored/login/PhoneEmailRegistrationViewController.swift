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
import FBSDKCoreKit
import FBSDKLoginKit

class PhoneEmailRegistrationViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("completed Login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    
    @IBAction func signUpWithEmailButton(_ sender: Any) {
        passwordTextField.isHidden = false
        emailTextField.isHidden = false
        nextButton.isHidden = false
        signUpWithEmailButton.isHidden = true
        
    }
    
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
        
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        facebookLoginButton.delegate = self
        facebookLoginButton.frame.size.width = view.frame.width - 32
        facebookLoginButton.frame.size.height = 50
        facebookLoginButton.layer.cornerRadius = 3
        facebookLoginButton.center = view.center
        
        view.addSubview(facebookLoginButton)
        
        
        if let token = FBSDKAccessToken.current() {
            print(token)
            fetchProfile()
            
        }
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields":"email, gender"]
        FBSDKGraphRequest(graphPath: "me", parameters: nil).start { (connection, result, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            print(result, "RESULT")
            
//            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? Dictionary, let url = data["url"] as? String {
//
//                print(url)
//
//            }
//
//            if let email = result["email"] as? String {
//                print(email)
//            }
        }
    }
    
    
    
    func loadUIStuff() {
        nextButton.layer.cornerRadius = 3
        signUpWithEmailButton.layer.cornerRadius = 3
        
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
        self.performSegue(withIdentifier: "toProfile", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
