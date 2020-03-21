//
//  GCDDataManager.swift
//  T Messenger
//
//  Created by Suspect on 15.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {

    private var fileName: String

    init(fileName: String) {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.fileName = ((dir ?? "") as NSString).appendingPathComponent(fileName)
    }

    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> Void) {
        let dict = profile.toDictionary()
        DispatchQueue.global(qos: .utility).async {
            if let readDict = NSDictionary(contentsOfFile: self.fileName) {
                let readProfile = ProfileModel(dict: readDict)
                if profile == readProfile {
                    DispatchQueue.main.async {
                        completion(true)
                        return
                    }
                }
            }

            let res = dict.write(toFile: self.fileName, atomically: false)
            DispatchQueue.main.async {
                completion(res)
            }
        }
    }

    func read(completion: @escaping (ProfileModel?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            if let dict = NSDictionary(contentsOfFile: self.fileName) {
                let profile = ProfileModel(dict: dict)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
