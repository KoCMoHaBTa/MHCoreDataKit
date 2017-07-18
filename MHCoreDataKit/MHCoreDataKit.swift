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

/**
 Creates a directory url where all store files can be placed.
 
 - parameter directory: The store directory. Default to Library drectory
 - returns: The constructed URL
 - throws: An error in case the URL cannot be constructed.
 - note: The url is constructed by the followin way - <directory>/CoreDataStores/
 */

public func StoresCommonDirectory(in directory: URL? = nil) throws -> URL {
    
    guard let directory = directory ?? FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
        
        throw MHCoreDataKitError(message: "Unable to load store directory")
    }
    
    let coreDataDirectory = directory.appendingPathComponent("CoreDataStores", isDirectory: true)
    try FileManager.default.createDirectory(at: coreDataDirectory, withIntermediateDirectories: true, attributes: nil)
    return coreDataDirectory
}

/**
 Creates a directory where a store file can be placed.
 
 - parameter name: The store file name
 - parameter directory: The store directory. Default to Library drectory
 - returns: The constructed URL
 - throws: An error in case the URL cannot be constructed.
 - note: The url is constructed by the followin way - <directory>/CoreDataStores/<name>/
 */

public func StoreDirectory(forName name: String, in directory: URL? = nil) throws -> URL {
 
    let storeDrectory = try StoresCommonDirectory(in: directory).appendingPathComponent(name, isDirectory: true)
    try FileManager.default.createDirectory(at: storeDrectory, withIntermediateDirectories: true, attributes: nil)
    
    return storeDrectory
}

/**
 Creates and returns a store URL for a given name and extension in a given directory.
 
 - parameter name: The store file name
 - parameter ext: The store file extension. Default to `sqlite`
 - parameter directory: The store directory. Default to Library drectory
 - returns: The constructed URL
 - throws: An error in case the URL cannot be constructed.
 - note: The url is constructed by the followin way - <directory>/CoreDataStores/<name>/<name>.<extension>
 */
public func StoreURL(forName name: String, withExtension ext: String = "sqlite", in directory: URL? = nil) throws -> URL {
    
    let storeDrectory = try StoreDirectory(forName: name, in: directory)
    let storeURL = storeDrectory.appendingPathComponent(name, isDirectory: false).appendingPathExtension(ext)
    return storeURL
}

/**
 Deletes the contents of a CoreDataStores directory inside a given directory.
 
  - parameter directory: The store directory. Default to Library drectory
  - throws: An error in case the directory cannot be deleted.
 */
public func DeleteAllStores(in directory: URL? = nil) throws {
    
    let dir = try StoresCommonDirectory(in: directory)
    try FileManager.default.removeItem(at: dir)
}

/**
 Deletes a store for a given name in a driectory
 
 - parameter directory: The store directory. Default to Library drectory
 - throws: An error in case the directory cannot be deleted.
 */

public func DeleteStore(forName name: String, in directory: URL? = nil) throws {
    
    let dir = try StoreDirectory(forName: name, in: directory)
    try FileManager.default.removeItem(at: dir)
}







