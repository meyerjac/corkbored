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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
    
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        let post = posts[indexPath.row]
        
        //getting Profile picture and username
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            let url = value?["profilePic"] as? String ?? ""
            let urlUrl = URL.init(string: url)
            print(url, "1")
            print(url, "1")
            
            let username = value?["username"] as? String ?? ""
            
//            let storageRef = Storage.storage().reference().child("profileImages").child("\(profilePic).png")
//
//            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//                if (error != nil) {
//                    print(error ?? "There was an error")
//                } else {
//                    DispatchQueue.main.async() {
//                    cell.profilePhotoImageView.image = UIImage(data: data!)
//                    }
//
//                }
//            }
            
            cell.usernameTextField.text = username
            cell.profilePhotoImageView?.image = nil
            cell.profilePhotoImageView?.contentMode = .scaleAspectFill
            cell.profilePhotoImageView?.layer.borderWidth = 1.0
            cell.profilePhotoImageView?.layer.masksToBounds = false
            cell.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            cell.profilePhotoImageView?.layer.cornerRadius = cell.profilePhotoImageView.frame.size.width / 2
            cell.profilePhotoImageView?.clipsToBounds = true
            self.manager.loadImage(with: urlUrl!, into: cell.profilePhotoImageView)
        }) { (error) in
            print(error.localizedDescription)
        }
        
      
        
        
        //getting the correct timestamp label
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
                
            } else {
                  stringTimeStamp = "\(hours) hr"
            }
        }
    
        cell.messageBody.text = post.postMessage
        
        cell.timePosted.text = stringTimeStamp
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do {
//            try Auth.auth().signOut()
//
//        } catch let logoutError {
//
//            print(logoutError)
//
//        }
    
//        performSegue(withIdentifier: "loggingOut", sender: self)
        
        checkAuthStatus()
        fetchCurrentPosition()
    }
    
    func checkAuthStatus() {
        let userInfo = Auth.auth().currentUser
        
        if (userInfo != nil) {
        // user is signed in
        print(userInfo)
        } else {
        performSegue(withIdentifier: "loggingOut", sender: self)
        }
        
    }
    
    func fetchCurrentPosition() {
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(self.currentCity)
            self.currentCity = value?["currentCity"] as? String ?? ""
            print(self.currentCity)
            self.fetchPosts()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchPosts() {
        
        var refExists: DatabaseReference!
        refExists = Database.database().reference()
            
        refExists.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(self.currentCity, "Current City")
            if snapshot.hasChild("\(self.currentCity)") {
                print("city exists")
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
