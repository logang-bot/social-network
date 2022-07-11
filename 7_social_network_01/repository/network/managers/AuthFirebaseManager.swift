//
//  AuthFirebaseManager.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import Foundation
import FirebaseFirestore

class AuthFirebaseManager {
    static let shared = AuthFirebaseManager()
    
    public func login(email: String, password: String, completion: @escaping ( Result<User, Error>) -> Void) {
        Firestore.firestore().collection(FirebaseCollections.users.rawValue)
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password)
            .getDocuments { querySnapshot, error in
                guard error == nil else { return completion(.failure(error!)) }
                guard let documents = querySnapshot?.documents, !documents.isEmpty
                       else { return completion(.failure(FirebaseErrors.InvalidUser)) }
                
                var items = [User]()
                let json = JSONDecoder()
                for document in documents {
                    if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                       let item = try? json.decode(User.self, from: data) {
                        items.append(item)
                    }
                }
                guard let user = items.first else { return completion(.failure(FirebaseErrors.InvalidUser)) }
                completion(.success(user))
        }
    }
    
    public func signUp(document: User, completion: @escaping ( Result<User, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
//        db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(document))
//            }
//        }
        
    }
}
