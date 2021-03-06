//
//  Message.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase

struct MessageStruct {
    let identifier: String?
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?

    init(identifier: String, from dic: [String: Any]) {
        self.senderId = dic["senderID"] as? String
        self.senderName = dic["senderName"] as? String
        self.content = dic["content"] as? String
        self.created = (dic["created"] as? Timestamp)?.dateValue()
        self.identifier = identifier
    }

    init(content: String?, senderName: String?) {
        self.created = Date()
        self.content = content
        self.senderName = senderName
        self.senderId = UIDevice.current.identifierForVendor?.uuidString
        self.identifier = nil
    }

    var toDict: [String: Any] {
        return ["content": content ?? "",
                "created": Timestamp(date: created ?? Date()),
                "senderID": senderId ?? "",
                "senderName": senderName ?? ""]
    }

}
