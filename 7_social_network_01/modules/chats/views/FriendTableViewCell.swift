//
//  FriendRequestTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    static let identifier = "FriendCell"
    static let nibName = "FriendTableViewCell"
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    let firebaseManager = FirebaseManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpData(idFriend: String) {
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: idFriend) { result in
            switch result {
            case .success(let user):
                self.userName.text = user.name
                if user.photo != AppConstants.defaultAvatar {
                    ImageManager.shared.loadImage(from: URL(string: user.photo)!) {result in
                        switch result {
                        case .success(let image):
                            self.userPhoto.image = image
                        case .failure(let error):
                            print("Can't display the image \(error)")
                        }
                    }
                }
            case .failure:
                print("Can't fetch the data for this user")
            }
        }
    }
}
