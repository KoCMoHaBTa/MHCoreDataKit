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
        XCTAssertEqual(try! NSPersistentStore.directory(forStoreName: "test", in: dir), dir.appendingPathComponent("CoreDataStores/Default/test", isDirectory: true))
        XCTAssertEqual(try! NSPersistentStore.directory(forStoreName: "test", configurationName: "kenobi", in: dir), dir.appendingPathComponent("CoreDataStores/kenobi/test", isDirectory: true))
    }
    
    func testStoreURL() {
        
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        XCTAssertEqual(try! NSPersistentStore.url(forStoreName: "test", configurationName: "asd", withExtension: "gg", in: dir), dir.appendingPathComponent("CoreDataStores/asd/test/test.gg", isDirectory: false))
        XCTAssertEqual(try! NSPersistentStore.url(forStoreName: "test", in: dir), dir.appendingPathComponent("CoreDataStores/Default/test/test.sqlite", isDirectory: false))
    }
    
    func testDeleteStore() {
        
        let url = try! NSPersistentStore.url(forStoreName: "s1")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        
        try! "".write(to: url, atomically: true, encoding: .utf8)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        
        try! NSPersistentStore.delete(forStoreName: "s1")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testDeleteStoreWithConfiguration() {
        
        let url = try! NSPersistentStore.url(forStoreName: "s2", configurationName: "jedi")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        
        try! "".write(to: url, atomically: true, encoding: .utf8)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        
        try! NSPersistentStore.delete(forStoreName: "s2", configurationName: "jedi")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testDeleteAllStores() {
        
        let s1 = try! NSPersistentStore.url(forStoreName: "s3")
        let s2 = try! NSPersistentStore.url(forStoreName: "s4", configurationName: "obi")
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
