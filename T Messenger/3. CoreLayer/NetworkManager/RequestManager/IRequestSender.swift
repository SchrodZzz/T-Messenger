//
//  IRequestSender.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestSender {
    func send<Model: Codable>(request: IRequest, completion: @escaping(Result<Model>) -> Void)
}
