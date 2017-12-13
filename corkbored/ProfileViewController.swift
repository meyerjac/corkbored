//
//  ProfileViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/8/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var birthday = ""
    var imagePicked = 0
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var topImage: UIImageView!
    
    @IBOutlet weak var bottomImage: UIImageView!
    
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
        let name = firstAndLastNameTextView.text
        let bio = bioTextView.text
        
        if (name?.count)! < 6 {
            //name is less than 6 characters, unlikely
            print("error1")
        }
        if (bio?.count)! < 50 {
            //bio is less than 50 characters, please add more
            print("error2")
        }
        
        if birthday == "" {
            //birthday isn't correct, please add birthday
            print("error3")
        }
    }

    @objc func handleLargeProfileImageView(_ sender: UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicked = 0
            print(imagePicked)
            present(imagePickerController, animated: true)
        }
    }

    @objc func handleTopImageView() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePicked = 1
        print(imagePicked)
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc func handleBottomImageView() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePicked = 2
        print(imagePicked)
        present(imagePickerController, animated: true, completion: nil)
    }
    
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if imagePicked == 0 {
            mainImage.image = pickedImage
        } else if imagePicked == 1 {
            topImage.image = pickedImage
        } else if imagePicked == 2 {
            bottomImage.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
        mainImage.contentMode = .scaleAspectFit
        topImage.contentMode = .scaleAspectFit
        bottomImage.contentMode = .scaleAspectFit
        
        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLargeProfileImageView)))
        
        topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTopImageView)))
        
        bottomImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomImageView)))
        
        mainImage.isUserInteractionEnabled = true
        topImage.isUserInteractionEnabled = true
        bottomImage.isUserInteractionEnabled = true
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
