//
//  FriendRequestsViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import Foundation
import FirebaseFirestore

class FriendRequestsViewModel {
    var reloadData: (() -> Void)?
    var friendRequestsList = [FriendRequest]() {
        didSet{
            reloadData?()
        }
    }
    var firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    func getFRList() {
        firebaseManager.getDocuments(type: FriendRequest.self, forCollection: .friendRequests) { result in
            switch result {
            case .success(var frs):
                frs.removeAll(where: {$0.idReceiver != self.currentUser.idUser})
                frs.removeAll(where: {$0.status == "accepted"})
                self.friendRequestsList = frs
            case .failure:
                print("Something went wrong, can't get all friend requests")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> FriendRequest {
        return friendRequestsList[indexPath.row]
    }
    
    func acceptRequest(forFR frItem: FriendRequest, completion: @escaping () -> Void) {
        let localUserValues = [
            "friends": FieldValue.arrayUnion([frItem.idSender])
        ]
        
        let targetUserValues = [
            "friends": FieldValue.arrayUnion([currentUser.idUser!])
        ]
        
        let frNewValues = [
            "status": "accepted"
        ]
        
        firebaseManager.updateFieldsInDocument(documentId: currentUser.idUser!, values: localUserValues, collection: .users) { [self] result in
            firebaseManager.updateFieldsInDocument(documentId: frItem.idSender, values: targetUserValues, collection: .users) { [self] result in
                firebaseManager.updateFieldsInDocument(documentId: frItem.id, values: frNewValues, collection: .friendRequests) { result in
                    print("request accepted")
                    completion()
                }
            }
        }
    }
    
    func rejectRequest(forFR frItem: FriendRequest, completion: @escaping () -> Void) {
        firebaseManager.removeDocument(documentID: frItem.id, collection: .friendRequests) {_ in
            print("request rejected")
            completion()
        }
    }
}
