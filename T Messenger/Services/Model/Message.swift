//
//  Message.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase
import CoreData

struct MessageStruct {
    let identifier: String?
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?

    init(identifier: String, from dic: [String: Any]) {
        self.senderId = dic["senderID"] as? String
        self.senderName = dic["senderName"] as? String
        self.content = dic["content"] as? String
        self.created = (dic["created"] as? Timestamp)?.dateValue()
        self.identifier = identifier
    }

    init(content: String?, senderName: String?) {
        self.created = Date()
        self.content = content
        self.senderName = senderName
        self.senderId = UIDevice.current.identifierForVendor?.uuidString
        self.identifier = nil
    }

    var toDict: [String: Any] {
        return ["content": content ?? "",
                "created": Timestamp(date: created ?? Date()),
                "senderID": senderId ?? "",
                "senderName": senderName ?? ""]
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
}
