//
//  EntityObserver.swift
//  MHCoreDataKit
//
//  Created by Milen Halachev on 3/27/16.
//  Copyright © 2016 Milen Halachev. All rights reserved.
//

import Foundation
import CoreData

open class EntityObserver<E:NSManagedObject> {
    
    private let entityType: E.Type
    private let context: NSManagedObjectContext?
    private let queue: OperationQueue = OperationQueue()
    
    public init(entityType: E.Type, context: NSManagedObjectContext? = nil) {
        
        self.entityType = entityType
        self.context = context
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult
    open func observeChangesFor(contextState: ContextState = .default, entityState: EntityState = .default, filter: ((_ entity: E) -> Bool)? = nil, changes: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E> {
        
        NotificationCenter.default.addObserver(forName: contextState.notificationName, object: self.context, queue: self.queue) { [weak self] (notification) -> Void in
            
            guard let weakSelf = self else {
                
                return
            }
            
            let (inserted, updated, deleted) = weakSelf.expandNotification(notification, entityStateChange: entityState)
            
            if let (inserted, updated, deleted) = weakSelf.match(inserted: inserted, updated: updated, deleted: deleted, entityState: entityState, filter: filter) {
                
                guard let context = notification.object as? NSManagedObjectContext ?? weakSelf.context else {
                    
                    changes(inserted, updated, deleted)
                    
                    return
                }
                
                context.perform({ () -> Void in
                    
                    changes(inserted, updated, deleted)
                })
            }
        }
        
        return self
    }
    
    //this is convenienice overload that provides more autocomplete options
    @discardableResult
    open func observeChangesFor(_ entityState: EntityState, filter: ((_ entity: E) -> Bool)? = nil, changes: @escaping (_ inserted: [E], _ updated: [E], _ deleted: [E]) -> Void) -> EntityObserver<E> {
        
        return self.observeChangesFor(entityState: entityState, filter: filter, changes: changes)
    }
    
    private func expandNotification(_ notification: Notification, entityStateChange: EntityState) -> (inserted: [E], updated: [E], deleted: [E]) {

        func transform(_ object: AnyObject?) -> [E] {
            
            let collection = object as? Set<NSManagedObject>
            let filtered = collection?.filter({ $0 is E }) as? [E]
            
            return filtered ?? []
        }
        
        var inserted = [E]()
        var updated = [E]()
        var deleted = [E]()
        
        switch entityStateChange {
            
        case .inserted: inserted = transform(notification.userInfo?[NSInsertedObjectsKey] as AnyObject?)
        case .updated: updated = transform(notification.userInfo?[NSUpdatedObjectsKey] as AnyObject?)
        case .deleted: deleted = transform(notification.userInfo?[NSDeletedObjectsKey] as AnyObject?)
            
        default:
            inserted = transform(notification.userInfo?[NSInsertedObjectsKey] as AnyObject?)
            updated = transform(notification.userInfo?[NSUpdatedObjectsKey] as AnyObject?)
            deleted = transform(notification.userInfo?[NSDeletedObjectsKey] as AnyObject?)
        }
        
        return(inserted, updated, deleted)
    }
    
    private func match(inserted: [E], updated: [E], deleted: [E], entityState: EntityState, filter: ((_ entity: E) -> Bool)?) -> (inserted: [E], updated: [E], deleted: [E])? {
        
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
