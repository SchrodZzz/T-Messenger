//
//  RequestSender.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    let session = URLSession.shared

    func send<Model: Codable>(request: IRequest, completion: @escaping (Result<Model>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(Result.error("url string can't be parsed to URL"))
            return
        }

        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
            if let error = error {
                completion(Result.error(error.localizedDescription))
                return
            }
            if let data = data as? Model {
                completion(Result.success(data))
                return
            }
            
            guard let data = data,
                let model: Model = try? JSONDecoder().decode(Model.self, from: data) else {
                    completion(Result.error("received data can't be parsed"))
                    return
            }

            completion(Result.success(model))
        }

        task.resume()
    }
}
