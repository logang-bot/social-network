//
//  AuthData+CoreDataProperties.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 6/7/22.
//
//

import Foundation
import CoreData


extension AuthData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthData> {
        return NSFetchRequest<AuthData>(entityName: "AuthData")
    }

    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var idUser: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: String?
    @NSManaged public var password: String?
    @NSManaged public var followers: Int64
    @NSManaged public var following: Int64
    @NSManaged public var friends: Int64
}

extension AuthData : Identifiable {

}
