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
    
    @IBOutlet weak var snapchatLogo: UIImageView!
    @IBOutlet weak var instagramLogo: UIImageView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quickMessage: UIButton!
    @IBOutlet weak var snapchatSocialHandle: UILabel!
    @IBOutlet weak var instagramSocialHandle: UILabel!
    @IBOutlet weak var favoriteQuoteLabel: UILabel!
    @IBOutlet weak var majorInSchoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTabBarControllerDown()
        loadViews()
        loadProfile()
    }
    
    func loadViews() {
        let width = view.frame.size.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(OtherProfileViewController.back(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        
        profileImageView.frame = CGRect(x: width / 4, y: view.frame.size.height / 6, width: width / 2, height: width / 2)
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        
        //nameLabel
        nameLabel.center = CGPoint(x: width / 2, y: profileImageView.frame.origin.y + profileImageView.frame.size.height + 8 + (nameLabel.frame.size.height / 2))
        
        //ageLabel
        ageLabel.center = CGPoint(x: width / 2, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 8 + ageLabel.frame.size.height / 2)
        
        //backButton
        backButton.frame = CGRect(x: 8, y: statusBarHeight + 8, width: 30, height: 30)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
           animateTabBarControllerUp()
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
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
    
    func animateTabBarControllerDown() {
        let duration = 0.25
        
        if let nav = self.tabBarController?.tabBar {
            
            //TabBarController
            let xPosition = nav.frame.origin.x
            let yPosition = nav.frame.origin.y + nav.frame.size.height
            let height = nav.frame.size.height
            let width = nav.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                nav.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                
                }, completion: {(completed) in
                    print("in completition")
                })
            } else {
        }
    }
    
    func animateTabBarControllerUp() {
        let duration = 0.25
        
        if let nav = self.tabBarController?.tabBar {
            
            //TabBarController
            let xPosition = nav.frame.origin.x
            let yPosition = nav.frame.origin.y - nav.frame.size.height
            let height = nav.frame.size.height
            let width = nav.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                nav.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                
            }, completion: {(completed) in
                print("in completition")
            })
        } else {
        }
    }
    
    func loadProfile() {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(self.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get users value
                let value = snapshot.value as? NSDictionary
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let firstName = value?["firstName"] as? String ?? ""
                let lastName = value?["lastName"] as? String ?? ""
                let bio = value?["bio"] as? String ?? ""
                let birthday = value?["birthday"] as? String ?? ""
                if let hashes = value?["hashtags"] as? NSArray {
                    self.hashtagArray = hashes as! [String]
                }
                
                var nameAndAgeText = firstName + " " + lastName
                
                //assign bio and birthday text views
                self.bioTextLabel.text = bio
                self.nameLabel.text = nameAndAgeText
                
                
                //social handles
                self.instagramSocialHandle.sizeToFit()
                self.snapchatSocialHandle.sizeToFit()


                self.instagramLogo.frame = CGRect(x: self.view.frame.size.width / 2 + 16, y: self.ageLabel.frame.origin.y + self.ageLabel.frame.size.height + 16, width: 30, height: 30)
                
                self.instagramSocialHandle.frame = CGRect(x: self.instagramLogo.frame.origin.x + self.instagramLogo.frame.size.width + 8, y: self.instagramLogo.frame.origin.y + self.instagramSocialHandle.frame.size.height / 2, width: self.instagramSocialHandle.frame.size.width, height: 20)
                
                 self.snapchatSocialHandle.frame = CGRect(x: self.view.frame.size.width / 2 - 16 - self.snapchatSocialHandle.frame.size.width, y: self.ageLabel.frame.origin.y + self.ageLabel.frame.size.height + 16 + self.snapchatSocialHandle.frame.size.height / 2, width: self.snapchatSocialHandle.frame.size.width, height: 20)
                
                self.snapchatLogo.frame = CGRect(x: self.snapchatSocialHandle.frame.origin.x - 8 - self.snapchatLogo.frame.size.width, y: self.ageLabel.frame.origin.y + self.ageLabel.frame.size.height + 16, width: 30, height: 30)
                
                //messageButton
                self.quickMessage.layer.cornerRadius = 5
                self.quickMessage.layer.borderColor = UIColor.black.cgColor
                self.quickMessage.layer.borderWidth = 1
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


