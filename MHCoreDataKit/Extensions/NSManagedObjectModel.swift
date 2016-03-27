//
//  NSManagedObjectModel.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObjectModel {
    
    var entitiesByClassName: [String: NSEntityDescription] {
        
        get {
            
            return self.entities.reduce([:], combine: { (result, entity) -> [String: NSEntityDescription] in
                
                var result = result
                result[entity.managedObjectClassName] = entity
                return result
            })
        }
    }
}