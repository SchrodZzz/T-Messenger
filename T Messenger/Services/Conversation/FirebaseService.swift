//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: ConversationService {
    private var channel: Channel?
    private var userName: String?

    private lazy var db = Firestore.firestore()
    private lazy var allChannelsReference = db.collection("channels")
    private lazy var channelReference: CollectionReference = {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()

    init() {
        GCDDataManager().read { model in
            self.userName = model?.name ?? "Unknown user"
        }
        channel = nil
    }

    func fetchChannels(completion: @escaping ([Channel]) -> Void) {
        allChannelsReference.order(by: "lastActivity", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting channels: \(error)")
            }
            if let documents = snapshot?.documents {
                var channels: [Channel] = []
                for doc in documents {
                    channels.append(Channel(identifier: doc.documentID, dic: doc.data()))
                }
                completion(channels)
            }
        }
    }

    func fetchMessages(from channel: Channel?, completion: @escaping ([Message]) -> Void) {
        self.channel = channel
        channelReference.order(by: "created").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting channels: \(error)")
            }
            if let documents = snapshot?.documents {
                var messages: [Message] = []
                for doc in documents {
                    messages.append(Message(senderId: doc.documentID, dic: doc.data()))
                }
                completion(messages)
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
        return userName
    }

}
