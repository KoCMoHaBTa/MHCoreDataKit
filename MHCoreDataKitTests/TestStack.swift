//
//  TestStack.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 12/12/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import XCTest
import CoreData

struct TestStack {
    
    lazy var model: NSManagedObjectModel = {
        
        let model = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: Bundle(for: MHCoreDataKitTests.self))
        XCTAssertNotNil(model)
        return model!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        do {
            
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        }
        catch {
            
            XCTFail("\(error)")
        }
        
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType, coordinator: self.coordinator)
    }()
}
