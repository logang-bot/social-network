//
//  MangaTableViewCell.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import UIKit

class MangaTableViewCell: UITableViewCell {
    
    static let identifier = "MangaCell"
    static let nibName = "MangaTableViewCell"
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData(manga: Manga) {
        titleLabel.text = manga.name
        descriptionLabel.text = manga.description
        rankingLabel.text = String(manga.ratingAvg)
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
