//
//  DiaryEntry.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation
import CoreData

public class DiaryEntry: NSManagedObject {
    @NSManaged public var creationDate: NSDate
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var entry: String
    @NSManaged public var location: String?
    @NSManaged public var rating: Int16
    @NSManaged public var image: NSData?
}
