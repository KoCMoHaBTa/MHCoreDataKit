//
//  NSManagedObjectContext.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    ///Initializes a context with a given concurrency type and a persistent store coordinator.
    public convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, coordinator: NSPersistentStoreCoordinator) {
        
        self.init(concurrencyType: concurrencyType)
        
        self.persistentStoreCoordinator = coordinator
    }
    
    ///Initializes a context with a given concurrency type and a parent context.
    public convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, perentContext: NSManagedObjectContext) {
        
        self.init(concurrencyType: concurrencyType)
        
        self.parent = perentContext
    }
}

extension NSManagedObjectContext {
    
    ///Deletes the object if not nil
    public func deleteIfPresent(_ object: NSManagedObject?) {
        
        guard let object = object else {
            
            return
        }
        
        self.delete(object)
    }
}
