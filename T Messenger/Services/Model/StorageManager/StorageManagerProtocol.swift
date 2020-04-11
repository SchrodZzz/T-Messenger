//
//  StorageManagerProtocol.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func loadProfile(completion: @escaping (User?) -> Void)
    func save(completion: ((Error?) -> Void)?)
    
    func getFetchedResultsController() -> NSFetchedResultsController<Channel>
    func getFetchedResultsController(from channel: ChannelStruct?) -> NSFetchedResultsController<Message>
    
    func fetchChannels(completion: @escaping (Error?) -> Void)
    func fetchMessages(from channel: ChannelStruct?, completion: @escaping (Error?) -> Void)
}
