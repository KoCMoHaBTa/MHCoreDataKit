//
//  ContextStateChange.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public enum ContextState {
    
    case willSave
    case didSave
    case didChange
}

extension ContextState {
    
    internal var notificationName: NSNotification.Name {
        
        switch self {
            
            case .willSave: return NSNotification.Name.NSManagedObjectContextWillSave
            case .didSave: return NSNotification.Name.NSManagedObjectContextDidSave
            case .didChange: return NSNotification.Name.NSManagedObjectContextObjectsDidChange
        }
    }
}
