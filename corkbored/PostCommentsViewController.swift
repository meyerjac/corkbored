//
//  PostCommentsViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/13/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PostCommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var messageBodyText = String()
    var username = String()
    var timeSincePost = String()
    var postOwnerUid = String()
    var currentCity = String()
    var postUid = String()
    var commentsArray = [Comment]()
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func sendCommentButtonClicked(_ sender: Any) {
        var PostRef = Database.database().reference().child("posts").child(currentCity).child(postUid).child("comments")
        let replyRef = PostRef.childByAutoId()

        var typedComment = commentTextField.text!
        var nowish = String(Date().timeIntervalSinceReferenceDate)
        var ownerUid = (Auth.auth().currentUser?.uid)!
        
        let comment = Comment(pinnedTimeAsInterval: nowish, ownerUid: ownerUid, commentMessage: typedComment, postUid: postUid)
        let commentObject = comment.toAnyObject()
        replyRef.setValue(commentObject)
        
        commentTextField.text = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(commentsArray)
        return commentsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //getting time stamp of users device to to compare to stamp of post
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        //pulling and identifying each post from array as a single post
        let comment = commentsArray[indexPath.row]
        
        //getting the correct timestamp label for post
        let postDate = Double(comment.pinnedTimeAsInterval)
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
        
        
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! PostCommentTableViewCell
        
        cell.commentCellMessageBody.text = comment.commentMessage
        cell.commentCellTimeLabel.text = stringTimeStamp
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        fetchPosts()
    
        commentTextField.delegate = self
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillChangeFrame, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func loadPost() {
        messageBodyLabel.text = messageBodyText
        usernameLabel.text = username
        
        //getting time stamp of users device to to compare to stamp of post
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        //getting the correct timestamp label for post
        let postDate = Double(self.timeSincePost)
        
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
         timeLabel.text = stringTimeStamp
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
    
    func fetchPosts() {
        var refExists: DatabaseReference!
        refExists = Database.database().reference().child("posts")
        refExists.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.currentCity) {
                print("Comment2")
                self.commentsTableView.isHidden = false
                
                refExists.child(self.currentCity).child(self.postUid).child("comments").observe(.childAdded) { (snapshot) in
                    print("Comment3")
                    if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                        print("Comment4")
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
