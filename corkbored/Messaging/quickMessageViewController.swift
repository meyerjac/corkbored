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

//        let size:CGSize = messageTextField.attributedText!.size()
//        let textHeight = size.height
//        let textWidth = size.width
//        let messageTextFieldHeight = messageTextField.frame.size.height
//        let messageTextFieldWidth = messageTextField.frame.size.width
//        var currentFontSize = messageTextField.font?.pointSize
//
//        if messageTextFieldWidth - textWidth <= 20 {
//            //text is getting close to edge, shift up
//
//        } else {
//            let duration = 1.0
//            UIView.animate(withDuration: duration as! TimeInterval, animations: {
//
//            }, completion: {(completed) in
//                print("in completition")
//            })
//        }
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
    
        cell.messageContainerViewLabel.layer.borderWidth = 1.0
        cell.messageContainerViewLabel.layer.borderColor = UIColor.gray.cgColor
        cell.messageContainerViewLabel.layer.masksToBounds = true
        cell.messageContainerViewLabel.layer.cornerRadius = 5
        

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
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadMessages()
        loadTitle()
        loadViews()
        addKeyboardObservers()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
                        }
                    }
                }
        })
    }
    
    func loadTitle() {
        
        self.navigationItem.title = self.userName
    }
    
    func loadViews() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(OtherProfileViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



