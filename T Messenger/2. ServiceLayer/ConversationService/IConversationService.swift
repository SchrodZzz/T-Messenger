//
//  IConversationService.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Firebase

protocol IConversationService {
    func fetchChannels(completion: @escaping (Error?, DocumentChange?) -> Void)
    func fetchMessages(fromChannel id: String, completion: @escaping (Error?, [DocumentChange]?) -> Void)

    func createChannel(named name: String, firstMessage: MessageStruct)
    func removeChannel(id: String?, completion: ((Error) -> Void)?)

    func send(message: MessageStruct, toChannel id: String?)
}
