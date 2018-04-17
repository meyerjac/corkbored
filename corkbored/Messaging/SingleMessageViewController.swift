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

class SingleMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var individualMessageArray = [Message]()
    var messageUid = ""
    var currentUserUid: String = ""
    var bottomConstraintTextView: NSLayoutConstraint?
    var bottomConstraintSendButton: NSLayoutConstraint?
    var cornerRadius = Int(5)
    
   
    @IBOutlet weak var messageCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBAction func textViewEditingBegan(_ sender: Any) {
        print("here")
    }
        
    @IBAction func sendMessageButton(_ sender: Any) {
        
        let nowish = String(Date().timeIntervalSinceReferenceDate)
        let messageText = messageTextField.text
        let uid = (Auth.auth().currentUser?.uid)!
        
        //getting Profile picture and username
        var UserOneMessagingRef: DatabaseReference!
        UserOneMessagingRef = Database.database().reference().child("users").child(uid).child("messaging").child(self.messageUid)
        var UserTwoMessagingRef: DatabaseReference!
        UserTwoMessagingRef = Database.database().reference().child("users").child(self.messageUid).child("messaging").child(uid)
        
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
        let attributes = [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        
        //Other users message
        if individualMessageArray[indexPath.section].userOneUid == self.currentUserUid {
            cell.messageView.layer.borderWidth = 0.5
            cell.messageView.layer.borderColor = UIColor.gray.cgColor
            cell.messageView.layer.masksToBounds = true
            cell.messageView.layer.cornerRadius = CGFloat(cornerRadius)
            cell.messageView.backgroundColor = UIColor.white
            
            cell.messageView.frame = CGRect(x: self.view.frame.width - estimatedFrame.width - 16 - 12, y: 0, width: estimatedFrame.width + 12, height: estimatedFrame.height + 16)
            
        } else {
            //current users message
            cell.messageView.layer.masksToBounds = true
            cell.messageView.layer.cornerRadius = CGFloat(cornerRadius)
            cell.messageView.backgroundColor = UIColor.gray
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
        
        loadViews()
        fetchMessages()
        addKeyboardObservers()
        
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.masksToBounds = true
        messageTextField.layer.cornerRadius = CGFloat(cornerRadius)
        messageTextField.backgroundColor = UIColor.white
        messageTextField.delegate = self
        
        messageCollectionView.dataSource = self
        messageCollectionView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        messageCollectionView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func loadViews() {
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(OtherProfileViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
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
        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            //messageView
            let xPosition = messageTextField.frame.origin.x
            let yPosition = messageTextField.frame.origin.y - keyboardSize.height
            let height = messageTextField.frame.size.height
            let width = messageTextField.frame.size.width
            
            //sendMessageButton
            let sendButtonxPosition = sendMessageButton.frame.origin.x
            let sendButtonyPosition = sendMessageButton.frame.origin.y - keyboardSize.height
            let sendButtonHeight = sendMessageButton.frame.size.height
            let sendButtonWidth = sendMessageButton.frame.size.width
            
            //CollectionView
            let collectionViewxPosition = messageCollectionView.frame.origin.x
            let collectionViewyPosition = messageCollectionView.frame.origin.y
            let collectionViewHeight = messageCollectionView.frame.size.height - keyboardSize.height
            let collectionViewWidth = messageCollectionView.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
            self.messageCollectionView.frame = CGRect(x: collectionViewxPosition, y: collectionViewyPosition, width: collectionViewWidth, height: collectionViewHeight)
                
            self.messageTextField.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

            self.sendMessageButton.frame = CGRect(x: sendButtonxPosition, y: sendButtonyPosition, width: sendButtonWidth, height: sendButtonHeight)
          
            }, completion: {(completed) in
                print("in completition")
                
                let indexPath = NSIndexPath(item: 0, section: self.individualMessageArray.count - 1)
                self.messageCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            //messageView
            let xPosition = messageTextField.frame.origin.x
            let yPosition = messageTextField.frame.origin.y + keyboardSize.height
            let height = messageTextField.frame.size.height
            let width = messageTextField.frame.size.width
            
            //sendButtonView
            let sendButtonxPosition = sendMessageButton.frame.origin.x
            let sendButtonyPosition = sendMessageButton.frame.origin.y + keyboardSize.height
            let sendButtonHeight = sendMessageButton.frame.size.height
            let sendButtonWidth = sendMessageButton.frame.size.width
            
            //CollectionView
            let collectionViewxPosition = messageCollectionView.frame.origin.x
            let collectionViewyPosition = messageCollectionView.frame.origin.y
            let collectionViewHeight = messageCollectionView.frame.size.height + keyboardSize.height
            let collectionViewWidth = messageCollectionView.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                self.messageTextField.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                self.sendMessageButton.frame = CGRect(x: sendButtonxPosition, y: sendButtonyPosition, width: sendButtonWidth, height: sendButtonHeight)
                self.messageCollectionView.frame = CGRect(x: collectionViewxPosition, y: collectionViewyPosition, width: collectionViewWidth, height: collectionViewHeight)
            })
        }
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
