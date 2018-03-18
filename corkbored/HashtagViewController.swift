//
//  HashtagViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/16/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ASIACheckmarkView
import AudioToolbox

class HashtagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var checkmarkOrEx: ASIACheckmarkView!
    @IBAction func nextButton(_ sender: Any) {
        if selectedHashtags.count < 10 {
            //button shake, select more
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.checkmarkOrEx.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.checkmarkOrEx.transform = CGAffineTransform.identity
                    })
                }
            } else {
            //send array to database
            if let uid = Auth.auth().currentUser?.uid {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                ref.child("users").child(uid).child("hashtags").setValue(selectedHashtags)
            }
                performSegue(withIdentifier: "interestsToRules", sender: nil)
            }
        }
    
    func changeState() {
        let newValue = !checkmarkOrEx.boolValue // boolValue describes current checkmark state
        checkmarkOrEx.animate(checked: newValue) // animate to state you want
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var HashtagCollectionView: UICollectionView!
    
    private var numberOfHashtags = 0
    private let reuseIdentifier = "hashtagCell"
    private var selectedHashtags = [String]()
    private let hashtagArray = ["#active", "#art", "#angry", "#adventure", "#breakfast", "#beer", "#collaborative", "#coffee", "#carpool", "#crypto", "#celebrate", "#deals","#desperate", "#dinner", "#drinks", "#engineering", "#earth", "#event", "#fun", "#funny", "#fire", "#freshman", "#fire", "#football", "#food&drink", "#game", "#graduate", "#hunk", "#homework", "#happyhour", "#idea", "#junior", "#lunch", "#meetup", "#music", "#nature", "#netflix&chill", "#new", "#news", "#outside", "#party", "#photo", "#relax", "#rest", "#sad", "#social", "#sports", "#sophomore", "#school", "#soccer", "#startup", "#swimming", "#senior", "#trip", "#technology", "#water", "#wind", "#wine", "#weekend", "#videogames"]
    
    //size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var size = CGSize(width: self.view.frame.size.width/3, height: 0)
        return size
    }
    
    //interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HashtagCollectionViewCell
        
        cell.hashtagButton.setTitle(hashtagArray[indexPath.row], for: .normal)
        cell.hashtagButton.tag = indexPath.row
        cell.hashtagButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        
        cell.hashtagButton.center = self.view.center

        return cell
    }
    
    @objc func handleClick(sender: UIButton) {
        if sender.isSelected == true {
            if numberOfHashtags == 10 {
                nextButton.alpha = 0.35
                changeState()
            } else {
                //no need to change state
            }
            //clicked hashtag was already selected
            if let index = selectedHashtags.index(of: sender.currentTitle!) {
                selectedHashtags.remove(at: index)
                sender.backgroundColor = UIColor.white
                sender.setTitleColor(UIColor.red, for: .normal)
                numberOfHashtags -= 1
                sender.isSelected = false
            } else {
                //print(not found)
            }
            //hashtag clicked isn't selected
        } else {
            if numberOfHashtags < 9 {
                selectedHashtags.append(sender.currentTitle!)
                sender.backgroundColor = UIColor.red
                sender.setTitleColor(UIColor.white, for: .selected)
                numberOfHashtags += 1
                sender.isSelected = true
                
            } else if numberOfHashtags == 9 {
                selectedHashtags.append(sender.currentTitle!)
                sender.backgroundColor = UIColor.red
                sender.setTitleColor(UIColor.white, for: .selected)
                numberOfHashtags += 1
                sender.isSelected = true
                nextButton.alpha = 1.0
                
                //animate checkmark for hashtags complete
                changeState()
            } else {
               //do nothing
            }
        }
        print(selectedHashtags)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    func loadUI() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        nextButton.alpha = 0.35
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
