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
    
    convenience init?(name: String, bundle: NSBundle = NSBundle.mainBundle()) {
        
        guard
        let url = bundle.URLForResource(name, withExtension: "momd")
        else {
                
            return nil
        }
        
        self.init(contentsOfURL: url)
    }
}

public extension NSManagedObjectModel {
    
    //this should be cached for performance
    var entitiesByClassName: [String: NSEntityDescription] {
        
        get {
            
            return self.entities.reduce([:], combine: { (result, entity) -> [String: NSEntityDescription] in
                
                var result = result
                result[entity.managedObjectClassName] = entity
                return result
            })
        }
    }
    
    func entityByClassName(entityClassName: String) -> NSEntityDescription? {
        
        return self.entitiesByClassName[entityClassName]
    }
    
    func entityByClass<C where C: NSManagedObject>(entityClass: C.Type) -> NSEntityDescription? {
        
        return self.entityByClassName(String(reflecting: entityClass))
    }
}