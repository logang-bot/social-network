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
    @IBOutlet weak var mangasTableView: UITableView!
    
    var viewmodel: ProfileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        photoImageVIew.layer.cornerRadius = 50
        mangasTableView.delegate = self
        mangasTableView.dataSource = self
        let uiNib = UINib(nibName: "MangaTableViewCell", bundle: nil)
        mangasTableView.register(uiNib, forCellReuseIdentifier: "MangaCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViewModel()
    }
    
    @IBAction func showEditScreen(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.user = viewmodel.profileData
        show(vc, sender: nil)
    }
    
    func initViewModel() {
        viewmodel.getProfileData()
        viewmodel.getMangas()
        viewmodel.reloadData = {[weak self] in
            self?.loadData()
            self?.mangasTableView.reloadData()
        }
    }
    
    func loadData() {
        followersLabel.text = String(viewmodel.profileData?.followers.count ?? 0)
        followingLabel.text = String(viewmodel.profileData?.following.count ?? 0)
        friendsLabel.text = String(viewmodel.profileData?.friends.count ?? 0)
        nameLabel.text = viewmodel.profileData?.name ?? ""
        emailLabel.text = viewmodel.profileData?.email ?? ""
        
        guard let userPhoto = viewmodel.profileData?.photo else {return}
        
        if userPhoto == AppConstants.defaultAvatar {
            photoImageVIew.image = UIImage(named: AppConstants.defaultAvatar)
        }
        
        else {
            ImageManager.shared.loadImage(from: URL(string: userPhoto)!) { result in
                switch result {
                case .success(let image):
                    self.photoImageVIew.image = image
                case .failure(let error):
                    ErrorAlert.shared.showAlert(title: "Error Loading the image", message: "Sorry, we can't show your profile image right now", target: self)
                    print("Can't display the image \(error)")
                }
            }
        }
    }

    @objc func logout() {
        ProfileViewModel.logout()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.mangas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mangasTableView.dequeueReusableCell(withIdentifier: "MangaCell") as? MangaTableViewCell ?? MangaTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(manga: cellData)
        
        return cell
    }
}
