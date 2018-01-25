//
//  FeedViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/8/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Nuke

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentCity: String = ""
    var messageBody: String = ""
    var profilePhotoFileName: String = ""
    var activeUser = Auth.auth().currentUser
    var manager = Nuke.Manager.shared
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logout(_ sender: Any) {
        handleLogout()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(posts[indexPath.row].postUid)
//         performSegue(withIdentifier: "loggingOut", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row].pinnedMediaFileName != "null" {
            return 500
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //getting time stamp of users device to to compare to stamp of post
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        //pulling and identifying each post from array as a single post
        let post = posts[indexPath.row]
        
        //getting the correct timestamp label for post
        let postDate = Double(post.pinnedTimeAsInterval)
        let difference = ((nowish - postDate!)/60)
        let stringDifference = String(difference)
        let delimiter = "."
        var numbers = stringDifference.components(separatedBy: delimiter)
        let minutesSince = Int(numbers[0])
        var stringTimeStamp = ""
        if minutesSince! < 1 {
            stringTimeStamp = "just now"
        } else if minutesSince! <= 60 {
            stringTimeStamp = "\(minutesSince ?? 23) min"
        } else if minutesSince! > 60 {
            let hours = minutesSince!/60
            if hours >= 25 {
                deletePostFromFeed(postUid: post.postUid)
            } else {
                stringTimeStamp = "\(hours) hr"
            }
        }
        
        //my two type of table cell
        if post.pinnedMediaFileName != "null" {
            
            let textAndImageCell = tableView.dequeueReusableCell(withIdentifier: "postCellWithPhoto", for: indexPath) as! FeedViewControllerTableViewCell
            
            //getting Profile picture and username
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let username = value?["username"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: textAndImageCell.profilePhotoImageView)
                }
                
                textAndImageCell.usernameTextField.text = username
                
            }) { (error) in
                print(error.localizedDescription)
            }
   
            textAndImageCell.profilePhotoImageView?.contentMode = .scaleAspectFit
            textAndImageCell.profilePhotoImageView?.layer.borderWidth = 1.0
            textAndImageCell.profilePhotoImageView?.layer.masksToBounds = false
            textAndImageCell.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            textAndImageCell.profilePhotoImageView?.layer.cornerRadius = textAndImageCell.profilePhotoImageView.frame.size.width / 2
            textAndImageCell.profilePhotoImageView?.clipsToBounds = true
            
            //setting picture field
            let postPhotoString = URL.init(string: post.pinnedMediaFileName)
            self.manager.loadImage(with: postPhotoString!, into: textAndImageCell.postPhoto)
            
            textAndImageCell.timePosted.text = stringTimeStamp
            
            textAndImageCell.messageBody.text = post.postMessage
            
            return textAndImageCell
            
        } else {
            let textOnlyCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
            
            //getting Profile picture and username
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let username = value?["username"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: textOnlyCell.profilePhotoImageView)
                }
                
                textOnlyCell.usernameTextField.text = username
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        
            textOnlyCell.profilePhotoImageView?.contentMode = .scaleAspectFit
            textOnlyCell.profilePhotoImageView?.layer.borderWidth = 1.0
            textOnlyCell.profilePhotoImageView?.layer.masksToBounds = false
            textOnlyCell.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            textOnlyCell.profilePhotoImageView?.layer.cornerRadius = textOnlyCell.profilePhotoImageView.frame.size.width / 2
            textOnlyCell.profilePhotoImageView?.clipsToBounds = true
            
            textOnlyCell.timePosted.text = stringTimeStamp
            
            textOnlyCell.messageBody.text = post.postMessage
            
            return textOnlyCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthStatus()
   
    }
    
    func checkAuthStatus() {
        let userInfo = Auth.auth().currentUser
        
        if (userInfo != nil) {
            
        // user is signed in
        fetchCurrentPosition()
            
        } else {
            
        performSegue(withIdentifier: "loggingOut", sender: self)
            
        }
    }
    
    func deletePostFromFeed(postUid: String) {
        print("trying to delete")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let postReference = ref.child("posts").child(currentCity).child(postUid)
        print(postReference)
        
        // Remove the post from the DB
         postReference.removeValue()
         print("trying to delete after remove")
    }
    
    func fetchCurrentPosition() {
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentCity = value?["currentCity"] as? String ?? ""
            self.fetchPosts()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchPosts() {
        
        var refExists: DatabaseReference!
        refExists = Database.database().reference()

        refExists.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild("Corvallis") {
                self.tableView.isHidden = false
               
                Database.database().reference().child("posts").child(self.currentCity).observe(.childAdded) { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let post = Post(snapshot: snapshot)
                        self.posts.append(post)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }else{
                print("city doesn't exist")
                self.tableView.isHidden = true
                self.handleAlertWhenNoTableViewItemsExist()
            }
        })
    }
    
    func handleAlertWhenNoTableViewItemsExist() {
        let alert = UIAlertController(title: "Error", message: "corkboard hasn't made it to your city yet, start the conversation!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { action in
            switch action.style{
            case .cancel:
                print("cancel")
            case .default:
                print("default case")
            case .destructive:
                print("destructive case")
            }
        }))
    }
 
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            
            } catch let logoutError {
                
            print(logoutError)
                
            }
    
       performSegue(withIdentifier: "loggingOut", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
