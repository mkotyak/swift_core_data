//
//  Walk+CoreDataProperties.swift
//  DogWalk
//
//  Created by Maria Kotyak on 03.01.2023.
//  Copyright © 2023 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dog: Dog?

}

extension Walk : Identifiable {

}
