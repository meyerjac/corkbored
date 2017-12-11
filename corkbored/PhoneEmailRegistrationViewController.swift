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

class PhoneEmailRegistrationViewController: UIViewController {
    @IBOutlet weak var emailNextButton: UIButton!
    @IBOutlet weak var plusOneTextView: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailPhoneSegmentedControl: UISegmentedControl!
    
    @IBAction func signInClicked(_ sender: Any) {
        let vc = LoginViewController()
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func emailNextButtonClicked(_ sender: Any) {

        switch (emailPhoneSegmentedControl.selectedSegmentIndex) {
        case 0:
            let email: String = emailTextField.text!
            let password: String = passwordTextField.text!
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                } else {
                    self.handleCreateUser()
                    
                }
            })
            break;
        case 1:
            //phone selected
            print("phone")
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailPhoneSegmentedControl.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
    }
    
    func handleCreateUser() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        let email = userInfo?.email
        
        var delimiter = "@"
        var token = email?.components(separatedBy: delimiter)
        let username = token![0]
        
        let emptyArray = [String]()
        
        let newUser = User(name: email!, username: username, currentCity: "", profilePics: emptyArray , age: "")

        ref.child("users").child(uid!).setValue(newUser.toAnyObject())

        self.performSegue(withIdentifier: "segue1", sender: nil)
    }
    
    @objc func handleValueChanged() {
        if (emailPhoneSegmentedControl.titleForSegment(at: emailPhoneSegmentedControl.selectedSegmentIndex) == "Phone") {
            emailTextField.isHidden = true
            passwordTextField.isHidden = true
            phoneNumberTextField.isHidden = false
            plusOneTextView.isHidden = false
        } else {
            emailTextField.isHidden = false
            passwordTextField.isHidden = false
            phoneNumberTextField.isHidden = true
            plusOneTextView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
