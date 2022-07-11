//
//  SignUpViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import Foundation

class SignUpViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = SignUpViewModel()
    
    func addUser(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        let userID = firebaseManager.getDocID(forCollection: .users)
        let user = User(id: userID, name: name, email: email, password: password, photo: "defaultUserPhoto", followers: [], following: [], friends: [], createdAt: Date(), updatedAt: Date())
        
        firebaseManager.addDocument(document: user, collection: .users) { result in
            completion(result)
        }
    }
}
