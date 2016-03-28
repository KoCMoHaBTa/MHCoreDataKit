//
//  EntityObserverTests.swift
//  MHCoreDataKitTests
//
//  Created by Milen Halachev on 1/25/16.
//  Copyright © 2016 KoCMoHaBTa. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import MHCoreDataKit

class EntityObserverTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private let managedObjectSorter: (NSManagedObject, NSManagedObject) -> Bool = { $0.objectID.URIRepresentation().absoluteString > $1.objectID.URIRepresentation().absoluteString }
    
    override func setUp() {
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //setup a simple stack
        let model = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: NSBundle(forClass: self.dynamicType))!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType, coordinator: coordinator)
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.context = nil
        
        super.tearDown()
    }
    
    func testInsert() {
        
        self.performExpectation { (expectation) in
            
            var insertedPersons: [Person] = []
            
            var observer: EntityObserver! = EntityObserver(entityType: Person.self, context: self.context)
            observer.observe(.Inserted) { (inserted, updated, deleted) in
                
                XCTAssertTrue(inserted.count == insertedPersons.count)
                XCTAssertTrue(updated.isEmpty)
                XCTAssertTrue(deleted.isEmpty)
                
                XCTAssertEqual(insertedPersons.sort(self.managedObjectSorter), inserted.sort(self.managedObjectSorter))
                
                expectation.fulfill()
                observer = nil
            }
            
            do {
                
                let p1 = try Person(context: self.context)
                p1.firstName = "Genadi"
                p1.lastName = "Gredoredov"
                p1.age = 27
                
                let p2 = try Person(context: self.context)
                p2.firstName = "Kuncho"
                p2.lastName = "Timelkov"
                p2.age = 17
                
                let p3 = try Person(context: self.context)
                p3.firstName = "Strahil"
                p3.lastName = "Keremidkov"
                p3.age = 21
                insertedPersons = [p1, p2, p3]
                
                try self.context.save()
            }
            catch let error {
                
                XCTFail("\(error)")
            }
        }
    }
    
    func testUpdate() {
        
        var updatedPersons: [Person] = []
        
        self.performExpectation { (expectation) in
            
            var observer: EntityObserver! = EntityObserver(entityType: Person.self, context: self.context)
            observer.observe(.Updated) { (inserted, updated, deleted) in
                
                XCTAssertTrue(inserted.isEmpty)
                XCTAssertTrue(updated.count == updatedPersons.count)
                XCTAssertTrue(deleted.isEmpty)
                
                XCTAssertEqual(updatedPersons.sort(self.managedObjectSorter), updated.sort(self.managedObjectSorter))
                
                expectation.fulfill()
                observer = nil
            }
            
            do {
                
                let p1 = try Person(context: self.context)
                p1.firstName = "Genadi"
                p1.lastName = "Gredoredov"
                p1.age = 27
                
                let p2 = try Person(context: self.context)
                p2.firstName = "Kuncho"
                p2.lastName = "Timelkov"
                p2.age = 17
                
                let p3 = try Person(context: self.context)
                p3.firstName = "Strahil"
                p3.lastName = "Keremidkov"
                p3.age = 21
                
                try self.context.save()
                
                p1.firstName = "Grigor"
                p2.age = 18
                
                updatedPersons = [p1, p2]
                
                try self.context.save()
            }
            catch let error {
                
                XCTFail("\(error)")
            }
        }
    }
    
    func testDelete() {
        
        self.performExpectation { (expectation) in
            
            var deletedPersons: [Person] = []
            
            var observer: EntityObserver! = EntityObserver(entityType: Person.self, context: self.context)
            observer.observe(.Deleted) { (inserted, updated, deleted) in
                
                print("golqm be")
                XCTAssertTrue(inserted.isEmpty)
                XCTAssertTrue(updated.isEmpty)
                XCTAssertTrue(deleted.count == deletedPersons.count)
                
                XCTAssertEqual(deletedPersons.sort(self.managedObjectSorter), deleted.sort(self.managedObjectSorter))
                
                expectation.fulfill()
                observer = nil
            }
            
            do {
                
                let p1 = try Person(context: self.context)
                p1.firstName = "Genadi"
                p1.lastName = "Gredoredov"
                p1.age = 27
                
                let p2 = try Person(context: self.context)
                p2.firstName = "Kuncho"
                p2.lastName = "Timelkov"
                p2.age = 17
                
                let p3 = try Person(context: self.context)
                p3.firstName = "Strahil"
                p3.lastName = "Keremidkov"
                p3.age = 21
                
                try self.context.save()
                
                self.context.deleteObject(p1)
                self.context.deleteObject(p2)
                
                deletedPersons = [p1, p2]
                
                try self.context.save()
            }
            catch let error {
                
                XCTFail("\(error)")
            }
        }
    }
    
    func testFilter() {
        
        self.performExpectation { (expectation) in
            
            expectation.addConditions(["inserted \(2)", "updated \(1)", "deleted \(1)"])
            
            var observer: EntityObserver! = EntityObserver(entityType: Person.self, context: self.context)            
            observer.observe(.Any, filter: { $0.age.unsignedShortValue >= 18 }, changes: { (inserted, updated, deleted) in
                
                if !inserted.isEmpty {
                    
                    expectation.fulfillCondition("inserted \(inserted.count)")
                }
                
                if !updated.isEmpty {
                    
                    expectation.fulfillCondition("updated \(updated.count)")
                }
                
                if !deleted.isEmpty {
                    
                    expectation.fulfillCondition("deleted \(deleted.count)")
                }
                
                if expectation.areAllConditionsFulfulled {
                 
                    observer = nil
                }
            })
            
            do {
                
                let p1 = try Person(context: self.context)
                p1.firstName = "Genadi"
                p1.lastName = "Gredoredov"
                p1.age = 27
                
                let p2 = try Person(context: self.context)
                p2.firstName = "Kuncho"
                p2.lastName = "Timelkov"
                p2.age = 17
                
                let p3 = try Person(context: self.context)
                p3.firstName = "Strahil"
                p3.lastName = "Keremidkov"
                p3.age = 21
                
                let p4 = try Person(context: self.context)
                p4.firstName = "Strahil"
                p4.lastName = "Keremidkov"
                p4.age = 14
                
                try self.context.save()
                
                p2.firstName = "zelen"
                p3.lastName = "vrat"
                
                self.context.deleteObject(p1)
                self.context.deleteObject(p4)
                
                try self.context.save()
            }
            catch let error {
                
                XCTFail("\(error)")
            }
        }
    }
    
}