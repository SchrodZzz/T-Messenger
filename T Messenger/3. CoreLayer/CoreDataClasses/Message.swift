//
//  Message.swift
//  T Messenger
//
//  Created by Suspect on 02.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var senderId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var channel: Channel?
    
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
