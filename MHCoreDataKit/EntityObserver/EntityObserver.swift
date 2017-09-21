//
//  EntityObserver.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

///Observe NSManagedObjectContext changes
open class EntityObserver<E: NSManagedObject> {
    
    private let context: NSManagedObjectContext?
    private let queue: OperationQueue = OperationQueue()
    
    
    /**
     
     Creates an instance of the receiver for a given entity and context
     
     - parameter entityType: The type of the entity for which to observer for changes
     - parameter context: The context for which to restrict the observer changes.
     - returns: An instance of the receiver.
     
     */
    
    public init(context: NSManagedObjectContext? = nil) {
        
        self.context = context
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     
     Start observing changes
     
     - parameter entityType: The type of the entity for which to observer for changes
     - parameter context: The context for which to restrict the observer changes.
     - returns: An instance of the receiver.
     
     */
    
    @discardableResult
    open func observeChanges(upon contextState: ContextState, for entityState: EntityState, filter: ((_ entity: E) -> Bool)?, handler: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E> {
        
        NotificationCenter.default.addObserver(forName: contextState.notificationName, object: self.context, queue: self.queue) { [weak self] (notification) -> Void in
            
            guard let weakSelf = self else {
                
                return
            }
            
            let (inserted, updated, deleted) = weakSelf.expand(notification: notification, for: entityState)
            
            if let (inserted, updated, deleted) = weakSelf.match(inserted: inserted, updated: updated, deleted: deleted, for: entityState, filteringBy: filter) {
                
                guard let context = notification.object as? NSManagedObjectContext ?? weakSelf.context else {
                    
                    handler(inserted, updated, deleted)
                    
                    return
                }
                
                context.perform({ () -> Void in
                    
                    handler(inserted, updated, deleted)
                })
            }
        }
        
        return self
    }
    
    @discardableResult
    open func observeChanges(_ handler: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E>{
        
        return self.observeChanges(upon: .default, for: .default, filter: nil, handler: handler)
    }
    
    @discardableResult
    open func observeChanges(for entityState: EntityState, handler: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E>{
        
        return self.observeChanges(upon: .default, for: entityState, filter: nil, handler: handler)
    }
    
    @discardableResult
    open func observeChanges(for entityState: EntityState, filter: ((_ entity: E) -> Bool)?, handler: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E>{
        
        return self.observeChanges(upon: .default, for: entityState, filter: filter, handler: handler)
    }
    
    ///transforms the content of a notification into generic typed changes
    private func expand(notification: Notification, for entityState: EntityState) -> (inserted: [E], updated: [E], deleted: [E]) {

        func transform(_ object: AnyObject?) -> [E] {
            
            let collection = object as? Set<NSManagedObject>
            let filtered = collection?.filter({ $0 is E }).map({ $0 as! E })
            
            return filtered ?? []
        }
        
        var inserted = [E]()
        var updated = [E]()
        var deleted = [E]()
        
        switch entityState {
            
            case .inserted: inserted = transform(notification.userInfo?[NSInsertedObjectsKey] as AnyObject?)
            case .updated: updated = transform(notification.userInfo?[NSUpdatedObjectsKey] as AnyObject?)
            case .deleted: deleted = transform(notification.userInfo?[NSDeletedObjectsKey] as AnyObject?)
            
            case .any:
                inserted = transform(notification.userInfo?[NSInsertedObjectsKey] as AnyObject?)
                updated = transform(notification.userInfo?[NSUpdatedObjectsKey] as AnyObject?)
                deleted = transform(notification.userInfo?[NSDeletedObjectsKey] as AnyObject?)
        }
        
        return(inserted, updated, deleted)
    }
    
    ///match, filter and transform changes into single tuple for a given EntityState and a filter closure
    private func match(inserted: [E], updated: [E], deleted: [E], for entityState: EntityState, filteringBy filter: ((_ entity: E) -> Bool)?) -> (inserted: [E], updated: [E], deleted: [E])? {
        
        var inserted = inserted
        var updated = updated
        var deleted = deleted
        
        switch entityState {
            
            case .inserted:
                
                if let filter = filter {
                    
                    inserted = inserted.filter(filter)
                }
                
                if inserted.isEmpty {
                    
                    return nil
                }
                
            case .updated:
                
                if let filter = filter {
                    
                    updated = updated.filter(filter)
                }
                
                if updated.isEmpty {
                    
                    return nil
                }
                
            case .deleted:
                
                if let filter = filter {
                    
                    deleted = deleted.filter(filter)
                }
                
                if deleted.isEmpty {
                    
                    return nil
                }
                
            default:
                
                if let filter = filter {
                    
                    inserted = inserted.filter(filter)
                    updated = updated.filter(filter)
                    deleted = deleted.filter(filter)
                }
                
                if inserted.isEmpty && updated.isEmpty && deleted.isEmpty {
                    
                    return nil
                }
        }
        
        return(inserted, updated, deleted)
    }
}

extension ContextState {
    
    fileprivate static let `default`: ContextState = .didSave
}

extension EntityState {
    
    fileprivate static let `default`: EntityState = .any
}
