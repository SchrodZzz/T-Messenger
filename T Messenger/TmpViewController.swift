//
//  TmpViewController.swift
//  T Messenger
//
//  Created by Suspect on 18.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//
//
//import UIKit
//import Firebase
//
//class TmpViewController: UIViewController {
//
//    private lazy var db = Firestore.firestore()
//    private lazy var reference: CollectionReference = {
//        guard let channelIdentifier = channel?.identifier else { fatalError() }
//        return db.collection("channels").document(channelIdentifier).collection("messages")
//    }()
//
//    private lazy var reference2 = db.collection("channels")
//
//    var channel: Channel? = Channel(identifier: "J3ZVwIGqRlS40iSrb1sS", name: "Fintech", lastMessage: "Алехин Александр")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let newMessage = Message(content: "Ившин Андрей 111", created: Date(), senderId: "schrod", senderName: "Ившин Андрей")
//
//        reference.addDocument(data: newMessage.toDict)
//
//        reference2.addSnapshotListener { snapshot, _ in
//            for i in 0 ..< 2 {
//                print(snapshot?.documents[i].documentID)
//            }
//        }
//    }
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//struct Channel {
//    let identifier: String
//    let name: String
//    let lastMessage: String
//}
//
//struct Message {
//    let content: String
//    let created: Date
//    let senderId: String
//    let senderName: String
//
//}
//
//extension Message {
//    var toDict: [String: Any] {
//        return ["content": content,
//                "created": Timestamp(date: created),
//                "senderID": senderId,
//                "senderName": senderName]
//    }
//}
