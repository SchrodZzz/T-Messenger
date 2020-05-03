//
//  ChannelSorter.swift
//  T Messenger
//
//  Created by Suspect on 03.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

enum ChannelState {
    case active, inactive
}

protocol IChannelSorter {
    func sort(_ channels: [Channel]) -> [ChannelState: [Channel]]
}

final class ChannelSorter: IChannelSorter {
    func sort(_ channels: [Channel]) -> [ChannelState: [Channel]] {
        var sortedChannels: [ChannelState: [Channel]] = [.active: [], .inactive: []]
        let sorted = channels.sorted { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }
        sorted.forEach { channel in
            sortedChannels[channel.isActive ? .active : .inactive]?.append(channel)
        }
        return sortedChannels
    }
}
