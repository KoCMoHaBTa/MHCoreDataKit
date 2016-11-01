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
    open var entitiesByClassName: [String: NSEntityDescription] {
        
        get {
            
            return self.entities.reduce([:], { (result, entity) -> [String: NSEntityDescription] in
                
                var result = result
                result[entity.managedObjectClassName] = entity
                return result
            })
        }
    }
    
    open func entityByClassName(_ entityClassName: String) -> NSEntityDescription? {
        
        return self.entitiesByClassName[entityClassName]
    }
    
    open func entityByClass<C>(_ entityClass: C.Type) -> NSEntityDescription? where C: NSManagedObject {
        
        return self.entityByClassName(String(reflecting: entityClass))
    }
}
