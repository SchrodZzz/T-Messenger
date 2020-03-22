//
//  Channel.swift
//  T Messenger
//
//  Created by Suspect on 21.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation
import Firebase

struct Channels {
    var inactiveChannels: [Channel]
    var activeChannels: [Channel]

    init(from arr: [Channel]) {
        activeChannels = []
        inactiveChannels = []
        for curChannel in arr {
            if isActive(curChannel) {
                activeChannels.append(curChannel)
            } else {
                inactiveChannels.append(curChannel)
            }
        }
    }

    func getChannels(for section: Int) -> [Channel]? {
        switch section {
        case 0:
            return activeChannels
        case 1:
            return inactiveChannels
        default:
            return nil
        }
    }

    func getTypeHeader(for section: Int) -> String? {
        switch section {
        case 0:
            if !activeChannels.isEmpty {
                return "Active"
            }
        case 1:
            if !inactiveChannels.isEmpty {
                return "Inactive"
            }
        default:
            return "Unknown #\(section + 1)"
        }
        return nil
    }

    private func isActive(_ channel: Channel) -> Bool {
        if let lastActivity = channel.lastActivity {
            return Date().minutes(sinceDate: lastActivity) < 10
        }
        return false
    }
}

struct Channel {
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

    init(name: String) {
        self.name = name
        self.identifier = nil
        self.lastMessage = nil
        self.lastActivity = nil
    }

    var nameToDic: [String: Any] {
        return ["name": name ?? ""]
    }
}

extension Date {
    func minutes(sinceDate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute ?? 0
    }
}
