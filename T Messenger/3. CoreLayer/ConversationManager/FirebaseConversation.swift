//
//  FirebaseService.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Firebase

class FirebaseConversation: IConversationManager {
    private var channelIdentifier: String?

    private lazy var db = Firestore.firestore()
    private lazy var allChannelsReference = db.collection("channels")
    private var channelReference: CollectionReference {
        guard let channelIdentifier = channelIdentifier else { fatalError("channelIdentifier is nil") }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }

    func fetchChannels(completion: @escaping (Error?, [DocumentChange]?) -> Void) {
        allChannelsReference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error, nil)
                return
            }
            if let changes = snapshot?.documentChanges {
                completion(nil, changes)
                return
            }
        }
    }

    func fetchMessages(fromChannel id: String?, completion: @escaping (Error?, [DocumentChange]?) -> Void) {
        channelIdentifier = id
        channelReference.order(by: "created").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error, nil)
                return
            }
            if let changes = snapshot?.documentChanges.filter({ $0.type == .added }) {
                completion(nil, changes)
                return
            }
        }
    }
    
    func addChannel(named name: String) -> String {
        let id = allChannelsReference.addDocument(data: ["name": name]).documentID
        return id
    }

    func send(message: MessageStruct, toChannel id: String?) {
        channelIdentifier = id
        channelReference.addDocument(data: message.toDict)
    }

    func removeChannel(id: String?, completion: ((Error) -> Void)?) {
        allChannelsReference.document(id ?? "").delete { err in
            if let err = err {
                completion?(err)
            }
        }
    }

}
