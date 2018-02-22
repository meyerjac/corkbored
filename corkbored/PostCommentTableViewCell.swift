//
//  PostCommentTableViewCell.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/14/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentCellMessageBody: UILabel!
    @IBOutlet weak var commentCellTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
