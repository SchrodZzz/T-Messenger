//
//  StorageManager.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

class StorageManager: IStorageManager {

    var user: User?

    lazy var mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext
    lazy var saveContext: NSManagedObjectContext = CoreDataStack.shared.saveContext

    private let coreDataStack = CoreDataStack.shared
    private let networkManager: INetworkManager = FirebaseNetwork()

    init() {
        loadProfile { profile in
            self.user = profile
        }
    }

    func getUser() -> User? {
        return user
    }

    func save(completion: ((Error?) -> Void)?) {
        coreDataStack.performSave(context: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }

    private func loadProfile(completion: @escaping (User?) -> Void) {
        User.getProfile(in: coreDataStack.mainContext) { (profile) in
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
}
