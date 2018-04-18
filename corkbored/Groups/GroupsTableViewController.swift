//
//  GroupsTableViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 4/17/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    var colors: Array = [UIColor.blue, UIColor.red, UIColor.cyan, UIColor.gray, UIColor.purple]
    var groupNames: Array = ["OSU computer science", "entrepreneurship club", "basketball club", "foodies of Corvallis", "real estate agents"]
    var numberOfMembers: Array = [23, 34, 2, 546, 56]
    var GroupImages: Array = [#imageLiteral(resourceName: "instagram"), #imageLiteral(resourceName: "instagram"), #imageLiteral(resourceName: "instagram"), #imageLiteral(resourceName: "instagram"), #imageLiteral(resourceName: "instagram")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! groupsTableViewCell
        
        cell.groupImage.image = GroupImages[indexPath.row]
        cell.numberOfGroupMembers.text = String( numberOfMembers[indexPath.row])
        cell.groupTitle.text = groupNames[indexPath.row]
        cell.cardView.backgroundColor = colors[indexPath.row]

        return cell
    }
}
