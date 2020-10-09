//
//  Feed+CoreDataProperties.swift
//  
//
//  Created by Admin on 05/10/20.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}
