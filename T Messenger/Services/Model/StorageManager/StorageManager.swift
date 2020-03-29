//
//  StorageManager.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

class StorageManager: StorageManagerProtocol {

    private let coreDataStack = CoreDataStack.shared

    func loadProfile(completion: @escaping (User?) -> Void) {
        User.getProfile(in: coreDataStack.mainContext) { (profile) in
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }

    func saveProfile(completion: @escaping (Error?) -> Void) {
        coreDataStack.performSave(context: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
