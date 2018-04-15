//
//  quickMessageViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase

class quickMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var dmProfileNavImage: UIImage!
    var POIUid = ""
    var messageArray = [Message]()
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {
        
        let nowish = String(Date().timeIntervalSinceReferenceDate)
        
        let messageText = messageTextField.text
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        let UserOneMessagingRef = Database.database().reference().child("users").child(uid).child("messaging").child(self.POIUid)
        let UserTwoMessagingRef = Database.database().reference().child("users").child(self.POIUid).child("messaging").child(uid)
        
        let messagingProfileOne = UserOneMessagingRef.childByAutoId()
        let messagingProfileTwo = UserTwoMessagingRef.childByAutoId()
        
        let messagingRefOneUid = messagingProfileOne.key
        let messagingRefTwoUid = messagingProfileTwo.key
        
        let uids = [messagingRefOneUid, messagingRefTwoUid]
        let refs = [messagingProfileOne, messagingProfileTwo]
        
        let newMessage = Message(userOneUid: uid, userTwoUid: POIUid, pinnedTimeAsInterval: nowish, postMessage: messageText!)
        let message = newMessage.toAnyObject()
        
        for i in 0 ... 1 {
            
            refs[i].setValue(message)
            
        }
        
        messageTextField.text = ""

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        loadMessages()
        loadTitleImage()
        addKeyboardObservers()
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    func loadMessages() {
        let uid = (Auth.auth().currentUser?.uid)!
        var messagingRef: DatabaseReference!
        
        messagingRef = Database.database().reference().child("users").child(uid).child("messaging").child(POIUid)
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func loadTitleImage() {
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageview.image = dmProfileNavImage
        imageview.contentMode = UIViewContentMode.scaleAspectFit
        imageview.layer.cornerRadius = 5
        imageview.layer.masksToBounds = true
        containView.addSubview(imageview)
//        let centerBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.titleView = containView
        
//        let image = dmProfileNavImage
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 15
//        imageView.clipsToBounds = true
//
//
//        let navController = navigationController!
//
//        let bannerWidth = navController.navigationBar.frame.size.width
//        let bannerHeight = navController.navigationBar.frame.size.height
//
//        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
//        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
//
//        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
//
//        navigationItem.titleView = imageView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hello")
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCellText", for: indexPath)
        
        cell.textLabel?.text = messageArray[indexPath.row].postMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return messageArray.count
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



