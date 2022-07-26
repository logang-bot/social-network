//
//  Comment.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import Foundation

struct Comment: Codable, BaseModel {
    var id: String
    let idCreator: String
    var idManga: String
    var content: String
    let createdAt: Date
    var updatedAt: Date
}
