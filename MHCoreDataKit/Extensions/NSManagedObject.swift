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
        
        let entityClassName: String = NSStringFromClass(self.dynamicType)
        
        guard let entityDescription = model.entitiesByClassName[entityClassName] else {
            
            throw Error.General("Unable to find entity for class name: \(entityClassName)")
        }
        
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}