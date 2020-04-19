//
//  PixabayResponse.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

struct PixabayResponse: Codable {
    var imageURLs: [PixabayImage]
    
    enum CodingKeys: String, CodingKey {
        case imageURLs = "hits"
    }
}
