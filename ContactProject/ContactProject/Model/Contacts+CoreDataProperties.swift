//
//  Contacts+CoreDataProperties.swift
//  ContactProject
//
//  Created by Zahraa Herz on 07/06/2022.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobileNumber: Int64
    @NSManaged public var email: String?

}

extension Contacts : Identifiable {

}
