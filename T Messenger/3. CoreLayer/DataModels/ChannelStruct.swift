//
//  ChannelStruct.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase
import CoreData

struct ChannelStruct {
    let identifier: String?
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?

    init(identifier: String, dic: [String: Any]) {
        self.identifier = identifier
        self.name = dic["name"] as? String
        self.lastMessage = dic["lastMessage"] as? String
        self.lastActivity = (dic["lastActivity"] as? Timestamp)?.dateValue()
    }

    init(channel: ChannelStruct?, identifier: String?) {
        self.name = channel?.name
        self.identifier = identifier
        self.lastMessage = channel?.lastMessage
        self.lastActivity = channel?.lastActivity
    }

    init(_ channel: Channel) {
        self.name = channel.name
        self.identifier = channel.identifier
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
}
