//
//  Channel.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase
import CoreData

struct ChannelStruct {
    let identifier: String?
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?

    init(identifier: String, dic: [String: Any]) {
        self.identifier = identifier
        self.name = dic["name"] as? String
        self.lastMessage = dic["lastMessage"] as? String
        self.lastActivity = (dic["lastActivity"] as? Timestamp)?.dateValue()
    }

    init(name: String) {
        self.name = name
        self.identifier = nil
        self.lastMessage = nil
        self.lastActivity = nil
    }

    init(channel: ChannelStruct?, identifier: String?) {
        self.name = channel?.name
        self.identifier = identifier
        self.lastMessage = channel?.lastMessage
        self.lastActivity = channel?.lastActivity
    }

    init(_ channel: Channel) {
        self.name = channel.name
        self.identifier = channel.identifier
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }

    var nameToDic: [String: Any] {
        return ["name": name ?? ""]
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

extension Date {
    func minutes(sinceDate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute ?? 0
    }
}
