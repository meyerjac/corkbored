//
//  FeedViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/8/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
        
        cell.messageBody.text = "There is an annoying bug happenening!"
        
        cell.profilePhotoImageView.image = UIImage(named: "elon.jpg")
        cell.profilePhotoImageView.layer.masksToBounds = false
        cell.profilePhotoImageView.layer.borderColor = UIColor.black.cgColor
        cell.profilePhotoImageView.layer.cornerRadius = cell.profilePhotoImageView.frame.height/2
        cell.profilePhotoImageView.clipsToBounds = true
        
        cell.usernameTextField.text = "meyerjac"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
