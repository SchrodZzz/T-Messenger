//
//  StorageManagerProtocol.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

protocol IStorageManager {

    var saveContext: NSManagedObjectContext { get }

    func save(completion: ((Error?) -> Void)?)

    func getUser() -> User?

}
