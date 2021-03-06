//
//  ServicesAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

final class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var conversationService: IConversationService = FirebaseService(conversationManager: self.coreAssembly.conversationManager)
    lazy var storageService: IStorageService = StorageService(storageManager: self.coreAssembly.storageManager)
    lazy var pixabayService: IPixabayService = PixabayService(requestSender: self.coreAssembly.requestSender)
}
