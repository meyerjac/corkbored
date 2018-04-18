//
//  messagesTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/14/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class messagesTableViewCell: UITableViewCell {
    @IBOutlet weak var messagesProfileView: UIImageView!
    @IBOutlet weak var messagesName: UILabel!
    @IBOutlet weak var messagesLastMessagePeek: UILabel!
    @IBOutlet weak var messagesLastMessageSent: UILabel!
    @IBOutlet weak var messageSeenIndicator: UILabel!
}
