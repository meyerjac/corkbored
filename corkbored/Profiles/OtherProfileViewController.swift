//
//  OtherProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Nuke

class OtherProfileViewController: UIViewController {
    var ownerUid = ""
    var hashtagArray = [String]()
    var manager = Nuke.Manager.shared

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextLabel: UILabel!
    @IBOutlet weak var nameAndAge: UILabel!
    @IBOutlet weak var quickMessage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuickMessage" {
            let controller = segue.destination as! quickMessageViewController
            controller.dmProfileNavImage = profileImageView.image
            controller.POIUid = self.ownerUid
        }
    }
    
    func loadProfile() {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(self.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let firstName = value?["firstName"] as? String ?? ""
                let lastName = value?["lastName"] as? String ?? ""
                let bio = value?["bio"] as? String ?? ""
                let birthday = value?["birthday"] as? String ?? ""
                if let hashes = value?["hashtags"] as? NSArray {
                    self.hashtagArray = hashes as! [String]
                }
                
                var nameAndAgeText = firstName + " " + lastName + "," + " 25"
                
                //assign bio and birthday text views
                self.bioTextLabel.text = bio
                self.nameAndAge.text = nameAndAgeText
                
                //messageButton
                self.quickMessage.layer.cornerRadius = self.quickMessage.frame.size.height / 2
                self.quickMessage.clipsToBounds = true
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: self.profileImageView)
                    self.profileImageView.contentMode = .scaleAspectFill
                }
            }) { (error) in
                print(error.localizedDescription)
            }
    }
}


