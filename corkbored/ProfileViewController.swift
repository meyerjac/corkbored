//
//  ProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/8/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var birthday: String = "12 4 13"
    var name: String = "Jackson meyer"
    var bio: String = "hello there, default value"
    var imagePickerController = UIImagePickerController()
    
    
  
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var firstAndLastNameTextView: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBAction func birthdayPickView(_ sender: Any) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: (sender as AnyObject).date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            birthday = "\(month) \(day) \(year)"
            print(birthday)
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        goButton.isEnabled = false
        
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultStyle(.dark)
        
        
        SVProgressHUD.setForegroundColor(UIColor.cyan)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.black)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear) //Background Color
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.showProgress(0.1, status: "Creating your profile...")
        
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        
        
        
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).png")
            SVProgressHUD.showProgress(0.2)
        
            if let uploadData = UIImagePNGRepresentation(self.mainImage.image!) {
             
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                 
                    if error != nil {
                        print(error ?? "error")
                        return
                    }
                    SVProgressHUD.showProgress(0.4)
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        SVProgressHUD.showProgress(0.6)
                        let values = ["name": self.name, "birthday": self.birthday, "profilePic": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUid(uid: uid!, values: values as [String : AnyObject])
                    }
                }
        )}
    }
    
    func registerUserIntoDatabaseWithUid(uid: String, values:[String: AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        SVProgressHUD.showProgress(0.7)
        
        
        ref.child("users").child(uid).updateChildValues(values) { (err, ref) in
            SVProgressHUD.showProgress(0.9)
            if err != nil {
                print(err!)
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
                    switch action.style{
                    case .cancel:
                        self.goButton.isEnabled = true
                        print("cancel")
                    case .default:
                        self.goButton.isEnabled = true
                        print("default case")
                    case .destructive:
                        self.goButton.isEnabled = true
                        print("destructive case")
                    }
                }))
            } else {
                 SVProgressHUD.showProgress(1.0)
                 SVProgressHUD.dismiss()
                 self.performSegue(withIdentifier: "ontoFeedSegue", sender: nil)
            }
        }
    }
  
    @objc func handleLargeProfileImageView(_ sender: UIImageView) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            mainImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("cancelled picker")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        mainImage.contentMode = .scaleAspectFit
        
        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLargeProfileImageView)))
        
        mainImage.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
