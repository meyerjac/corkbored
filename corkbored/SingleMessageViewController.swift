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

class SingleMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
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
        if let count = individualMessageArray.count as Int?  {
            return count
            print(count, "Count")
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! MessageCollectionViewCell
            var perfectMaxCellWidth = (view.frame.size.width * 2 / 3)
        
            cell.backgroundColor = UIColor.clear
            cell.messageView.text = individualMessageArray[indexPath.section].postMessage
    
            let messageText = individualMessageArray[indexPath.section].postMessage as? String
            let size = CGSize(width: perfectMaxCellWidth, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let attributes = [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        
                //Other users message
                if individualMessageArray[indexPath.section].userOneUid == self.currentUserUid {
                    cell.messageView.layer.borderWidth = 1.0
                    cell.messageView.layer.borderColor = UIColor.red.cgColor
                    cell.messageView.layer.masksToBounds = true
                    cell.messageView.layer.cornerRadius = 14
                    cell.messageView.backgroundColor = UIColor.white
                    
                       cell.messageView.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 16 - 12, y: 0, width: estimatedFrame.width + 12, height: estimatedFrame.height + 16)
              
                } else {
                    //current users message
                    cell.messageView.layer.masksToBounds = true
                    cell.messageView.layer.cornerRadius = 14
                    cell.messageView.backgroundColor = UIColor.red
                    
                    cell.messageView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 12, height: estimatedFrame.height + 16)
                    
                }
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let size = CGSize(width:  view.frame.size.width * 2 / 3 , height: 1000)
         let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
         let attributes = [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 18)]
         let messageText = individualMessageArray[indexPath.section].postMessage as? String
         let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
