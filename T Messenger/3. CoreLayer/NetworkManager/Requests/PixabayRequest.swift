//
//  PixabayRequest.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class PixabayRequest: IRequest {
    private var baseUrl: String = "https://pixabay.com/api/"
    private let apiKey: String
    private var getParameters: [String: String] {
        return ["key": apiKey,
                "per_page": "102",
                "safesearch": "true",
                "order": "popular",
                "category": "science"]
    }
    private var urlString: String {
        let getParams = getParameters.compactMap({
            "\($0.key)=\($0.value)" }).joined(separator: "&")
        return baseUrl + "?" + getParams
    }

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }

        return nil
    }
}
