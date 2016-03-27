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
    
    override func setUp() {
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
        
        super.tearDown()
    }
    
    func testExample() {
        
        //model init
        let model: NSManagedObjectModel! = NSManagedObjectModel(name: "MHCoreDataKitTests", bundle: NSBundle(forClass: self.dynamicType))
        XCTAssertNotNil(model)
        
        //test entites by class name generation
        model.entities.forEach({ (entity) in
            
            XCTAssertNotNil(model.entitiesByClassName[entity.managedObjectClassName])
        })
        
        //model entity lookup
        XCTAssertNotNil(model.entityByClass(Person))
        XCTAssertNotNil(model.entityByClass(Company))
        XCTAssertNil(model.entityByClass(_NonExistingPerson))
        
        //entity initialization by model
        XCTAssertNotNil(try? Person(model: model))
        XCTAssertNotNil(try? Company(model: model))
        XCTAssertNil(try? _NonExistingPerson(model: model))
    }
}
