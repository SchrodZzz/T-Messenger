//
//  Avatars+Delegates.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

// MARK: - IAvatarsModelDelegate

extension AvatarsViewController: IAvatarsModelDelegate {
    func setup(dataSource: [PixabayImage]) {
        avatars = dataSource
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.avatarsCollectionView.reloadData()
        }
    }

    func show(error message: String) {
        print(message)
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard !avatarHasBeenSelected else { return }
        DispatchQueue.global(qos: .utility).async {
            self.model.loadImage(urlString: self.avatars[indexPath.row].largeURLString ?? "") { imageData in
                self.delegate?.didFinishAvatarSelection(with: imageData)
            }
        }
        avatarHasBeenSelected = true
    }
}

extension AvatarsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 3.2
        return CGSize(width: size, height: size)
    }
}
