//
//  CoreDataStackInitializationProtocol.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 9/4/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

///A type that implements CoreDataStack initialization
public protocol CoreDataStackInitializationProtocol {
    
    ///Creates an instance of the receiver with a given context
    init(context: NSManagedObjectContext)
}

extension CoreDataStackInitializationProtocol {
    
    ///Creates an instance of the receiver with the provided persistent store coordinator and main thread context
    public init(coordinator: NSPersistentStoreCoordinator) {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType, coordinator: coordinator)
        
        self.init(context: context)
    }
    
    ///Creates an instance of the receiver with the provided model and persistent store coordinator configurations
    public init(model: NSManagedObjectModel, storeType: String, configurationName: String?, storeURL: URL?, options: [AnyHashable: Any]?) throws {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try coordinator.addPersistentStore(ofType: storeType, configurationName: configurationName, at: storeURL, options: options)
        
        self.init(coordinator: coordinator)
    }
    
    ///Creates an instance of the receiver for a given model name, bundle and persistent store coordinator configurations
    public init(modelName: String, modelBundle: Bundle, storeType: String, configurationName: String?, storeName: String?, options: [AnyHashable : Any]?) throws {
        
        guard let model = NSManagedObjectModel(name: modelName, bundle: modelBundle) else {
            
            throw MHCoreDataKitError(message: "Unable to find model")
        }
        
        let storeName = storeName ?? modelName
        let storeURL = try NSPersistentStore.url(forStoreName: storeName, configurationName: configurationName)
        try self.init(model: model, storeType: storeType, configurationName: configurationName, storeURL: storeURL, options: options)
    }
}
