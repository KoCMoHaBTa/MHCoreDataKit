//
//  Company.swift
//  MHCoreDataKitTests
//
//  Created by Milen Halachev on 11/10/14.
//  Copyright (c) 2014 KoCMoHaBTa. All rights reserved.
//

import Foundation
import CoreData

class Company: NSManagedObject  {
    
    @NSManaged var name: String
    @NSManaged var address: String
    @NSManaged var employees: NSSet
}
