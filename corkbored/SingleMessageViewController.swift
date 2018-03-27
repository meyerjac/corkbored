//
//  SingleMessageViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/24/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SingleMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate {
    
    var individualMessageArray = [Message]()
    var messageUid = ""
    var currentUserUid: String = ""
    
    @IBOutlet weak var messageCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        let nowish = String(Date().timeIntervalSinceReferenceDate)
        
        let messageText = messageTextField.text
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        let UserOneMessagingRef = Database.database().reference().child("users").child(uid).child("messaging").child(self.messageUid)
        let UserTwoMessagingRef = Database.database().reference().child("users").child(self.messageUid).child("messaging").child(uid)
        
        let messagingProfileOne = UserOneMessagingRef.childByAutoId()
        let messagingProfileTwo = UserTwoMessagingRef.childByAutoId()
        
        let messagingRefOneUid = messagingProfileOne.key
        let messagingRefTwoUid = messagingProfileTwo.key
        
        let uids = [messagingRefOneUid, messagingRefTwoUid]
        let refs = [messagingProfileOne, messagingProfileTwo]
        
        let newMessage = Message(userOneUid: uid, userTwoUid: self.messageUid, pinnedTimeAsInterval: nowish, postMessage: messageText!)
        let message = newMessage.toAnyObject()
        
        for i in 0 ... 1 {
            
            refs[i].setValue(message)
            
        }
        
        messageTextField.text = ""
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return individualMessageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! MessageCollectionViewCell
        
        print(indexPath.section, "section")
        print(indexPath.row, "row")
        
        //person who sent the message appears on the right side in white
        if individualMessageArray[indexPath.section].userOneUid != self.currentUserUid {
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 22
            cell.backgroundColor = UIColor.white
            
        } else {
            //person who recieved messages, on left in  red
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 22
            cell.backgroundColor = UIColor.red
        }
        
        cell.messageLabel.text = individualMessageArray[indexPath.section].postMessage
        
        cell.messageLabel.frame.size.width = cell.messageLabel.intrinsicContentSize.width
        
        cell.frame.size.width = cell.messageLabel.frame.size.width + 40
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(messageUid, "Message or User UID")
        fetchMessages()
        addKeyboardObservers()
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        messageCollectionView.addGestureRecognizer(dismissKeyboardGesture)
        
        messageCollectionView.dataSource = self
        messageCollectionView.delegate = self
    }
    

    
    func fetchMessages() {
        currentUserUid = (Auth.auth().currentUser?.uid)!
        var messagingRef: DatabaseReference!
        
        messagingRef = Database.database().reference().child("users").child(self.currentUserUid).child("messaging").child(messageUid)
        messagingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            messagingRef.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                    let message = Message(snapshot: snapshot)
                    self.individualMessageArray.insert(message, at: self.individualMessageArray.endIndex)
                    DispatchQueue.main.async {
                        self.messageCollectionView.reloadData()
                    }
                }
            }
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
