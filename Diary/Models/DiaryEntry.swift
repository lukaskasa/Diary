//
//  DiaryEntry.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import CoreData

/// Diary Entry Managed Object for Core Data
public class DiaryEntry: NSManagedObject {
    @NSManaged public var creationDate: NSDate
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var entry: String
    @NSManaged public var location: String?
    @NSManaged public var rating: Int16
    @NSManaged public var image: NSData?
}

extension DiaryEntry {
    
    /// Transient properties for the section naming
    @objc var sectionIdentifier: String? {
        
        self.willAccessValue(forKey: "sectionIdentifier")
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
        dateFormatter.locale = locale
        
        let stringDate = dateFormatter.string(from: creationDate as Date)
        let date = dateFormatter.date(from: stringDate)!
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = locale
        let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
        let year = calendar.component(.year, from: date)
        self.didAccessValue(forKey: "sectionIdentifier")
        
        return "\(month) \(year)"
    }
    
    /// Fetch request class function for DiaryEntry
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntry> {
        
        let request = NSFetchRequest<DiaryEntry>(entityName: String(describing: DiaryEntry.self))
        
        let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        request.sortDescriptors = [dateSortDescriptor]
        
        return request
        
    }

}
