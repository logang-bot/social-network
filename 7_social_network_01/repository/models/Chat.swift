//
//  Chat.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import Foundation

struct Chat: Codable, BaseModel {
    var id: String
    var idParcitipants: [String]
    let createdAt: Date
    let updatedAt: Date
    var messages: [String]
}
