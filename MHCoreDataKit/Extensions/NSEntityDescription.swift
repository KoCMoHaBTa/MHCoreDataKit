//
//  NSEntityDescription.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public extension NSEntityDescription {
    
    class func entityForClassName(entityClassName: String, model: NSManagedObjectModel) -> NSEntityDescription? {
        
        return model.entitiesByClassName[entityClassName]
    }
    
    class func entityForClassName(entityClassName: String, coordinator: NSPersistentStoreCoordinator) -> NSEntityDescription? {
        
        return self.entityForClassName(entityClassName, model: coordinator.managedObjectModel)
    }
    
    class func entityForClassName(entityClassName: String, context: NSManagedObjectContext) -> NSEntityDescription? {
        
        guard let coordinator = context.persistentStoreCoordinator else { return nil }
        
        return self.entityForClassName(entityClassName, coordinator: coordinator)
    }
}