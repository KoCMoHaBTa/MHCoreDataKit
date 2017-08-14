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
    
    private var stack = TestStack()
    
    func testEntitiesByClassNameGeneration() {
        
        let model = self.stack.model
        
        //test entites by class name generation
        model.entities.forEach({ (entity) in
            
            XCTAssertNotNil(model.entitiesByClassName[entity.managedObjectClassName])
        })
    }
    
    func testModelEntityLookup() {
        
        let model = self.stack.model
        
        XCTAssertNotNil(model.entity(byClass: Person.self))
        XCTAssertNotNil(model.entity(byClass: Company.self))
        XCTAssertNil(model.entity(byClass: _NonExistingPerson.self))
    }
    
    func testEntityInitializationByModel() {
        
        let model = self.stack.model
        
        XCTAssertNotNil(try? Person(model: model))
        XCTAssertNotNil(try? Company(model: model))
        XCTAssertNil(try? _NonExistingPerson(model: model))
    }
    
    func testEntityName() {
        
        XCTAssertEqual(Person.entityName(), "Person")
    }
    
    func testMakingNSFetchRequest() {
        
        let fetchRequest = Person.makeFetchRequest()
        XCTAssertEqual(fetchRequest.resultType, NSFetchRequestResultType.managedObjectResultType)
        XCTAssertEqual(fetchRequest.entityName, "Person")
    }
    
    func testStoresCommonDirectory() {
        
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        XCTAssertEqual(try! NSPersistentStore.commonDirectory(in: dir), dir.appendingPathComponent("CoreDataStores", isDirectory: true))
    }
    
    func testStoreDirectory() {
        
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        XCTAssertEqual(try! NSPersistentStore.directory(forName: "test", in: dir), dir.appendingPathComponent("CoreDataStores/test", isDirectory: true))
    }
    
    func testStoreURL() {
        
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        XCTAssertEqual(try! NSPersistentStore.url(forName: "test", withExtension: "gg", in: dir), dir.appendingPathComponent("CoreDataStores/test/test.gg", isDirectory: false))
    }
    
    func testDeleteStore() {
        
        let url = try! NSPersistentStore.url(forName: "s1")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        
        try! "".write(to: url, atomically: true, encoding: .utf8)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        
        try! NSPersistentStore.delete(forName: "s1")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testDeleteAllStores() {
        
        let s1 = try! NSPersistentStore.url(forName: "s1")
        let s2 = try! NSPersistentStore.url(forName: "s2")
        XCTAssertFalse(FileManager.default.fileExists(atPath: s1.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: s1.path))
        
        try! "".write(to: s1, atomically: true, encoding: .utf8)
        try! "".write(to: s2, atomically: true, encoding: .utf8)
        XCTAssertTrue(FileManager.default.fileExists(atPath: s1.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: s1.path))
        
        try! NSPersistentStore.deleteAll()
        XCTAssertFalse(FileManager.default.fileExists(atPath: s1.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: s1.path))
    }
}
