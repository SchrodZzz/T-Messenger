//
//  ImageRequest.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {

    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }

        return nil
    }

}
