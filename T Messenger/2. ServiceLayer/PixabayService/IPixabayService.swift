//
//  IPixabayService.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol IPixabayService {
    func loadImages(completion: @escaping (PixabayResponse?, String?) -> Void)
    func loadImage(urlString: String, completion: @escaping (Data?, String?) -> Void)
}
