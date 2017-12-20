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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentCity: String = "San Fransisco"
    var messageBody: String = ""
    var profilePhotoFileName: String = ""
    
    
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
            let profilePic = value?["profilePic"] as? String ?? ""
            let username = value?["username"] as? String ?? ""
            
            let storageRef = Storage.storage().reference().child("profileImages").child("\(profilePic).png")
            
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error ?? "There was an error")
                } else {
                    cell.profilePhotoImageView.image = UIImage(data: data!)
                }
            }

            cell.usernameTextField.text = username
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
           stringTimeStamp = "\(hours) hr"
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
    
        fetchCurrentPosition()
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
        }) { (error) in
            print(error.localizedDescription)
        }
        fetchPosts()
    }
    
    func fetchPosts() {
        Database.database().reference().child("posts").child("San Francisco").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
              let post = Post(snapshot: snapshot)
                self.posts.append(post)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
