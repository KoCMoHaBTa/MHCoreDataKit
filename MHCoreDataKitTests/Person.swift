//
//  Person.swift
//  MHCoreDataKitTests
//
//  Created by Milen Halachev on 11/10/14.
//  Copyright (c) 2014 KoCMoHaBTa. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject  {
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var age: NSNumber
    @NSManaged var company: Company
    @NSManaged var coleagues: NSSet
}

class _NonExistingPerson: Person {}