//
//  NSEntityDescription.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSEntityDescription {
    
    open class func entityForClassName(_ entityClassName: String, context: NSManagedObjectContext) -> NSEntityDescription? {
        
        return context.persistentStoreCoordinator?.managedObjectModel.entityByClassName(entityClassName)
    }
    
    open class func entityForClass<C>(_ entityClass: C.Type, context: NSManagedObjectContext) -> NSEntityDescription? where C: NSManagedObject {
        
        return self.entityForClassName(String(reflecting: entityClass), context: context)
    }
}
