//
//  ProfileViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import Foundation

class ProfileViewModel: MangasTableViewModel {
    var profileData: User? {
        didSet {
            reloadData?()
        }
    }
    
    init() {
        super.init(for: (CoreDataManager.shared.getData().first as! AuthData).idUser!)
    }
    func getProfileData() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: currentUser.idUser!) { result in
            switch result {
            case .success(let user):
                self.profileData = user
            case .failure(let error):
                self.showError?(error)
            }
        }
    }
    static func logout() {
        if (CoreDataManager.shared.getData().count != 0) {
            CoreDataManager.shared.deleteAll()
            SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: false)
        }
    }
}
