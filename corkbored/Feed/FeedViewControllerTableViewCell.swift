//
//  FeedViewControllerTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/15/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class FeedViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var hangoutTitle: UILabel!
    @IBOutlet weak var hangoutDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
