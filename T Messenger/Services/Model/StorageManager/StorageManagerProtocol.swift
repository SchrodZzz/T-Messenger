//
//  StorageManagerProtocol.swift
//  T Messenger
//
//  Created by Suspect on 29.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
    func loadProfile(completion: @escaping (User?) -> Void)
    func saveProfile(completion: @escaping (Error?) -> Void)
}
