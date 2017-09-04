//
//  CoreDataStack.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 6/8/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

///A type that represent a core data stack
public protocol CoreDataStack {
    
    ///The managed object context associated with the stack
    var context: NSManagedObjectContext { get }
    
    ///Creates a stack with a managed object context that is associated with a private queue.
    func createBackgrondStack() -> CoreDataStack
    
    ///Creates a stack with a managed object context that is associated with the main queue.
    func createMainStack() -> CoreDataStack
}

extension CoreDataStack {
    
    ///Asynchronously performs the block on the context's queue.
    public func perform(_ handler: @escaping (NSManagedObjectContext) -> Void) {
        
        let context = self.context
        context.perform {
            
            handler(context)
        }
    }
    
    ///Synchronously performs the block on the context's queue.
    public func performAndWait(_ handler: @escaping (NSManagedObjectContext) -> Void) {
        
        let context = self.context
        context.performAndWait {
            
            handler(context)
        }
    }
}

extension CoreDataStack {
    
    public func addPersistentStore(ofType storeType: String, configurationName: String?, storeName: String, options: [AnyHashable : Any]?) throws {
        
        let storeURL = try NSPersistentStore.url(forName: storeName)
        try self.context.persistentStoreCoordinator?.addPersistentStore(ofType: storeType, configurationName: configurationName, at: storeURL, options: options)
    }
}
