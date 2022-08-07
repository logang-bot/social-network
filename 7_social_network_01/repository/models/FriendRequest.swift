//
//  FriendRequest.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import Foundation

struct FriendRequest: Codable, BaseModel {
    var id: String
    let idSender: String
    let idReceiver: String
    var status: String
    let createdAt: Date
    var updatedAt: Date
}
