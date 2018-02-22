//
//  HashtagViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/16/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBAction func nextButton(_ sender: Any) {
        if selectedHashtags.count < 10 {
            //button shake, select more
        } else {
            //segue to next view
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var HashtagCollectionView: UICollectionView!
    
    private var numberOfHashtags = 0
    private let reuseIdentifier = "hashtagCell"
    private var selectedHashtags = [String]()
    private let hashtagArray = ["#active", "#art", "#angry", "#adventure", "#breakfast", "#beer", "#collaborative", "#coffee", "#carpool", "#crypto", "#celebrate", "#deals","#desperate", "#dinner", "#drinks", "#engineering", "#earth", "#event", "#fun", "#funny", "#fire", "#freshman", "#fire", "#football", "#food&drink", "#game", "#graduate", "#hunk", "#homework", "#happyhour", "#idea", "#junior", "#lunch", "#meetup", "#music", "#nature", "#netflix&chill", "#new", "#news", "#outside", "#party", "#photo", "#relax", "#rest", "#sad", "#social", "#sports", "#sophomore", "#school", "#soccer", "#startup", "#swimming", "#senior", "#trip", "#technology", "#water", "#wind", "#wine", "#weekend", "#videogames"]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HashtagCollectionViewCell
        
        let cellwidth = self.view.frame.size.width/4
        
        cell.frame.size.width = cellwidth
        cell.frame.size.height = 30

        
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 2
        
//        cell.hashtagLabel.center = self.view.center
        cell.hashtagButton.setTitle(hashtagArray[indexPath.row], for: .normal)
        cell.hashtagButton.tag = indexPath.row
        cell.hashtagButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleClick(sender: UIButton) {
        if sender.isSelected == true {
            if let index = selectedHashtags.index(of: sender.currentTitle!) {
                selectedHashtags.remove(at: index)
                sender.backgroundColor = UIColor.white
                sender.setTitleColor(UIColor.red, for: .normal)
                numberOfHashtags -= 1
                sender.isSelected = false
            } else {
                //print(not found)
            }
        } else {
            if numberOfHashtags < 10 {
                selectedHashtags.append(sender.currentTitle!)
                sender.backgroundColor = UIColor.red
                sender.setTitleColor(UIColor.white, for: .selected)
                numberOfHashtags += 1
                sender.isSelected = true
            } else {
                //animate checkmark for hashtags complete
            }
        }
        print(selectedHashtags)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
