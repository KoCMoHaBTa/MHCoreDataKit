//
//  XCTestExtensions.swift
//  https://gist.github.com/KoCMoHaBTa/4ba07984d7c95822bc05
//
//  Created by Milen Halachev on 3/18/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    
    public func performExpectation(description: String = "XCTestCase Default Expectation", timeout: TimeInterval = 2, handler: (_ expectation: XCTestExpectation) -> Void) {
        
        let expectation = self.expectation(description: description)
        handler(expectation)
        
        self.waitForExpectations(timeout: timeout, handler: { (error) -> Void in
            
            XCTAssertNil(error, "Expectation Error")
        })
    }
}

extension XCTestExpectation {
    
    private struct AssociatedKeys {
        
        static var conditionsKey = "XCTestExpectation.AssociatedKeys.conditionsKey"
    }
    
    public private(set) var conditions: [String: Bool] {
        
        get {
            
            return objc_getAssociatedObject(self, &AssociatedKeys.conditionsKey) as? [String: Bool] ?? [:]
        }
        
        set {
            
            objc_setAssociatedObject(self, &AssociatedKeys.conditionsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var areAllConditionsFulfulled: Bool {
        
        for state in Array(self.conditions.values) {
            
            if state == false {
                
                return false
            }
        }
        
        return true
    }
    
    public func add(conditions: [String]) {
        
        conditions.forEach { (condition) -> () in
            
            self.conditions[condition] = false
        }
    }
    
    public func fulfill(condition: String) {
        
        XCTAssertNotNil(self.conditions[condition], "Cannot fulfil a non-exiting condition: \"\(condition)\"")
        
        guard self.conditions[condition] == false else {
            
            XCTFail("Cannot fulfil condition again - \(condition)")
            return
        }
        
        self.conditions[condition] = true
        
        guard self.areAllConditionsFulfulled else {
            
            return
        }
        
        self.fulfill()
    }
}
