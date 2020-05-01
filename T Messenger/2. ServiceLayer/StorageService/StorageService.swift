//
//  StorageService.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

class StorageService: IStorageService {

    private let storageManager: IStorageManager

    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }

    func save(completion: ((Error?) -> Void)?) {
        storageManager.save(completion: completion)
    }

    func addMessage(channelId: String, messageId: String, data: [String: Any]) {
        let message = Message.insert(in: storageManager.saveContext, MessageStruct(identifier: messageId, from: data))
        if let message = message, let channel = Channel.get(in: storageManager.saveContext, with:
                NSPredicate(format: "identifier == %@", channelId)) as? Channel {
            channel.addToMessage(message)
        }
    }

    func addChannel(id: String, data: [String: Any]) {
        let tmp = ChannelStruct(identifier: id, dic: data)
        let channel = Channel.insert(in: storageManager.saveContext, tmp)
        User.getProfile(in: storageManager.saveContext) { user in
            if let channel = channel {
                user?.addToChannel(channel)
            }
        }
    }

    func updateChannel(id: String, data: [String: Any]) {
        guard let channel = Channel.get(in: storageManager.saveContext, with: NSPredicate(format: "identifier == %@", id)) else { return }
        let tmp = ChannelStruct(identifier: id, dic: data)
        channel.setValue(tmp.lastActivity, forKey: "lastActivity")
        channel.setValue(tmp.lastMessage, forKey: "lastMessage")
        channel.setValue(tmp.name, forKey: "name")
    }

    func removeChannel(id: String) {
        guard let channel = Channel.get(in: storageManager.saveContext, with: NSPredicate(format: "identifier == %@", id)) else { return }
        if let channel = channel as? Channel, let user = storageManager.getUser() {
            user.removeFromChannel(channel)
        }
        if let messages = Message.getAll(in: storageManager.saveContext, with: NSPredicate(format: "channel.identifier == %@", id)) {
            for message in messages {
                storageManager.saveContext.delete(message)
            }
        }
        storageManager.saveContext.delete(channel)
    }

    func getFetchedResultsController() -> NSFetchedResultsController<Channel> {
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storageManager.mainContext,
                                                                  sectionNameKeyPath: "isActive", cacheName: nil)
        return fetchedResultsController
    }

    func getFetchedResultsController(fromChannel name: String?) -> NSFetchedResultsController<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "channel.name == %@", name ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storageManager.mainContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    func getUser() -> User? {
        return storageManager.getUser()
    }

    func getUserName() -> String? {
        return storageManager.getUser()?.name ?? "Unknown User"
    }

}
