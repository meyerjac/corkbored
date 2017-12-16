//
//  newPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/14/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase

class newPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var charactersRemaining: UILabel!
    
    @IBOutlet weak var whatsOnYourMindTextField: UITextView!
    
    @IBAction func postTopBarButton(_ sender: Any) {
        
        let uid:String = (Auth.auth().currentUser?.uid)!
        let message:String = whatsOnYourMindTextField.text
        let backgroundColor:String = "white"
        let date = "12 15 17"
        
        let post = Post(postOwnerUid: uid, message: message, backgroundColor: backgroundColor, date: date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        whatsOnYourMindTextField.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location + range.length > whatsOnYourMindTextField.text.count {
            
            return false
            
        }
        
        let maxChar = 150
        
        charactersRemaining.text = String(maxChar - whatsOnYourMindTextField.text.count)
        
        if (maxChar - whatsOnYourMindTextField.text.count) <= 60 {
            
            charactersRemaining.textColor = UIColor.green
            
        } else if (maxChar - whatsOnYourMindTextField.text.count) <= 20 {
            
            charactersRemaining.textColor = UIColor.red
            
        }
        
        let newLength = whatsOnYourMindTextField.text.count + text.count - range.length
        
        return newLength <= maxChar
    }
    
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
