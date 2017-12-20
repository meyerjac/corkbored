//  createPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/18/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.

import UIKit
import Firebase
import SVProgressHUD

class createPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController = UIImagePickerController()
    
    var currentCity = "noCity"
    
    var nowish = "0.0"
    
    @IBAction func addPicture(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    @IBOutlet weak var newPostImageView: UIImageView!
    
    @IBOutlet weak var whatsOnYourMindTextField: UITextView!
    
    @IBOutlet weak var charactersRemaining: UILabel!
    
    @IBAction func postBarButtonItemClicked(_ sender: Any) {
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("postImages").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.newPostImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error ?? "error")
                    return
                } else {
                    let uid = (Auth.auth().currentUser?.uid)!
                    var profileRef: DatabaseReference!
                    var cityFeedRef: DatabaseReference!
                    profileRef = Database.database().reference().child("users").child(uid).child("posts")
                    cityFeedRef = Database.database().reference().child("posts").child(self.currentCity)
                    
                    let message = self.whatsOnYourMindTextField.text
                    
                    let poster = Post(pinnedTimeAsInterval: self.nowish, ownerUid: uid, postMessage: message!, pinnedMediaFileName: imageName)
                    
                    let post = poster.toAnyObject()
                    
                    print(post)
                    
                    profileRef.childByAutoId().setValue(post)
                    
                    cityFeedRef.childByAutoId().setValue(post)
                      print("we are here 5")
                    
                    self.performSegue(withIdentifier: "postBarButtonToFeed", sender: nil)
                }
            }
        )}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            newPostImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("cancelled picker")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location + range.length > whatsOnYourMindTextField.text.count {
            
            return false
            
        }
        
        let maxChar = 100
        
        charactersRemaining.text = String(maxChar - whatsOnYourMindTextField.text.count)
        
        if (maxChar - whatsOnYourMindTextField.text.count) <= 20 {
            
            charactersRemaining.textColor = UIColor.red
            
        } else if (maxChar - whatsOnYourMindTextField.text.count) <= 60 {
            
            charactersRemaining.textColor = UIColor.green
            
        }
        
        let newLength = whatsOnYourMindTextField.text.count + text.count - range.length
        
        return newLength <= maxChar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPostImageView.contentMode = .scaleAspectFit
        
          nowish = String(Date().timeIntervalSinceReferenceDate)
        
                var uid = (Auth.auth().currentUser?.uid)!
        
                uid = (Auth.auth().currentUser?.uid)!
                var profileRef: DatabaseReference!
        
                profileRef = Database.database().reference().child("users").child(uid)
                profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    self.currentCity = value?["currentCity"] as? String ?? ""
        
                    // ...
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
