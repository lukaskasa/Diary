//
//  CoreDataManager.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import CoreData

/// Manager Object for the Core Data Stack
final class CoreDataManager {
    
    /// Name of the Model to be managed by the Core Data Manager
    private let modelName: String
    
    /// Initializes the CoreDataManager
    init(modelName: String) {
        self.modelName = modelName
    }
    
    /// Managed Object Context self invoking closure
    /// Apple Documentation: https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    /// Persistent Store Container self invoking closure
    /// Apple Documentation: https://developer.apple.com/documentation/coredata/nspersistentcontainer
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
}

extension NSManagedObjectContext {
    
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
