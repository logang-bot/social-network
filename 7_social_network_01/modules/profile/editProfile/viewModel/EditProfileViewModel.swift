//
//  EditProfileViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 11/7/22.
//

import Foundation
import UIKit

class EditProfileViewModel: LocalViewModel {
    var user: User?
    var finishEditing: (() -> Void)?
    
    func updateInfo(values: [String: String]) {
        firebaseManager.updateFieldsInDocument(documentId: (user?.id)!, values: values, collection: .users) { result in
            switch result {
            case .success:
                self.finishEditing?()
            case .failure(let error):
                self.showError?(error)
            }
        }
    }
    
    func updateFullData(values: [String: String], photo: UIImage) {
        var finalValues = values
        FirebaseStorageManager.shared.uploadPhoto(file: photo, route: .photos) { url in
            CoreDataManager.shared.deleteAll()
            CoreDataManager.shared.saveLocalUser(idUser: self.currentUser.idUser!, photo: url.absoluteString)
            finalValues["photo"] = url.absoluteString
            self.updateInfo(values: finalValues)
        }
    }
    
    func deleteUser() {
        guard let idUser = self.user?.id else {return}
        self.firebaseManager.removeDocument(documentID: idUser, collection: .users) {result in
            ProfileViewModel.logout()
        }
    }
}
