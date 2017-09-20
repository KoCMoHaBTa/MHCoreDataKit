//
//  NSPersistentStore.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 8/14/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentStore {
    
    ///The default directory into which all physical persistent stores resides. Default to Library/Application Support directory.
    @nonobjc public static var defaultDirectory: URL! = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    
    /**
     Creates a directory url where all store files can be placed.
     
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - returns: The constructed URL
     - throws: An error in case the URL cannot be constructed.
     - note: The url is constructed by the followin way - <directory>/CoreDataStores/
     */
    
    public static func commonDirectory(in directory: URL = defaultDirectory) throws -> URL {
        
        let coreDataDirectory = directory.appendingPathComponent("CoreDataStores", isDirectory: true)
        try FileManager.default.createDirectory(at: coreDataDirectory, withIntermediateDirectories: true, attributes: nil)
        return coreDataDirectory
    }
    
    /**
     Creates a directory where a store file can be placed.
     
     - parameter name: The store file name
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - returns: The constructed URL
     - throws: An error in case the URL cannot be constructed.
     - note: The url is constructed by the followin way - <directory>/CoreDataStores/<name>/
     */
    
    public static func directory(forName name: String, in directory: URL = defaultDirectory) throws -> URL {
        
        let storeDrectory = try self.commonDirectory(in: directory).appendingPathComponent(name, isDirectory: true)
        try FileManager.default.createDirectory(at: storeDrectory, withIntermediateDirectories: true, attributes: nil)
        
        return storeDrectory
    }
    
    /**
     Creates and returns a store URL for a given name and extension in a given directory.
     
     - parameter name: The store file name
     - parameter ext: The store file extension. Default to `sqlite`
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - returns: The constructed URL
     - throws: An error in case the URL cannot be constructed.
     - note: The url is constructed by the followin way - <directory>/CoreDataStores/<name>/<name>.<extension>
     */
    
    public static func url(forName name: String, withExtension ext: String = "sqlite", in directory: URL = defaultDirectory) throws -> URL {
        
        let storeDrectory = try self.directory(forName: name, in: directory)
        let storeURL = storeDrectory.appendingPathComponent(name, isDirectory: false).appendingPathExtension(ext)
        return storeURL
    }
    
    /**
     Deletes the contents of a CoreDataStores directory inside a given directory.
     
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - throws: An error in case the directory cannot be deleted.
     */
    
    public static func deleteAll(in directory: URL = defaultDirectory) throws {
        
        let dir = try self.commonDirectory(in: directory)
        try FileManager.default.removeItem(at: dir)
    }
    
    /**
     Deletes a store for a given name in a driectory
     
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - throws: An error in case the directory cannot be deleted.
     */
    
    public static func delete(forName name: String, in directory: URL = defaultDirectory) throws {
        
        let dir = try self.directory(forName: name, in: directory)
        try FileManager.default.removeItem(at: dir)
    }
}

extension NSPersistentStore {
    
    ///The name of the store derived from its URL as lastPathComponent
    public var storeName: String? {
        
        return self.url?.deletingPathExtension().lastPathComponent
    }
}
