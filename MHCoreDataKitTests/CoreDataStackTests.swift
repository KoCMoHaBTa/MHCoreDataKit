//
//  CoreDataStackTests.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 6/9/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import MHCoreDataKit

class CoreDataStackTests: XCTestCase {
    
    func testAnyStack() {
        
        self.performExpectation { (e) in
            
            e.expectedFulfillmentCount = 2
            
            var stack: CoreDataStack?
            stack = AnyCoreDataStack(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType), createBackgrondStackHandler: { () -> CoreDataStack in
                
                e.fulfill()
                return stack!
                
            }, createMainStackHandler: { () -> CoreDataStack in
                
                e.fulfill()
                return stack!
                
            })
            
            _ = stack?.createBackgrondStack().createMainStack()
        }
    }
    
    func testDefaultStack() {
        
        let model = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: Bundle(for: MHCoreDataKitTests.self))!
        let stack = try! DefaultCoreDataStack(model: model, storeType: NSInMemoryStoreType, configurationName: nil, storeURL: nil, options: nil)
        
        XCTAssertEqual(stack.context.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertTrue(stack.context.persistentStoreCoordinator?.managedObjectModel === model)
        
        let backgorundStack = stack.createBackgrondStack()
        
        XCTAssertEqual(backgorundStack.context.concurrencyType, .privateQueueConcurrencyType)
        XCTAssertTrue(backgorundStack.context.persistentStoreCoordinator?.managedObjectModel === model)
        
        let mainStack = stack.createMainStack()
        
        XCTAssertEqual(mainStack.context.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertTrue(mainStack.context.persistentStoreCoordinator?.managedObjectModel === model)
        
        XCTAssertFalse(mainStack.context === stack.context)
    }
}
