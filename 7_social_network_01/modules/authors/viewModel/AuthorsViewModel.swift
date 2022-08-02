//
//  AuthorsViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 14/7/22.
//

import Foundation

class AuthorsViewModel: LocalViewModel {
    var authors = [User]() {
        didSet{
            reloadData?()
        }
    }
    
    func getAuthors() {
        let currentUser = CoreDataManager.shared.getData().first as! AuthData
        firebaseManager.getDocuments(type: User.self, forCollection: .users) { result in
            switch result {
            case .success(var authors):
                authors.removeAll(where: {$0.id == currentUser.idUser})
                self.authors = authors
            case .failure:
                print("Something went wrong, can't get all documents")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> User {
        return authors[indexPath.row]
    }
}
