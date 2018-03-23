//
//  MessagesTableViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/14/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell", for: indexPath) as! messagesTableViewCell
        
//        cell.messagesName.text = messages[indexPath.row]
        cell.messagesProfileView.image = UIImage(named: "praise.png")
        cell.messagesProfileView.contentMode = .scaleAspectFit
        cell.messagesProfileView.layer.cornerRadius = cell.messagesProfileView.frame.size.width / 2
        cell.messagesProfileView.clipsToBounds = true
        cell.messagesLastMessageSent.text = "14 h"
        cell.messagesLastMessagePeek.text = "Hey man, do you want to grab coffee and talk about collaboration and a bunch of stuff, anything you want?"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "toSelectedDm", sender: self)
    }
}
