//
//  EntityStateChange.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation

///Represent an entity change state/type
public enum EntityState {
    
    case inserted
    case updated
    case deleted
    case any
}
