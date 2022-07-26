//
//  MangaDetailViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import UIKit

class MangaDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var myRankLabel: UILabel!
    @IBOutlet weak var rankStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var mangaId: String?
    var viewmodel: MangaDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        // Do any additional setup after loading the view.
    }
    
    func initViewModel() {
        viewmodel = MangaDetailViewModel(mangaId: mangaId!)
        viewmodel?.getManga()
        viewmodel?.setData = { [weak self] in
            self?.setupData()
        }
    }
    
    func setupData() {
        self.titleLabel.text = viewmodel?.mangaData?.name
        self.descriptionLabel.text = viewmodel?.mangaData?.description
        self.categoriesLabel.text = viewmodel?.mangaData?.categories.joined(separator: ", ")
        self.rankLabel.text = String((viewmodel?.mangaData?.ratingAvg)!)
        self.authorLabel.text = viewmodel?.mangaAuthor
        ImageManager.shared.loadImage(from: URL(string: (viewmodel?.mangaData?.frontPage)!)!) { result in
            switch result {
            case .success(let image):
                self.coverImageView.image = image
            case .failure(let error):
                print("Can't display the image \(error)")
            }
        }
    }
    
    @IBAction func rateManga(_ sender: Any) {
    }
    
    @IBAction func leaveComment(_ sender: Any) {
    }
    
}
