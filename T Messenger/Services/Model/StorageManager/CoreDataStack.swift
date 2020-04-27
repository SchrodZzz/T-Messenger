//
//  CoreDataStack.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }

    private var storeURL: URL? {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = directoryURL?.appendingPathComponent("Store.sqlite")
        return url
    }

    private let managedObjectModelName = "Model"

    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd") else { fatalError() }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let managedObjectModel: NSManagedObjectModel = managedObjectModel else { fatalError() }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            print("Error in adding persistent store to coordinator: \(error)")
        }

        return coordinator
    }()

    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()

    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()

    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()

    func performSave(context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                    completion(error)
                }
            }
            
            if let parent = context.parent {
                self.performSave(context: parent, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
}
