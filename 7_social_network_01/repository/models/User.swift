//
//  User.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import Foundation

struct User: Codable, BaseModel {
    var id: String
    let name: String
    let email: String
    let password: String
    let photo: String
    let followers: [String]
    let following: [String]
    let friends: [String]
    var mangas: [String]
    var chats: [String]
    let createdAt: Date
    let updatedAt: Date
}

