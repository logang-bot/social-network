//
//  CommentTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 26/7/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var authorCommentLabel: UILabel!
    @IBOutlet weak var contentCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//CommentCell
