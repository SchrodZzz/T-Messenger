//
//  DataManager.swift
//  T Messenger
//
//  Created by Suspect on 15.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> Void)
    func read(completion: @escaping (ProfileModel?) -> Void)
}
