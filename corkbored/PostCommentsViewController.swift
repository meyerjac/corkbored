//
//  PostCommentsViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/13/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class PostCommentsViewController: UIViewController {

    @IBOutlet weak var messageBodyLabel: UILabel!
    
    var messageBodyText = String()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageBodyLabel.text = messageBodyText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
