//
//  ChatViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: LocalViewModel {
    var chatId: String?
    var messages = [Message]() {
        didSet {
            messages = messages.sorted(by: {$0.createdAt < $1.createdAt})
            reloadData?()
        }
    }
    
    func getMessages() {
        // Get messages
        firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatId!) { [self] result in
            switch result {
            case .success(let chat):
                chat.messages.forEach{ messageId in
                    firebaseManager.getOneDocument(type: Message.self, forCollection: .messages, id: messageId) { result in
                        switch result {
                        case .success(let message):
                            self.messages.append(message)
                        case .failure:
                            print("Can't fetch the data of the message")
                        }
                    }
                }
//                self.reloadData?()
            case .failure:
                print("Can't fetch the data of the chat")
            }
        }
    }
    
    func setChatListener() {
//         Set listener
        firebaseManager.listenCollectionChanges(type: Message.self, collection: .messages) {result in
            switch result {
            case .success(let messages):
                print("listener working")
                self.messages.removeAll()
                let finalMessages = messages.reversed()
                finalMessages.forEach { msg in
                    if msg.idChat == self.chatId {
                        self.messages.append(msg)
                    }
                }
            case .failure:
                print("listener for messages failure")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> Message {
        return messages[indexPath.row]
    }
    
//    func getCellIndex(at indexPath: IndexPath) -> Message {
//        return messages[indexPath.row]
//    }
    
    
//    func getCellData (idMessage: String, completion: @escaping (_ data: Message) -> Void) {
//        firebaseManager.getOneDocument(type: Message.self, forCollection: .messages, id: idMessage) { result in
//            switch result {
//            case .success(let message):
//                completion(message)
//            case .failure:
//                print("Can't fetch the data for this message")
//            }
//        }
//    }
    
    func createMessage(content: String) {
        let messageID = firebaseManager.getDocID(forCollection: .messages)
        let newMessage = Message(id: messageID, idChat: chatId!, idSender: currentUser.idUser!, content: content, createdAt: Date())
        firebaseManager.addDocument(document: newMessage, collection: .messages) { [self] result in
            let newMessageChat = [
                "messages": FieldValue.arrayUnion([messageID])
            ]
            firebaseManager.updateFieldsInDocument(documentId: chatId!, values: newMessageChat, collection: .chats) { _ in
//                self.messages.append(newMessage)
            }
        }
    }
}
