//
//  quickMessageViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class quickMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postButton = UIBarButtonItem(title: "send", style: .plain, target: self, action: #selector(createPostViewController.post))
        let cancelButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(createPostViewController.cancelBackToFeed))
        
        self.navigationItem.rightBarButtonItem  = postButton
        self.navigationItem.leftBarButtonItem  = cancelButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
