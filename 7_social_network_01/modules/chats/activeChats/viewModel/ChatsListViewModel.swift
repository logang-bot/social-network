//
//  ChatsListViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 19/7/22.
//

import Foundation

class ChatListViewModel: LocalViewModel {
    var chatsList = [Chat]() {
        didSet {
//            populateUserFromChat(chat: chatsList.last!)
//            reloadData?()
        }
    }
    var usersList = [User]() {
        didSet {
            reloadData?()
        }
    }
    
    func getChats() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: currentUser.idUser!) { [self] result in
            switch result {
            case .success(let user):
                user.chats.forEach { chatId in
                    firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatId) { result in
                        switch result {
                        case .success(let chat):
                            self.populateUserFromChat(chat: chat)
                        case .failure:
                            print("Can't fetch the chat data")
                        }
                    }
                }
            case .failure:
                print("Can't fetch the data of the user")
            }
        }
    }
    
    func populateUserFromChat(chat: Chat) {
        let requiredUserId = chat.idParcitipants.first(where: {$0 != self.currentUser.idUser!})
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: requiredUserId!) { result in
            switch result {
            case .success(let user):
                self.chatsList.append(chat)
                self.usersList.append(user)
            case .failure:
                print("Can't fetch the user data")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> Chat {
        return chatsList[indexPath.row]
    }
    
    func getUserData(at indexPath: IndexPath) -> User {
        return usersList[indexPath.row]
    }
}
