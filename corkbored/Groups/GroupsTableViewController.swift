//
//  GroupsTableViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 4/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class GroupsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var bunchesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let bunches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        print("hello")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hello1")
        if bunches.count == 0 {
            self.bunchesLabel.isHidden = true
        } else {
            return 0
        }
            return 0
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bunchesCell", for: indexPath)
        print("hello2")
        
        return cell
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        print("hello3")
        let str = "Join more Bunches!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        print("hello4")
        let str = "Your city is happening! Tap the button below to start your own bunch"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        print("hello5")
        return UIImage(named: "banana")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        print("hello6")
        let str = "Create Bunch"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        print("hello7")
        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hurray", style: .default))
        present(ac, animated: true)
    }
}
