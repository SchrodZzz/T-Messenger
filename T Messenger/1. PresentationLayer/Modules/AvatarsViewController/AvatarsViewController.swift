//
//  AvatarsViewController.swift
//  T Messenger
//
//  Created by Suspect on 19.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class AvatarsViewController: UIViewController {

    // MARK: - Proporties
    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: IAvatarsControllerDelegate?
    
    var avatars: [PixabayImage] = []

    private let presentationAssembly: IPresentationAssembly
    var model: IAvatarsModel
    
    var avatarHasBeenSelected = false

    // MARK: - Initialization

    init(model: IAvatarsModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "Avatars", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        model.loadImages()
        
        model.delegate = self
        avatarsCollectionView.register(UINib(nibName: "AvatarCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCell")
    }

}
