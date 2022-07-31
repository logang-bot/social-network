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

    @NSManaged public var idUser: String?
    @NSManaged public var photo: String?
}

extension AuthData : Identifiable {

}
