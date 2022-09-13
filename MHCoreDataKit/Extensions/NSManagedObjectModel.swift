//
//  NSManagedObjectModel.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    
    /**
     
     Creates an instance of the receiver by looking up for a given name in bundle.
     
     - parameter name: The model name for which to lookup.
     - parameter bundle: The bundle into which to look for the model. Default to main bundle
     - returns: An instance of the receiver if a model is found, otherwise - nil.
     
     */
    
    public convenience init?(name: String, bundle: Bundle = .main) {
        
        guard
        let url = bundle.url(forResource: name, withExtension: "momd")
        else {
                
            return nil
        }
        
        self.init(contentsOf: url)
    }
}

extension NSManagedObjectModel {
    
    //NOTE: this should be cached for performance
    public var entitiesByClassName: [String: NSEntityDescription] {
        
        get {
            
            return self.entities.reduce([:], { (result, entity) -> [String: NSEntityDescription] in
                
                var result = result
                result[entity.managedObjectClassName] = entity
                return result
            })
        }
    }
    
    public func entity(byClassName entityClassName: String) -> NSEntityDescription? {
        
        return self.entitiesByClassName[entityClassName]
    }
    
    public func entity<C>(byClass entityClass: C.Type) -> NSEntityDescription? where C: NSManagedObject {
        
        return self.entity(byClassName: String(reflecting: entityClass))
    }
}
