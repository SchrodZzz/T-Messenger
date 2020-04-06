//
//  StorageManager.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

class StorageManager: StorageManagerProtocol {
    
    static var user: User?

    private let coreDataStack = CoreDataStack.shared
    private let conversationService: ConversationService = FirebaseService()
    
    init() {
        loadProfile { profile in
            StorageManager.user = profile
        }
    }

    func loadProfile(completion: @escaping (User?) -> Void) {
        User.getProfile(in: coreDataStack.mainContext) { (profile) in
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }

    func save(completion: ((Error?) -> Void)?) {
        coreDataStack.performSave(context: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }

    func getFetchedResultsController() -> NSFetchedResultsController<Channel> {
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.mainContext,
                                                                  sectionNameKeyPath: "isActive", cacheName: nil)
        return fetchedResultsController
    }

    func getFetchedResultsController(from channel: ChannelStruct?) -> NSFetchedResultsController<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "channel.name == %@", channel?.name ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.mainContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func fetchChannels(completion: @escaping (Error?) -> Void) {
        conversationService.fetchChannels(in: coreDataStack.saveContext) { [weak self] error in
            if error == nil {
                self?.save(completion: nil)
            }
            completion(error)
        }
    }
    
    func fetchMessages(from channel: ChannelStruct?, completion: @escaping (Error?) -> Void) {
        conversationService.fetchMessages(in: coreDataStack.saveContext, from: channel) { [weak self] error in
            if error == nil {
                self?.save(completion: nil)
            }
            completion(error)
        }
    }
    
    func add(channel: Channel, to user: User) {
        
    }
    
    func add(message: Message, to channel: Channel) {
        
    }
}
