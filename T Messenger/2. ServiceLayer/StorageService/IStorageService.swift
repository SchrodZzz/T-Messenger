//
//  IStorageService.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

protocol IStorageService {
    
    func save(completion: ((Error?) -> Void)?)

    func addMessage(channelId: String, messageId: String, data: [String: Any])

    func addChannel(id: String, data: [String: Any])
    func updateChannel(id: String, data: [String: Any])
    func removeChannel(id: String)

    func getFetchedResultsController() -> NSFetchedResultsController<Channel>
    func getFetchedResultsController(fromChannel name: String?) -> NSFetchedResultsController<Message>

    func getUser() -> User?
    func getUserName() -> String?

}
