//
//  MangaTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import UIKit

class MangaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(manga: Manga) {
        titleLabel.text = manga.name
        descriptionLabel.text = manga.description
        ImageManager.shared.loadImage(from: URL(string: manga.frontPage)!) { result in
            switch result {
            case .success(let image):
                self.coverImageView.image = image
            case .failure(let error):
                print("Can't display the image \(error)")
            }
        }
    }
}
