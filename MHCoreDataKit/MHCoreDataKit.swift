//
//  MHCoreDataKit.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/4/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public struct MHCoreDataKitError: RawRepresentable, Error {
    
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

