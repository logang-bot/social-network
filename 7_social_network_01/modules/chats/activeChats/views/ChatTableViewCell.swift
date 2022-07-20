//
//  ChatTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 19/7/22.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    let firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(chatItem: Chat) {
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatItem.id) { [self] result in
            switch result {
            case .success(let chat):
                let requiredUserId = chat.idParcitipants.first(where: {$0 != self.currentUser.idUser!})
                firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: requiredUserId!) { result in
                    switch result {
                    case .success(let user):
                        self.userNameLabel.text = user.name
                        ImageManager.shared.loadImage(from: URL(string: user.photo)!) {result in
                            switch result {
                            case .success(let image):
                                self.userPhoto.image = image
                            case .failure(let error):
                                print("Can't display the image \(error)")
                            }
                        }
                    case .failure:
                        print("Can't fetch the friend data")
                    }
                }
            case .failure:
                print("Can't fetch the data for this chat")
            }
        }
    }
    
}
