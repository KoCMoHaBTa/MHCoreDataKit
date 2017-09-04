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
open class DefaultCoreDataStack: CoreDataStack, CoreDataStackInitializationProtocol {
    
    open let context: NSManagedObjectContext
    
    ///Creates an instance of the receiver with a given context
    public required init(context: NSManagedObjectContext) {
        
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


