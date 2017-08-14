//
//  DefaultCoreDataStack.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 6/9/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

///A default core data stack that creates background and main contexts targeting directly the receiver context's persistent store coordinator.
open class DefaultCoreDataStack: CoreDataStack {
    
    open let context: NSManagedObjectContext
    
    ///Creates an instance of the receiver with a given context
    public init(context: NSManagedObjectContext) {
        
        self.context = context
    }
    
    open func createBackgrondStack() -> CoreDataStack {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.context.persistentStoreCoordinator
        
        let stack = DefaultCoreDataStack(context: context)
        return stack
    }
    
    open func createMainStack() -> CoreDataStack {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.context.persistentStoreCoordinator
        
        let stack = DefaultCoreDataStack(context: context)
        return stack
    }
}

extension DefaultCoreDataStack {
    
    ///Creates an instance of the receiver with the provided persistent store coordinator and main thread context
    public convenience init(coordinator: NSPersistentStoreCoordinator) {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType, coordinator: coordinator)
        
        self.init(context: context)
    }
    
    ///Creates an instance of the receiver with the provided model and persistent store coordinator configurations
    public convenience init(model: NSManagedObjectModel, storeType: String, configurationName: String?, storeURL: URL?, options: [AnyHashable: Any]?) throws {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try coordinator.addPersistentStore(ofType: storeType, configurationName: configurationName, at: storeURL, options: options)
        
        self.init(coordinator: coordinator)
    }
    
    ///Creates an instance of the receiver for a given model name, bundle and persistent store coordinator configurations
    public convenience init(modelName: String, modelBundle: Bundle, storeType: String, configurationName: String?, storeName: String?, options: [AnyHashable : Any]?) throws {
        
        guard let model = NSManagedObjectModel(name: modelName, bundle: modelBundle) else {
            
            throw MHCoreDataKitError(message: "Unable to find model")
        }

        let storeName = storeName ?? modelName
        let storeURL = try NSPersistentStore.url(forName: storeName)
        try self.init(model: model, storeType: storeType, configurationName: configurationName, storeURL: storeURL, options: options)
    }
}



