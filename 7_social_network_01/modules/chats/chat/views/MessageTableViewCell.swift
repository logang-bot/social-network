//
//  MessageTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    
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
//        self.layer.borderColor = .init(red: 255, green: 255, blue: 255, alpha: 0)
//        self.layer.borderWidth = 5
    }

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
        }
    }
}
