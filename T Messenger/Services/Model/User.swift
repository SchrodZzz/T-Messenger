//
//  User.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension User {
    static func getRequest() -> NSFetchRequest<User>? {
        return NSFetchRequest<User>(entityName: "User")
    }

    static func insertProfile(in context: NSManagedObjectContext) -> User? {
        guard let profile = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else { return nil }
        profile.name = UIDevice.current.name
        profile.avatar = UIImage(named: "Placeholder")?.pngData()
        profile.aboutMe = "No description was provided"
        return profile
    }

    static func getProfile(in context: NSManagedObjectContext, completion: @escaping (User?) -> Void) {
        context.perform {
            guard let request = User.getRequest() else { return }
            var profile: User?
            do {
                let results = try context.fetch(request)
                profile = results.first ?? User.insertProfile(in: context)
                completion(profile)
            } catch {
                print("Failed to fetch profile: \(error)")
                completion(nil)
            }
        }
    }
    
}
