//
//  MHCoreDataKitTests.swift
//  MHCoreDataKitTests
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import XCTest
import CoreData
@testable import MHCoreDataKit

class MHCoreDataKitTests: XCTestCase {
    
    fileprivate var context: NSManagedObjectContext!
    
    override func setUp() {
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //setup a simple stack
        let model = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: Bundle(for: type(of: self)))!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType, coordinator: coordinator)
        
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.context = nil
        
        super.tearDown()
    }
    
    func testExample() {
        
        //model init
        let model: NSManagedObjectModel! = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: Bundle(for: type(of: self)))
        XCTAssertNotNil(model)
        
        //test entites by class name generation
        model.entities.forEach({ (entity) in
            
            XCTAssertNotNil(model.entitiesByClassName[entity.managedObjectClassName])
        })
        
        //model entity lookup
        XCTAssertNotNil(model.entityByClass(Person.self))
        XCTAssertNotNil(model.entityByClass(Company.self))
        XCTAssertNil(model.entityByClass(_NonExistingPerson.self))
        
        //entity initialization by model
        XCTAssertNotNil(try? Person(model: model))
        XCTAssertNotNil(try? Company(model: model))
        XCTAssertNil(try? _NonExistingPerson(model: model))
        
        let g1 = String(describing: Person.self)
        let g2 = String(reflecting: Person.self)
        let g3 = NSStringFromClass(Person.self)
        
        let e = self.context.persistentStoreCoordinator?.managedObjectModel.entitiesByName
        let fff = FetchRequest<Person, Person>()
        let gay = try! self.context.fetch(fff)
        
        print("gay")
    }
}
