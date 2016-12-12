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
        
        XCTAssertNotNil(model.entityByClass(Person.self))
        XCTAssertNotNil(model.entityByClass(Company.self))
        XCTAssertNil(model.entityByClass(_NonExistingPerson.self))
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
}
