//
//  ManagedFeedImage+CoreDataProperties.swift
//  EssentialFeed
//
//  Created by User on 29/03/2024.
//
//

import Foundation
import CoreData


extension ManagedFeedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }

    @NSManaged public var url: URL?
    @NSManaged public var location: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var cache: ManagedCache?

}

extension ManagedFeedImage : Identifiable {

}
