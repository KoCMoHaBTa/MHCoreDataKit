//
//  AnyCoreDataStack.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 6/9/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

open class AnyCoreDataStack: CoreDataStack {
    
    open var context: NSManagedObjectContext
    open let createBackgrondStackHandler: () -> CoreDataStack
    open let createMainStackHandler: () -> CoreDataStack
    
    public init(context: NSManagedObjectContext, createBackgrondStackHandler: @escaping () -> CoreDataStack, createMainStackHandler: @escaping () -> CoreDataStack) {
        
        self.context = context
        self.createBackgrondStackHandler = createBackgrondStackHandler
        self.createMainStackHandler = createMainStackHandler
    }
    
    open func createBackgrondStack() -> CoreDataStack {
        
        return self.createBackgrondStackHandler()
    }
    
    open func createMainStack() -> CoreDataStack {
        
        return self.createMainStackHandler()
    }
}
