//
//  ProfileModel.swift
//  T Messenger
//
//  Created by Suspect on 15.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class ProfileModel {

    private let kNameKey = "name"
    private let kAboutMeKey = "aboutMe"
    private let kAvatarKey = "avatar"

    var nameChanged = false
    var aboutMeChanged = false
    var imageChanged = false

    var name: String?
    var aboutMe: String?
    var avatarImageData: NSData?

    var isChanged: Bool {
        return nameChanged || aboutMeChanged || imageChanged
    }

    init() {

    }

    init(name: String?, aboutMe: String?, avatarImageData: NSData?) {
        self.name = name
        self.aboutMe = aboutMe
        self.avatarImageData = avatarImageData
    }

    init(dict: NSDictionary) {
        name = dict.object(forKey: kNameKey) as? String
        aboutMe = dict.object(forKey: kAboutMeKey) as? String
        avatarImageData = dict.object(forKey: kAvatarKey) as? NSData
    }

    func toDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict[kNameKey] = name
        dict[kAboutMeKey] = aboutMe
        dict[kAvatarKey] = avatarImageData
        return dict
    }

    func resetTrackingBools() {
        nameChanged = false
        aboutMeChanged = false
        imageChanged = false
    }

}

extension ProfileModel: Equatable {

    static func == (lhs: ProfileModel, rhs: ProfileModel) -> Bool {
        if lhs.name != rhs.name { return false }
        if lhs.aboutMe != rhs.aboutMe { return false }
        if lhs.avatarImageData == nil && rhs.avatarImageData == nil { return true }
        guard let lData = lhs.avatarImageData, let rData = rhs.avatarImageData else { return false }
        return lData.isEqual(to: rData as Data)
    }

}
