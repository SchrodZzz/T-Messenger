//
//  AllChannelsModel.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import CoreData

protocol IAllChannelsModel {
    
    var delegate: IAllChannelsModelDelegate? { get set }
    
    func fetchChannels()

    func createChannel(named channelName: String)
    func removeChannel(id: String)

    func getFetchedResultsController() -> NSFetchedResultsController<Channel>
}

protocol IAllChannelsModelDelegate: AnyObject {
    func show(error message: String)
}

final class AllChannelsModel: IAllChannelsModel {

    let storageService: IStorageService
    let conversationService: IConversationService
    
    weak var delegate: IAllChannelsModelDelegate?

    init(storageService: IStorageService, conversationService: IConversationService) {
        self.storageService = storageService
        self.conversationService = conversationService
    }

    func fetchChannels() {
        conversationService.fetchChannels { [weak self] error, change in
            if let error = error {
                self?.delegate?.show(error: "fetchChannels : \(error.localizedDescription)")
            }
            if let change = change {
                let doc = change.document
                let docId = doc.documentID
                switch change.type {
                case .added:
                    self?.storageService.addChannel(id: docId, data: doc.data())
                case .modified:
                    self?.storageService.updateChannel(id: docId, data: doc.data())
                case .removed:
                    self?.storageService.removeChannel(id: docId)
                }
            }
            self?.storageService.save(completion: nil)
        }
    }

    func createChannel(named channelName: String) {
        let greetingMessage = MessageStruct(content: "Hello everyone!", senderName: storageService.getUserName())
        conversationService.createChannel(named: channelName, firstMessage: greetingMessage)
    }

    func removeChannel(id: String) {
        conversationService.removeChannel(id: id) { [weak self] error in
            self?.delegate?.show(error: "Channel delete error: \(error.localizedDescription)")
        }
    }

    func getFetchedResultsController() -> NSFetchedResultsController<Channel> {
        return storageService.getFetchedResultsController()
    }
}
