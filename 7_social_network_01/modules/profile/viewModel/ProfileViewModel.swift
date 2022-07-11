//
//  ProfileViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import Foundation

class ProfileViewModel {
    
    var profileData: AuthData = AuthData()
    
    func loadData() {
        profileData = CoreDataManager.shared.getData().first as! AuthData
    }
}
