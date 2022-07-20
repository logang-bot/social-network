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
    
    var userId: String?
    var viewmodel: AuthorDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    func initViewModel() {
        viewmodel = AuthorDetailViewModel(userId: self.userId!)
        viewmodel?.getAuthor()
        viewmodel?.setData = {[weak self] in
            self?.setupData()
        }
    }
    
    func setupData() {
        usernameLabel.text = viewmodel?.authorData?.name
        followersCantLabel.text = String(viewmodel?.authorData?.followers.count ?? 0)
        followingCantLabel.text = String(viewmodel?.authorData?.following.count ?? 0)
        followButton.setTitle(viewmodel?.followOption, for: .normal)
        sendFriendReqButton.setTitle(viewmodel?.friendshipOption, for: .normal)
        self.title = viewmodel?.authorData?.name 
        
        if viewmodel?.authorData?.photo != "defaultUserPhoto" {
            ImageManager.shared.loadImage(from: URL(string: (viewmodel?.authorData?.photo)!)!) { result in
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
