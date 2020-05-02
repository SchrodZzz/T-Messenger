//
//  Channel.swift
//  T Messenger
//
//  Created by Suspect on 02.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

@objc(Channel)
public class Channel: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Channel> {
        return NSFetchRequest<Channel>(entityName: "Channel")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String?
    @NSManaged public var message: NSSet?
    @NSManaged public var user: User?
    
    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: Message)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: Message)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)
    
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
