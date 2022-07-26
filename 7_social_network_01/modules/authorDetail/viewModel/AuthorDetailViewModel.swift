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
    var followOption: String?
    var friendshipOption: String?
    
    var friendshipStatus: FriendRequest?
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    var authorData: User? {
        didSet {
            checkFollowStatus()
            checkFriendShipStatus()
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
        
        firebaseManager.getDocuments(type: FriendRequest.self, forCollection: .friendRequests) { result in
            switch result {
            case .success(let friendsRequests):
                self.friendshipStatus = (friendsRequests.filter { request in
                    request.idReceiver == self.authorId && request.idSender == self.currentUser.idUser
                }).first
            case .failure:
                print("Something went wrong, can't get all documents")
            }
        }
    }
    
    private func updateLocalUser(values: [String: Any]) {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: (currentUser.idUser)!) { [weak self] result in
            switch result {
            case .success(let data):
                self!.firebaseManager.updateFieldsInDocument(documentId: (self!.currentUser.idUser)!, values: values, collection: .users) { result in
                }
                self?.getAuthor()
                CoreDataManager.shared.deleteAll()
                CoreDataManager.shared.saveLocalUser(user: data)
                
            case .failure(let error):
                print("error, \(error.localizedDescription)")
            }
        }
    }
}

// Methos for following features
extension AuthorDetailViewModel {
    func checkFollowStatus() {
        if (authorData?.followers.contains(currentUser.idUser!))! {
            followOption = "Unfollow"
            return
        }
        followOption = "Follow"
    }
    
    
    func toggleFollowStatus() {
        var followersValues = [String: Any]()
        var followingValues = [String: Any]()
        
        if (authorData?.followers.contains(currentUser.idUser!))! {
            followersValues = [
                "followers": FieldValue.arrayRemove([currentUser.idUser!])
            ]
            followingValues = [
                "following": FieldValue.arrayRemove([self.authorId!])
            ]
        } else {
            followersValues = [
                "followers": FieldValue.arrayUnion([currentUser.idUser!])
            ]
            followingValues = [
                "following": FieldValue.arrayUnion([self.authorId!])
            ]
        }
        
        firebaseManager.updateFieldsInDocument(documentId: (authorId)!, values: followersValues, collection: .users) { result in
                self.updateLocalUser(values: followingValues)
        }
    }
    
}

// Method for friendship features
extension AuthorDetailViewModel {
    func checkFriendShipStatus() {
        if friendshipStatus?.status == "accepted" {
            friendshipOption = "Unfriend"
            return
        }
        if friendshipStatus?.status == "requested" {
            friendshipOption = "Unsend friend request"
            return
        }
        friendshipOption = "Add friend"
    }
    
    func changeFriendshipStatus() {
        if friendshipStatus == nil {
            let frID = firebaseManager.getDocID(forCollection: .friendRequests)
            let newfr = FriendRequest(id: frID, idSender: currentUser.idUser!, idReceiver: authorId!, status: "requested", createdAt: Date(), updatedAt: Date())
            
            firebaseManager.addDocument(document: newfr, collection: .friendRequests) { result in
                self.friendshipOption = "Unsend friend request"
                self.getAuthor()
            }
            return
        }
        
        firebaseManager.removeDocument(documentID: friendshipStatus!.id, collection: .friendRequests) {_ in
            self.friendshipOption = "Add friend"
            self.getAuthor()
        }
    }
}
