//
//  createPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/18/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class createPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var normalView: UIView!
    
    @IBOutlet weak var sellView: UIView!
    
    let nowish = Date().timeIntervalSinceReferenceDate
    let cellItemLabels = ["Sell something", "Event coming up?", "Just Post"]
    let cellItemPhotos = ["pricetag.png", "calendar.png", "text.png"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellItemLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! postTypeTableViewCell
        
        cell.postTypeImage.image = UIImage(named: cellItemPhotos[indexPath.row])
        
        cell.postTypeLabel.text = cellItemLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row){
        case 0:
            //Sell
            print("sell")
            normalView.isHidden = true
            eventView.isHidden = true
            sellView.isHidden = false
        case 1:
            //Event
            print("1")
            normalView.isHidden = true
            eventView.isHidden = false
            sellView.isHidden = true
        case 2:
            //Post
            print("2")
            normalView.isHidden = false
            eventView.isHidden = true
            sellView.isHidden = true
            
        default:
            print("nothing selected")
        }
    }
    
    //ACTION
    
    //        uid = (Auth.auth().currentUser?.uid)!
    //
    //        var profileRef: DatabaseReference!
    //        var cityFeedRef: DatabaseReference!
    //
    //        profileRef = Database.database().reference().child("users").child(uid).child("posts")
    //        cityFeedRef = Database.database().reference().child("posts").child(currentCity)
    //
    //
    
    
    //        let post = Post(pinnedTimeAsInterval: <#T##Int#>, ownerUid: <#T##String#>, type: <#T##String#>, sellItemDescription: <#T##String#>, sellPrice: <#T##Int#>, sellPhotoUrl: <#T##String#>, sellCondition: <#T##String#>, eventDateTime: <#T##String#>, eventLocation: <#T##String#>, eventDescription: <#T##String#>, postMessage: <#T##String#>, postBackgroundColor: <#T##String!#>, pinnedMediaUrl: <#T##String#>)
    //
    //         print(post)
    
    //         profileRef.childByAutoId().setValue(post)
    //         cityFeedRef.childByAutoId().setValue(post)
    
    
    //at very end, on completion of post being sent to firebase successfully
    //
    //        performSegue(withIdentifier: "postToFeed", sender: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        //
        //        uid = (Auth.auth().currentUser?.uid)!
        //        var profileRef: DatabaseReference!
        //
        //        profileRef = Database.database().reference().child("users").child(uid)
        //        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
        //            // Get user value
        //            let value = snapshot.value as? NSDictionary
        //            self.currentCity = value?["currentCity"] as? String ?? ""
        //
        //            // ...
        //        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
