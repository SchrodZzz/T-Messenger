//
//  ConversationService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationService {

    func fetchChannels(in context: NSManagedObjectContext, completion: @escaping (Error?) -> Void)
    func fetchMessages(in context: NSManagedObjectContext, from channel: ChannelStruct?, completion: @escaping (Error?) -> Void)

    func send(message: MessageStruct, to channel: ChannelStruct?)
    func create(channel: ChannelStruct)
    func removeChannel(with id: String?)

    func getUserName() -> String?
}
