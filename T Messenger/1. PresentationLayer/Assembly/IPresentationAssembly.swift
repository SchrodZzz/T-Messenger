//
//  IPresentationAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

protocol IPresentationAssembly {
    
    func profileViewController() -> ProfileViewController
    
    func allChannelsViewController() -> AllChannelsViewController
    
    func channelViewController() -> ChannelViewController
    
    func avatarsViewController() -> AvatarsViewController
}
