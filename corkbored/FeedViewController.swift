//
//  FeedViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/8/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var TopView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "postCell")
        cell.textLabel?.text = "top row"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        TopView.addGestureRecognizer(UITapGestureRecognizer(target: FeedViewController(), action: #selector(topViewClicked)))
        // Do any additional setup after loading the view.
    }
    
    @objc func topViewClicked() {
    print("it woorked")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
