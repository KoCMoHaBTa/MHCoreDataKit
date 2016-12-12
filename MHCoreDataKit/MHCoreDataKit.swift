//
//  MHCoreDataKit.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public struct Error: RawRepresentable, Swift.Error {
    
    public let message: String
    
    public init(message: String) {
        
        self.message = message
    }
    
    //MARK: - RawRepresentable
    
    public var rawValue: String {
        
        return self.message
    }
    
    public init?(rawValue: String) {
        
        self.message = rawValue
    }
}




//iskame go tova za da mojem da napravim generic fetch request i po class da vzemem entity name
//
//
//
//vsu6tnost entity name trqbva da e imeto na klasa hmmm ....
//ama realno 6e iskame da razberem ot koi model e
//vuv NSFetchRequest - entityName se predostavq v konstruktora koeto zna4i 4e e user provided

/*
 by default this should be the name of the class without module prefix
 at this point (swift 2.2) this can be retrieved by String(self)
 however the user can always change the entity name to something else
 probably more appropriate would be to lookup into models and get the name from matching class
 model lookup is expensive and should be done once per class
 
 so the options are following:
 1. Assume that the entity name will match the class name and String(self) will continue to provide it - do not care about the model - better for generic fetch request
 2. Lookup the entity name trough all possible models in the file system - multiple models may match the same class - better for core data stack
 
 */


