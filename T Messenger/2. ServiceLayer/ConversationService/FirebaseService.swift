//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Firebase

class FirebaseService: IConversationService {

    private let conversationManager: IConversationManager

    init(conversationManager: IConversationManager) {
        self.conversationManager = conversationManager
    }

    func fetchChannels(completion: @escaping (Error?, DocumentChange?) -> Void) {
        conversationManager.fetchChannels { error, changes in
            if let error = error {
                completion(error, nil)
                return
            }
            if let changes = changes {
                for change in changes {
                    completion(nil, change)
                }
            }
        }
    }

    func fetchMessages(fromChannel id: String, completion: @escaping (Error?, [DocumentChange]?) -> Void) {
        conversationManager.fetchMessages(fromChannel: id) { error, changes in
            if let error = error {
                completion(error, nil)
                return
            }
            if let changes = changes {
                completion(nil, changes)
            }
        }
    }

    func createChannel(named name: String, firstMessage: MessageStruct) {
        let id = conversationManager.addChannel(named: name)
        conversationManager.send(message: firstMessage, toChannel: id)
    }

    func removeChannel(id: String?, completion: ((Error) -> Void)?) {
        conversationManager.removeChannel(id: id, completion: completion)
    }

    func send(message: MessageStruct, toChannel id: String?) {
        conversationManager.send(message: message, toChannel: id)
    }
}
