//
//  NSFetchRequestConfigurationTests.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 12/12/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import MHCoreDataKit

class NSFetchRequestConfigurationTests: XCTestCase {
    
    private var stack: TestStack = {
        
        var stack = TestStack()
        
        //load some data
        do {
            
            let p1 = try Person(insertingInto: stack.context)
            p1.firstName = "zara"
            p1.age = 18
            
            let p2 = try Person(insertingInto: stack.context)
            p2.firstName = "geno"
            p2.age = 15
            
            let p3 = try Person(insertingInto: stack.context)
            p3.firstName = "geno"
            p3.age = 18
            
            let p4 = try Person(insertingInto: stack.context)
            p4.firstName = "liubo"
            p4.age = 15
            
            let p5 = try Person(insertingInto: stack.context)
            p5.firstName = "tenio"
            p5.lastName = "ivanov"
            p5.age = 21
            
            let p6 = try Person(insertingInto: stack.context)
            p6.firstName = "ivanov"
            p6.lastName = "ivanov"
            p6.age = 40
        }
        catch {
            
            XCTFail("\(error)")
        }
        
        return stack
    }()
    
    func testBasicConfiguration() {
        
        let predicate = NSPredicate(format: "test == predicate")
        let sortDescriptors = [NSSortDescriptor(key: "test key", ascending: true)]
        
        let fetchRequest = Person.makeFetchRequest()
        XCTAssertNil(fetchRequest.predicate)
        XCTAssertNil(fetchRequest.sortDescriptors)
        
        fetchRequest.configureWith(predicate: predicate)
        XCTAssertEqual(predicate, fetchRequest.predicate)
        
        fetchRequest.configureWith(sortDescriptors: sortDescriptors)
        XCTAssertNotNil(fetchRequest.sortDescriptors)
        XCTAssertEqual(sortDescriptors, fetchRequest.sortDescriptors!)
    }
    
    func testQuickSortConfiguration() {
        
        let fetchRequest = Person.makeFetchRequest().sortedBy(key: "name", ascending: true)
        XCTAssertNotNil(fetchRequest.sortDescriptors)
        XCTAssertEqual(fetchRequest.sortDescriptors?.count, 1)
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.key, "name")
        XCTAssertEqual(fetchRequest.sortDescriptors?.first?.ascending, true)
    }
    
    func testFetchAll() {
        
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingAll())
        XCTAssertEqual(result?.count, 6)
    }
    
    func testSorting() {
        
        //ascending
        let result1 = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingAll().sortedBy(key: "age", ascending: true)).map({ $0.age.intValue })
        XCTAssertNotNil(result1)
        XCTAssertEqual(result1!, [15, 15, 18, 18, 21, 40])
        
        //descending
        let result2 = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingAll().sortedBy(key: "age", ascending: false)).map({ $0.age.intValue })
        XCTAssertNotNil(result2)
        XCTAssertEqual(result2!, [15, 15, 18, 18, 21, 40].reversed())
    }
    
    func testFetchBySingleKeySingleValue() {
        
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingBy(key: "firstName", value: "geno"))
        XCTAssertEqual(result?.count, 2)
    }
    
    func testFetchByPairs() {
        
        let pairs: [String: Any] = ["firstName": "geno", "age": 15]
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingBy(pairs: pairs))
        XCTAssertEqual(result?.count, 1)
    }
    
    func testFetchByMultipleKeysSingleValue() {
        
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingBy(keys: ["firstName", "lastName"], value: "ivanov"))
        XCTAssertEqual(result?.count, 1)
    }
    
    func testFetchForMultipleKeysSingleValue() {
        
        let fetchRequest = Person.makeFetchRequest().fetchingFor(keys: ["firstName", "lastName"], value: "ivanov")
        let result = try? self.stack.context.fetch(fetchRequest)
        XCTAssertEqual(result?.count, 2)
    }
    
    func testFetchForSingleKeyMultipleValues() {
        
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingFor(key: "age", values: [15, 21]))
        XCTAssertEqual(result?.count, 3)
    }
    
    func testFetchForMultipleKeysMultipleValues() {
        
        let result = try? self.stack.context.fetch(Person.makeFetchRequest().fetchingFor(keys: ["firstName", "lastName", "age"], values: ["ivanov", 15]))
        XCTAssertEqual(result?.count, 4)
    }
    
    func testExecuteWithContextOverload() {
        
        let result = try? Person.makeFetchRequest().fetchingFor(keys: ["firstName", "lastName", "age"], values: ["ivanov", 15]).execute(with: self.stack.context)
        XCTAssertEqual(result?.count, 4)
    }
}
