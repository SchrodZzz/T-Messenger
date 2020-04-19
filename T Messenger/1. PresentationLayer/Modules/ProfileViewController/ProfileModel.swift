//
//  ProfileModel.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol IProfileModel {
    func loadProfile(completion: (User?) -> Void)
    func save(completion: ((Error?) -> Void)?)
}

class ProfileModel: IProfileModel {
    let storageService: IStorageService
    
    init(storageService: IStorageService) {
        self.storageService = storageService
    }
    
    func loadProfile(completion: (User?) -> Void) {
        completion(storageService.getUser())
    }
    
    func save(completion: ((Error?) -> Void)?) {
        storageService.save(completion: completion)
    }
}
