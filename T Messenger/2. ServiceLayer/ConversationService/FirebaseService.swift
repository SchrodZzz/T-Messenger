//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Firebase

class FirebaseService: IConversationService {

    private let networkManager: INetworkManager

    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
    }

    func fetchChannels(completion: @escaping (Error?, DocumentChange?) -> Void) {
        networkManager.fetchChannels { error, changes in
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

    func fetchMessages(fromChannel id: String, completion: @escaping (Error?, DocumentChange?) -> Void) {
        networkManager.fetchMessages(fromChannel: id) { error, changes in
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

    func createChannel(named name: String, firstMessage: MessageStruct) {
        let id = networkManager.addChannel(named: name)
        networkManager.send(message: firstMessage, toChannel: id)
    }

    func removeChannel(id: String?) {
        networkManager.removeChannel(id: id)
    }

    func send(message: MessageStruct, toChannel id: String?) {
        networkManager.send(message: message, toChannel: id)
    }
}
