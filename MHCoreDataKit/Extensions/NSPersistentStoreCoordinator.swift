//
//  NSPersistentStoreCoordinator.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 8/14/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentStoreCoordinator {
    
    /**
     
     Adds a persistent store to a location based on its name.
     
     - note: The store location is derived from the store name, using `NSPersistentStore.url(forName:)`
     - note: For arguments documentation - see `NSPersistentStoreCoordinator.addPersistentStore(ofType:configurationName:at:options:)`
     */
    
    public func addPersistentStore(ofType storeType: String, configurationName: String?, storeName: String, options: [AnyHashable : Any]?) throws {
        
        let storeURL = try NSPersistentStore.url(forName: storeName)
        try self.addPersistentStore(ofType: storeType, configurationName: configurationName, at: storeURL, options: options)
    }

    /**
     
     Lookup and returns a persistent store based on its name.
     
     - note: The store location is derived from the store name, using `NSPersistentStore.url(forName:)`
     - prameter storeName: The name of the persistant store for which to look up
     - returns: The persistent store for the given name`.
     
     */
    
    public func persistentStore(forName storeName: String) -> NSPersistentStore? {
        
        guard let storeURL = try? NSPersistentStore.url(forName: storeName) else {
            
            return nil
        }
        
        return self.persistentStore(for: storeURL)
    }
    
    /**
     
     Removes a persistent store based on its name.
     
     - note: The store location is derived from the store name, using `NSPersistentStore.url(forName:)`
     - prameter storeName: The name of the persistant store for which to look up
     
     */
    
    public func removePersistentStore(forName storeName: String) throws {
        
        let storeURL = try NSPersistentStore.url(forName: storeName)
        guard let store = self.persistentStore(for: storeURL) else {
            
            throw MHCoreDataKitError(message: "Unable to find store at \(storeURL)")
        }
        
        try self.remove(store)
    }
    
    /**
     
     Removes all persistent stores matching a given configuration name.
     
     - prameter configurationName: The name of the persistant store configuration
     
     */
    
    public func removePersistentStores(forConfigurationName configurationName: String) throws {
        
        for store in self.persistentStores {
            
            if store.configurationName == configurationName {
                
                try self.remove(store)
            }
        }
    }
    
    ///Removes all presistent sotres from the receiver
    public func removeAllPersistentStores() throws {
        
        for store in self.persistentStores {
            
            try self.remove(store)
        }
    }
}
