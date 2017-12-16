//
//  FeedViewControllerTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/15/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class FeedViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
