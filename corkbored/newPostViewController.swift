//
//  newPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/14/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class newPostViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    var currentCity = "NoLocationFound"
    var uid = ""
    var backgroundColor:String = String(describing: UIColor.white)
    let date = "12 15 17"
    
    var messageTypeImage: String = ""
    var messageTypeLabel: String = ""
    let cellItemLabels = ["Sell something", "Event coming up?", "add Photo/Video", "Text only"]
    let cellItemPhotos = ["pricetag.png", "calendar.png", "picture.png", "text.png"]
    let backgroundColorArray = [UIColor.black, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.darkGray, UIColor.green, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.red]
    
    @IBOutlet weak var charactersRemaining: UILabel!
    
    @IBOutlet weak var whatsOnYourMindTextField: UITextView!
    
    @IBOutlet weak var backgroundColorCollectionView: UICollectionView!
    
    
    @IBAction func postTopBarButton(_ sender: Any) {
        uid = (Auth.auth().currentUser?.uid)!
        
        var profileRef: DatabaseReference!
        var cityFeedRef: DatabaseReference!
        
        profileRef = Database.database().reference().child("users").child(uid).child("posts")
        cityFeedRef = Database.database().reference().child("posts").child(currentCity)
        
        let message:String = whatsOnYourMindTextField.text
        
        let post = Post(postOwnerUid: uid, message: message, backgroundColor: backgroundColor, date: date).toAnyObject()
        
         print(post)
        
         profileRef.childByAutoId().setValue(post)
         cityFeedRef.childByAutoId().setValue(post)
        
        
        //at very end, on completion of post being sent to firebase successfully
        
        performSegue(withIdentifier: "postToFeed", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItemLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundColorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backgroundColorCell", for: indexPath) as! BackgroundColorCollectionViewCell
        
        backgroundColor = String(describing: backgroundColorArray[indexPath.row])
        
        cell.colorLabel.backgroundColor = backgroundColorArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        whatsOnYourMindTextField.backgroundColor = backgroundColorArray[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postOptionTableCell", for: indexPath) as! MessageTypeTableViewCell
        
        cell.messageTypeImage.image = UIImage(named: cellItemPhotos[indexPath.row])
        
        cell.messageTypeLabel.text = cellItemLabels[indexPath.row]
        
        cell.messageTypeImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(cellItemLabels[indexPath.row])
        
        switch (indexPath.row){
        case 0:
            sellCellSelected()
            
        case 1:
            print("1")
            backgroundColorCollectionView.isHidden = true
        case 2:
            print("1")
            backgroundColorCollectionView.isHidden = true
        case 3:
            print("1")
            backgroundColorCollectionView.isHidden = false
            
        default:
            print("nothing selected")
        }
    }
    
    func sellCellSelected() {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = (Auth.auth().currentUser?.uid)!
        var profileRef: DatabaseReference!
        
        profileRef = Database.database().reference().child("users").child(uid)
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentCity = value?["currentCity"] as? String ?? ""
            
            // ...
        })

        // Do any additional setup after loading the view.
        
        whatsOnYourMindTextField.text = ""

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location + range.length > whatsOnYourMindTextField.text.count {
            
            return false
            
        }
        
        let maxChar = 150
        
        charactersRemaining.text = String(maxChar - whatsOnYourMindTextField.text.count)
        
        if (maxChar - whatsOnYourMindTextField.text.count) <= 20 {
            
            charactersRemaining.textColor = UIColor.red
            
        } else if (maxChar - whatsOnYourMindTextField.text.count) <= 60 {
            
            charactersRemaining.textColor = UIColor.green
            
        }
        
        let newLength = whatsOnYourMindTextField.text.count + text.count - range.length
        
        return newLength <= maxChar
    }
    
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
