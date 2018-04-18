//
//  quickMessageViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase

class quickMessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    var dmProfileNavImage: UIImage!
    var POIUid = ""
    var userName = ""
    var messageArray = [Message]()
    var currentUserUid = ""
    
    @IBAction func textFieldEditingInProgress(_ sender: Any) {
        print("here")
        if messageTextField.text == "" {
            print("here1")
           sendButton.isEnabled = false
        } else {
            print("here2")
            sendButton.isEnabled = true
        }

    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {

        let nowish = String(Date().timeIntervalSinceReferenceDate)
        
        let messageText = messageTextField.text
        
        currentUserUid = (Auth.auth().currentUser?.uid)!
        
        let UserOneMessagingRef = Database.database().reference().child("users").child(currentUserUid).child("messaging").child(self.POIUid)
        let UserTwoMessagingRef = Database.database().reference().child("users").child(self.POIUid).child("messaging").child(currentUserUid)
        
        let messagingProfileOne = UserOneMessagingRef.childByAutoId()
        let messagingProfileTwo = UserTwoMessagingRef.childByAutoId()
        
        let messagingRefOneUid = messagingProfileOne.key
        let messagingRefTwoUid = messagingProfileTwo.key
        
        let uids = [messagingRefOneUid, messagingRefTwoUid]
        let refs = [messagingProfileOne, messagingProfileTwo]
        
        let newMessage = Message(userOneUid: currentUserUid, userTwoUid: POIUid, pinnedTimeAsInterval: nowish, postMessage: messageText!)
        let message = newMessage.toAnyObject()
        
        for i in 0 ... 1 {
            
            refs[i].setValue(message)
            
        }
        messageTextField.text = ""
        sendButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quickMessageCell") as! quickMessageCustomCell
        cell.messageLabel.text = messageArray[indexPath.row].postMessage
        cell.messageLabel.numberOfLines = 0
        cell.messageProfileView.image = self.dmProfileNavImage
        cell.messageProfileView.layer.cornerRadius = 5
        cell.messageProfileView.clipsToBounds = true

   
//        cell.messageLabel.frame.size = cell.messageLabel.intrinsicContentSize
        let newFrame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: cell.messageLabel.intrinsicContentSize.width, height: cell.messageLabel.intrinsicContentSize.height)
        
        cell.messageLabel.frame = newFrame
        
//        cell.messageLabel.frame = CGRect(x: view.frame.origin.x + (view.frame.size.height / 2), y: view.frame.origin.y, width: cell.messageLabel.intrinsicContentSize.width, height: cell.messageLabel.intrinsicContentSize.height)
      
        cell.messageLabel.layer.borderWidth = 1.0
        cell.messageLabel.layer.borderColor = UIColor.gray.cgColor
        cell.messageLabel.layer.masksToBounds = true
        cell.messageLabel.layer.cornerRadius = 5
        
//
//        cell.messageContainerViewLabel.setNeedsLayout()
//        cell.messageContainerViewLabel.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserUid = (Auth.auth().currentUser?.uid)!
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        messageTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadMessages()
        loadTitle()
        loadViews()
        addKeyboardObservers()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tableView.addGestureRecognizer(tap)
    }
    
    func loadMessages() {
        var messagingRef: DatabaseReference!
        
        messagingRef = Database.database().reference().child("users").child(self.currentUserUid).child("messaging").child(POIUid)
        messagingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                messagingRef.observe(.childAdded) { (snapshot) in
                    if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                        let message = Message(snapshot: snapshot)
                        self.messageArray.insert(message, at: self.messageArray.endIndex)
                        DispatchQueue.main.async {
                                self.tableView.reloadData()
//                            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
//                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
        })
    }
    
    func loadTitle() {
        self.navigationItem.title = self.userName
    }
    
    func loadViews() {
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            let sendButtonxPosition = sendButton.frame.origin.x
            let sendButtonyPosition = sendButton.frame.origin.y - keyboardSize.height
            let sendButtonHeight = sendButton.frame.size.height
            let sendButtonWidth = sendButton.frame.size.width
            
            //TableView
            let tableViewxPosition = tableView.frame.origin.x
            let tableViewyPosition = tableView.frame.origin.y
            let tableViewHeight = tableView.frame.size.height - keyboardSize.height
            let tableViewWidth = tableView.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                self.messageTextField.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                self.sendButton.frame = CGRect(x: sendButtonxPosition, y: sendButtonyPosition, width: sendButtonWidth, height: sendButtonHeight)
                self.tableView.frame = CGRect(x: tableViewxPosition, y: tableViewyPosition, width: tableViewWidth, height: tableViewHeight)
                
            }, completion: {(completed) in
                if self.messageArray.count == 0 {
                    
                } else {
                let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
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
            let sendButtonxPosition = sendButton.frame.origin.x
            let sendButtonyPosition = sendButton.frame.origin.y + keyboardSize.height
            let sendButtonHeight = sendButton.frame.size.height
            let sendButtonWidth = sendButton.frame.size.width
            
            //CollectionView
            let tableViewxPosition = tableView.frame.origin.x
            let tableViewyPosition = tableView.frame.origin.y
            let tableViewHeight = tableView.frame.size.height + keyboardSize.height
            let tableViewWidth = tableView.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                self.messageTextField.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                self.sendButton.frame = CGRect(x: sendButtonxPosition, y: sendButtonyPosition, width: sendButtonWidth, height: sendButtonHeight)
                self.tableView.frame = CGRect(x: tableViewxPosition, y: tableViewyPosition, width: tableViewWidth, height: tableViewHeight)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



