//
//  AuthorDetailViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 14/7/22.
//

import UIKit

class AuthorDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followersCantLabel: UILabel!
    @IBOutlet weak var followingCantLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var sendFriendReqButton: UIButton!
    
    @IBOutlet weak var mangasTableView: UITableView!
    
    var userId: String?
    var viewmodel: AuthorDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        mangasTableView.delegate = self
        mangasTableView.dataSource = self
        let uiNib = UINib(nibName: MangaTableViewCell.nibName, bundle: nil)
        mangasTableView.register(uiNib, forCellReuseIdentifier: MangaTableViewCell.identifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    func initViewModel() {
        viewmodel = AuthorDetailViewModel(userId: self.userId!)
        viewmodel?.getAuthor()
        viewmodel?.getMangas()
        viewmodel?.reloadData = {[weak self] in
            self?.setupData()
            self?.mangasTableView.reloadData()
        }
    }
    
    func setupData() {
        usernameLabel.text = viewmodel?.authorData?.name
        followersCantLabel.text = String(viewmodel?.authorData?.followers.count ?? 0)
        followingCantLabel.text = String(viewmodel?.authorData?.following.count ?? 0)
        followButton.setTitle(viewmodel?.followOption, for: .normal)
        sendFriendReqButton.setTitle(viewmodel?.friendshipOption, for: .normal)
        self.title = viewmodel?.authorData?.name 
        
        guard let authorPhoto = viewmodel?.authorData?.photo else {return}
        
        if viewmodel?.authorData?.photo != AppConstants.defaultAvatar {
            ImageManager.shared.loadImage(from: URL(string: authorPhoto)!) { result in
                switch result {
                case .success(let image):
                    self.photoImageView.image = image
                case .failure(let error):
                    print("Can't display the image \(error)")
                }
            }
        }
    }
    
    @IBAction func follow(_ sender: UIButton) {
        viewmodel?.toggleFollowStatus()
        guard let buttonTitle = sender.title(for: .normal) else {return}
        
        if buttonTitle == "Follow" {
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
    @IBAction func sendFriendReq(_ sender: UIButton) {
        viewmodel?.changeFriendshipStatus()
        guard let buttonTitle = sender.title(for: .normal) else {return}
        
        if buttonTitle == "Add friend" {
            sendFriendReqButton.setTitle("Unsend friend request", for: .normal)
        } else {
            followButton.setTitle("Add friend", for: .normal)
        }
    }
}

extension AuthorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewmodel?.mangas.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mangasTableView.dequeueReusableCell(withIdentifier: MangaTableViewCell.identifier) as? MangaTableViewCell ?? MangaTableViewCell()
        
        let cellData = viewmodel!.getCellData(at: indexPath)
        cell.setUpData(manga: cellData)
        
        return cell
    }
}
