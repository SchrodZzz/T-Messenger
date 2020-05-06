//
//  CoreAssembly.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

class CoreAssembly: ICoreAssembly {
    lazy var networkManager: INetworkManager = FirebaseNetwork()
    lazy var storageManager: IStorageManager = StorageManager()
}
