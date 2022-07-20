//
//  ChatsListViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 19/7/22.
//

import Foundation

class ChatListViewModel {
    var reloadData: (() -> Void)?
    var chatsList = [Chat]() {
        didSet{
            reloadData?()
        }
    }
    var firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    func getChats() {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: currentUser.idUser!) { [self] result in
            switch result {
            case .success(let user):
                user.chats.forEach { chatId in
                    firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatId) { result in
                        switch result {
                        case .success(let chat):
                            self.chatsList.append(chat)
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
    
    func getCellData(at indexPath: IndexPath) -> Chat {
        return chatsList[indexPath.row]
    }
}
