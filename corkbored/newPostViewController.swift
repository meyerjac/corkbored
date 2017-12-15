//
//  newPostViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/14/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class newPostViewController: UIViewController {
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        let feed: UIViewController = FeedViewController()
        present(feed, animated: true, completion: nil)
    }
    
    @IBAction func Pin(_ sender: UIBarButtonItem) {
        print("hello")
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
