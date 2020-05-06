//
//  PresentationAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

final class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController(model: model)
        return profileVC
    }
    
    private func profileModel() -> IProfileModel {
        return ProfileModel(storageService: serviceAssembly.storageService)
    }
    
    // MARK: - AllChannelsViewController
    
    func allChannelsViewController() -> AllChannelsViewController {
        let model = allChannelsModel()
        let allChannelsVC = AllChannelsViewController(model: model, presentationAssembly: self)
        return allChannelsVC
    }
    
    private func allChannelsModel() -> IAllChannelsModel {
        return AllChannelsModel(storageService: serviceAssembly.storageService, conversationService: serviceAssembly.conversationService)
    }
    
    // MARK: - ProfileViewController
    
    func channelViewController() -> ChannelViewController {
        let model = channelModel()
        let channelVC = ChannelViewController(model: model, presentationAssembly: self)
        return channelVC
    }
    
    private func channelModel() -> IChannelModel {
        return ChannelModel(storageService: serviceAssembly.storageService, conversationService: serviceAssembly.conversationService)
    }
    
}
