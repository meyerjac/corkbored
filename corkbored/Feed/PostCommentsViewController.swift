//
//  PostCommentsViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/13/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import UIKit
import Nuke

class PostCommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    //getting all these from previous view controller on a prepare for sender
    var clickedPostMessageBody = String()
    var clickedUsername = String()
    var clickedPostTimeStamp = String()
    var clickedPostOwnerUid = String()
    var clickedCurrentCity = String()
    var clickedPostUid = String()
    var clickedPostProfilePicture = UIImage()
    var clickedPostMedia = UIImage()
    var commentsArray = [Comment]()
    
    var manager = Nuke.Manager.shared
    var myProfilePictureUrl = String()
    
    //commentProfilesRef
    var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var descriptionOfEventLabel: UILabel!
    @IBOutlet weak var titleOfEventLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postUserProfileImageView: UIImageView!
    
    @IBAction func sendCommentButtonClicked(_ sender: Any) {
        let PostRef = Database.database().reference().child("posts").child(clickedCurrentCity).child(clickedPostUid).child("comments")
        let PostRefForNumberOfComments = Database.database().reference().child("posts").child(clickedCurrentCity).child(clickedPostUid).child("numberOfComments")
        
        PostRefForNumberOfComments.observeSingleEvent(of: .value, with: { (snapshot) in
            let valString = snapshot.value as! String
            if let value = Int(valString) {
                let newValue = value + 1
                PostRefForNumberOfComments.setValue("\(newValue)")
            }
        })
        
        
        let replyRef = PostRef.childByAutoId()

        let typedComment = commentTextField.text!
        let nowish = String(Date().timeIntervalSinceReferenceDate)
        let ownerUid = (Auth.auth().currentUser?.uid)!
        
        let comment = Comment(pinnedTimeAsInterval: nowish, ownerUid: ownerUid, commentMessage: typedComment, postUid: clickedPostUid)
        let commentObject = comment.toAnyObject()
        
        replyRef.setValue(commentObject)
        
        commentTextField.text = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! PostCommentTableViewCell
        
        ref.child("users").child(commentsArray[indexPath.row].ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            
            let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
            
            if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                self.manager.loadImage(with: urlUrl, into: cell.commentProfileImageVIew)
            }
        })
        
        //getting time stamp of users device to to compare to stamp of post
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        //pulling and identifying each post from array as a single post
        let comment = commentsArray[indexPath.row]
        
        //getting the correct timestamp label for post
        let postDate = Double(comment.pinnedTimeAsInterval)
        print(postDate, "Post date")
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
        }
        
//        cell.messageBody.text = comment.commentMessage
        cell.commentCellTimeLabel.text = stringTimeStamp
        cell.commentProfileImageVIew.layer.cornerRadius = 5.0
        cell.commentProfileImageVIew.clipsToBounds = true
        print(stringTimeStamp, "timeStamp")
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        loadPost()
        fetchComments()
    
    
        commentTextField.delegate = self
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillChangeFrame, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func loadPost() {
        descriptionOfEventLabel.text = clickedPostMessageBody
        usernameLabel.text = clickedUsername
        timeLabel.text = clickedPostTimeStamp
        
        postUserProfileImageView.image = clickedPostProfilePicture
        postUserProfileImageView.contentMode = .scaleAspectFill
        postUserProfileImageView.layer.borderWidth = 1.0
        postUserProfileImageView.layer.masksToBounds = true
        postUserProfileImageView.layer.borderColor = UIColor.white.cgColor
        postUserProfileImageView.layer.cornerRadius = 5.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        commentTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.commentTextField.frame.origin.y+=deltaY + 48
            self.sendCommentButton.frame.origin.y+=deltaY + 48
            self.commentsTableView.frame.size.height += deltaY + 48
        },completion: nil)
    }
    
    func fetchComments() {
        var refExists: DatabaseReference!
        refExists = Database.database().reference().child("posts")
        refExists.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.clickedCurrentCity) {
                self.commentsTableView.isHidden = false
                refExists.child(self.clickedCurrentCity).child(self.clickedPostUid).child("comments").observe(.childAdded) { (snapshot) in
                
                    if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                        let comment = Comment(snapshot: snapshot)
                        self.commentsArray.insert(comment, at: self.commentsArray.endIndex)
                        DispatchQueue.main.async {
                            self.commentsTableView.reloadData()
                        }
                    }
                }
            }else{
                print("city doesn't exist")
                self.commentsTableView.isHidden = true
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
