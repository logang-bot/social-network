//
//  ChatTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 19/7/22.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatCell"
    static let nibName = "ChatTableViewCell"
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(userItem: User) {
//        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        
        self.userNameLabel.text = userItem.name
        ImageManager.shared.loadImage(from: URL(string: userItem.photo)!) {result in
            switch result {
            case .success(let image):
                self.userPhoto.image = image
            case .failure(let error):
                print("Can't display the image \(error)")
            }
        }
        
//        firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatItem.id) { [self] result in
//            switch result {
//            case .success(let chat):
//                let requiredUserId = chat.idParcitipants.first(where: {$0 != self.currentUser.idUser!})
//                firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: requiredUserId!) { result in
//                    switch result {
//                    case .success(let user):
//                        self.userNameLabel.text = user.name
//                        ImageManager.shared.loadImage(from: URL(string: user.photo)!) {result in
//                            switch result {
//                            case .success(let image):
//                                self.userPhoto.image = image
//                            case .failure(let error):
//                                print("Can't display the image \(error)")
//                            }
//                        }
//                    case .failure:
//                        print("Can't fetch the friend data")
//                    }
//                }
//            case .failure:
//                print("Can't fetch the data for this chat")
//            }
//        }
    }
}
