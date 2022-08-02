//
//  CreateChatViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import Foundation
import FirebaseFirestore

class CreateChatViewModel: LocalViewModel {
    var friendsList = [User]() {
        didSet{
            reloadData?()
        }
    }
    
    func getFriendsList() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: currentUser.idUser!) { [self] result in
            switch result {
            case .success(let user):
                user.friends.forEach { friendId in
                    firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: friendId) { result in
                        switch result {
                        case .success(let friend):
                            self.friendsList.append(friend)
                        case .failure:
                            print("Can't fetch the friend data")
                        }
                    }
                }
            case .failure:
                print("Can't fetch the data of the user")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> User {
        return friendsList[indexPath.row]
    }
    
    func createNewChat(with idUser: String, completion: @escaping (_ id: String) -> Void) {
        
        firebaseManager.getDocuments(type: Chat.self, forCollection: .chats) { result in
            switch result {
            case .success(let chats):
                let existingChat = chats.filter { chat in
                    chat.idParcitipants.contains(self.currentUser.idUser!) && chat.idParcitipants.contains(idUser)
                }
                if existingChat.count > 0 {
                    completion(existingChat.first!.id)
                }
                else {
                    let chatID = self.firebaseManager.getDocID(forCollection: .chats)
                    let newChat = Chat(id: chatID, idParcitipants: [idUser, self.currentUser.idUser!], createdAt: Date(), updatedAt: Date(), messages: [])
                    self.firebaseManager.addDocument(document: newChat, collection: .chats) { [self] result in
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
            case .failure(let error):
                print(error)
            }
        }
    }
}
