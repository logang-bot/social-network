//
//  ProfileViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 1/7/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var photoImageVIew: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewmodel: ProfileViewModel = ProfileViewModel()

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        photoImageVIew.layer.cornerRadius = 50
    }
    
    @IBAction func showEditScreen(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.user = viewmodel.profileData
        show(vc, sender: nil)
    }
    
    func loadData() {
        viewmodel.loadData()
        followersLabel.text = String(viewmodel.profileData.followers)
        followingLabel.text = String(viewmodel.profileData.following)
        friendsLabel.text = String(viewmodel.profileData.friends)
        nameLabel.text = viewmodel.profileData.name
        emailLabel.text = viewmodel.profileData.email
        
        if viewmodel.profileData.photo == "defaultUserPhoto" {
            photoImageVIew.image = UIImage(named: "defaultUserPhoto")
        }
        
        else {
            ImageManager.shared.loadImage(from: URL(string: viewmodel.profileData.photo!)!) { result in
                switch result {
                case .success(let image):
                    self.photoImageVIew.image = image
                case .failure(let error):
                    print("Can't display the image \(error)")
                }
            }
        }
    }

    @objc func logout() {
        if (CoreDataManager.shared.getData().count != 0) {
            CoreDataManager.shared.deleteAll()
            SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: false)
        }
    }
}
