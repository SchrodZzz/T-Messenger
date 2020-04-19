//
//  ProfileImageCell.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var imageUrl: String?
    
}

// MARK: - ConfigurableView protocol implementation

extension AvatarCell: IConfigurableView {
    func configure(with model: PixabayImage) {
        imageUrl = model.previewURLString
    }
}
