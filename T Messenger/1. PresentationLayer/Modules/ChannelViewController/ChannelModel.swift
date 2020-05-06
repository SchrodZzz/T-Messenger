//
//  ChannelModel.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

protocol IChannelModel {
    func fetchMessages(fromChannel id: String, completion: () -> Void)

    func sendMessage(content: String?, toChannel id: String?)

    func getFetchedResultsController(fromChannel name: String?) -> NSFetchedResultsController<Message>
}

final class ChannelModel: IChannelModel {

    let storageService: IStorageService
    let conversationService: IConversationService

    init(storageService: IStorageService, conversationService: IConversationService) {
        self.storageService = storageService
        self.conversationService = conversationService
    }

    func fetchMessages(fromChannel id: String, completion: () -> Void) {
        conversationService.fetchMessages(fromChannel: id) { [weak self] error, changes in
            if let error = error {
                print("fetchChannels : \(error.localizedDescription)")
            }
            if let changes = changes {
                for change in changes {
                    let doc = change.document
                    self?.storageService.addMessage(channelId: id, messageId: doc.documentID, data: doc.data())
                }
                self?.storageService.save(completion: nil)
            }

        }
    }

    func sendMessage(content: String?, toChannel id: String?) {
        let message = MessageStruct(content: content, senderName: storageService.getUserName())
        conversationService.send(message: message, toChannel: id)
    }

    func getFetchedResultsController(fromChannel name: String?) -> NSFetchedResultsController<Message> {
        return storageService.getFetchedResultsController(fromChannel: name)
    }

}
