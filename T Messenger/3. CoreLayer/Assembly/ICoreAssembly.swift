//
//  ICoreAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

protocol ICoreAssembly {
    var conversationManager: IConversationManager { get }
    var storageManager: IStorageManager { get }
    var requestSender: IRequestSender { get }
}
