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
    
    /**
     
     Lookup an entity into a context's model by a given class name.
     
     - parameter entityClassName: The entity class name for which to lookup.
     - parameter context: The managed object context associated with the model into which to lookup.
     - returns: An instance of the receiver if found, otherwise nil.
     
     */
    open class func entity(forClassName entityClassName: String, context: NSManagedObjectContext) -> NSEntityDescription? {
        
        return context.persistentStoreCoordinator?.managedObjectModel.entity(byClassName: entityClassName)
    }
    
    /**
     
     Lookup an entity into a context's model by a given class.
     
     - parameter entityClass: The entity class for which to lookup.
     - parameter context: The managed object context associated with the model into which to lookup.
     - returns: An instance of the receiver if found, otherwise nil.
     
     */
    
    open class func entity<C>(forClass entityClass: C.Type, context: NSManagedObjectContext) -> NSEntityDescription? where C: NSManagedObject {
        
        return self.entity(forClassName: String(reflecting: entityClass), context: context)
    }
}
