//
//  OperationDataManager.swift
//  T Messenger
//
//  Created by Suspect on 15.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class OperationDataManager: DataManagerProtocol {

    private var fileName: String

    init(fileName: String = "Profile.plist") {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.fileName = ((dir ?? "") as NSString).appendingPathComponent(fileName)
    }

    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> Void) {

        let saveOperation = SaveOperation()
        saveOperation.profile = profile
        saveOperation.toFile = fileName
        saveOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(saveOperation.res == true ? true : false)
            }
        }

        let saveOperationQueue = OperationQueue()
        saveOperationQueue.qualityOfService = .utility
        saveOperationQueue.addOperation(saveOperation)
    }

    func read(completion: @escaping (ProfileModel?) -> Void) {
        let readOperation = ReadOperation()
        readOperation.fromFile = fileName
        readOperation.completionBlock = {
            if let dict = readOperation.dict {
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

        let readOperationQueue = OperationQueue()
        readOperationQueue.qualityOfService = .utility
        readOperationQueue.addOperation(readOperation)
    }

}

class SaveOperation: Operation {
    var profile: ProfileModel?
    var toFile: String?
    var res: Bool = false

    override func main() {
        if let readDict = NSDictionary(contentsOfFile: toFile ?? "") {
            let readProfile = ProfileModel(dict: readDict)
            if profile == readProfile {
                DispatchQueue.main.async {
                    self.res = true
                    return
                }
            }
        }

        let dict = profile?.toDictionary() ?? [:]
        res = dict.write(toFile: toFile ?? "", atomically: false)
    }
}

class ReadOperation: Operation {
    var fromFile: String?
    var dict: NSDictionary?

    override func main() {
        dict = NSDictionary(contentsOfFile: fromFile ?? "")
    }
}
