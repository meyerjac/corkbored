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
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {
        
        let nowish = String(Date().timeIntervalSinceReferenceDate)
        
        let messageText = messageTextField.text
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        let profileRef = Database.database().reference().child("users").child(uid).child("messaging").child(self.POIUid)
        
        let profRef = profileRef.childByAutoId()
        
        let newMessage = Message(ownerUid: uid, pinnedTimeAsInterval: nowish, postMessage: messageText!)
            
        let message = newMessage.toAnyObject()
        
        profRef.setValue(message)
        
        messageTextField.text = ""
    }
    
    var dmProfileNavImage: UIImage!
    var POIUid = ""
    
    var messageArray = [Message]()

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
         print("hello1")
        loadMessages()
         print("hello3")
        loadTitleImage()
         print("hello4")
        addKeyboardObservers()
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    func loadMessages() {
        let uid = (Auth.auth().currentUser?.uid)!
        var messagingRef: DatabaseReference!
        
        messagingRef = Database.database().reference().child("users").child(uid).child("messaging").child(POIUid)
         print("hello6")
        messagingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                 print("hello7")
                messagingRef.observe(.childAdded) { (snapshot) in
                     print("hello8")
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
         print("hello5")
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quickMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func loadTitleImage() {
        print("hello4")
        let image = dmProfileNavImage
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
    
        let navController = navigationController!

        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
       
        navigationItem.titleView = imageView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hello")
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCellText", for: indexPath)
        
        cell.textLabel?.text = messageArray[indexPath.row].postMessage
        print(messageArray[indexPath.row], "MESSAGE")
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



