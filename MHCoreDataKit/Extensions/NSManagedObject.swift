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
    
    convenience init(model: NSManagedObjectModel, context: NSManagedObjectContext? = nil) throws {
        
        guard let entityDescription = model.entityByClass(self.dynamicType) else {
            
            throw Error.General("Unable to find entity for class: \(self.dynamicType)")
        }
        
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    convenience init(context: NSManagedObjectContext, insert: Bool = true) throws {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            
            throw Error.General("Attempting to create an instance of \(self.dynamicType) with invalid context \(context)\nReson: Missing persistentStoreCoordinator in context")
        }
        
        try self.init(model: model, context: insert ? context : nil)
    }
}