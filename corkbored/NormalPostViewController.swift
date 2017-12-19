//
//  NormalPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/18/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class NormalPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var charactersRemaining: UILabel!
    
    @IBOutlet weak var whatsOnYourMindTextField: UITextView!

    
    var backgroundColorArray = [UIColor.black, UIColor.blue, UIColor.red, UIColor.magenta, UIColor.gray, UIColor.cyan, UIColor.darkGray, UIColor.purple, UIColor.orange]
    
    var backgroundColor: Int = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return backgroundColorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backgroundCell", for: indexPath) as! postBackgroundCollectionViewCell
        
        cell.backgroundImage.contentMode = .scaleAspectFill
        
        cell.backgroundColor = backgroundColorArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        backgroundColor = indexPath.row
        
        whatsOnYourMindTextField.backgroundColor = backgroundColorArray[indexPath.row]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
