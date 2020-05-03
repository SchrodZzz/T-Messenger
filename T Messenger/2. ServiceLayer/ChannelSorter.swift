//
//  ChannelSorter.swift
//  T Messenger
//
//  Created by Suspect on 03.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

enum MessageState {
    case active, inactive
}

protocol IChannelSorter {
    func sort(_ channels: [Channel]) -> [MessageState: [Channel]]
}

final class ChannelSorter: IChannelSorter {
    func sort(_ channels: [Channel]) -> [MessageState: [Channel]] {
        var sortedChannels: [MessageState: [Channel]] = [.active: [], .inactive: []]
        sortedChannels[.active] = channels.sorted { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }
        return sortedChannels
    }
}
