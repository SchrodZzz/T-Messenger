//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase

#warning("TODO: check fetching on two devices")

class FirebaseService: ConversationService {
    private var channel: Channel?

    private lazy var db = Firestore.firestore()
    private lazy var allChannelsReference = db.collection("channels")
    private lazy var channelReference: CollectionReference = {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()

    func fetchChannels(completion: @escaping ([Channel]) -> Void) {
        allChannelsReference.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting channels: \(error)")
            }
            if let documents = snapshot?.documents {
                var channels: [Channel] = []
                for doc in documents {
                    channels.append(Channel(identifier: doc.documentID, dic: doc.data()))
                }
                completion(channels.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }))
            }
        }
    }

    #warning("TODO: fix sort for same minute messages")
    func fetchMessages(from channel: Channel?, completion: @escaping ([Message]) -> Void) {
        self.channel = channel
        channelReference.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting channels: \(error)")
            }
            if let documents = snapshot?.documents {
                var messages: [Message] = []
                for doc in documents {
                    messages.append(Message(senderId: doc.documentID, dic: doc.data()))
                }
                completion(messages.sorted(by: { $0.created ?? Date() < $1.created ?? Date() }))
            }
        }
    }

    func send(message: Message, to channel: Channel?) {
        self.channel = channel
        channelReference.addDocument(data: message.toDict)
    }

    func create(channel: Channel) {
        allChannelsReference.addDocument(data: channel.nameToDic)
    }

    func getUserName() -> String? {
        return "Andrey"
    }

}
