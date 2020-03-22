//
//  Message.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?

    init(senderId: String, dic: [String: Any]) {
        self.senderId = senderId
        self.senderName = dic["senderName"] as? String
        self.content = dic["content"] as? String
        self.created = (dic["created"] as? Timestamp)?.dateValue()
    }

    init(created: Date, content: String?, senderName: String?) {
        self.created = created
        self.content = content
        self.senderName = senderName
        self.senderId = nil
    }

    var toDict: [String: Any] {
        return ["content": content ?? "",
                "created": Timestamp(date: created ?? Date()),
                "senderID": senderId ?? "",
                "senderName": senderName ?? ""]
    }

}
