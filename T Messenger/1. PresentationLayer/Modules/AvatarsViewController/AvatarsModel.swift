//
//  AvatarsModel.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol IAvatarsModel {
    
    var delegate: IAvatarsModelDelegate? { get set }
    
    func loadImages()
    func loadImage(urlString: String, completion: @escaping (Data) -> Void)
}

protocol IAvatarsModelDelegate: AnyObject {
    func setup(dataSource: [PixabayImage])
    func show(error message: String)
}

protocol IAvatarsControllerDelegate: AnyObject {
    func didFinishAvatarSelection(with imageData: Data?)
}

class AvatarsModel: IAvatarsModel {
    let pixabayService: IPixabayService
    
    weak var delegate: IAvatarsModelDelegate?
    
    init(pixabayService: IPixabayService) {
        self.pixabayService = pixabayService
    }
    
    func loadImages() {
        pixabayService.loadImages { (images, error) in
            if let images = images {
                self.delegate?.setup(dataSource: images.imageURLs)
            } else {
                self.delegate?.show(error: error ?? "Error")
            }
        }
    }
    
    func loadImage(urlString: String, completion: @escaping (Data) -> Void) {
        pixabayService.loadImage(urlString: urlString) { (imageData, error) in
            if let imageData = imageData {
                completion(imageData)
            } else {
                self.delegate?.show(error: error ?? "Error")
            }
        }
    }
}
