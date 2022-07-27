//
//  Rating.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import Foundation

struct Rating: Codable, BaseModel {
    var id: String
    let idUser: String
    let idManga: String
    var rating: Int
    let createdAt: Date
    var updatedAt: Date
}
