//
//  MessageTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static let identifier = "MessageCell"
    static let nibName = "MessageTableViewCell"
    
    @IBOutlet weak var messageContentLabel: UILabel!
    
    @IBOutlet weak var dateMessageLabel: UILabel!
    
    var idSender: String?
    
    let firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
        if idSender != nil {
            setupMessageStyle(idSender: idSender!)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupMessageStyle(idSender: String) {
        self.idSender = idSender
        if idSender == currentUser.idUser {
            self.backgroundColor = .lightGray
            messageContentLabel.textColor = .white
            dateMessageLabel.textColor = .white
            messageContentLabel.textAlignment = .right
            dateMessageLabel.textAlignment = .right
            
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
        } else {
            self.backgroundColor = .white
            messageContentLabel.textColor = .black
            dateMessageLabel.textColor = .black
            messageContentLabel.textAlignment = .left
            dateMessageLabel.textAlignment = .left
        }
    }
}
