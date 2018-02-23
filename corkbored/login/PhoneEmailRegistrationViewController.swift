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
    var about = ""
    var birthday = ""
    var email = ""
    var first_name = ""
    var gender = ""
    var last_name = ""
    var name = ""
    var id = ""
    
    var currentCity = ""
    var currentStateCode = ""
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userLocation: CLLocation = CLLocation()
    
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
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("did Complete")
        
        //exchange token for firebase credential
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print("error signing in")
                return
            }
            
            // generating profile
            print("signed in user")
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.fetchFacebookProfile()
        }
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
        print("will Login")
        return true
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
        autoLogin()
    }
    
    func autoLogin() {
        
        if Auth.auth().currentUser?.uid != nil {
            
            print("user logged in")
            
            performSegue(withIdentifier: "phoneToFeed", sender: nil)
        } else {
            
            print("user not logged in")
            
        }
    }
  
    func fetchFacebookProfile() {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "about,birthday,email,first_name,gender,id,last_name, picture.width(1080).height(1080)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error != nil){
                   print(error, "error")
                }
                
                if let dictionary = result as? [String: Any] {
                    print(dictionary, "dictionary")
                    
                    if let about = dictionary["about"] as? String {
                        self.about = about
                    }
                    
                    if let birthday = dictionary["birthday"] as? String {
                        self.birthday = birthday
                    }
                    
                    if let email = dictionary["email"] as? String {
                        self.email = email
                    }
                    if let first_name = dictionary["first_name"] as? String {
//                        self.first_name = first_name
                    }
                    if let gender = dictionary["gender"] as? String {
                        self.gender = gender
                    }
                    if let id = dictionary["id"] as? String {
                        self.id = id
                    }
                    if let last_name = dictionary["last_name"] as? String {
                        self.name = last_name
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
                                    let values = [ "bio": self.about, "birthday": self.birthday,"currentCity": self.currentCity, "currentState": self.currentStateCode, "name": self.name,"profilePic": profileImageUrl]
                                    
                                    let uid = Auth.auth().currentUser?.uid
                                    
                                    self.registerUserIntoDatabaseWithUid(uid: uid!, values: values as [String : AnyObject])
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
    
    func registerUserIntoDatabaseWithUid(uid: String, values:[String: AnyObject]) {
        print("HERE5")
        print(values, "Values")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print("HERE6")
        ref.child("users").child(uid).setValue(values) { (err, ref) in
            
            if err != nil {
                
                print(err!)
                
            } else {
                print("made it to the end")
                
                self.performSegue(withIdentifier: "phoneToFeed", sender: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]
        print(userLocation)
        
        geocoder.reverseGeocodeLocation(userLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let location = placemarks?[0]
                                                print(location!)
                                                self.currentCity = (location?.locality)!
                                                print(self.currentCity)
                                                self.currentStateCode = (location?.administrativeArea)!
                                                print(self.currentStateCode)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                print("couldnt get users location")
                                            }
        })
    }
    
    func loadUIStuff() {
        //main middle sign up button and next button if email is clicked//
        nextButton.layer.cornerRadius = 3
        signUpWithEmailButton.layer.cornerRadius = 3
        
        //set facebook button in middle and set read permissions
        
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        facebookLoginButton.delegate = self
        facebookLoginButton.frame.size.width = view.frame.width - 32
        facebookLoginButton.frame.size.height = 50
        facebookLoginButton.layer.cornerRadius = 3
        facebookLoginButton.center = view.center
        view.addSubview(facebookLoginButton)
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
