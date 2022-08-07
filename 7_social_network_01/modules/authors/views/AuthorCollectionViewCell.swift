//
//  AuthorCollectionViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 13/7/22.
//

import UIKit

class AuthorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AuthorCell"
    static let nibName = "AuthorCollectionViewCell"
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var auhorNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.width / 2
        }
    }
    
    func setUpData(author: User) {
        auhorNameLabel.text = author.name
        followersLabel.text = "\(String(author.followers.count)) followers"
        if author.photo != "defaultUserPhoto" {
            ImageManager.shared.loadImage(from: URL(string: author.photo)!) { result in
                switch result {
                case .success(let image):
                    self.userPhotoImageView.image = image
                case .failure(let error):
                    print("Can't display the image \(error)")
                }
            }
        }
    }
}
