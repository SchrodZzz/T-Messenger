//
//  RequestsFactory.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixabayRequests {
        static func getPixabayRequest() -> IRequest {
            return PixabayRequest(apiKey: "16117721-2e67b66d5a0bbb325595eab42")
        }
    }
    
    struct ImageRequests {
        static func getImageRequest(urlString: String) -> IRequest {
            return ImageRequest(urlString: urlString)
        }
    }
}
