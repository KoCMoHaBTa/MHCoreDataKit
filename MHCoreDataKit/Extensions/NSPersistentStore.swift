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
     Creates and returns the directory where a store file can be placed.
     
     - parameter storeName: The store file name
     - parameter configurationName: The configiuration name. Default to nil, resolving to "Default"
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - returns: The constructed URL
     - throws: An error in case the URL cannot be constructed.
     - note: The url is constructed by the followin way - <directory>/CoreDataStores/<configurationName>/<storeName>/
     */
    
    public static func directory(forStoreName storeName: String, configurationName: String? = nil, in directory: URL = defaultDirectory) throws -> URL {
        
        let configurationName = configurationName ?? "Default"
        let storeDrectory = try self.commonDirectory(in: directory).appendingPathComponent(configurationName, isDirectory: true).appendingPathComponent(storeName, isDirectory: true)
        try FileManager.default.createDirectory(at: storeDrectory, withIntermediateDirectories: true, attributes: nil)
        
        return storeDrectory
    }
    
    /**
     Creates and returns a store URL for a given store name, configuration name and extension in a given directory.
     
     - parameter storeName: The store file name
     - parameter configurationName: The configuration folder name. Default to nil, resolving to "Default"
     - parameter ext: The store file extension. Default to `sqlite`
     - parameter directory: The store directory. Default to Library/Application Support drectory
     - returns: The constructed URL
     - throws: An error in case the URL cannot be constructed.
     - note: The url is constructed by the followin way - <directory>/CoreDataStores/<configurationName>/<storeName>/<storeName>.<extension>
     */
    
    public static func url(forStoreName storeName: String, configurationName: String? = nil, withExtension ext: String = "sqlite", in directory: URL = defaultDirectory) throws -> URL {
        
        let storeDirectory = try self.directory(forStoreName: storeName, configurationName: configurationName, in: directory)
        let storeURL = storeDirectory.appendingPathComponent(storeName, isDirectory: false).appendingPathExtension(ext)
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
     Deletes a store for a given name and configuration in a driectory.
     
     - parameter storeName: The name of the store.
     - parameter configurationName: The configuration folder name. Default to nil, resolving to "Default"
     - throws: An error in case the directory cannot be deleted.
     */
    
    public static func delete(forStoreName storeName: String, configurationName: String? = nil, in directory: URL = defaultDirectory) throws {
        
        let storeDirectory = try self.directory(forStoreName: storeName, configurationName: configurationName, in: directory)
        try FileManager.default.removeItem(at: storeDirectory)
    }
}

extension NSPersistentStore {
    
    ///The name of the store derived from its URL as lastPathComponent
    public var storeName: String? {
        
        return self.url?.deletingPathExtension().lastPathComponent
    }
}
