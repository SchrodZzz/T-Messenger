//
//  PixabayService.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class PixabayService: IPixabayService {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }

    func loadImages(completion: @escaping (PixabayResponse?, String?) -> Void) {
        let request = RequestsFactory.PixabayRequests.getPixabayRequest()
        requestSender.send(request: request) { (result: Result<PixabayResponse>) in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }

    func loadImage(urlString: String, completion: @escaping (Data?, String?) -> Void) {
        let request = RequestsFactory.ImageRequests.getImageRequest(urlString: urlString)
        requestSender.send(request: request) { (result: Result<Data>) in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
}
