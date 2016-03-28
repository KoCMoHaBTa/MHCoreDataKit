//
//  EntityObserver.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

public class EntityObserver<E:NSManagedObject> {
    
    private let entityType: E.Type
    private let context: NSManagedObjectContext?
    private let queue: NSOperationQueue = NSOperationQueue()
    
    public init(entityType: E.Type, context: NSManagedObjectContext? = nil) {
        
        self.entityType = entityType
        self.context = context
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func observe(contextStateChange: ContextStateChange = .DidSave, entityStateChange: EntityStateChange = .Any, filter: ((entity: E) -> Bool)? = nil, changes: (inserted: [E], updated: [E], deleted: [E]) -> Void) -> EntityObserver<E> {
        
        NSNotificationCenter.defaultCenter().addObserverForName(contextStateChange.notificationName, object: self.context, queue: self.queue) { [weak self] (notification) -> Void in
            
            guard let weakSelf = self else {
                
                return
            }
            
            let (inserted, updated, deleted) = weakSelf.expandNotification(notification, entityStateChange: entityStateChange)
            
            if let (inserted, updated, deleted) = weakSelf.match(inserted, updated: updated, deleted: deleted, entityStateChange: entityStateChange, filter: filter) {
                
                guard let context = notification.object as? NSManagedObjectContext ?? weakSelf.context else {
                    
                    changes(inserted: inserted, updated: updated, deleted: deleted)
                    
                    return
                }
                
                context.performBlock({ () -> Void in
                    
                    changes(inserted: inserted, updated: updated, deleted: deleted)
                })
            }
        }
        
        return self
    }
    
    public func observe(entityStateChange: EntityStateChange, filter: ((entity: E) -> Bool)? = nil, changes: (inserted: [E], updated: [E], deleted: [E]) -> Void) -> EntityObserver<E> {
        
        return self.observe(entityStateChange: entityStateChange, filter: filter, changes: changes)
    }
    
    private func expandNotification(notification: NSNotification, entityStateChange: EntityStateChange) -> (inserted: [E], updated: [E], deleted: [E]) {
        
        func transform(object: AnyObject?) -> [E] {
            
            let collection = object as? Set<NSManagedObject>
            let filtered = collection?.filter({ $0 is E }) as? [E]
            
            return filtered ?? []
        }
        
        var inserted = [E]()
        var updated = [E]()
        var deleted = [E]()
        
        switch entityStateChange {
            
        case .Inserted: inserted = transform(notification.userInfo?[NSInsertedObjectsKey])
        case .Updated: updated = transform(notification.userInfo?[NSUpdatedObjectsKey])
        case .Deleted: deleted = transform(notification.userInfo?[NSDeletedObjectsKey])
            
        default:
            inserted = transform(notification.userInfo?[NSInsertedObjectsKey])
            updated = transform(notification.userInfo?[NSUpdatedObjectsKey])
            deleted = transform(notification.userInfo?[NSDeletedObjectsKey])
        }
        
        return(inserted, updated, deleted)
    }
    
    private func match(inserted: [E], updated: [E], deleted: [E], entityStateChange: EntityStateChange, filter: ((entity: E) -> Bool)?) -> (inserted: [E], updated: [E], deleted: [E])? {
        
        var inserted = inserted
        var updated = updated
        var deleted = deleted
        
        switch entityStateChange {
            
        case .Inserted:
            
            if let filter = filter {
                
                inserted = inserted.filter(filter)
            }
            
            if inserted.isEmpty {
                
                return nil
            }
            
        case .Updated:
            
            if let filter = filter {
                
                updated = updated.filter(filter)
            }
            
            if updated.isEmpty {
                
                return nil
            }
            
        case .Deleted:
            
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

