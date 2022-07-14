//
//  EditProfileViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 11/7/22.
//

import Foundation
import UIKit

class EditProfileViewModel {
    var user: AuthData?
    let firebaseManager = FirebaseManager.shared
    var finishEditing: (() -> Void)?
    
    func updateInfo(values: [String: String]) {
        firebaseManager.updateFieldsInDocument(documentId: (user?.idUser)!, values: values, collection: .users) { result in
            self.refreshLocalData()
        }
    }
    
    func updateFullData(values: [String: String], photo: UIImage) {
        var finalValues = values
        FirebaseStorageManager.shared.uploadPhoto(file: photo, route: "photos") { url in
            finalValues["photo"] = url.absoluteString
            self.updateInfo(values: finalValues)
        }
    }
    
    func deleteUser() {
        guard let idUser = self.user?.idUser else {return}
        self.firebaseManager.removeDocument(documentID: idUser, collection: .users) {result in
            ProfileViewController().logout()
        }
    }
    
    private func refreshLocalData() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: (user?.idUser)!) { result in
            switch result {
            case .success(let data):
                CoreDataManager.shared.deleteAll()
                CoreDataManager.shared.saveLocalUser(user: data)
                print(data)
                self.finishEditing!()
            case .failure(let error):
                print("error, \(error.localizedDescription)")
            }
        }
    }
}
