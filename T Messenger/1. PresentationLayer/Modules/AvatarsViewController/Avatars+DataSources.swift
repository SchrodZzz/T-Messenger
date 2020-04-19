//
//  Avatars+DataSources.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension AvatarsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell
            else { fatalError("AvatarCell cannot be dequeued") }
        cell.configure(with: avatars[indexPath.row])
        DispatchQueue.global(qos: .utility).async {
            self.model.loadImage(urlString: self.avatars[indexPath.row].previewURLString ?? "") { imageData in
                DispatchQueue.main.async {
                    cell.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
        return cell
    }
    
}
