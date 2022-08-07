//
//  Manga.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import Foundation

struct Manga: Codable, BaseModel {
    var id: String
    let idOwner: String
    var name: String
    var description: String
    var categories: [String]
    var frontPage: String
    var ratingAvg: Double
    var numRatings: Int
    var comments: [String]
    let createdAt: Date
    var updatedAt: Date
}
