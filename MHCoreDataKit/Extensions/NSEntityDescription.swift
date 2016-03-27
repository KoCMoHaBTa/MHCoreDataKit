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
    
    class func entityForClassName(entityClassName: String, context: NSManagedObjectContext) -> NSEntityDescription? {
        
        return context.persistentStoreCoordinator?.managedObjectModel.entityByClassName(entityClassName)
    }
    
    class func entityForClass<C where C: NSManagedObject>(entityClass: C.Type, context: NSManagedObjectContext) -> NSEntityDescription? {
        
        return self.entityForClassName(String(reflecting: entityClass), context: context)
    }
}