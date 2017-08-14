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
    
    public func addPersistentStore(ofType storeType: String, configurationName: String?, storeName: String, options: [AnyHashable : Any]?) throws {
        
        let storeURL = try NSPersistentStore.url(forName: storeName)
        try self.addPersistentStore(ofType: storeType, configurationName: configurationName, at: storeURL, options: options)
    }

    public func persistentStore(forName storeName: String) -> NSPersistentStore? {
        
        guard let storeURL = try? NSPersistentStore.url(forName: storeName) else {
            
            return nil
        }
        
        return self.persistentStore(for: storeURL)
    }
    
    public func removePersistentStore(forName storeName: String) throws {
        
        let storeURL = try NSPersistentStore.url(forName: storeName)
        guard let store = self.persistentStore(for: storeURL) else {
            
            throw MHCoreDataKitError(message: "Unable to find store at \(storeURL)")
        }
        
        try self.remove(store)
    }
}
