## MHCoreDataKit

[![Build Status](https://app.bitrise.io/app/f506822a8d2fd46f/status.svg?token=PBc8UeNP6lxA2Iso8gC64w)](https://app.bitrise.io/app/f506822a8d2fd46f)

**MHCoreDataKit** is a collection of useful tools that, which goal is to makes developer's life easier by reducing the complexity of using **CoreData**.

## Highlights

- provides single Core Data stack abstraction
- provides default Core Data stack implementation
- type friendly and convenient Entity observing
- type friendly, convenient and no boilerplate NSFetchRequest setup and executing
- convenient NSManagedObject initialization
- focus on just model name and optionally configuation name - forget about managing store and model URLs

## Contents

The library provides utilities and extensions of CoreData classes that are more convenient to use and reduce some boilerplate code.

- [Core Sata stack protocol oriented abstraction and common interface](#core-sata-stack-protocol-oriented-abstraction-and-common-interface)
- [How to use `DefaultCoreDataStack`](#how-to-use-defaultcoredatastack)
- [Convenient entity observing](#convenient-entity-observing)
- [Core Data extensions](#core-data-extensions)
	- [`NSManagedObject`](#nsmanagedobject)
	- [`NSFetchRequest`](#nsfetchrequest)
	- [`NSManagedObjectModel`](#nsmanagedobjectmodel)
	- [`NSPersistentStore`](#nspersistentstore)
	- [`NSPersistentStoreCoordinator`](#nspersistentstorecoordinator)

## Details

### Core Sata stack protocol oriented abstraction and common interface

You prabably already have heard of [Core Data stack](https://developer.apple.com/library/content/documentation/DataManagement/Devpedia-CoreData/coreDataStack.html). And you probably already know how inconvenient it is to setup and use. On top of it, you've probably already been using a custom one and you are wondering whenever you should use [the newly introduced in iOS 10 native one](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html) or it's too inconvenient to migrate to it.

Well, what actually is core data stack in it its simplest form - its something that at the end will provide an isntance of `NSManagedObjectContext` for your code to work with where it's implementation details are not important.

For your convenience working with Core Data stacks, you can use the following tools:

- `CoreDataStack` - this a protocol that defines the very basic type of a Core Data stack. By itself it provides convenience methods to perform tasks and add persistent store to its context. You can use for abstraction in your application and implement it for any stack you'd like.
- `CoreDataStackInitializationProtocol` - a protocol that defines initialization of a Core Data stack and provides default convenient implementation of initialization by automatic model lookup.
- extension of `NSPersistentContainer` that implements ***CoreDataStack*** - if your application is using ***CoreDataStack*** rather than concrete implementation, you can later always switch to ***NSPersistentContainer*** or other custom implementation without the need to change your application code.
- `DefaultCoreDataStack` - this is a default, very basic, implementation of a ***CoreDataStack*** and ***CoreDataStackInitializationProtocol***
- `AnyCoreDataStack` - this is type eraser of ***CoreDataStack***, used in the implementation of ***NSPersistentContainer***

### How to use `DefaultCoreDataStack`

If you are just looking for a simple implementation of a Core Data stack - you can use the default implementation as following:

```
let modelName = "<#T##The name of your Core Data model#>"
let modelBundle = Bundle.main
let storeType = NSSQLiteStoreType
let options: [AnyHashable: Any] = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    
let stack = try DefaultCoreDataStack(modelName: modelName, modelBundle: modelBundle, storeType: storeType, configurationName: nil, storeName: nil, options: options)
let mainContext = stack.context
``` 

What this code will do:

- it will look for a model with the provided name in your application main bundle
- if the model is found - it will load it, otherwise and exception will be thrown
- then it will initialize an instance of `NSPersistentStoreCoordinator` and add an SQLite store with the provided options.
- at the end, an instance of NSManagedContext will be created which you can access trough the `context` property of the stack.

You can always tweak the input arguments or use one of the other constructors of `CoreDataStackInitializationProtocol`

The store location is generated based on the `NSPersistentStore` extension.

### Convenient entity observing

If you've heard of managed obejct notifications

- [NSManagedObjectContextWillSave](https://developer.apple.com/documentation/foundation/nsnotification.name/1506816-nsmanagedobjectcontextwillsave)
- [NSManagedObjectContextDidSave](https://developer.apple.com/documentation/foundation/nsnotification.name/1506380-nsmanagedobjectcontextdidsave)
- [NSManagedObjectContextDidChange](https://developer.apple.com/documentation/foundation/nsnotification.name/1506884-nsmanagedobjectcontextobjectsdid)

You might already know how inconvenient to use they are. Don't even mention using them from Swift.

Due to the lack of convenience and strong typing of using the managed object notifications - the `EntityObserver` was born.

Its goal is:

- to be convenient
- to handle observation details
- to deliver type fiendly objects to you 

How to use it:

```
let observer = EntityObserver<<#T##Entity#>>()
observer.observeChanges { (inserted, updated, deleted) in
    
    //handle any changes
}
```

Or you can receive notifications only for a given type of change:

```
let observer = EntityObserver<<#T##Entity#>>()
observer.observeChanges(for: .inserted) { (inserted, _, _) in
    
    //handle inserted objects
}
```

Or do something with objects that are about to be deleted:

```
let observer = EntityObserver<<#T##Entity#>>()
observer.observeChanges(upon: .willSave, for: .deleted) { (_, _, deleted) in
    
    //handle objects are are about to be deleted
}
```

You can always play around with the arguments in order to suit your needs.

### Core Data extensions

How often you've been struggling with CoreData's unclear or unconvenient APIs like, making fetch requests by writing the same string based predicates over and over again, like looking for model and intantiating it, like deciding where to put stores and how to manage them.

For your aid with such problems, here comes the following extensions on existing CoreData classes:

#### `NSManagedObject`

If you've worked with core data, you probably know how inconvenient is to make an instance of ***NSManagedObject***. That's no more, thanks to the automatic entity lookup, you can make instances just like this:

- `convenience init(context: NSManagedObjectContext, insert: Bool) throws`
- `convenience init(insertingInto context: NSManagedObjectContext) throws`

Creating ***NSFetchRequest*** was supposed to be easy, but turns out to be inconvenient and not type friendly for Swift. Apple addressed this by introducing

- `class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult>`

However this only works with iOS 10+.
So for your convenience and alternative, you can use

- `public static func makeFetchRequest() -> NSFetchRequest<Self>` 

on any NSManagedObject subclass you have on iOS 8+.

Creating entity observers is even simpler:

- `public static func makeObserver(with context: NSManagedObjectContext? = nil) -> EntityObserver<Self>`

#### `NSFetchRequest`

You will find various convenient extension methods on NSFetchRequest that will help you configure it quickly for your most common needs.

```
//Assuming that you have NSManagedObject subclass named Person

//fetching all persons
let context: NSManagedObjectContext = //...
let allPersons: [Person] = try Person.makeFetchRequest().fetchingAll().execute(with: context)

//fetching persons with name John
let johnPersons = try Person.makeFetchRequest().fetchingBy(key: "name", value: "John").execute(with: context)

//fetching persons with name John from Canada
let result = try Person.makeFetchRequest().fetchingBy(pairs: ["name": "John", "country": "Canada"]).execute(with: context)

//fetching persons that have Senior or Lead job title, sorted by years of experience
//note that we are calling `fetchingFor` rather than `fetchingBy`
let experiencedPersons = try Person.makeFetchRequest().fetchingFor(key: "jobTitle", values: ["Senior", "Lead"]).sortedBy(key: "yearsOfExperience").execute(with: context)
```

**Keep in mind** that each of these configuration methods, generated a new predicate for the fetch request, so chaning them will result to applying the last one called. However you can always apply a custom predicate by using `configured(with: <#T##NSPredicate?#>)` function.

#### `NSManagedObjectModel`

Creating an instance by looking up the model by name.

- `convenience init?(name: String, bundle: Bundle = .main)`

#### `NSPersistentStore`

You will find extensions for convenient managing store directories.

- **`defaultDirectory`** - this is the default directory where all stores will be placed. You can always change it at the entry point of your application or keep the default value which places stores into ***Library/Application Support*** directory.
- **`commonDirectory()`** - this creates a common stores directory within the default one where the stores are placed. Default to ***Library/Application Support/CoreDataStores/*** 
- **`directory(forStoreName:configurationName:in:)`**
This method returns a persistent store directory URL based store name and optional configuration name. Using the default values will produce the following URL - ***Library/Application Support/CoreDataStores/Default/`<storeName>`/***
- **`url(forStoreName:configurationName:withExtension:in:)`**
This method returns a persistent store URL based on input arguments and/or default values. Using the default values will produce the following URL - ***Library/Application Support/CoreDataStores/Default/`<storeName>`/`<storeName>`.sqlite***
- **`deleteAll()`** - by default this will delete the following folder - ***Library/Application Support/CoreDataStores/***
- **`detele(forStoreName:configurationName:in:)`**
This method deteles a persistent store directory based on store name and optional configuration name. Using the default values will delete the following URL - ***Library/Application Support/CoreDataStores/Default/`<storeName>`/***

#### `NSPersistentStoreCoordinator`

Extensions on ***NSPersistentStoreCoordinator*** provides convenience methods to add, remove and retrieve stores based on store name and configuration name, managed by NSPersistentStore extensions rather than direct URLs. 

- **`addPersistentStore(ofType:configurationName:storeName:options:)`** - Adds a persistent store to a location based on its name.
- **`persistentStore(forName:configurationName:)`** - Lookup and returns a persistent store based on its name.
- **`removePersistentStore(forName:configurationName:)`** - Removes a persistent store based on its name.
- **`removePersistentStores(forConfigurationName:)`** - Removes all persistent stores matching a given configuration name.
- **`removeAllPersistentStores()`** - Removes all presistent sotres.
