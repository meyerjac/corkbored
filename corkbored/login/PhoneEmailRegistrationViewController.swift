//
//  PhoneEmailRegistrationViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/5/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth
import Firebase
import FirebaseAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class PhoneEmailRegistrationViewController: UIViewController, FBSDKLoginButtonDelegate, CLLocationManagerDelegate {
    //filled in with Facebook data
    var acceptedTerms = false
    var bio = ""
    var birthday = ""
    var currentCity = ""
    var currentState = ""
    var dms = [String]()
    var email = ""
    var facebookId = ""
    var firstName = ""
    var hashtags = [String]()
    var lastName = ""
    var posts = [String]()
    var profilePic = ""
    var replies = [String]()
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userLocation: CLLocation = CLLocation()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var facebookLogButton: FBSDKLoginButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBAction func signInClicked(_ sender: Any) {
    }
    
    @IBAction func signUpWithEmailButton(_ sender: Any) {
        let duration = 0.50
        //animate
        UIView.animate(withDuration: duration as! TimeInterval, animations: {
            self.signUpWithEmailButton.alpha = 0
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: duration as! TimeInterval, delay: 0.25, animations: {
            self.passwordTextField.alpha = 1
            self.emailTextField.alpha = 1
            self.nextButton.alpha = 1
            
        }, completion: {(completed) in
            print("in completition 1")
            
        })
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        nextButton.isEnabled = false
        
        self.email = emailTextField.text!
        let password: String = passwordTextField.text!
        Auth.auth().createUser(withEmail: self.email, password: password, completion: { (user, error) in
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
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if (error == nil) {
            let fbloginresult : FBSDKLoginManagerLoginResult = result
            if result.isCancelled {
                return
                } else {
                //not cancelled
                //exchange token for firebase credential
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    
                    // generating profile
                    print("generating profile")
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    self.fetchFacebookProfile()
                }
            }
        } else {
            //print error
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLogButton.removeConstraints(facebookLogButton.constraints)
        facebookLogButton.frame.size.height = 50
        facebookLogButton.layer.cornerRadius = 3
        facebookLogButton.delegate = self
        let buttonText = NSAttributedString(string: "Sign Up With Facebook")
        facebookLogButton.setAttributedTitle(buttonText, for: .normal)
         facebookLogButton.titleLabel?.font =  UIFont(name: "system", size: 12)
        
        nextButton.layer.cornerRadius = 3
        signUpWithEmailButton.layer.cornerRadius = 3
        
        titleLabel.frame = CGRect(x: facebookLogButton.frame.origin.x, y: facebookLogButton.frame.origin.y - 50, width: view.frame.width, height: 50)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func fetchFacebookProfile() {
        print("yup1")
        if((FBSDKAccessToken.current()) != nil){
             print("yup2")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "about,birthday,email,first_name,gender,id,last_name, picture.width(1080).height(1080)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error != nil){
                    return
                   print(error, "error")
                }
                
                if let dictionary = result as? [String: Any] {
                    print(dictionary, "dictionary")
                    
                    if let about = dictionary["about"] as? String {
                        self.bio = about
                    }
                    
                    if let birthday = dictionary["birthday"] as? String {
                        self.birthday = birthday
                    }
                    
                    if let email = dictionary["email"] as? String {
                        self.email = email
                    }
                    if let first_name = dictionary["first_name"] as? String {
                        self.firstName = first_name
                    }
                    if let facebookId = dictionary["id"] as? String {
                        self.facebookId = facebookId
                    }
                    if let last_name = dictionary["last_name"] as? String {
                        self.lastName = last_name
                    }
                    if let picture = dictionary["picture"] as? [String: Any] {
                        if let data = picture["data"] as? [String: Any] {
                            if let url = data["url"] as? String {
                                let photoUrlString: String! = url
                                self.downloadAndStoreImageAsFirebaseUrl(photoUrl: photoUrlString)
                                
                            }
                        }
                    }
                }
                
            })
        }
    }
    
    func downloadAndStoreImageAsFirebaseUrl(photoUrl: String) {
        let myUrl = URL(string: photoUrl);
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            print("HERE6")
            if let err = error {
                print(err, "some error occured")
            } else {
                print("HERE7")
                if(response as? HTTPURLResponse) != nil {
                    print("HERE8")
                    if let imageData = data {
                        print("HERE9")
                        let imageName = NSUUID().uuidString
                        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).png")
                        print("HERE10")
                            
                            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    print(error ?? "error")
                                    return
                                }
                                
                                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                    var type = "facebook"
                                    
                                    let values = ["acceptedTerms": self.acceptedTerms, "bio": self.bio, "birthday": self.birthday, "currentCity": self.currentCity, "currentState": self.currentState, "dms": self.dms, "email": self.email, "facebookId": self.facebookId, "firstName": self.firstName, "hashtags": self.hashtags, "lastName": self.lastName, "posts": self.posts, "profilePic": profileImageUrl, "replies": self.replies] as [String : Any]
             
                                    let uid = Auth.auth().currentUser?.uid
                                    
                                    self.registerUserIntoDatabaseWithUid(uid: uid!, values: values as [String : AnyObject], type: type)
                                }
                            })
                    } else {
                        print("no image found")
                    }
                } else {
                    print("no response from url server")
                }
            }
        }
        task.resume()
    }
    
    func registerUserIntoDatabaseWithUid(uid: String, values:[String: AnyObject], type: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
     
        ref.child("users").child(uid).setValue(values) { (err, ref) in
            
            if err != nil {
                
                print(err!)
                
            } else {
                print("made it to the end")
                
                if type == "facebook" {
                    print("facebook")
                    self.performSegue(withIdentifier: "facebookSignInToHashtags", sender: nil)
                    
                } else {
                    print("email")
                    self.performSegue(withIdentifier: "toProfileSetUpPage", sender: nil)
            }
        }
    }
}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]

        geocoder.reverseGeocodeLocation(userLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let location = placemarks?[0]
                                                //setting current city/state
                                                self.currentCity = (location?.locality)!
                                                self.currentState = (location?.administrativeArea)!
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                print("couldnt get users location")
                                            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleCreateUser() {
       let uid = Auth.auth().currentUser?.uid
        print(self.email, "EMAIL")
        var type = "email"
            
        let values = ["acceptedTerms": self.acceptedTerms, "bio": self.bio, "birthday": self.birthday, "currentCity": self.currentCity, "currentState": self.currentState, "dms": self.dms, "email": self.email, "facebookId": self.facebookId, "firstName": self.firstName, "hashtags": self.hashtags, "lastName": self.lastName, "posts": self.posts, "profilePic": self.profilePic, "replies": self.replies] as [String : Any]
        
        self.registerUserIntoDatabaseWithUid(uid: uid!, values: values as [String : AnyObject], type: type)
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            print("signing out")
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("did log out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
