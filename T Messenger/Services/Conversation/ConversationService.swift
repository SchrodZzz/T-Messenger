//
//  ConversationService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol ConversationService {

    func fetchChannels(completion: @escaping ([Channel]) -> Void)
    func fetchMessages(from channel: Channel?, completion: @escaping ([Message]) -> Void)

    func send(message: Message, to channel: Channel?)
    func create(channel: Channel)

    func getUserName() -> String?
}
