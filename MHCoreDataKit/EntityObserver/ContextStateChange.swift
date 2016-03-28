//
//  ContextStateChange.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public enum ContextStateChange {
    
    case WillSave
    case DidSave
    case DidChange
}

extension ContextStateChange {
    
    internal var notificationName: String {
        
        switch self {
            
            case .WillSave: return NSManagedObjectContextWillSaveNotification
            case .DidSave: return NSManagedObjectContextDidSaveNotification
            case .DidChange: return NSManagedObjectContextObjectsDidChangeNotification
        }
    }
}