//
//  User.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

#warning("TODO: remove auto-generation")
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

extension Message {
    static func getRequest() -> NSFetchRequest<Message>? {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    static func insert(in context: NSManagedObjectContext, _ message: MessageStruct)
        -> Message? {
            guard Message.get(in: context, with: NSPredicate(format: "identifier == %@", message.identifier ?? "")) == nil else { return nil }
            guard let msg = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else { return nil }
            msg.senderId = message.senderId
            msg.senderName = message.senderName
            msg.content = message.content
            msg.created = message.created
            msg.identifier = message.identifier
            return msg
    }

    static func get(in context: NSManagedObjectContext, with predicate: NSPredicate) -> NSManagedObject? {
        guard let fetchRequest = getRequest() else { return nil }
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch message: \(error)")
            return(nil)
        }
    }
    
    static func getAll(in context: NSManagedObjectContext, with predicate: NSPredicate) -> [NSManagedObject]? {
        guard let fetchRequest = getRequest() else { return nil }
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch message: \(error)")
            return(nil)
        }
    }
}

extension Channel {
    static func getRequest() -> NSFetchRequest<Channel>? {
        return NSFetchRequest<Channel>(entityName: "Channel")
    }

    static func insert(in context: NSManagedObjectContext, _ channel: ChannelStruct) -> Channel? {
        guard Channel.get(in: context, with: NSPredicate(format: "identifier == %@", channel.identifier ?? "")) == nil else { return  nil }
        guard let chnl = NSEntityDescription.insertNewObject(forEntityName: "Channel", into: context) as? Channel else { return nil }
        chnl.name = channel.name
        chnl.identifier = channel.identifier
        chnl.lastMessage = channel.lastMessage
        chnl.lastActivity = channel.lastActivity
        return chnl
    }

    static func get(in context: NSManagedObjectContext, with predicate: NSPredicate) -> NSManagedObject? {
        guard let fetchRequest = getRequest() else { return nil }
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch channel: \(error)")
            return(nil)
        }
    }

    @objc dynamic var isActive: Bool {
        if let lastActivity = self.lastActivity {
            return Date().minutes(sinceDate: lastActivity) < 10
        }
        return false
    }
}
