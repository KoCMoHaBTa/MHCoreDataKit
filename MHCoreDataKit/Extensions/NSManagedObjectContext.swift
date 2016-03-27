//
//  NSManagedObjectContext.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    public convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, coordinator: NSPersistentStoreCoordinator) {
        
        self.init(concurrencyType: concurrencyType)
        
        self.persistentStoreCoordinator = coordinator
    }
}