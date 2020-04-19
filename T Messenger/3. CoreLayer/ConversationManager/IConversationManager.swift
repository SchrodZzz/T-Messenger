//
//  ConversationService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Firebase

protocol IConversationManager {

    #warning("TODO: think about removing Firebase specific data from here")
    func fetchChannels(completion: @escaping (Error?, [DocumentChange]?) -> Void)
    func fetchMessages(fromChannel id: String?, completion: @escaping (Error?, [DocumentChange]?) -> Void)
    
    func addChannel(named name: String) -> String

    func send(message: MessageStruct, toChannel id: String?)
    func removeChannel(id: String?)
}
