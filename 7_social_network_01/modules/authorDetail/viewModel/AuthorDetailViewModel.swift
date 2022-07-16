//
//  AuthDetailViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 14/7/22.
//

import Foundation
import FirebaseFirestore

class AuthorDetailViewModel {
    var authorId: String?
    var setData: (()->Void)?
    var followStatus: String?
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    var authorData: User? {
        didSet {
            self.checkFollowStatus()
            setData?()
        }
    }
    var firebaseManager = FirebaseManager.shared
    
    init(userId: String) {
        self.authorId = userId
    }
    
    func getAuthor() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: authorId!) { result in
            switch result {
            case .success(let author):
                self.authorData = author
            case .failure:
                print("Can't fetch the author data")
            }
        }
    }
    
    func checkFollowStatus() {
        if (authorData?.followers.contains(currentUser.idUser!))! {
            followStatus = "Unfollow"
            return
        }
        followStatus = "Follow"
    }
    
    func toggleFollowStatus() {
        var followersValues = [String: Any]()
        var followingValues = [String: Any]()
        
        if (authorData?.followers.contains(currentUser.idUser!))! {
            followersValues = [
                "followers": FieldValue.arrayRemove([currentUser.idUser!])
            ]
            followingValues = [
                "followers": FieldValue.arrayRemove([self.authorId!])
            ]
        } else {
            followersValues = [
                "followers": FieldValue.arrayUnion([currentUser.idUser!])
            ]
            followingValues = [
                "followers": FieldValue.arrayUnion([self.authorId!])
            ]
        }
        
        firebaseManager.updateFieldsInDocument(documentId: (authorId)!, values: followersValues, collection: .users) { result in
                self.updateLocalUser(values: followingValues)
        }
    }
    
    private func updateLocalUser(values: [String: Any]) {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: (currentUser.idUser)!) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                self!.firebaseManager.updateFieldsInDocument(documentId: (self!.currentUser.idUser)!, values: values, collection: .users) { result in
                }
                
                CoreDataManager.shared.deleteAll()
                CoreDataManager.shared.saveLocalUser(user: data)
                self?.setData?()
                
            case .failure(let error):
                print("error, \(error.localizedDescription)")
            }
        }
    }
}
