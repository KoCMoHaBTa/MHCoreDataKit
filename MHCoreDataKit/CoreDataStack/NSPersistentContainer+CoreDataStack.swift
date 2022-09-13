//
//  NSPersistentContainer+CoreDataStack.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 6/9/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

@available(iOS 10.0, *)
extension NSPersistentContainer: CoreDataStack {
    
    public var context: NSManagedObjectContext {
        
        return self.viewContext
    }
    
    public func createBackgrondStack() -> CoreDataStack {
        
        let context = self.newBackgroundContext()
        
        let createBackgrondStackHandler = { [unowned self] () -> CoreDataStack  in
            
            return self.createBackgrondStack()
        }
        
        let createMainStackHandler = { [unowned self] () -> CoreDataStack  in
            
            return self.createMainStack()
        }
        
        let stack = AnyCoreDataStack(context: context, createBackgrondStackHandler: createBackgrondStackHandler, createMainStackHandler: createMainStackHandler)
        return stack
    }
    
    public func createMainStack() -> CoreDataStack {
        
        let context = self.viewContext
        
        let createBackgrondStackHandler = { [unowned self] () -> CoreDataStack  in
            
            return self.createBackgrondStack()
        }
        
        let createMainStackHandler = { [unowned self] () -> CoreDataStack  in
            
            return self.createMainStack()
        }
        
        let stack = AnyCoreDataStack(context: context, createBackgrondStackHandler: createBackgrondStackHandler, createMainStackHandler: createMainStackHandler)
        return stack
    }
}
