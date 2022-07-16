//
//  FriendRequest.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import Foundation

struct FrienRequest: Codable, BaseModel {
    var id: String
    let idSender: String
    let idReceiver: String
    let status: String
    let createdAt: Date
    let updatedAt: Date
}
