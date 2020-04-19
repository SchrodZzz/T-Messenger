//
//  PixabayImage.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

struct PixabayImage: Codable {
    var previewURLString: String?
    var largeURLString: String?
    
    enum CodingKeys: String, CodingKey {
        case previewURLString = "previewURL"
        case largeURLString = "largeImageURL"
    }
}
