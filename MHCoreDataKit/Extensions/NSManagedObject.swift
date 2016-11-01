//
//  NSManagedObject.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    /**
         Initializes the receiver and inserts it into the specified managed object context.
         
         - parameter model:   The model into which this entity is defined.
         - parameter context: The context into which the new instance is inserted.
         
         - throws: `Error.General` if the `model` does not contains an entity description for the receiver.
         
         - returns: An instance of the receiver.
     */
    
    convenience init(model: NSManagedObjectModel, context: NSManagedObjectContext? = nil) throws {
        
        guard let entityDescription = model.entityByClass(self.dynamicType) else {
            
            throw Error.General("Unable to find entity for class: \(self.dynamicType)")
        }
        
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    /**
         Initializes the receiver and inserts it into the specified managed object context.
     
         - parameter context: The `context` into which the new instance is inserted. The context's `persistentStoreCoordinator` must not be nil and must have a `model` that contains the entity.
         - parameter insert: Wherever the created instance should be inserted into the provided `context`
     
         - throws: `Error.General` if the context's `model` does not contains an entity description for the receiver or the context is not associated with an isntance of NSPersistendStoreCoordinator.
         
         - returns: An instance of the receiver.
     */
    
    convenience init(context: NSManagedObjectContext, insert: Bool = true) throws {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            
            throw Error.General("Attempting to create an instance of \(self.dynamicType) with invalid context \(context)\nReson: Missing persistentStoreCoordinator in context")
        }
        
        try self.init(model: model, context: insert ? context : nil)
    }
}

public extension NSManagedObject {
    
    ///By default convention, this is the name of the class. Override in order to provide custom name.
    class func entityName() -> String {
        
        return String(self)
    }
}
