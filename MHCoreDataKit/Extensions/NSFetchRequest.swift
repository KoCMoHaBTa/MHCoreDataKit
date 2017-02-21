//
//  NSFetchRequest.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 12/12/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

//there is a very stupid limtation that does not allow to do almost any kind of extensions of NSFetchRequest due to some stupid conflict with the obj generic - so instead - we add any kind of extensions to this protocol
@objc public protocol NSFetchRequestExtension {
    
    func configureWith(predicate: NSPredicate?)
    func configureWith(sortDescriptors: [NSSortDescriptor])
}

//magically make NSFetchRequest conforming to it
extension NSFetchRequest: NSFetchRequestExtension {
    
    ///Configures the receiver with a predicate
    public func configureWith(predicate: NSPredicate?) {
        
        self.predicate = predicate
    }
    
    ///Configures the receiver with a collection of sort descriptors
    public func configureWith(sortDescriptors: [NSSortDescriptor]) {
        
        self.sortDescriptors = sortDescriptors
    }
}

//add chainable configuration methods
extension NSFetchRequestExtension {
    
    ///Configures the receiver with a predicate
    @discardableResult
    public func configured(with predicate: NSPredicate?) -> Self {
        
        self.configureWith(predicate: predicate)
        return self
    }
    
    ///Configures the receiver with a collection of sort descriptors
    @discardableResult
    public func configured(with sortDescriptors: [NSSortDescriptor]) -> Self {
        
        self.configureWith(sortDescriptors: sortDescriptors)
        return self
    }
}

//add sorting configuration
extension NSFetchRequestExtension {
    
    ///Configures the receiver for sorting the result collection by the value of a give key
    public func sortedBy(key: String, ascending: Bool = true) -> Self {
        
        return self.configured(with: [NSSortDescriptor(key: key, ascending: ascending)])
    }
}

extension NSFetchRequestExtension {
    
    ///Configures the receiver for fecthing all entities
    public func fetchingAll() -> Self {
        
        return self.configured(with: nil)
    }
}

//add fetching BY configuration - matching ALL of the specified key-value pairs
extension NSFetchRequestExtension {
    
    ///Configures the receiver for fecthing all entities that match the given key-value pair
    public func fetchingBy(key: String, value: Any) -> Self {
        
        let format = "%K == %@"
        let predicate = NSPredicate(format: format, argumentArray: [key, value])
        return self.configured(with: predicate)
    }
    
    ///Configures the receiver for fecthing all entities that match ALL of the given key-value pairs
    public func fetchingBy(pairs: [String: Any]) -> Self {
        
        guard !pairs.isEmpty else { return self }
        
        var format = ""
        var argumentsArray: [Any] = []
        
        for (key, value) in pairs {
            
            if format != "" {
                
                format += " AND "
            }
            
            format += "%K == %@"
            argumentsArray.append(key)
            argumentsArray.append(value)
        }
        
        let predicate = NSPredicate(format: format, argumentArray: argumentsArray)
        return self.configured(with: predicate)
    }
    
    ///Configures the receiver for fecthing all entities that match the given value for ALL of the given keys
    public func fetchingBy(keys: [String], value: Any) -> Self {
        
        guard !keys.isEmpty else { return self }
        
        var format = ""
        var argumentsArray: [Any] = []
        
        for key in keys {
            
            if format != "" {
                
                format += " AND "
            }
            
            format += "%K == %@"
            argumentsArray.append(key)
            argumentsArray.append(value)
        }
        
        let predicate = NSPredicate(format: format, argumentArray: argumentsArray)
        return self.configured(with: predicate)
    }
}

//add fetching FOR configuration - matching ANY of the specified key-value pairs
extension NSFetchRequestExtension {
    
    ///Configures the receiver for fecthing all entities that match the given value for ANY of the given keys
    public func fetchingFor(keys: [String], value: Any) -> Self {
        
        guard !keys.isEmpty else { return self }
        
        var format = ""
        var argumentsArray: [Any] = []
        
        for key in keys {
            
            if format != "" {
                
                format += " OR "
            }
            
            format += "%K == %@"
            argumentsArray.append(key)
            argumentsArray.append(value)
        }
        
        let predicate = NSPredicate(format: format, argumentArray: argumentsArray)
        return self.configured(with: predicate)
    }
    
    ///Configures the receiver for fecthing all entities that match ANY of the given values for the given key
    func fetchingFor(key: String, values: [Any]) -> Self {
        
        guard !values.isEmpty else { return self }
        
        var predicateFormat = ""
        var argumentsArray: [Any] = []
        
        for value in values {
            
            if predicateFormat != "" {
                
                predicateFormat += " OR "
            }
            
            predicateFormat += "%K == %@"
            argumentsArray.append(key)
            argumentsArray.append(value)
        }
        
        let predicate = NSPredicate(format: predicateFormat, argumentArray: argumentsArray)
        return self.configured(with: predicate)
    }
    
    ///Configures the receiver for fecthing all entities that match ANY of the given values for ANY of the given keys
    public func fetchingFor(keys: [String], values: [Any]) -> Self {
        
        guard !keys.isEmpty && !values.isEmpty else { return self }
        
        var predicateFormat = ""
        var argumentsArray: [Any] = []
        
        for key in keys {
            
            for value in values {
                
                if predicateFormat != "" {
                    
                    predicateFormat += " OR "
                }
                
                predicateFormat += "%K == %@"
                argumentsArray.append(key)
                argumentsArray.append(value)
            }
        }
        
        let predicate = NSPredicate(format: predicateFormat, argumentArray: argumentsArray)
        return self.configured(with: predicate)
    }
}
