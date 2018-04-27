//  createPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/18/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.

import UIKit
import Firebase
import SVProgressHUD

class createPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var hangoutStartTimePickerView: UIPickerView!
    @IBOutlet weak var hangoutEndTimePickerView: UIPickerView!
    @IBOutlet weak var hangoutEmojiDecriptionButton: UIButton!
    @IBOutlet weak var createPostButton: UIButton!
    @IBAction func hangoutEmojiDescriptionButton(_ sender: Any) {
        
    }
    @IBAction func createPostButton(_ sender: Any) {
        
    }
  
    var currentCity = ""
    var commentArray = [Comment]()
    var nowish = "0.0"
    var numberOfComments = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLoginInfo()
        getUsersLocation()
        addKeyboardObservers()
        
        let postButton = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(createPostViewController.post))
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(createPostViewController.cancelBackToFeed))
        
        self.navigationItem.rightBarButtonItem  = postButton
        self.navigationItem.leftBarButtonItem  = cancelButton
    
        nowish = String(Date().timeIntervalSinceReferenceDate)
    }
    
    func handleCreatedEvent() {
//        let message = self.whatsOnYourMindTextField.text
//        let uid = (Auth.auth().currentUser?.uid)!
//
//        var profileRef = Database.database().reference().child("users").child(uid).child("posts")
//        var cityFeedRef = Database.database().reference().child("posts").child(self.currentCity)
//
//        let profRef = profileRef.childByAutoId()
//        let feedRef = cityFeedRef.childByAutoId()
//
//        let profRefUid = profRef.key
//        let feedRefUid = feedRef.key
//
//        let uids = [profRefUid, feedRefUid]
//        let refs = [profRef, feedRef]
//
//        for i in 0 ... 1 {
//            let poster = Post(pinnedTimeAsInterval: self.nowish, ownerUid: uid, postMessage: message!, postUid: uids[i], pinnedMediaFileName: "null", likes: self.reactionArray, comments: self.commentArray, numberOfComments: self.numberOfComments)
//
//            let post = poster.toAnyObject()
//            refs[i].setValue(post)
//
//        }
//        whatsOnYourMindTextField.text = ""
//        newPostImageView.isHidden = true
//        dismiss(animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = 0
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func cancelBackToFeed() {
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
            handleCreatedEvent()
    }
    
    func getLoginInfo() {
        let uid = (Auth.auth().currentUser?.uid)!
        let profileRef: DatabaseReference!
        
        profileRef = Database.database().reference().child("users").child(uid)
    }
    
    func getUsersLocation() {
        let userLocationObject = UserDefaults.standard.object(forKey: "currentUserLocation")
        if let userLocation = userLocationObject as? String {
            currentCity = userLocation
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func ok() {
        let postButton = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(createPostViewController.post))
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(createPostViewController.cancelBackToFeed))
        
        self.navigationItem.rightBarButtonItem  = postButton
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.title = "Create Post"
        dismissKeyboard()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
//            let postButton = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(createPostViewController.post))
//            let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(createPostViewController.cancelBackToFeed))
//
//            self.navigationItem.rightBarButtonItem  = postButton
//            self.navigationItem.leftBarButtonItem  = cancelButton
//            self.navigationItem.title = "Create Post"
        }
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
