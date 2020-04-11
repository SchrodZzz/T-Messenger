//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseService: ConversationService {
    private var channel: ChannelStruct?

    private lazy var db = Firestore.firestore()
    private lazy var allChannelsReference = db.collection("channels")
    private var channelReference: CollectionReference {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }

    func fetchChannels(in context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {
        allChannelsReference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            if let changes = snapshot?.documentChanges {
                for change in changes {
                    let doc = change.document
                    switch change.type {
                    case .added:
                        let channel = Channel.insert(in: context, ChannelStruct(identifier: doc.documentID, dic: doc.data()))
                        User.getProfile(in: context) { profile in
                            if let channel = channel {
                                profile?.addToChannel(channel)
                            }
                        }
                    case .modified:
                        guard let channel = Channel.get(in: context, with: NSPredicate(format: "identifier == %@", doc.documentID)) else { return }
                        let tmp = ChannelStruct(identifier: doc.documentID, dic: doc.data())
                        channel.setValue(tmp.lastActivity, forKey: "lastActivity")
                        channel.setValue(tmp.lastMessage, forKey: "lastMessage")
                        channel.setValue(tmp.name, forKey: "name")
                    case .removed:
                        guard let channel = Channel.get(in: context, with: NSPredicate(format: "identifier == %@", doc.documentID)) else { return }
                        User.getProfile(in: context) { profile in
                            if let channel = channel as? Channel {
                                profile?.removeFromChannel(channel)
                            }
                        }
                        context.delete(channel)
                    }
                }
                completion(nil)
                return
            }
            completion(nil)
        }
    }

    func fetchMessages(in context: NSManagedObjectContext, from channel: ChannelStruct?, completion: @escaping (Error?) -> Void) {
        guard let channel = channel else { return }
        self.channel = channel
        channelReference.order(by: "created").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            if let changes = snapshot?.documentChanges.filter({ $0.type == .added }) {
                for change in changes {
                    let doc = change.document
                    let message = Message.insert(in: context, MessageStruct(identifier: doc.documentID, from: doc.data()))
                    if let message = message, let channel = Channel.get(in: context, with:
                            NSPredicate(format: "identifier == %@", channel.identifier ?? "")) as? Channel {
                        channel.addToMessage(message)
                    }
                }
                completion(nil)
                return
            }
            completion(nil)
            return
        }
    }

    func send(message: MessageStruct, to channel: ChannelStruct?) {
        self.channel = channel
        channelReference.addDocument(data: message.toDict)
    }

    func create(channel: ChannelStruct) {
        let id = allChannelsReference.addDocument(data: channel.nameToDic).documentID
        let channel = ChannelStruct(channel: channel, identifier: id)
        send(message: MessageStruct(content: "Hello everyone!", senderName: getUserName()), to: channel)
    }

    func removeChannel(with id: String?) {
        allChannelsReference.document(id ?? "").delete { err in
            if let err = err {
                print("Channel deletion error: \(err)")
            }
        }
    }

    func getUserName() -> String? {
        return StorageManager.user?.name ?? "Unknown User"
    }

}
