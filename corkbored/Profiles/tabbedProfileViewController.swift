//
//  tabbedProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/10/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import Nuke
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class tabbedProfileViewController: UIViewController {
    

    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileButton(_ sender: Any) {
        //handle Edit profile
    }
    @IBOutlet weak var bioTextLabel: UILabel!
    @IBOutlet weak var nameAndAge: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profileUid = String()
    var hashtagArray = [String]()
    var manager = Nuke.Manager.shared
    
    func loadProfile() {
        if let uid = Auth.auth().currentUser?.uid {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let firstName = value?["firstName"] as? String ?? ""
                let lastName = value?["lastName"] as? String ?? ""
                let bio = value?["bio"] as? String ?? ""
                let birthday = value?["birthday"] as? String ?? ""
                if let hashes = value?["hashtags"] as? NSArray {
                    self.hashtagArray = hashes as! [String]
                    print(self.hashtagArray, "HASH")
                }
                
                var nameAndAgeText = firstName + " " + lastName + "," + " 25"
                
                //assign bio and birthday text views
                self.bioTextLabel.text = bio
                self.nameAndAge.text = nameAndAgeText
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: self.profileImageView)
                    self.profileImageView.contentMode = .scaleAspectFill
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
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
        loadProfile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
