//
//  ChatViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import Foundation
import FirebaseFirestore

class ChatViewModel {
    var chatId: String?
    var reloadData: (() -> Void)?
    var messages = [Message]() {
        didSet {
            reloadData?()
        }
    }
//    var messages = [String]()
    var firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    func getMessages() {
        firebaseManager.getOneDocument(type: Chat.self, forCollection: .chats, id: chatId!) { [self] result in
            switch result {
            case .success(let chat):
                let finalMessages = chat.messages.reversed()
                finalMessages.forEach{messageId in
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
                self.messages.append(newMessage)
            }
        }
    }
}
