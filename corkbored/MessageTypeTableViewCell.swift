//
//  MessageTypeTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/16/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class MessageTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageTypeImage: UIImageView!
    
    @IBOutlet weak var messageTypeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
