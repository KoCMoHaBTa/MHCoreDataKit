//
//  NSManagedObject.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /**
         Initializes the receiver and inserts it into the specified managed object context.
         
         - parameter model:   The model into which this entity is defined.
         - parameter context: The context into which the new instance is inserted.
         
         - throws: `Error.General` if the `model` does not contains an entity description for the receiver.
         
         - returns: An instance of the receiver.
     */
    
    public convenience init(model: NSManagedObjectModel, context: NSManagedObjectContext? = nil) throws {
        
        guard let entityDescription = model.entity(byClass: type(of: self)) else {
            
            
            throw Error(message: "Unable to find entity for class: \(type(of: self))")
        }
        
        self.init(entity: entityDescription, insertInto: context)
    }
    
    /**
         Initializes the receiver and inserts it into the specified managed object context.
     
         - parameter context: The `context` into which the new instance is inserted. The context's `persistentStoreCoordinator` must not be nil and must have a `model` that contains the entity.
         - parameter insert: Wherever the created instance should be inserted into the provided `context`
     
         - throws: `Error.General` if the context's `model` does not contains an entity description for the receiver or the context is not associated with an isntance of NSPersistendStoreCoordinator.
         
         - returns: An instance of the receiver.
     */
    
    public convenience init(context: NSManagedObjectContext, insert: Bool) throws {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            
            throw Error(message: "Attempting to create an instance of \(type(of: self)) with invalid context \(context)\nReson: Missing persistentStoreCoordinator in context")
        }
        
        try self.init(model: model, context: insert ? context : nil)
    }
    
    public convenience init(insertingInto context: NSManagedObjectContext) throws {
        
        try self.init(context: context, insert: true)
    }
}

extension NSManagedObject {
    
    ///By default convention, this is the name of the class. Override in order to provide custom name.
    open class func entityName() -> String {
        
        return String(describing: self)
    }
}

extension NSFetchRequestResult where Self: NSManagedObject {
    
    ///Makes a new instance of NSFetchRequest with ResultType and entityName beign the receiver
    static func makeFetchRequest() -> NSFetchRequest<Self> {
        
        let entityName = self.entityName()
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        return fetchRequest
    }
}

