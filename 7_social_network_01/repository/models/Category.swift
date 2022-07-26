//
//  Category.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import Foundation

struct Category: Codable, BaseModel {
    var id: String
    var name: String
    let createdAt: Date
    var updatedAt: Date
}
