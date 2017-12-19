//
//  postTypeTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/18/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit

class postTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var postTypeImage: UIImageView!
    
    @IBOutlet weak var postTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
