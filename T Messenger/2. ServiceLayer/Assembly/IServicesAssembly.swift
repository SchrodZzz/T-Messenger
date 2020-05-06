//
//  IServicesAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

protocol IServicesAssembly {
    var conversationService: IConversationService { get }
    var storageService: IStorageService { get }
}
