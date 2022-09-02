//
//  PostItem+CoreDataProperties.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/01.
//
//

import Foundation
import CoreData


extension PostItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostItem> {
        return NSFetchRequest<PostItem>(entityName: "PostItem")
    }

    @NSManaged public var content: String?
    @NSManaged public var color: String?
    @NSManaged public var date: Date?

}

extension PostItem : Identifiable {

}
