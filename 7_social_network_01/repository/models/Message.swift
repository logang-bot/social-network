//
//  Message.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import Foundation

struct Message: Codable, BaseModel {
    var id: String
    let idChat: String
    let idSender: String
    let content: String
    let createdAt: Date
}
