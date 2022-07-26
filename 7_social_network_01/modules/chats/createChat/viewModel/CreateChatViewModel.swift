//
//  CreateChatViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import Foundation
import FirebaseFirestore

class CreateChatViewModel {
    var reloadData: (() -> Void)?
    var friendsList = [User]() {
        didSet{
            reloadData?()
        }
    }
    
    var firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    func getFriendsList() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: currentUser.idUser!) { [self] result in
            switch result {
            case .success(let user):
//                var friends = [User]()
                user.friends.forEach { friendId in
                    firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: friendId) { result in
                        switch result {
                        case .success(let friend):
//                            friends.append(friend)
                            self.friendsList.append(friend)
                        case .failure:
                            print("Can't fetch the friend data")
                        }
                    }
                }
            
//                if friends.isEmpty {
//                    print("friends empty")
//                }
//                self.friendsList = friends
            case .failure:
                print("Can't fetch the data of the user")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> User {
        return friendsList[indexPath.row]
    }
    
    func createNewChat(with idUser: String, completion: @escaping (_ id: String) -> Void) {
        let chatID = firebaseManager.getDocID(forCollection: .chats)
        let newChat = Chat(id: chatID, idParcitipants: [idUser, currentUser.idUser!], createdAt: Date(), updatedAt: Date(), messages: [])
        firebaseManager.addDocument(document: newChat, collection: .chats) { [self] result in
//            completion(newChat.id)
            let userNewChat = [
                "chats": FieldValue.arrayUnion([newChat.id])
            ]
            
            firebaseManager.updateFieldsInDocument(documentId: currentUser.idUser!, values: userNewChat, collection: .users) { [self] _ in
                    firebaseManager.updateFieldsInDocument(documentId: idUser, values: userNewChat, collection: .users) { result in
                            completion(newChat.id)
                    }
            }
        }
    }
}
